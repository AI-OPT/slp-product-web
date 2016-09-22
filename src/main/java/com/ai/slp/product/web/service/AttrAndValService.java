package com.ai.slp.product.web.service;

import com.ai.slp.product.api.normproduct.param.AttrMap;
import com.ai.slp.product.api.normproduct.param.AttrValInfo;
import com.ai.slp.product.api.normproduct.param.ProdCatAttrInfo;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * Created by jackieliu on 16/7/26.
 */
@Service
public class AttrAndValService {

    public Map<ProdCatAttrInfo, List<AttrValInfo>> getAttrAndVals(AttrMap attrMap) {
        Map<ProdCatAttrInfo, List<AttrValInfo>> attrAndValMap = new LinkedHashMap<>();
        Set<Map.Entry<Long, List<Long>>> entrySet = attrMap.attrAndVal.entrySet();
        for (Map.Entry<Long, List<Long>> mapEntry : entrySet) {
            ProdCatAttrInfo attrInfo = attrMap.getAttrDefMap().get(mapEntry.getKey());
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
