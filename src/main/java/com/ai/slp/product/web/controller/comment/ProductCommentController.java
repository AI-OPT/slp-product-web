package com.ai.slp.product.web.controller.comment;

import java.sql.Timestamp;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ai.opt.base.vo.BaseResponse;
import com.ai.opt.base.vo.PageInfo;
import com.ai.opt.base.vo.PageInfoResponse;
import com.ai.opt.sdk.components.ccs.CCSClientFactory;
import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.dubbo.util.HttpClientUtil;
import com.ai.opt.sdk.util.BeanUtils;
import com.ai.opt.sdk.util.StringUtil;
import com.ai.opt.sdk.web.model.ResponseData;
import com.ai.slp.product.api.productcomment.interfaces.IProdCommentManagerSV;
import com.ai.slp.product.api.productcomment.param.*;
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
						String userName = userData.getString("userName");
						pageInfo.setUserName(userName);
						pageInfoList.add(pageInfo);
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
	 */
	@RequestMapping("/discardComment")
	@ResponseBody
	public BaseResponse discardComment(String commentIds) {
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
}
