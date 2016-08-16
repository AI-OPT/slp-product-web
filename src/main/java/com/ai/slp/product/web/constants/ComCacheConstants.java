package com.ai.slp.product.web.constants;

/**
 * Created by jackieliu on 16/6/17.
 */
public final class ComCacheConstants {
	/**
	 * 标准品TYPE
	 * @author Gavin
	 *
	 */
	public final class NormProduct{
		public static final String CODE = "STANDEDPRODUCT";
		
		public static final String STATUS = "STATE";
		
	}
	/**
	 * 类目属性
	 */
	public final class ProdAttr{
		public static final String CODE = "PRODATTRDEF";
		
		
		public static final String VALUE_WAY = "VALUE_WAY";
		
	}

    /**
     * 商品TYPE
     */
    public final class TypeProduct{
        public static final String CODE = "PRODUCT";
        /**
         * 商品类型
         */
        public static final String PROD_PRODUCT_TYPE = "PRODUCT_TYPE";
        /**
         * 有效期单位
         */
        public static final String PROD_UNIT = "UNIT";
        /**
         * 运营商
         */
        public static final String BASIC_ORG_ID = "BASIC_ORG_ID";
    }
    /**
     * 库存和库存组状态
     */
    public final class StateStorage{
    	/**
    	 * 库存TYPE
    	 */
        public static final String STORAGE_TYPR_CODE = "STORAGE";
        /**
         * 库存库存组CODE
         */
        public static final String PARAM_CODE = "STATE";
        /**
    	 * 库存组TYPE
    	 */
        public static final String STORAGEGROUP_TYPR_CODE = "STORAGEGROUP";
    }

}
