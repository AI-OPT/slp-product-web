package com.ai.slp.product.web.util;

import java.math.BigDecimal;

public class AmountUtil {
    
    private AmountUtil() {
		// TODO Auto-generated constructor stub
	}

	/**  
     * 将厘为单位的转换为元 （除1000）  
     *   
     * @param amount  
     * @return  
     * @throws Exception   
     */    
    public static double changeL2Y(String amount) throws Exception{    
        BigDecimal balance = BigDecimal.valueOf(Long.valueOf(amount)).divide(new BigDecimal(1000L),2,BigDecimal.ROUND_HALF_UP);
        return balance.doubleValue();
    }  
    
    /**  
     * 将厘为单位的转换为元 （除1000）  
     *   
     * @param amount  
     * @return  
     * @throws Exception   
     */    
    public static double changeL2Y(Long amount) throws Exception{
        BigDecimal balance = BigDecimal.valueOf(amount).divide(new BigDecimal(1000L),2,BigDecimal.ROUND_HALF_UP);
        return balance.doubleValue();
    }
    
    /**  
     * 将厘为单位的转换为元 （除1000）  
     */    
    public static String li2Yuan(Long amount) throws Exception{
        if(amount == null){
            return "0.00";
        }
        BigDecimal balance = BigDecimal.valueOf(amount).divide(new BigDecimal(1000L),2,BigDecimal.ROUND_HALF_UP);
        return balance.toString();
    }
    
    /**  
     * 将厘为单位的转换为元 （除1000）  
     */    
    public static String li2Yuan(Double amount) throws Exception{
        String result = "0.00";
        if(amount != null){
            BigDecimal balance = BigDecimal.valueOf(amount).divide(new BigDecimal(1000L),2,BigDecimal.ROUND_HALF_UP);
            result = balance.toString();
        }
        return result;
    }  
    
}
