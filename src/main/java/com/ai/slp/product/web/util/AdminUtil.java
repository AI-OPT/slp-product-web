package com.ai.slp.product.web.util;

import com.ai.opt.sso.client.filter.SSOClientConstants;
import com.ai.slp.product.web.model.sso.GeneralSSOClientUser;

import javax.servlet.http.HttpSession;

/**
 * Created by jackieliu on 16/7/8.
 */
public class AdminUtil {
    /**
     * 获取管理员标识
     * @param session
     * @return
     */
    public static Long getAdminId(HttpSession session){
        GeneralSSOClientUser user = (GeneralSSOClientUser)session.getAttribute(SSOClientConstants.USER_SESSION_KEY);
//        return user.getUserId();
        return 1l;
    }
}
