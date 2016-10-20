package com.ai.slp.product.web.constants;

/**
 * 商品类目
 *
 * Created by jackieliu on 16/5/1.
 */
public final class ProductConstants {

    public static final class NormProduct{
        public static final class State{
            /**
             * 失效
             */
            public static final String INACTIVE = "0";

            /**
             * 可使用
             */
            public static final String ENABLE = "1";
            
            /**
             * 不可使用
             */
            public static final String DISABLE = "2";
        }
    }

    public static final class IsSaleNationwide{
        /**
         * 为全国
         */
        public static final String YES = "Y";
        /**
         * 非全国
         */
        public static final String NO = "N";
    }
}
