package util.common;

import java.util.Map;

import util.other.Utils;

import javax.servlet.http.HttpSession;

/**
 * SecurityCodeVerificationUtils - 验证码是否正确
 * ============================================================================
 * 版权所有 2010-2013 XXXX软件有限公司，并保留所有权利。
 * ----------------------------------------------------------------------------
 * 提示：在未取得SHOPJSP商业授权之前，您不能将本软件应用于商业用途，否则SHOPJSP将保留追究的权力。
 * ----------------------------------------------------------------------------
 * 官方网站：http://www.shopjsp.com
 * ============================================================================
 */
public class SecurityCodeVerificationUtils {
	
	/**
	 * 校验手机短信验证码
	 * @param session  获取用户session
	 * @param verificationCode  得到用户输入的图形验证码
	 * @param fileUrlConfig  全局配置文件对象
	 * @return isExsit  返回验证码结果，1:正确，2验证码错误，3:验证码失效
	 * */
	public static String checkVerificationSecurityCode(HttpSession session,String verificationCode,Map<String, Object> fileUrlConfig){
		String isExsit="0";//0默认，1:正确，2验证码错误,3:验证码失效
		if(Utils.objectIsNotEmpty(session.getAttribute("verificationCodeFront"))){
			String verificationCodeFront = String.valueOf(session.getAttribute("verificationCodeFront"));//session中存储的验证码
			//获取验证码的失效时间计时
			long verificationInvalidationTime = Long.parseLong(String.valueOf(session.getAttribute("verificationInvalidationTime")));
			//获取失效时间，单位毫秒
			long sessionVerificationInvalidationTime =  Long.parseLong( String.valueOf(fileUrlConfig.get("session_verificationInvalidationTime")) );
			//判断验证码状态，判断验证码时间是否超时
			if(null==verificationCodeFront||((System.currentTimeMillis() - verificationInvalidationTime) > sessionVerificationInvalidationTime)){
				isExsit="3";//3:验证码失效
			}else if(verificationCode!=null&&verificationCode.equals(verificationCodeFront)){
				isExsit="1";//正确
			}else if(verificationCode!=null&&!verificationCode.equals(verificationCodeFront)){
				isExsit="2";//2验证码错误
			}
		}else{//session中没有之前存放的短信验证码
			isExsit="2";//2验证码错误
		}
		return isExsit;
	}
	
}

