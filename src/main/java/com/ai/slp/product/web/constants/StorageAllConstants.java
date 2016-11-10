package com.ai.slp.product.web.constants;

/**
 * 库存
 * Created by jiawen on 16/11/10.
 */

public class StorageAllConstants {
	private StorageAllConstants() {
		// TODO Auto-generated constructor stub
	}
	
	public static final class StorageGroup{

        public static final String DEFAULT_NAME = "默认库存组";
        public static final class State{
            /**
             * 启用
             */
            public static final String ACTIVE = "1";
            /**
             * 自动启用
             */
            public static final String AUTO_ACTIVE = "11";
            /**
             * 停用
             */
            public static final String STOP = "2";
            /**
             * 自动停用
             */
            public static final String AUTO_STOP = "21";
            /**
             * 废弃
             */
            public static final String DISCARD = "3";
            /**
             * 自动废弃
             */
            public static final String AUTO_DISCARD = "31";
        }
        public static final class isSaleAttr{
            /**
             * 有销售属性
             */
            public static final String HAS_SALE_ATTR = "Y";
            /**
             * 无销售属性
             */
            public static final String NO_SALE_ATTR = "N";
        }
    }
	
    public static final class Storage{
        public static final class State{
            /**
             * 启用
             */
            public static final String ACTIVE = "1";
            /**
             * 自动启用
             */
            public static final String AUTO_ACTIVE = "11";
            /**
             * 停用
             */
            public static final String STOP = "2";
            /**
             * 自动停用
             */
            public static final String AUTO_STOP = "21";
            /**
             * 废弃
             */
            public static final String DISCARD = "3";
            /**
             * 自动废弃
             */
            public static final String AUTO_DISCARD = "31";
        }
    }
	
}
