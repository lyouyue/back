package util.other;
import util.common.EnumUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.tuckey.web.filters.urlrewrite.utils.Log;
/**
 * 封装时间和日期的各种计算方法
 * @author LQS
 *
 */
public class DateUtil {
	private static Log logger = Log.getLog(DateUtil.class);
	/**
	 * 封装了某年某月的开始日期和结束日期
	 * @param yearString
	 * @param monthNum
	 * @return
	 */
	public static String getMonthOfBeginAndEndDate(String yearString,String monthNum){
	    String beginDateString="01";
		String endDateString=null;
	    String beginString="00:00:00";
	    String endString="23:59:59";
	    int year=Integer.valueOf(yearString);
		if("01".equals(monthNum)||"03".equals(monthNum)||"05".equals(monthNum)||"07".equals(monthNum)||"08".equals(monthNum)||"10".equals(monthNum)||"12".equals(monthNum)){
			endDateString="31";
		}
	    if("02".equals(monthNum)){
	    	endDateString="28";
	    	if(year%4==0&&year%100!=0||year%400==0){
	    		endDateString="29";
	    	}
	    }
	    if("04".equals(monthNum)||"06".equals(monthNum)||"09".equals(monthNum)||"11".equals(monthNum)){
	    	endDateString="30";
	    }
		return yearString+"-"+monthNum+"-"+beginDateString+"  "+beginString+","+yearString+"-"+monthNum+"-"+endDateString+"  "+endString;
	}
	/**
	 * 获取当前年月的月的第一天
	 * @param yearString
	 * @param monthNum
	 * @return
	 */
	public static String getMonthBegin(String yearString,String monthNum){
		String beginDateString="01";
		return yearString+"-"+monthNum+"-"+beginDateString;
	}
	/**
	 * 获取当前年月的月的第一天带上开始时间
	 * @param yearString
	 * @param monthNum
	 * @return
	 */
	public static String getMonthBeginWithBeginTime(String yearString,String monthNum){
		String beginDateString="01";
		String beginString="00:00:00";
		return yearString+"-"+monthNum+"-"+beginDateString+"  "+beginString;
	}
	/**
	 * 获取当前年月的月的第一天带上结束时间
	 * @param yearString
	 * @param monthNum
	 * @return
	 */
	public static String getMonthBeginWithEndTime(String yearString,String monthNum){
		String beginDateString="01";
		String endString="23:59:59";
		return yearString+"-"+monthNum+"-"+beginDateString+"  "+endString;
	}
	/**
	 * 获取当前年月的月的最后一天
	 * @param yearString
	 * @param monthNum
	 * @return
	 */
	public static String getMonthEnd(String yearString,String monthNum){
		String endDateString=null;
		int year=Integer.valueOf(yearString);
		if("01".equals(monthNum)||"03".equals(monthNum)||"05".equals(monthNum)||"07".equals(monthNum)||"08".equals(monthNum)||"10".equals(monthNum)||"12".equals(monthNum)){
			endDateString="31";
		}
		if("02".equals(monthNum)){
			endDateString="28";
			if(year%4==0&&year%100!=0||year%400==0){
				endDateString="29";
			}
		}
		if("04".equals(monthNum)||"06".equals(monthNum)||"09".equals(monthNum)||"11".equals(monthNum)){
			endDateString="30";
		}
		return yearString+"-"+monthNum+"-"+endDateString;
	}
	/**
	 * 获取当前年月的月的最后一天带上时间
	 * @param yearString
	 * @param monthNum
	 * @return
	 */
	public static String getMonthEndWithTime(String yearString,String monthNum){
		String endDateString=null;
		String endString="23:59:59";
		int year=Integer.valueOf(yearString);
		if("01".equals(monthNum)||"03".equals(monthNum)||"05".equals(monthNum)||"07".equals(monthNum)||"08".equals(monthNum)||"10".equals(monthNum)||"12".equals(monthNum)){
			endDateString="31";
		}
		if("02".equals(monthNum)){
			endDateString="28";
			if(year%4==0&&year%100!=0||year%400==0){
				endDateString="29";
			}
		}
		if("04".equals(monthNum)||"06".equals(monthNum)||"09".equals(monthNum)||"11".equals(monthNum)){
			endDateString="30";
		}
		return yearString+"-"+monthNum+"-"+endDateString+"  "+endString;
	}
	/**
	 * 日期格式化工具类，格式为 yyyy-MM-dd 年月日
	 * @param date 时间
	 * @return
	 */
	public static String dateToStringYTD(Date date){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		return sdf.format(date);
	}
	/**
	 * 日期格式化工具类，格式为 yyyy-MM-dd 年月日
	 * @param date 时间
	 * @return
	 */
	public static String dateToStringYear(Date date){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		return sdf.format(date);
	}
	/**
	 * 日期格式化工具类，格式为 yyyy-MM-dd 年月日
	 * @param date 时间
	 * @return
	 */
	public static Date stringToDateYTD(String date){
		Date d = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		try {
			d = sdf.parse(date);
		} catch (ParseException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return d;
	}

	/**
     * 获得指定日期的后n天
     *
     * @param specifiedDay 指定日期
     * @return
     */
    public static String getSpecifiedDayAfter(String specifiedDay,Integer n) {
        Calendar c = Calendar.getInstance();
        Date date = null;
        try {
            date = new SimpleDateFormat("yy-MM-dd").parse(specifiedDay);
        } catch (ParseException e) {
            String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        }
        c.setTime(date);
        int day = c.get(Calendar.DATE);
        c.set(Calendar.DATE, day + n);
        String dayAfter = new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
        return dayAfter;
    }

	/**
	 * 获得指定日期的后一天
	 * @author Mengqirui
	 * @param specifiedDay
	 * 		指定的日期 如果为null则判定为当前日期
	 * @param beforeOrAfter
	 * 		计算的方向 before为向前计算 after为向后计算
	 * @param number
	 * 		需要浮动的天数  即向前计算n天  或向后计算n天
	 * @return dayBeforeOrAfter
	 * 		计算后的日期
	 */
	public static String getSpecifiedDayBeforeOrAfter(String specifiedDay,String beforeOrAfter,Integer number) {
		Calendar c = Calendar.getInstance();
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yy-MM-dd");//格式化规则
		Date nowDate = new Date();//当前时间
		String dayBeforeOrAfter = simpleDateFormat.format(nowDate);//计算后的日期 默认使用当前日期
		Date date = nowDate;//日期对象
		try {
			//验证传递的日期是否为null或者空
			if(Utils.stringIsNotEmpty(specifiedDay)){
				//使用传递的日期进行计算
				date = simpleDateFormat.parse(specifiedDay);
			}
			c.setTime(date);//将需要计算的日期赋值给c
			int day = c.get(Calendar.DATE);
			//计算浮动的天数
			int tmp = 0;
			if(Utils.stringIsNotEmpty(beforeOrAfter) && Utils.objectIsNotEmpty(number)){
				if("before".equals(beforeOrAfter)){
					tmp = day-number;
				}else if("after".equals(beforeOrAfter)){
					tmp = day+number;
				}
			}else{
				tmp = day;
			}
			c.set(Calendar.DATE, tmp);
			dayBeforeOrAfter = simpleDateFormat.format(c.getTime());
		} catch (ParseException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return dayBeforeOrAfter;
	}

	/**
	 * 获取指定年月的最后一天
	 * @param year_month 如  2016-04
	 * @return
	 */
	public static String getLastDayByMonth(String year_month) {
		if (Utils.objectIsEmpty(year_month) || "null".equals(year_month)) return "";

		String date[] = year_month.split("-");
		if (Utils.objectIsEmpty(date) || date.length == 0) return "";
		int year = Integer.parseInt(date[0]);
		int month = Integer.parseInt(date[1]);
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.YEAR, year);
		calendar.set(Calendar.MONTH, month-1);
		int  day = calendar.getActualMaximum(Calendar.DATE);

		calendar.set(Calendar.DAY_OF_MONTH, day);
		String lastDayOfMonth = (new SimpleDateFormat("yyyy-MM-dd")).format(calendar.getTime());
		return lastDayOfMonth;
	}
}