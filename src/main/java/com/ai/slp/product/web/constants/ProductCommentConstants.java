package com.ai.slp.product.web.constants;

public class ProductCommentConstants {
	public final class State{
        /**
         * 失效
         */
        public static final String INACTIVE = "0";

        /**
         * 可使用
         */
        public static final String ENABLE = "1";
    }
	
	public final class HasPicture{
		public static final String YSE = "Y";
		public static final String NO = "N";
	}
	
	public final class ReplyState{
		/**
		 * 已回复
		 */
		public static final String YSE = "1";
		/**
		 * 未回复
		 */
		public static final String NO = "0";
	}
}
