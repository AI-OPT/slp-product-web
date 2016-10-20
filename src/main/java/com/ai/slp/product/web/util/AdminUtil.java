package com.ai.slp.product.web.util;

import com.ai.opt.sso.client.filter.SSOClientConstants;
import com.ai.slp.product.web.model.sso.GeneralSSOClientUser;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpSession;

/**
 * Created by jackieliu on 16/7/8.
 */
public class AdminUtil {
    private AdminUtil() {
		// TODO Auto-generated constructor stub
	}

	/**
     * 获取管理员标识
     * @param session
     * @return
     */
    public static Long getAdminId(HttpSession session){
        GeneralSSOClientUser user = (GeneralSSOClientUser)session.getAttribute(SSOClientConstants.USER_SESSION_KEY);
        String userId = user.getUserId();
        return Long.parseLong(userId);
    }

    /**
     * 获取管理员标识
     * @return
     */
    public static Long getAdminId(){
        HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();
        return getAdminId(session);
    }

    /**
     * 获取用户租户标识
     * @return
     */
    public static String getTenantId(){
        HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();
        GeneralSSOClientUser user = (GeneralSSOClientUser)session.getAttribute(SSOClientConstants.USER_SESSION_KEY);
        return user.getTenantId();
    }

    /**
     * 获取商户标识
     * @return
     */
    public static String getSupplierId(){
//        HttpSession session = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getSession();
        return "-1";
    }
}
