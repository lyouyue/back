package basic.service;
import java.util.Map;

import util.service.IBaseService;
import basic.pojo.Statistics;
/**
 * 统计Service接口
 * @author wy
 *
 */
public interface IStatisticsService extends IBaseService <Statistics>{

	public Map<String, Object> getStatisticsMap();
	/**
	 * @功能：定时修改后台首页展示数据，并同时更新application中的值
	 * @作者: 
	 * @参数： 
	 * @返回值：void
	 * @日期: 2016年2月22日 下午2:32:27 
	 */
	public void updateStatistics();
}
