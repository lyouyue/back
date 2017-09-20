/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
 * ============================================================================
 * 版权所有 2011 - 今 北京华宇盈通科技有限公司，并保留所有权利。
 * ----------------------------------------------------------------------------
 * 提示：在未取得SHOPJSP商业授权之前，您不能将本软件应用于商业用途，否则SHOPJSP将保留追究的权力。
 * ----------------------------------------------------------------------------
 * 官方网站：http://www.shopjsp.com
 * ============================================================================
*/
package util.json;


import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import util.other.Utils;

/**
 * 工具类 - 封装回写页面json值
 * 
 * */
public class JsonUtils {
	//回写页面json值
	public static void responsePrintToJson(HttpServletResponse response, String jsonValue) {
		try {
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jsonValue);
			out.flush();
			out.close();
		} catch (IOException e) {
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}

	/**
	 * 将对象专成json
	 * {"key":{"name":"value"}}
	 * 数据格式：{"cmsarticle":{"title":"test","brief":"ttt"}}
	 * @author ma
	 * */
	@SuppressWarnings("unchecked")
	public static Object createObjectToJson(Object object) {
		Field[] fields = object.getClass().getDeclaredFields();
		StringBuffer sb=new StringBuffer();
		sb.append("{\""+object.getClass().getSimpleName().toLowerCase()+"\":{");
		for (int i=0;i<fields.length;i++){
			Field field=fields[i];
			field.setAccessible(true);
			String fieldName = field.getName();
			String type = field.getGenericType().toString();
			if(!"serialVersionUID".equals(fieldName)){
				Object fieldValue=getFieldValue(object,fieldName);
				if(null!=fieldValue){
					if(type.equals("java.util.List<java.lang.Object>")){
						fieldValue=createListJsonString((List<Object>) fieldValue);
						if(fieldValue!=null){
							sb.append("\""+fieldName+"\":"+fieldValue+",");
						}
					}else if (type.equals("class java.util.Date")){
						SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
						fieldValue=sf.format(fieldValue);
							sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
					}else if(type.equals("class java.lang.Integer")){
							sb.append("\""+fieldName+"\":"+fieldValue+",");
					}else if(type.equals("class java.lang.Long")){
							sb.append("\""+fieldName+"\":"+fieldValue+",");
					}else if(type.equals("class java.lang.Double")){
							sb.append("\""+fieldName+"\":"+fieldValue+",");
					}
					else{
						sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
					}
				}
			}
		}
		sb.replace(sb.length()-1, sb.length(), "");
		sb.append("}}");
		return sb.toString();
	}
	
	/**
	 * 将对象专成json
	 * {"key":"value"}
	 * 数据格式：{"title":"test","brief":"ttt"}
	 * @author ma
	 * */
	@SuppressWarnings("unchecked")
	public static Object createObjectToJsonStr(Object object) {
		Field[] fields = object.getClass().getDeclaredFields();
		StringBuffer sb=new StringBuffer();
		sb.append("{");
		for (int i=0;i<fields.length;i++){
			Field field=fields[i];
			field.setAccessible(true);
			String fieldName = field.getName();
			String type = field.getGenericType().toString();
			if(!"serialVersionUID".equals(fieldName)){
				Object fieldValue=getFieldValue(object,fieldName);
				
				if(null!=fieldValue){
					if(type.equals("java.util.List<java.lang.Object>")){
						fieldValue=createListJsonString((List<Object>) fieldValue);
						if(fieldValue!=null){
							sb.append("\""+fieldName+"\":"+fieldValue+",");
						}
					}else if (type.equals("class java.util.Date")){
						SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
						fieldValue=sf.format(fieldValue);
						sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
					}else if(type.equals("class java.lang.Integer")){
							sb.append("\""+fieldName+"\":"+fieldValue+",");
					}else if(type.equals("class java.lang.Long")){
							sb.append("\""+fieldName+"\":"+fieldValue+",");
					}else if(type.equals("class java.lang.Double")){
							sb.append("\""+fieldName+"\":"+fieldValue+",");
					}else{
						sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
					}
				}
			}
		}
		sb.replace(sb.length()-1, sb.length(), "");
		sb.append("}");
		return sb.toString();
	}
	
	/**
	 * 将对象专成String
	 * 数据格式： "cmsarticle":{"title":"test","brief":"ttt"}
	 * @author 
	 * */
	@SuppressWarnings("unchecked")
	public static Object createObjectToString(Object object) {
		Field[] fields = object.getClass().getDeclaredFields();
		StringBuffer sb=new StringBuffer();
		sb.append("\""+object.getClass().getSimpleName().toLowerCase()+"\":{");
		for (int i=0;i<fields.length;i++){
			Field field=fields[i];
			field.setAccessible(true);
			String fieldName = field.getName();
			String type = field.getGenericType().toString();
			if(!"serialVersionUID".equals(fieldName)){
				Object fieldValue=getFieldValue(object,fieldName);
				
				if(null!=fieldValue){
					if(type.equals("java.util.List<java.lang.Object>")){
						fieldValue=createListJsonString((List<Object>) fieldValue);
						if(fieldValue!=null){
						
							sb.append("\""+fieldName+"\":"+fieldValue+",");
						
						}
					}else if (type.equals("class java.util.Date")){
						SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
						fieldValue=sf.format(fieldValue);
						
							sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
						
					}else if(type.equals("class java.lang.Integer")){

						
							sb.append("\""+fieldName+"\":"+fieldValue+",");
						
					}else if(type.equals("class java.lang.Long")){

						
							sb.append("\""+fieldName+"\":"+fieldValue+",");
						
					}else if(type.equals("class java.lang.Double")){

						
							sb.append("\""+fieldName+"\":"+fieldValue+",");
						
					}
					else
					{
					
						sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
					}
				}
			}
		}
		sb.replace(sb.length()-1, sb.length(), "");
		sb.append("}");
		return sb.toString();
	}
	
	/**
	 * 将对象集合封装成json
	 * {"key":[{},{}]}
	 * @author ma
	 * */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static String createListJsonString(String objectKeyName,List list){
		StringBuffer sb=new StringBuffer();
		sb.append("{\""+objectKeyName+"\":[");
		int con=1;//用于计数
		for(Object object:list){
			sb.append("{");
			Field[] fields = object.getClass().getDeclaredFields();
			for (int i=0;i<fields.length;i++){
				Field field=fields[i];
				field.setAccessible(true);
				String fieldName = field.getName();
				String type = field.getGenericType().toString();
				if(!"serialVersionUID".equals(fieldName)){
					Object fieldValue=getFieldValue(object,fieldName);
					if(null!=fieldValue){
						if(type.equals("java.util.List<java.lang.Object>")){
							fieldValue=createListJsonString((List<Object>) fieldValue);
							if(fieldValue!=null){
							
								sb.append("\""+fieldName+"\":"+fieldValue+",");
							
							}
						}else if (type.equals("class java.util.Date")){
							SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
							fieldValue=sf.format(fieldValue);
							
								sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
							
						}else if(type.equals("class java.lang.Integer")){

							
								sb.append("\""+fieldName+"\":"+fieldValue+",");
							
						}else if(type.equals("class java.lang.Long")){

							
								sb.append("\""+fieldName+"\":"+fieldValue+",");
							
						}else if(type.equals("class java.lang.Double")){

							
								sb.append("\""+fieldName+"\":"+fieldValue+",");
							
						}
						
						else
						{
						
							sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
						}
					}
				}
			}
			con++;
			sb.replace(sb.length()-1, sb.length(), "");
			if(con<=list.size()){sb.append("},");}else{
				sb.append("}");
			}
		}
		sb.append("]}");
		return sb.toString();
		
	}
	
	/**
	 * 将对象集合封装成json
	 * @author ma
	 * [{},{}]
	 * */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static String createListJsonString(List list){
		StringBuffer sb=new StringBuffer();
		if(list.size()>0){
		sb.append("[");
		int con=1;//用于计数
		for(Object object:list){
			sb.append("{");
			Field[] fields = object.getClass().getDeclaredFields();
			for (int i=0;i<fields.length;i++){
				Field field=fields[i];
				field.setAccessible(true);
				String fieldName = field.getName();
				String type = field.getGenericType().toString();
				if(!"serialVersionUID".equals(fieldName)){
					Object fieldValue=getFieldValue(object,fieldName);
					if(null!=fieldValue){
						if(type.equals("java.util.List<java.lang.Object>")){
							fieldValue=createListJsonString((List<Object>) fieldValue);
							if(fieldValue!=null){
							
								sb.append("\""+fieldName+"\":"+fieldValue+",");
							
							}
						}else if (type.equals("class java.util.Date")){
							SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
							fieldValue=sf.format(fieldValue);
							
								sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
							
						}else if(type.equals("class java.lang.Integer")){

								sb.append("\""+fieldName+"\":"+fieldValue+",");
							
						}else if(type.equals("class java.lang.Long")){

								sb.append("\""+fieldName+"\":"+fieldValue+",");
							
						}else if(type.equals("class java.lang.Double")){

								sb.append("\""+fieldName+"\":"+fieldValue+",");
							
						}
						else
						{
							sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
						}
					}
				}
			}
			con++;
			sb.replace(sb.length()-1, sb.length(), "");
			if(con<=list.size()){sb.append("},");}else{
				sb.append("}");
			}
		}
		sb.append("]");
		return sb.toString();
		}else{
			return "[]";
			}
		
		
	}
	
	/**
	 * 将对象集合封装成json
	 * @author ma
	 * [{},{}]
	 * */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static String createListJsonDateFormat(List list,String dateFormat){
		StringBuffer sb=new StringBuffer();
		if(list.size()>0){
		sb.append("[");
		int con=1;//用于计数
		for(Object object:list){
			sb.append("{");
			Field[] fields = object.getClass().getDeclaredFields();
			for (int i=0;i<fields.length;i++){
				Field field=fields[i];
				field.setAccessible(true);
				String fieldName = field.getName();
				String type = field.getGenericType().toString();
				if(!"serialVersionUID".equals(fieldName)){
					Object fieldValue=getFieldValue(object,fieldName);
					if(null!=fieldValue){
						if(type.equals("java.util.List<java.lang.Object>")){
							fieldValue=createListJsonString((List<Object>) fieldValue);
							if(fieldValue!=null){
								sb.append("\""+fieldName+"\":"+fieldValue+",");
							}
						}else if (type.equals("class java.util.Date")){
							SimpleDateFormat sf=new SimpleDateFormat(dateFormat);
							fieldValue=sf.format(fieldValue);
								sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
						}else if(type.equals("class java.lang.Integer")){
								sb.append("\""+fieldName+"\":"+fieldValue+",");
						}else if(type.equals("class java.lang.Long")){
								sb.append("\""+fieldName+"\":"+fieldValue+",");
						}else if(type.equals("class java.lang.Double")){
								sb.append("\""+fieldName+"\":"+fieldValue+",");
						}else{
							sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
						}
					}
				}
			}
			con++;
			sb.replace(sb.length()-1, sb.length(), "");
			if(con<=list.size()){sb.append("},");}else{
				sb.append("}");
			}
		}
		sb.append("]");
		return sb.toString();
		}else{
			return "[]";
			}
		
		
	}
	
	/**
	 * 将bean集合专成字符串  
	 * @author ma
	 * "key"：[]
	 * */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static String createListToString(String objectKeyName,List list){
		StringBuffer sb=new StringBuffer();
		sb.append("\""+objectKeyName+"\":[");
		int con=1;//用于计数
		for(Object object:list){
			sb.append("{");
			Field[] fields = object.getClass().getDeclaredFields();
			for (int i=0;i<fields.length;i++){
				Field field=fields[i];
				field.setAccessible(true);
				String fieldName = field.getName();
				String type = field.getGenericType().toString();
				if(!"serialVersionUID".equals(fieldName)){
					Object fieldValue=getFieldValue(object,fieldName);
					if(null!=fieldValue){
						if(type.equals("java.util.List<java.lang.Object>")){
							fieldValue=createListJsonString((List<Object>) fieldValue);
							if(fieldValue!=null){
								sb.append("\""+fieldName+"\":"+fieldValue+",");
							}
						}else if (type.equals("class java.util.Date")){
							SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
							fieldValue=sf.format(fieldValue);
								sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
						}else if(type.equals("class java.lang.Integer")){
								sb.append("\""+fieldName+"\":"+fieldValue+",");
						}else if(type.equals("class java.lang.Long")){
								sb.append("\""+fieldName+"\":"+fieldValue+",");
						}else if(type.equals("class java.lang.Double")){
								sb.append("\""+fieldName+"\":"+fieldValue+",");
						}else{
							sb.append("\""+fieldName+"\":\""+fieldValue+"\",");
						}
					}
				}
			}
			con++;
			sb.replace(sb.length()-1, sb.length(), "");
			if(con<=list.size()){sb.append("},");}else{
				sb.append("}");
			}
		}
		sb.append("]");
		return sb.toString();
		
	}
	
	/**
	 * 将多个"key"：[]字符串的集合转成json,{"key":[],"key1":[]}
	 * @author ma
	 * */
	public static String getJson(List<Object > list){
		StringBuffer sb=new StringBuffer();
		sb.append("{");
		int con=1;//用于计数
		for(Object o:list){
			con++;
			if(con<=list.size()){sb.append(o+",");
			}else{
				sb.append(o);
			}
		}
		sb.append("}");
		return sb.toString();
	}

	public  static Object getFieldValue(Object object, String fieldName) {
	    try {
			PropertyDescriptor pd = new PropertyDescriptor(fieldName, object.getClass());
			if (pd != null) {
				Method getMethod = pd.getReadMethod();// 获得get方法
				return getMethod.invoke(object);// 执行get方法返回一个Object
			}
		} catch (SecurityException e) {
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		} catch (IllegalArgumentException e) {
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		} catch (IntrospectionException e) {
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		} catch (IllegalAccessException e) {
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		} catch (InvocationTargetException e) {
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	    return "";
	}
	
	
	@SuppressWarnings("rawtypes")
	public static Object toJavaBean(Object object, Map data) throws Exception{
		Field[] fields = object.getClass().getDeclaredFields();
        try {
            for (int i = 0; i < fields.length; i++) { // 遍历所有属性
                String fieldName = fields[i].getName(); // 获取属性的名字
                fieldName = fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1); // 将属性的首字符大写，方便构造get，set方法
                String type = fields[i].getGenericType().toString(); // 获取属性的类型
                String tempFeildName=fieldName.toLowerCase().charAt(0) + fieldName.substring(1);
                if(!"serialVersionUID".equals(tempFeildName)){
                	Object fieldValue=data.get(tempFeildName);
                	if(fieldValue!=null){
		                if (type.equals("class java.lang.String")) { // 如果type是类类型，则前面包含"class "，后面跟类名
		                    Method m = object.getClass().getMethod("get" + fieldName);
		                    String value = (String) m.invoke(object); // 调用getter方法获取属性值
		                    if (value == null) {
		                    	if(fieldValue!=null&&!"null".equals(fieldValue)){
			                        m = object.getClass().getMethod("set"+fieldName,String.class);
			                        m.invoke(object, fieldValue);
		                    	}
		                    }
		                }else  if (type.equals("class java.lang.Integer")) {
		                    Method m = object.getClass().getMethod("get" + fieldName);
		                    Integer value = (Integer) m.invoke(object);
		                    if (value == null) {
		                    	if(fieldValue!=null&&!"null".equals(fieldValue)){
			                        m = object.getClass().getMethod("set"+fieldName,Integer.class);
			                        m.invoke(object, Integer.parseInt(fieldValue.toString()));
		                    	}
		                    }
		                }else if (type.equals("class java.lang.Boolean")) {
		                    Method m = object.getClass().getMethod("get" + fieldName);
		                    Boolean value = (Boolean) m.invoke(object);
		                    if (value == null) {
		                    	if(fieldValue!=null&&!"null".equals(fieldValue)){
			                        m = object.getClass().getMethod("set"+fieldName,Boolean.class);
			                        m.invoke(object, Boolean.parseBoolean(fieldValue.toString()));
		                    	}
		                    }
		                }else if (type.equals("class java.util.Date")) {
		                    Method m = object.getClass().getMethod("get" + fieldName);
		                    Date value = (Date) m.invoke(object);
		                    if (value == null) {
		                        m = object.getClass().getMethod("set"+fieldName,Date.class);
		                        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		                        if(fieldValue!=null&&!"null".equals(fieldValue)){
			                        Date date=sdf.parse(fieldValue.toString());
			                        m.invoke(object, date);
		                        }
		                    }
		                }else if (type.equals("class java.lang.Double")) {
		                    Method m = object.getClass().getMethod("get" + fieldName);
		                    Double value = (Double) m.invoke(object);
		                    if (value == null) {
		                    	if(fieldValue!=null&&!"null".equals(fieldValue)){
			                        m = object.getClass().getMethod("set"+fieldName,Double.class);
			                        m.invoke(object, Double.parseDouble(fieldValue.toString()));
		                    	}
		                    }
		                }else if (type.equals("class java.lang.Float")) {
		                    Method m = object.getClass().getMethod("get" + fieldName);
		                    Float value = (Float) m.invoke(object);
		                    if (value == null) {
		                    	if(fieldValue!=null&&!"null".equals(fieldValue)){
			                        m = object.getClass().getMethod("set"+fieldName,Float.class);
			                        m.invoke(object, Float.parseFloat(fieldValue.toString()));
		                    	}
		                    }
		                }
		                //后面还有其他类型可以再此进行补充
                	}
                }
            }
        } catch (NoSuchMethodException e) {
            //String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        } catch (SecurityException e) {
            //String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        } catch (IllegalAccessException e) {
            //String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        } catch (IllegalArgumentException e) {
            //String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        } catch (InvocationTargetException e) {
            //String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        }
		
        return object;

    }
	
	/**
	 * 将对象转换成map
	 * mlc
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Map ObjectToMap(Object object){
		Map map=new HashMap<String, Object>();
		if(Utils.objectIsNotEmpty(object)){
			Field[] fields = object.getClass().getDeclaredFields();
			for (int i=0;i<fields.length;i++){
				Field field=fields[i];
				field.setAccessible(true);
				String fieldName = field.getName();
				String type = field.getGenericType().toString();
				if(!"serialVersionUID".equals(fieldName)){
					Object fieldValue=getFieldValue(object,fieldName);
					if(null!=fieldValue){
						if(type.equals("java.util.List<java.lang.Object>")){
							fieldValue=toListMap((List<Object>) fieldValue);
							if(fieldValue!=null){
								map.put(fieldName, fieldValue);
							}
						}else if (type.equals("class java.util.Date")){
							SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
							fieldValue=sf.format(fieldValue);
							map.put(fieldName, fieldValue);
							
						}else
						{
							map.put(fieldName, fieldValue);
						}
					}
				}
			}
		}
		return map;
	}
	
	/**
	 * 将对象转换成map
	 * mlc
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Map ObjectToMap(Object object,String dateFormat){
		Map map=new HashMap<String, Object>();
		if(Utils.objectIsNotEmpty(object)){
			Field[] fields = object.getClass().getDeclaredFields();
			for (int i=0;i<fields.length;i++){
				Field field=fields[i];
				field.setAccessible(true);
				String fieldName = field.getName();
				String type = field.getGenericType().toString();
				if(!"serialVersionUID".equals(fieldName)){
					Object fieldValue=getFieldValue(object,fieldName);
					if(null!=fieldValue){
						if(type.equals("java.util.List<java.lang.Object>")){
							fieldValue=toListMap((List<Object>) fieldValue);
							if(fieldValue!=null){
								map.put(fieldName, fieldValue);
							}
						}else if (type.equals("class java.util.Date")){
							SimpleDateFormat sf=new SimpleDateFormat(dateFormat);
							fieldValue=sf.format(fieldValue);
							map.put(fieldName, fieldValue);
							
						}else
						{
							map.put(fieldName, fieldValue);
						}
					}
				}
			}
		}
		return map;
	}
	/**
	 * 
	 * 将集合对象封装成List<Map>
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static List<Map> toListMap(List list,String dateFormat){
		List<Map> listMap=new ArrayList<Map>();
		if(Utils.objectIsNotEmpty(list)&& list.size()>0){
			for(Object object:list){
				Field[] fields = object.getClass().getDeclaredFields();
				Map map=new HashMap<String, Object>();
				for (int i=0;i<fields.length;i++){
					Field field=fields[i];
					field.setAccessible(true);
					String fieldName = field.getName();
					String type = field.getGenericType().toString();
					if(!"serialVersionUID".equals(fieldName)){
						Object fieldValue=getFieldValue(object,fieldName);
						
						if(null!=fieldValue){
							if(type.equals("java.util.List<java.lang.Object>")){
								fieldValue=toListMap((List<Object>) fieldValue);
								if(fieldValue!=null){
									map.put(fieldName, fieldValue);
								}
							}else if (type.equals("class java.util.Date")){
								SimpleDateFormat sf=new SimpleDateFormat(dateFormat);
								fieldValue=sf.format(fieldValue);
								map.put(fieldName, fieldValue);
								
							}
							else
							{
								map.put(fieldName, fieldValue);
							}
						}
					}
				}
				listMap.add(map);
			}
			}
		return listMap;
		
	}
	
	/**
	 * 
	 * 将集合对象封装成List<Map>
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static List<Map> toListMap(List list){
		List<Map> listMap=new ArrayList<Map>();
		if(Utils.objectIsNotEmpty(list)&& list.size()>0){
			for(Object object:list){
				Field[] fields = object.getClass().getDeclaredFields();
				Map map=new HashMap<String, Object>();
				for (int i=0;i<fields.length;i++){
					Field field=fields[i];
					field.setAccessible(true);
					String fieldName = field.getName();
					String type = field.getGenericType().toString();
					if(!"serialVersionUID".equals(fieldName)){
						Object fieldValue=getFieldValue(object,fieldName);
						
						if(null!=fieldValue){
							if(type.equals("java.util.List<java.lang.Object>")){
								fieldValue=toListMap((List<Object>) fieldValue);
								if(fieldValue!=null){
									map.put(fieldName, fieldValue);
								}
							}else if (type.equals("class java.util.Date")){
								SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
								fieldValue=sf.format(fieldValue);
								map.put(fieldName, fieldValue);
								
							}
							else
							{
								map.put(fieldName, fieldValue);
							}
						}
					}
				}
				listMap.add(map);
			}
			}
		return listMap;
		
	}
	 
	/**
     * 将Json对象转换成Map
     * 
     * @param jsonObject json对象
     * @return Map对象
     * @throws JSONException
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map toMap(String jsonString) throws JSONException {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        Map result = new HashMap();
        Iterator iterator = jsonObject.keys();
        String key = null;
        String value = null;
        while (iterator.hasNext()) {
            key = (String) iterator.next();
            value = jsonObject.getString(key);
            result.put(key, value);
        }
        return result;

    }
	
	 /**
     * JSONObject到JavaBean
     * 
     * @param bean javaBean
     * @return json对象
	 * @throws Exception 
     */
    @SuppressWarnings("rawtypes")
	public static Object toJavaBean(Object javabean, String jsonString) throws Exception {
        JSONObject jsonObject = JSONObject.fromObject(jsonString);
        Map map = toMap(jsonObject.toString());
        return toJavaBean(javabean, map);
    }
	
	public static Object parseJsonToObject(Object object,String jsonString) throws Exception {
	   JSONObject jo = JSONObject.fromObject(jsonString);
	   String jsonStr = jo.getString(object.getClass().getSimpleName().toLowerCase());
	   return toJavaBean(object,jsonStr);
	}
	
	public static Integer getCountValue(String countJsonStr){
		@SuppressWarnings("unchecked")
		Map<String, Object> countMap=toMap(countJsonStr);
		Integer count =Integer.parseInt(countMap.get("count").toString()); 
		return count;
	}
	
	@SuppressWarnings("rawtypes")
	public static List<Object> getObjectsByJsonArrayString(String jsonArrayString,String parseName,Class clazz) throws JSONException, Exception{
		List<Object> objectList =new ArrayList<Object>();
		JSONObject dataJson = JSONObject.fromObject(jsonArrayString);
		JSONArray array = dataJson.getJSONArray(parseName);
		for (int i = 0; i < array.size(); i++) {
			Object obj=clazz.newInstance();
			obj=toJavaBean(obj,toMap(array.getJSONObject(i).toString()));
			objectList.add(obj);
		}
		return objectList;
	}
}
