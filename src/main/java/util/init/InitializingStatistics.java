package util.init;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.context.ServletContextAware;

import basic.service.IStatisticsService;
import util.common.EnumUtils;
import util.json.FastJsonUtils;

/**
 * @作用：统计首页数据初始化集合列表
 * @功能：
 * @作者:cq
 * @日期：2016年2月22日 上午9:59:46
 * @版本：V1.0
 */
public class InitializingStatistics implements InitializingBean, ServletContextAware{
	//servlet 上下文
	private ServletContext servletContext;
	//
	private IStatisticsService statisticsService;
	/**
	 * @功能：统计首页数据初始化集合列表
	 * @作者:
	 * @参数： @throws IOException
	 * @返回值：void
	 * @日期: 2016年2月19日 下午6:51:48
	 */
	@Override
	public void afterPropertiesSet() throws Exception {
		if (servletContext != null) {
			String sql="SELECT statisticsType,statisticsName,statisticColor,statisticsNum,statisticsUrl FROM `basic_statistics` WHERE isShow=1";
			List<Map<String,Object>> statisticsList =statisticsService.findListMapBySql(sql);
			String statisticsListJson = FastJsonUtils.toJSONString(statisticsList);
			servletContext.setAttribute("statisticsList", statisticsListJson);
			SimpleDateFormat fmt = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());//格式大小写有区别
			String updateTime = fmt.format(new Date());
			servletContext.setAttribute("time2",updateTime);//当前本次统计时间
		    Calendar dar=Calendar.getInstance();
		    dar.setTime(new Date());
		    dar.add(java.util.Calendar.HOUR_OF_DAY, 2); //延后2小时
		    servletContext.setAttribute("time3",fmt.format(dar.getTime()));

		}
	}
	public ServletContext getServletContext() {
		return servletContext;
	}
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}
	public void setStatisticsService(IStatisticsService statisticsService) {
		this.statisticsService = statisticsService;
	}
}
