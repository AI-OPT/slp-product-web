package com.ai.slp.product.web.constants;

/**
 * 库存
 * Created by jackieliu on 16/8/24.
 */
public class StorageConstants {
	
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
	
   /* private StorageConstants() {
		// TODO Auto-generated constructor stub
	}

	*//**
     * 库存启用
     *//*
    public static final String STATUS_ACTIVE = "1";
    *//**
     * 库存停用
     *//*
    public static final String STATUS_STOP = "2";

    *//**
     * 库存废弃
     *//*
    public static final String STATUS_DISCARD = "3";*/
}
