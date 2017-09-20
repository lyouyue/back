package util.mail;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletContext;
import org.apache.commons.lang.StringUtils;
import basic.pojo.KeyBook;
/**
 * Mail：发送邮件工具类
 * 
 */
public class Mail {
	/**
	 * 发送邮件
	 * @param toAddress 发送地址
	 * @param subject 邮件标题
	 * @param content 邮件内容
	 * @param servletContext servlet上下文（获取数据字典使用）
	 */
	@SuppressWarnings("unchecked")
	public static Boolean  sent(String toAddress,String subject,String content,ServletContext servletContext){
		Boolean flag=true;
		try {
			Map<String,Object> keyBookMap = (Map<String, Object>) servletContext.getAttribute("keybook");
			List<KeyBook> kbList = (List<KeyBook>) keyBookMap.get("mailInformation");
			MailSenderInfo mailInfo=new MailSenderInfo();
			SimpleMailSender sms = new SimpleMailSender(); //该对象用来发送email
			for(KeyBook kb:kbList){
				String name = kb.getName();
				if("MailServerHost".equals(name)){
					mailInfo.setMailServerHost(kb.getValue());//定义邮箱为那个邮箱规则 
				}else if("MailServerPort".equals(name)){
					mailInfo.setMailServerPort(kb.getValue());    
				}else if("UserName".equals(name)){
					mailInfo.setUserName(kb.getValue());//商家邮箱地址  
				}else if("Password".equals(name)){
					mailInfo.setPassword(kb.getValue());//商家邮箱密码    
				}else if("FromAddress".equals(name)){
					mailInfo.setFromAddress(kb.getValue());//商家邮箱地址     
				}
			}
			mailInfo.setValidate(true);    
			mailInfo.setToAddress(toAddress);
			mailInfo.setSubject(subject);
			mailInfo.setContent(content);
			if(StringUtils.isNotEmpty(toAddress)&&StringUtils.isNotEmpty(subject)){
				sms.sendHtmlMail(mailInfo);//发送html格式   
//				sms.sendTextMail(mailInfo);//发送文体格式 
			}else{
				flag=false;
			}
		}catch (Exception e) {
			flag=false;
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return flag;
	}
}
