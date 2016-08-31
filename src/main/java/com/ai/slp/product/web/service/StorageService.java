package com.ai.slp.product.web.service;

import com.ai.opt.sdk.dubbo.util.DubboConsumerFactory;
import com.ai.platform.common.api.cache.interfaces.ICacheSV;
import com.ai.platform.common.api.cache.param.SysParam;
import com.ai.platform.common.api.cache.param.SysParamMultiCond;
import com.ai.slp.product.web.constants.ComCacheConstants;
import com.ai.slp.product.web.util.AdminUtil;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by jackieliu on 16/8/31.
 */
@Service
public class StorageService {
    /**
     * 获取库存状态字典信息
     * @return
     */
    public Map<String,SysParam> getStorageStatus(){
        ICacheSV cacheSV = DubboConsumerFactory.getService(ICacheSV.class);
        SysParamMultiCond multiCond = new SysParamMultiCond(AdminUtil.getTenantId(),
                ComCacheConstants.StateStorage.STORAGE_TYPR_CODE, ComCacheConstants.StateStorage.PARAM_CODE);
        List<SysParam> sysParamList = cacheSV.getSysParamList(multiCond);
        Map<String,SysParam> paramMap = new HashMap<>();
        for (SysParam sysParam:sysParamList){
            paramMap.put(sysParam.getColumnValue(),sysParam);
        }
        return paramMap;
    }
}
