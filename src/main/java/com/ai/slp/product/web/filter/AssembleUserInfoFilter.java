package com.ai.slp.product.web.filter;

import java.io.IOException;
import java.lang.reflect.Field;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jasig.cas.client.authentication.AttributePrincipal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.opt.sdk.util.CollectionUtil;
import com.ai.opt.sso.client.filter.SSOClientConstants;
import com.ai.platform.common.api.menu.interfaces.ISysMenuQuerySV;
import com.ai.platform.common.api.menu.param.SysMenuListQueryRequest;
import com.ai.platform.common.api.menu.param.SysMenuListQueryResponse;
import com.ai.slp.product.web.model.sso.GeneralSSOClientUser;
import com.alibaba.fastjson.JSON;


public class AssembleUserInfoFilter implements Filter {
    private String[] ignor_suffix = {};
    private static final Logger LOG = LoggerFactory.getLogger(AssembleUserInfoFilter.class);
	private static final String USER_MENUS = "user_menus";
	private static final String ALL_MENUS = "all_menus";

    public void init(FilterConfig filterConfig) throws ServletException {
        String ignore_res = filterConfig.getInitParameter("ignore_suffix");
        if (!"".equals(ignore_res)) {
            this.ignor_suffix = filterConfig.getInitParameter("ignore_suffix").split(",");
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        if (!shouldFilter(req)) {
            chain.doFilter(req, response);
            return;
        }
        else{
        	HttpSession session = req.getSession();
            GeneralSSOClientUser user = (GeneralSSOClientUser) session.getAttribute(SSOClientConstants.USER_SESSION_KEY);
            if (user == null) {
                user = assembleUser(req);
                if(user!=null){
                	//用户信息存入session
                	session.setAttribute(SSOClientConstants.USER_SESSION_KEY, user);
                	
                	//获取用户的菜单信息，存到session里面
                	ISysMenuQuerySV menuSV=DubboConsumerFactory.getService(ISysMenuQuerySV.class);
                	SysMenuListQueryRequest cond=new SysMenuListQueryRequest();
                	cond.setUserId(user.getUserId());
                	cond.setTenantId(user.getTenantId());
                	SysMenuListQueryResponse menuResp=menuSV.queryMenuByUserId(cond);
                	
                	List<String> menuList=new ArrayList<String>();
                	List<String> allMenuList=new ArrayList<String>();
                	if(menuResp.getResponseHeader()!=null&&"000000".equalsIgnoreCase(menuResp.getResponseHeader().getResultCode())){
                		menuList=menuResp.getMenuList();
                		allMenuList =menuResp.getAllMenuList();
                		if (!CollectionUtil.isEmpty(allMenuList)) {
                			session.setAttribute(USER_MENUS, menuList);
						}
                		if (!CollectionUtil.isEmpty(menuList)) {
                			session.setAttribute(ALL_MENUS, allMenuList);
						}
                	}
                	
                	LOG.info("已封装的用户信息为：" + JSON.toJSONString(user));
                }
                else{
                	LOG.info("未获取到用户信息");
                }            

            } 
            //判断权限 若果没有权限跳到403，判断规则  request.getRequestURI 去掉request.getContext前缀    
            boolean authMenuFlag=authMenu(req);
            if(!authMenuFlag){
            	//((HttpServletResponse)response).setStatus(HttpServletResponse.SC_FORBIDDEN);
            	((HttpServletResponse)response).sendRedirect(req.getContextPath()+"/403.jsp");
            }
            else{
            	chain.doFilter(req, response);
            }
           // chain.doFilter(req, response);
        }
        
        
    }

    @Override
    public void destroy() {

    }

    /**
     * 封装用户信息
     *
     * @param request
     * @return
     */
    private GeneralSSOClientUser assembleUser(HttpServletRequest request) {
    	GeneralSSOClientUser user = null;
        try {
            Principal principal = request.getUserPrincipal();
            if (principal != null) {
                user = new GeneralSSOClientUser();
                AttributePrincipal attributePrincipal = (AttributePrincipal) principal;
                Map<String, Object> attributes = attributePrincipal.getAttributes();
                Field[] fields = GeneralSSOClientUser.class.getDeclaredFields();
                for (Field field : fields) {
                    String value = (String) attributes.get(field.getName());
                    if (value != null) {
                        field.setAccessible(true);
                        if ("long".equalsIgnoreCase(field.getType().toString())) {
                            field.set(user, Long.parseLong(value));
                        } else {
                            field.set(user, value);
                        }
                    }
                }
            }
        } catch (Exception e) {
            LOG.error("封装用户信息失败", e);
        }
        return user;
    }

/*    private boolean shouldFilter(HttpServletRequest req) {
        if (ignor_suffix != null && ignor_suffix.length > 0) {
            String uri = req.getRequestURI().toLowerCase();
            for (String suffix : ignor_suffix) {
                if (uri.endsWith(suffix)) {
                    return false;
                }
            }
        }
        return true;
    }*/
    private boolean shouldFilter(HttpServletRequest req) {
        if (ignor_suffix != null && ignor_suffix.length > 0) {
            String uri = req.getRequestURI().toLowerCase();
            for (String suffix : ignor_suffix) {
                if (uri.endsWith(suffix.toLowerCase())) {
                    return false;
                }
            }
        }
        return true;
    }
    
    private boolean authMenu(HttpServletRequest request) {
    	
    	String currentURL = request.getRequestURI(); // 取得根目录所对应的绝对路径:
    	LOG.debug("currentURL=" + currentURL);
		String targetURL =currentURL.replace(request.getContextPath(), "");
		LOG.debug("targetURL=" + targetURL);
		List<String> menuList=new ArrayList<String>();
		List<String> allMenuList=new ArrayList<String>();
		
		if(request.getSession().getAttribute(USER_MENUS)!=null){
			menuList=(List<String>) request.getSession().getAttribute(USER_MENUS);	
			allMenuList=(List<String>) request.getSession().getAttribute(ALL_MENUS);	
		}
		//各中心自测的frame直接放行
		if (allMenuList != null && allMenuList.size() > 0) {
			boolean isMenu =false;
    		for (String menu : allMenuList) {
    			if (menu.toLowerCase().trim().contains(targetURL.toLowerCase().trim())) {
    				isMenu =true;
    			}
    		}
    		
    		if(!isMenu){
    			return true;
    		}
    	}
		
    	if (menuList != null && menuList.size() > 0) {
    		for (String menu : menuList) {
    			if (menu.toLowerCase().trim().contains(targetURL.toLowerCase().trim())) {
    				return true;
    			}
    		}
    	}
    	return false;
    }
}
















/*package com.ai.slp.product.web.filter;

import com.ai.opt.sso.client.filter.SSOClientConstants;
import com.ai.slp.product.web.model.sso.GeneralSSOClientUser;
import com.alibaba.fastjson.JSON;
import org.jasig.cas.client.authentication.AttributePrincipal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.lang.reflect.Field;
import java.security.Principal;
import java.util.Map;


public class AssembleUserInfoFilter implements Filter {
    private String[] ignor_suffix = {};
    private String ignorSuffixStr = "";
    private static final Logger LOG = LoggerFactory.getLogger(AssembleUserInfoFilter.class);

    public void init(FilterConfig filterConfig) throws ServletException {
        ignorSuffixStr = filterConfig.getInitParameter("ignore_suffix");
        if (!"".equals(ignorSuffixStr.trim())) {
            this.ignor_suffix = filterConfig.getInitParameter("ignore_suffix").split(",");
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        if (shouldFilter(req)) {
            chain.doFilter(req, response);
            return;
        }
        HttpSession session = req.getSession();
        GeneralSSOClientUser user = (GeneralSSOClientUser) session.getAttribute(SSOClientConstants.USER_SESSION_KEY);
        if (user == null) {
            user = assembleUser(req);
            if(user!=null){
                session.setAttribute(SSOClientConstants.USER_SESSION_KEY, user);
                LOG.info("已封装的用户信息为：" + JSON.toJSONString(user));
            }
            else{
                LOG.info("未获取到用户信息");
            }
            chain.doFilter(req, response);

        } else {
            chain.doFilter(req, response);
        }
    }

    @Override
    public void destroy() {

    }

    *//**
     * 封装用户信息
     *
     * @param request
     * @return
     *//*
    private GeneralSSOClientUser assembleUser(HttpServletRequest request) {
        GeneralSSOClientUser user = null;
        try {
            Principal principal = request.getUserPrincipal();
            if (principal != null) {
                user = new GeneralSSOClientUser();
                AttributePrincipal attributePrincipal = (AttributePrincipal) principal;
                Map<String, Object> attributes = attributePrincipal.getAttributes();
                Field[] fields = GeneralSSOClientUser.class.getDeclaredFields();
                for (Field field : fields) {
                    String value = (String) attributes.get(field.getName());
                    if (value != null) {
                        field.setAccessible(true);
                        if ("long".equalsIgnoreCase(field.getType().toString())) {
                            field.set(user, Long.parseLong(value));
                        } else {
                            field.set(user, value);
                        }
                    }
                }
            }
        } catch (Exception e) {
            LOG.error("封装用户信息失败", e);
        }
        return user;
    }

    private boolean shouldFilter(HttpServletRequest req) {
        if (ignorSuffixStr==null || "".equals(ignorSuffixStr)){
        	return true;
        }
        String uri = req.getRequestURI().toLowerCase();
        if (ignor_suffix != null && ignor_suffix.length > 0) {
            String uri = req.getRequestURI().toLowerCase();
            for (String suffix : ignor_suffix) {
                if (uri.endsWith(suffix)) {
                    return false;
                }
            }
        }
        return true;
        return ignorSuffixStr.contains(uri)||ignorSuffixStr.contains(uri+",");
    }
}
*/