package wxmg.util.wx;  
  
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.junit.Test;
import org.tuckey.web.filters.urlrewrite.utils.Log;

import wxmg.domAnalysisDemo.TextMessageBean;
  
  
/** 
 * xml转换成javaBean
 *  
 * 
 */  
@SuppressWarnings("rawtypes")
public class XmlToJavaBean {
	/**
	 * 日志
	 */
	public static Log logger = Log.getLog(XmlToJavaBean.class);

    /** 
     * xml字符串转换成bean对象 
     *  
     * @param postStr xml字符串 
     * @param clazz 待转换的class 
     * @return 转换后的对象 
     */  
    public static Object postStrToBean(String postStr, Class clazz) {  
        Object obj = null;  
        try {  
            // 将xml格式的数据转换成Map对象  
            Map<String, Object> map = postStrToMap(postStr);  
            //将map对象的数据转换成Bean对象  
            obj = mapToBean(map, clazz);  
        } catch(Exception e) {  
            String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}  
        }  
        return obj;  
    }  
    /** 
     * xml字符串转换成bean对象 
     *  
     * @param root Element对象
     * @param clazz 待转换的class 
     * @return 转换后的对象 
     */ 
    public static Object postStrToBean(Element root,  Class clazz) {
    	 Object obj = null;  
         try {  
             // 将xml格式的数据转换成Map对象  
             Map<String, Object> map = postStrToMap(root);  
             //将map对象的数据转换成Bean对象  
             obj = mapToBean(map, clazz);  
         } catch(Exception e) {  
             String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}  
         }  
         return obj;  
	}
    /** 
     * 将xml格式的字符串转换成Map对象 
     *  
     * @param root Element对象
     * @return Map对象 
     * @throws Exception 异常 
     */  
    private static Map<String, Object> postStrToMap(Element root) {
    	if(root!=null && !"".equals(root)) {  
            Map<String, Object> map = new HashMap<String, Object>();  
            //获取根节点下的所有元素  
            List children = root.elements();  
            //循环所有子元素  
            if(children != null && children.size() > 0) {  
            	for(int i = 0; i < children.size(); i++) {  
            		Element child = (Element)children.get(i);  
            		String strKey = child.getName();
            		strKey =strKey.replaceFirst(strKey.substring(0, 1), strKey.substring(0, 1).toLowerCase())  ;
            		map.put(strKey, child.getTextTrim());  
            	}  
            }  
            return map;  
        }
		return null;  
	}
	/** 
     * 将xml格式的字符串转换成Map对象 
     *  
     * @param postStr xml格式的字符串 
     * @return Map对象 
     * @throws Exception 异常 
     */  
    public static Map<String, Object> postStrToMap(String postStr) throws Exception {  
        if(postStr!=null && !"".equals(postStr)) {  
            Map<String, Object> map = new HashMap<String, Object>();  
            //将xml格式的字符串转换成Document对象  
            Document doc = DocumentHelper.parseText(postStr);  
            //获取根节点  
            Element root = doc.getRootElement();  
            //获取根节点下的所有元素  
            List children = root.elements();  
            //循环所有子元素  
            if(children != null && children.size() > 0) {  
            	for(int i = 0; i < children.size(); i++) {  
            		Element child = (Element)children.get(i);  
            		String strKey = child.getName();
            		//System.out.println("strKey = "+strKey);
            		strKey =strKey.replaceFirst(strKey.substring(0, 1), strKey.substring(0, 1).toLowerCase())  ;
            		//System.out.println("strKey = "+strKey);
            		map.put(strKey, child.getTextTrim());  
            	}  
            }  
            return map;  
        }
		return null;  
    }  
      
    /** 
     * 将Map对象通过反射机制转换成Bean对象 
     *  
     * @param map 存放数据的map对象 
     * @param clazz 待转换的class 
     * @return 转换后的Bean对象 
     * @throws Exception 异常 
     */  
    @SuppressWarnings("unchecked")
    public static Object mapToBean(Map<String, Object> map, Class clazz) throws Exception {  
        Object obj = clazz.newInstance();  
        if(map != null && map.size() > 0) {  
            for(Map.Entry<String, Object> entry : map.entrySet()) {  
                String propertyName = entry.getKey();  
                Object value = entry.getValue();  
                String setMethodName = "set"  
                        + propertyName.substring(0, 1).toUpperCase()  
                        + propertyName.substring(1);  
                try{
                	Field field= getClassField(clazz, propertyName);  
                	if(field!=null){
                		Class fieldTypeClass = field.getType();  
                		value = convertValType(value, fieldTypeClass);  
                		clazz.getMethod(setMethodName, field.getType()).invoke(obj, value);  
                	}  
                }catch(Exception e){
                	String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
                }
            }  
        }  
        return obj;  
    }  
      
    /** 
     * 将Object类型的值，转换成bean对象属性里对应的类型值 
     *  
     * @param value Object对象值 
     * @param fieldTypeClass 属性的类型 
     * @return 转换后的值 
     */  
    private static Object convertValType(Object value, Class fieldTypeClass) {  
        Object retVal = null;  
        if(Long.class.getName().equals(fieldTypeClass.getName())  
                || long.class.getName().equals(fieldTypeClass.getName())) {  
            retVal = Long.parseLong(value.toString());  
        } else if(Integer.class.getName().equals(fieldTypeClass.getName())  
                || int.class.getName().equals(fieldTypeClass.getName())) {  
            retVal = Integer.parseInt(value.toString());  
        } else if(Float.class.getName().equals(fieldTypeClass.getName())  
                || float.class.getName().equals(fieldTypeClass.getName())) {  
            retVal = Float.parseFloat(value.toString());  
        } else if(Double.class.getName().equals(fieldTypeClass.getName())  
                || double.class.getName().equals(fieldTypeClass.getName())) {  
            retVal = Double.parseDouble(value.toString());  
        } else {  
            retVal = value;  
        }  
        return retVal;  
    }  
  
    /** 
     * 获取指定字段名称查找在class中的对应的Field对象(包括查找父类) 
     *  
     * @param clazz 指定的class 
     * @param fieldName 字段名称 
     * @return Field对象 
     */  
 
	private static Field getClassField(Class clazz, String fieldName) {  
        if( Object.class.getName().equals(clazz.getName())) {  
            return null;  
        }  
        Field []declaredFields = clazz.getDeclaredFields();  
        for (Field field : declaredFields) {  
            if (field.getName().equals(fieldName)) {  
                return field;  
            }  
        }  
  
        Class superClass = clazz.getSuperclass();  
        if(superClass != null) {// 简单的递归一下  
            return getClassField(superClass, fieldName);  
        }  
        return null;  
    }

	 @Test
	    //测试方法
		public void testXmlStrToBean(){
			//String postStr="<xml><ToUserName><![CDATA[wenjyweixinhao]]></ToUserName><FromUserName><![CDATA[fromUser]]></FromUserName> <CreateTime>1348831860</CreateTime><MsgType><![CDATA[text]]></MsgType><Content><![CDATA[hellow]]></Content><MsgId>1234567890123456</MsgId></xml>";
			String postStr="<xml><URL><![CDATA[http://wxsj.shopjsp.com/wx/responseInfo/receiveGeneralNews.do]]></URL><ToUserName><![CDATA[wenjyweixinhao]]></ToUserName><FromUserName><![CDATA[412425]]></FromUserName><CreateTime>354534</CreateTime><MsgType><![CDATA[text]]></MsgType><Content><![CDATA[abcdefg]]></Content><MsgId>56856</MsgId></xml>";
			//自动封装xml为bean对象 
			TextMessageBean textMessageBean = (TextMessageBean)postStrToBean(postStr,TextMessageBean.class);
//			System.out.println("****** textMessageBean="+textMessageBean);
//			System.out.println("textMessageBean.getContent() ="+textMessageBean.getContent());
//			System.out.println("textMessageBean.getCreateTime() ="+textMessageBean.getCreateTime());
//			System.out.println(" textMessageBean.getFromUserName()="+textMessageBean.getFromUserName());
//			System.out.println(" textMessageBean.getMsgType()="+textMessageBean.getMsgType());
//			System.out.println(" textMessageBean.getToUserName()="+textMessageBean.getToUserName());
//			System.out.println(" textMessageBean.getMsgId()="+textMessageBean.getMsgId());
			//直接读取xml 
			/**
			Document document= null;
			try {
				document = DocumentHelper.parseText(textTpl);
				Element root = document.getRootElement();
				String toUsername = root.elementText("ToUserName");
				String fromUsername = root.elementText("FromUserName");
				String createTime = root.elementText("CreateTime");
				String msgType = root.elementText("MsgType");
				String content = root.elementText("Content");
				String msgId = root.elementTextTrim("MsgId");
				System.out.println("*********toUsername ="+toUsername);
				System.out.println("*********fromUsername ="+fromUsername);
				System.out.println("*********createTime ="+createTime);
				System.out.println("*********msgType ="+msgType);
				System.out.println("*********content ="+content);
				System.out.println("*********msgId ="+msgId);
			} catch (DocumentException e) {
				String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			}
			*/
		}
}  