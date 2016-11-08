package com.ai.slp.product.web.constants;

/**
 * 商品类目
 *
 * Created by jackieliu on 16/5/1.
 */
public final class ProductConstants {

    private ProductConstants() {
		// TODO Auto-generated constructor stub
	}

	public static final class NormProduct{
        public final class State{
            private State() {
				// TODO Auto-generated constructor stub
			}

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
        private IsSaleNationwide() {
			// TODO Auto-generated constructor stub
		}
		/**
         * 为全国
         */
        public static final String YES = "Y";
        /**
         * 非全国
         */
        public static final String NO = "N";
    }
    
    public static final class Product{
        public final class State{
            private State() {
				// TODO Auto-generated constructor stub
			}

            /**
             * 新增状态
             */
            public static final String ADD = "0";
            /**
             * 未编辑
             */
            public static final String UNEDIT = "1";
            /**
             * 已编辑状态
             */
            public static final String EDITED = "2";
            /**
             * 审核中
             */
            public static final String VERIFYING = "3";
            /**
             * 审核拒绝
             */
            public static final String REJECT = "4";
            /**
             * 销售中
             */
            public static final String IN_SALE = "5";
            /**
             * 仓库中,(审核通过,手动下架后状态)
             */
            public static final String IN_STORE = "6";
            /**
             * 售罄下架
             */
            public static final String SALE_OUT = "61";
            /**
             * 停用下架
             */
            public static final String STOP = "62";
            /**
             * 废弃
             */
            public static final String DISCARD = "7";
        
        }
    }
}
