package com.ai.slp.product.web.constants;

public class ProductCommentConstants {
	private ProductCommentConstants() {
	}

	public static final class State{
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
    }
	
	public static final class HasPicture{
		private HasPicture() {
			// TODO Auto-generated constructor stub
		}
		public static final String YSE = "Y";
		public static final String NO = "N";
	}
	
	public static final class ReplyState{
		private ReplyState() {
			// TODO Auto-generated constructor stub
		}
		/**
		 * 已回复
		 */
		public static final String YSE = "1";
		/**
		 * 未回复
		 */
		public static final String NO = "0";
	}
	
	/**
	 * 配置中心key
	 */
	public static final class CCSKey{
		private CCSKey() {
			// TODO Auto-generated constructor stub
		}
		public static final String userserver_ip = "/product.comment.userserver-ip";
		public static final String userserver_appkey = "/product.comment.userserver-appkey";
	}
}
