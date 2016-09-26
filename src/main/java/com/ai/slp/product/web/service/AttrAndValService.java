package com.ai.slp.product.web.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.ai.slp.product.api.normproduct.param.AttrMap;
import com.ai.slp.product.api.normproduct.param.AttrValInfo;
import com.ai.slp.product.api.normproduct.param.ProdCatAttrInfo;

/**
 * Created by jackieliu on 16/7/26.
 */
@Service
public class AttrAndValService {

    public Map<ProdCatAttrInfo, List<AttrValInfo>> getAttrAndVals(AttrMap attrMap) {
        Map<ProdCatAttrInfo, List<AttrValInfo>> attrAndValMap = new LinkedHashMap<>();
        Map<Long, ProdCatAttrInfo> attrDefMap = attrMap.getAttrDefMap();
        for (Map.Entry<Long, List<Long>> mapEntry :  attrMap.getAttrAndVal().entrySet()) {
            ProdCatAttrInfo attrInfo = attrDefMap.get(mapEntry.getKey());
            List<AttrValInfo> valInfoList = new ArrayList<AttrValInfo>();
            List<Long> valIds = mapEntry.getValue();
            for (Long valId : valIds) {
                valInfoList.add(attrMap.getAttrValDefMap().get(valId));
            }
            attrAndValMap.put(attrInfo, valInfoList);
        }
        return attrAndValMap;
    }
}
