package com.ai.slp.product.web.controller.comment;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.ai.opt.base.exception.BusinessException;
import com.ai.opt.base.exception.SystemException;
import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.PageInfo;
import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.sdk.components.ccs.CCSClientFactory;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.dubbo.util.HttpClientUtil;
import com.ai.opt.sdk.util.BeanUtils;
import com.ai.opt.sdk.util.StringUtil;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.product.api.flushdata.interfaces.ICreateDataBatSV;
import com.ai.slp.product.api.flushdata.interfaces.IFlushDataSV;
import com.ai.slp.product.api.flushdata.params.CreateCommentRequest;
import com.ai.slp.product.api.flushdata.params.CreateDataRequest;
import com.ai.slp.product.api.flushdata.params.FlushDataRequest;
import com.ai.slp.product.api.productcomment.interfaces.IProdCommentManagerSV;
import com.ai.slp.product.api.productcomment.param.CommentPageRequest;
import com.ai.slp.product.api.productcomment.param.CommentPageResponse;
import com.ai.slp.product.api.productcomment.param.CommentPictureQueryRequset;
import com.ai.slp.product.api.productcomment.param.CommentPictureQueryResponse;
import com.ai.slp.product.api.productcomment.param.PictureVO;
import com.ai.slp.product.api.productcomment.param.UpdateCommentStateRequest;
import com.ai.slp.product.web.constants.ProductCommentConstants;
import com.ai.slp.product.web.model.comment.CommentPageInfo;
import com.ai.slp.product.web.util.AdminUtil;
import com.ai.slp.product.web.util.DateUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

/**
 * 商品评价
 * 
 * @author jiaxs
 */
@Controller
@RequestMapping("/productcomment")
public class ProductCommentController {
	private static final Logger LOG = LoggerFactory.getLogger(ProductCommentController.class);

	public class Test {
		
	}
	
	/**
	 * 进入页面
	 */
	@RequestMapping("/list")
	public String editQuery(Model uiModel) {
		return "comment/commentlist";
	}

	/**
	 * 点击查询按钮调用方法-查询商品评价
	 * 
	 * @return
	 */
	@RequestMapping("/getCommentList")
	@ResponseBody
	public ResponseData<PageInfo<CommentPageInfo>> queryCommentList(HttpServletRequest request,
			CommentPageRequest params, String commentTimeBeginStr, String commentTimeEndStr) {
		ResponseData<PageInfo<CommentPageInfo>> responseData = null;
		try {
			// 设置入参条件
			if (!StringUtil.isBlank(commentTimeBeginStr)) {
				Timestamp commentTimeBegin = DateUtil.getTimestamp(commentTimeBeginStr, "yyyy-MM-dd HH:mm:ss");
				params.setCommentTimeBegin(commentTimeBegin);
			}
			if (!StringUtil.isBlank(commentTimeEndStr)) {
				Timestamp commentTimeEnd = DateUtil.getTimestamp(commentTimeEndStr, "yyyy-MM-dd HH:mm:ss");
				params.setCommentTimeEnd(commentTimeEnd);
			}
			params.setTenantId(AdminUtil.getTenantId());
			IProdCommentManagerSV commentSV = DubboConsumerFactory.getService(IProdCommentManagerSV.class);
			// 设置返回对象
			PageInfoResponse<CommentPageResponse> commentPageInfo = commentSV.queryPageInfo(params);
			PageInfo<CommentPageInfo> commentPageResult = new PageInfo<CommentPageInfo>();
			if (commentPageInfo != null) {
				commentPageResult.setCount(commentPageInfo.getCount());
				commentPageResult.setPageCount(commentPageInfo.getPageCount());
				commentPageResult.setPageSize(commentPageInfo.getPageSize());
				commentPageResult.setPageNo(commentPageInfo.getPageNo());
				List<CommentPageResponse> commentList = commentPageInfo.getResult();
				List<CommentPageInfo> pageInfoList = new LinkedList<CommentPageInfo>();
				if (commentList != null && commentList.size() > 0) {
					for (CommentPageResponse comment : commentList) {
						CommentPageInfo pageInfo = new CommentPageInfo();
						BeanUtils.copyProperties(pageInfo, comment);
						Map<String, String> queryMap = new HashMap<String, String>();
						queryMap.put("openId", pageInfo.getUserId());
						String queryParam = JSON.toJSONString(queryMap);
						//获取地址
						String userServerIp = CCSClientFactory.getDefaultConfigClient()
								.get(ProductCommentConstants.CCSKey.userserver_ip);
						String url = "http://" + userServerIp + "/opaas/http/srv_up_user_getuserinfobyopenid_qry";
						Map<String, String> header = new HashMap<String, String>();
						String userServerAppKey = CCSClientFactory.getDefaultConfigClient()
								.get(ProductCommentConstants.CCSKey.userserver_appkey);
						header.put("appkey", userServerAppKey);
						// 设置用户名
						String userInfoStr = HttpClientUtil.sendPost(url, queryParam, header);
						JSONObject userjson = JSON.parseObject(userInfoStr);
						String userDataStr = userjson.getString("data");
						JSONObject userData = JSON.parseObject(userDataStr);
						
						JSONObject data = JSON.parseObject(userData.getString("data"));
						if (data!=null) {
							String userName = data.getString("userName");
							pageInfo.setUserName(userName);
							pageInfoList.add(pageInfo);
						}else {
							String userName1 = "";
							pageInfo.setUserName(userName1);
							pageInfoList.add(pageInfo);
						}
						/*pageInfo.setUserName(userName);
						pageInfoList.add(pageInfo);*/
					}
				}
				commentPageResult.setResult(pageInfoList);
			}
			responseData = new ResponseData<PageInfo<CommentPageInfo>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					commentPageResult);
		} catch (Exception e) {
			responseData = new ResponseData<PageInfo<CommentPageInfo>>(ResponseData.AJAX_STATUS_FAILURE, "获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}

	/**
	 * 废弃评论
	 * 
	 * @param commentIdArray
	 * @return
	 * @throws Exception 
	 * @throws IOException 
	 * @throws SystemException 
	 * @throws BusinessException 
	 */
	@RequestMapping("/discardComment")
	@ResponseBody
	public BaseResponse discardComment(String commentIds) throws BusinessException, SystemException, IOException, Exception {
		IProdCommentManagerSV commentSV = DubboConsumerFactory.getService(IProdCommentManagerSV.class);
		UpdateCommentStateRequest updataParams = new UpdateCommentStateRequest();
		List<String> commentIdList = new ArrayList<String>();
		String[] commentIdArray = commentIds.split(",");
		for (String commentId : commentIdArray) {
			commentIdList.add(commentId);
		}
		updataParams.setCommentIdList(commentIdList);
		updataParams.setTenantId(AdminUtil.getTenantId());
		updataParams.setOperId(AdminUtil.getAdminId().toString());
		updataParams.setState(ProductCommentConstants.State.INACTIVE);
		return commentSV.updateCommentState(updataParams);
	}

	/**
	 * 查询商品评价图片
	 * 
	 * @param commentIds
	 * @return
	 */
	@RequestMapping("/selectCommentImages")
	@ResponseBody
	public ResponseData<List<PictureVO>> selectCommentImages(String commentId) {
		ResponseData<List<PictureVO>> responseData = null;
		try {
			IProdCommentManagerSV commentSV = DubboConsumerFactory.getService(IProdCommentManagerSV.class);
			CommentPictureQueryRequset queryRequset = new CommentPictureQueryRequset();
			queryRequset.setCommentId(commentId);
			CommentPictureQueryResponse pictureQueryResponse = commentSV.queryPictureByCommentId(queryRequset);
			responseData = new ResponseData<List<PictureVO>>(ResponseData.AJAX_STATUS_SUCCESS, "查询成功",
					pictureQueryResponse.getPictureList());
		} catch (Exception e) {
			responseData = new ResponseData<List<PictureVO>>(ResponseData.AJAX_STATUS_FAILURE, "获取信息异常");
			LOG.error("获取信息出错：", e);
		}
		return responseData;
	}
	
	@RequestMapping("/jumptoflushpage")
	public ModelAndView jumpToFlushPage(){
		return new ModelAndView("comment/flushData");
	}
	
	
	@RequestMapping(value="/flushproductdata")
	@ResponseBody
	public String flushProductData(FlushDataRequest request) throws UnsupportedEncodingException{
		IFlushDataSV flushDataSV = DubboConsumerFactory.getService(IFlushDataSV.class);
		if(!StringUtil.isBlank(request.getProdName())){
			request.setProdName(new String(request.getProdName().getBytes("iso8859-1"),"UTF-8"));
		}
		BaseResponse response = flushDataSV.flushProductData(request);
		String str = JSONObject.toJSONString(response).replace("\\","");
		return new String(str.getBytes("UTF-8"),"iso8859-1");
	}
	
	@RequestMapping(value="/flushcommentdata")
	@ResponseBody
	public String flushCommentData(FlushDataRequest request) throws UnsupportedEncodingException{
		IFlushDataSV flushDataSV = DubboConsumerFactory.getService(IFlushDataSV.class);
		BaseResponse response = flushDataSV.flushCommentData(request);
		String str = JSONObject.toJSONString(response).replace("\\","");
		return new String(str.getBytes("UTF-8"),"iso8859-1");
	}
	
	@RequestMapping(value="/createProduct")
	public ModelAndView createProduct(CreateDataRequest request) throws UnsupportedEncodingException{
		ICreateDataBatSV createDataBatSV = DubboConsumerFactory.getService(ICreateDataBatSV.class);
		createDataBatSV.createProductBat(request);
		return new ModelAndView("comment/flushData");
	}
	
	@RequestMapping(value="/createComment")
	public ModelAndView createComment(CreateCommentRequest request) throws UnsupportedEncodingException{
		ICreateDataBatSV createDataBatSV = DubboConsumerFactory.getService(ICreateDataBatSV.class);
		createDataBatSV.createCommentBat(request);
		return new ModelAndView("comment/flushData");
	}
	
}

