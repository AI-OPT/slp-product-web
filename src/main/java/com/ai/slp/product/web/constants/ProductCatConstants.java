package com.ai.slp.product.web.constants;

/**
 * 商品类目
 *
 * Created by jackieliu on 16/5/1.
 */
public final class ProductCatConstants {

    private ProductCatConstants() {
		// TODO Auto-generated constructor stub
	}

	public static final class ProductCat{
        public final class IsChild{
            private IsChild() {
				// TODO Auto-generated constructor stub
			}

			/**
             * 有子分类
             */
            public static final String HAS_CHILD = "Y";

            /**
             * 没有子分类
             */
            public static final String NO_CHILD = "N";
        }

        public final class ParentProductCatId {
            private ParentProductCatId() {
				// TODO Auto-generated constructor stub
			}

			/**
             * 根类目标识
             */
            public static final String ROOT_CAT = "0";
        }
    }

    public static final class ProductCatAttr{
        private ProductCatAttr() {
			// TODO Auto-generated constructor stub
		}

		public final class AttrType{
            /**
             * 关键属性类型
             */
            public static final String ATTR_TYPE_KEY = "1";
            /**
             * 销售属性
             */
            public static final String ATTR_TYPE_SALE = "2";
            /**
             * 非关键属性
             */
            public static final String ATTR_TYPE_NONKEY = "3";
        }
    }

}
