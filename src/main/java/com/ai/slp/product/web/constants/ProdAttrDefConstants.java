package com.ai.slp.product.web.constants;

/**
 * Created by jackieliu on 16/9/13.
 */
public final class ProdAttrDefConstants {
    private ProdAttrDefConstants() {
		// TODO Auto-generated constructor stub
	}

	/**
     * 值输入方式
     */
    public static final class ValueWay{
        private ValueWay() {
			// TODO Auto-generated constructor stub
		}
		/**
         * 单选
         */
        public static final String RADIO = "1";
        /**
         * 多选
         */
        public static final String CHECKBOX = "2";
        /**
         * 单行输入
         */
        public static final String INPUT_TEXT = "3";
        /**
         * 多行输入
         */
        public static final String INPUT_AREA = "4";
        /**
         * 时间
         */
        public static final String DATE = "5";
        /**
         * 时间段
         */
        public static final String DATE_BUCKET = "6";
    }
}
