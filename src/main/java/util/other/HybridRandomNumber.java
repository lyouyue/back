package util.other;

import java.util.Random;

/**
 * 混合随机数生成-工具类
 * @author mf
 */
public class HybridRandomNumber {
	/**
	 * 生成混合随机数
	 * @param length 字符长度
	 * @return val 随机数
	 */
	 public static String getCharAndNumr(int length) {   
	        String val = "";   
	        Random random = new Random();   
	        for(int i = 0; i < length; i++) {   
	            String charOrNum = random.nextInt(2) % 2 == 0 ? "char" : "num"; // 输出字母还是数字   
	            if("char".equalsIgnoreCase(charOrNum)) {// 字符串   
	                int choice = random.nextInt(2) % 2 == 0 ? 65 : 97; //取得大写字母还是小写字母   
	                val += (char) (choice + random.nextInt(26));   
	            } else if ("num".equalsIgnoreCase(charOrNum)) {// 数字   
	                val += String.valueOf(random.nextInt(10));   
	            }   
	        }   
	        return val;   
	    } 
	 //方法测试
	 public static void main(String[] args){
		 //生成10位字母数字混合随机数
	    	System.out.println(getCharAndNumr(10));
	    }
}
