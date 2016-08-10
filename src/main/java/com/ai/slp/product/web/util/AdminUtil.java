package com.ai.slp.product.web.util;

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
        return 1l;
    }
}
