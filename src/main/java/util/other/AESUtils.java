package util.other;

import org.apache.log4j.Logger;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

/**
 * AES 加解密（需要密钥，从数据库中取）
 * @author 张丁方
 */
public class AESUtils {
	
	static Logger logger = Logger.getLogger(AESUtils.class);

	private final static String encoding = "UTF-8";
	private static String PASSWORD = "";
	static{
		//初始化密钥
		PASSWORD = String.valueOf(ConfigUtils.getSystemConfigValue("secretKey"));
		logger.info("初始化密钥：" + PASSWORD);
	}

	/**
	 * 加密
	 * @param content 待加密内容
	 * @return 返回加密字符串
	 */
	public static String encrypt(String content) {
		byte[] encryptResult = encryptStr(content);
		String encryptResultStr = parseByte2HexStr(encryptResult);
		// BASE64位加密
		encryptResultStr = ebotongEncrypto(encryptResultStr);
		return encryptResultStr;
	}

	/**
	 * 解密
	 * @param encryptStr 待解密内容
	 * @return 返回解密字符串
	 */
	public static String decrypt(String encryptStr) {
		// BASE64位解密
		String decrpt = ebotongDecrypto(encryptStr);
		byte[] decryptFrom = parseHexStr2Byte(decrpt);
		byte[] decryptResult = decryptStr(decryptFrom);
		return new String(decryptResult);
	}

	/**
	 * 加密
	 * @param content  需要加密的内容
	 * @return	返回二进制
	 */
	private static byte[] encryptStr(String content) {
		try {
			KeyGenerator kgen = KeyGenerator.getInstance("AES");
			//防止linux下 随机生成key
			SecureRandom secureRandom = SecureRandom.getInstance("SHA1PRNG" );
			secureRandom.setSeed(PASSWORD.getBytes());
			kgen.init(128, secureRandom);
			SecretKey secretKey = kgen.generateKey();
			byte[] enCodeFormat = secretKey.getEncoded();
			SecretKeySpec key = new SecretKeySpec(enCodeFormat, "AES");
			Cipher cipher = Cipher.getInstance("AES");// 创建密码器
			byte[] byteContent = content.getBytes("utf-8");
			cipher.init(Cipher.ENCRYPT_MODE, key);// 初始化
			byte[] result = cipher.doFinal(byteContent);
			return result; // 加密
		} catch (NoSuchAlgorithmException e) {
			logger.error("加密异常 NoSuchAlgorithmException = " + e);
		} catch (NoSuchPaddingException e) {
			logger.error("加密异常 NoSuchAlgorithmException = " + e);
		} catch (InvalidKeyException e) {
			logger.error("加密异常 InvalidKeyException = " + e);
		} catch (UnsupportedEncodingException e) {
			logger.error("加密异常 UnsupportedEncodingException = " + e);
		} catch (IllegalBlockSizeException e) {
			logger.error("加密异常 IllegalBlockSizeException = " + e);
		} catch (BadPaddingException e) {
			logger.error("加密异常 BadPaddingException = " + e);
		}
		return null;
	}

	/**
	 * 解密
	 * @param content  待解密内容
	 * @return 返回二进制
	 */
	private static byte[] decryptStr(byte[] content) {
		try {
			KeyGenerator kgen = KeyGenerator.getInstance("AES");
			//防止linux下 随机生成key
			SecureRandom secureRandom = SecureRandom.getInstance("SHA1PRNG" );
			secureRandom.setSeed(PASSWORD.getBytes());
			kgen.init(128, secureRandom);
			SecretKey secretKey = kgen.generateKey();
			byte[] enCodeFormat = secretKey.getEncoded();
			SecretKeySpec key = new SecretKeySpec(enCodeFormat, "AES");
			Cipher cipher = Cipher.getInstance("AES");// 创建密码器
			cipher.init(Cipher.DECRYPT_MODE, key);// 初始化
			byte[] result = cipher.doFinal(content);
			return result; // 加密
		} catch (NoSuchAlgorithmException e) {
			logger.error("解密异常 NoSuchAlgorithmException = " + e);
		} catch (NoSuchPaddingException e) {
			logger.error("解密异常 NoSuchPaddingException = " + e);
		} catch (InvalidKeyException e) {
			logger.error("解密异常 InvalidKeyException = " + e);
		} catch (IllegalBlockSizeException e) {
			logger.error("解密异常 IllegalBlockSizeException = " + e);
		} catch (BadPaddingException e) {
			logger.error("解密异常 BadPaddingException = " + e);
		}
		return null;
	}

	/**
	 * 将16进制转换为二进制
	 *
	 * @param hexStr
	 * @return
	 */
	public static byte[] parseHexStr2Byte(String hexStr) {
		if (hexStr.length() < 1)
			return null;
		byte[] result = new byte[hexStr.length() / 2];
		for (int i = 0; i < hexStr.length() / 2; i++) {
			int high = Integer.parseInt(hexStr.substring(i * 2, i * 2 + 1), 16);
			int low = Integer.parseInt(hexStr.substring(i * 2 + 1, i * 2 + 2), 16);
			result[i] = (byte) (high * 16 + low);
		}
		return result;
	}

	/**
	 * 将二进制转换成16进制
	 *
	 * @param buf
	 * @return
	 */
	public static String parseByte2HexStr(byte buf[]) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < buf.length; i++) {
			String hex = Integer.toHexString(buf[i] & 0xFF);
			if (hex.length() == 1) {
				hex = '0' + hex;
			}
			sb.append(hex.toUpperCase());
		}
		return sb.toString();
	}

	/**
	 * 加密字符串
	 * @param str
	 * @return  String
	 */
	public static String ebotongEncrypto(String str) {
		BASE64Encoder base64encoder = new BASE64Encoder();
		String result = str;
		if (str != null && str.length() > 0) {
			try {
				byte[] encodeByte = str.getBytes(encoding);
				result = base64encoder.encode(encodeByte);
			} catch (Exception e) {
				String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			}
		}
		//base64加密超过一定长度会自动换行 需要去除换行符
		return result.replaceAll("\r\n", "").replaceAll("\r", "").replaceAll("\n", "");
	}

	/**
	 * 解密字符串
	 * @param str
	 * @return  String
	 */
	public static String ebotongDecrypto(String str) {
		BASE64Decoder base64decoder = new BASE64Decoder();
		try {
			byte[] encodeByte = base64decoder.decodeBuffer(str);
			return new String(encodeByte);
		} catch (IOException e) {
			logger.error("BASE64解密异常 IOException = " + e);
			return str;
		}
	}

	/*public static void main(String[] args) {
		String str = "密文";
		System.out.println("待加密内容：" + str);
		String en_str = AESUtils.encrypt(str);
		System.out.println("加密内容：" + en_str);
		String de_str = AESUtils.decrypt(en_str);
		System.out.println("解密内容：" + de_str);
	}*/
}