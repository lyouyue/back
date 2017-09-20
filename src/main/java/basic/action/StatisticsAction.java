package basic.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.json.FastJsonUtils;
import util.other.Utils;
import basic.dao.IStatisticsDao;
import basic.pojo.Statistics;
import basic.service.IStatisticsService;

/**
 * @作用：后台首页维护
 * @功能：
 * @作者:cq
 * @日期：2016年2月18日 下午3:21:08
 * @版本：V1.0
 */
public class StatisticsAction  extends BaseAction{
	private static final long serialVersionUID = -1395120657923919480L;
	private IStatisticsService statisticsService;//添加service
	private IStatisticsDao statisticsDao;
	private Statistics statistics;
	private String statisticsId;
	private String ids;
	//进入后台首页维护页面
	public String gotoStatisticsPage(){
		return SUCCESS;
	}

	//后台首页维护列表
	public void ListStatistics() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		String statisticsCode=request.getParameter("statisticsCode");
		String statisticsName=request.getParameter("statisticsName");
		String sql="SELECT s.statisticsId,DATE_FORMAT(s.updateTime, '%Y-%m-%d %h:%m') as updateTime,s.statisticsType,s.statisticsName,s.statisticsCode,s.statisticsNum,s.statisticsUrl,s.statisticColor,s.isShow,s.sortCode FROM basic_statistics s where 1=1 ";
		String HqlCount="SELECT count(statisticsId) FROM Statistics s where 1=1 ";
		//查询总条数
		if(Utils.objectIsNotEmpty(selectFlag)){
			if(Utils.objectIsNotEmpty(statisticsName)){
				sql+=" and s.statisticsName like '%"+statisticsName.trim()+"%'";
				HqlCount+=" and s.statisticsName like '%"+statisticsName.trim()+"%'";
			}
			if(Utils.objectIsNotEmpty(statisticsCode)){
				sql+=" and s.statisticsCode like '%"+statisticsCode.trim()+"%'";
				HqlCount+=" and s.statisticsCode like '%"+statisticsCode.trim()+"%'";
			}
		}
		sql+=" order by statisticsType ,sortCode ";
		int totalRecordCount =statisticsService.getCountByHQL(HqlCount);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map<String, Object>> statisticsList = statisticsService.findListMapPageBySql(sql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", statisticsList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	//添加或者修改
	public void saveOrUpdateStatistics() throws IOException{
		if(Utils.objectIsNotEmpty(statistics)){
			if(Utils.objectIsNotEmpty(statistics.getStatisticsId())){//判断id是否为空
				statistics.setUpdateTime(new Date());
			}
			statistics =  (Statistics) statisticsService.saveOrUpdateObject(statistics);
			if(Utils.objectIsNotEmpty(statistics.getStatisticsId())){
				//如果修改成功则重新更新统计
				//statisticsService.updateStatistics();
				JSONObject jo = new JSONObject();
				jo.accumulate("isSuccess", "true");
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.println(jo.toString());
				out.flush();
				out.close();
			}
		}
	}
	//获取一条记录
	public void getStatisticsInfo() throws IOException{
		statistics = (Statistics) statisticsService.getObjectByParams(" where o.statisticsId='"+statisticsId+"'");
		JSONObject jo = JSONObject.fromObject(statistics);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除记录
	public void deleteStatistics() throws IOException{
		Boolean isSuccess = statisticsService.deleteObjectsByIds("statisticsId",ids);
		String[] split = ids.split(",");//解析ids
		for(String id : split){
			List<Statistics> statisticsList = statisticsService.findObjects(" where o.statisticsId='"+id+"'");
			for(Statistics ss : statisticsList){
				statisticsService.deleteObjectByParams(" where o.statisticsId='"+ss.getStatisticsId()+"'");
			}
		}
		//如果修改成功则重新更新统计
		if(isSuccess){
			statisticsService.updateStatistics();
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	//更新数据到内存
	public void initStatisticsHome() throws IOException{
		String sql="select statisticsType,statisticsName,statisticsCode,statisticsNum,statisticColor,statisticsUrl,updateTime,sortCode from basic_statistics  where  isShow=1";
		List<Map<String, Object>> statisticsList=	statisticsService.findListMapBySql(sql);
		if(Utils.collectionIsNotEmpty(statisticsList)){
			//加载到上下文中
			String statisticsListJson = FastJsonUtils.toJSONString(statisticsList);
			servletContext.setAttribute("statisticsList", statisticsListJson);
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", "true");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();

	}

	//更新数据
	public void updateData() throws IOException{
		//取的相应的值
		Map<String,Object> statisticsMap =statisticsService.getStatisticsMap();
		if(Utils.objectIsNotEmpty(statisticsMap)){
			Iterator<String> it=statisticsMap.keySet().iterator();
			String key = "";
			String updateTime="";
			while(it.hasNext()){
				key = it.next();
				SimpleDateFormat fmt = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());//格式大小写有区别
				updateTime = fmt.format(new Date());
				String sql="update basic_statistics o set o.updateTime='"+updateTime+"', o.statisticsNum='"+statisticsMap.get(key)+"' where o.statisticsCode="+key;
				statisticsService.updateBySQL(sql);
			}
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", "true");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();

	}

	public void setStatisticsService(IStatisticsService statisticsService) {
		this.statisticsService = statisticsService;
	}
	public Statistics getStatistics() {
		return statistics;
	}
	public void setStatistics(Statistics statistics) {
		this.statistics = statistics;
	}
	public String getStatisticsId() {
		return statisticsId;
	}
	public void setStatisticsId(String statisticsId) {
		this.statisticsId = statisticsId;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}

	public void setStatisticsDao(IStatisticsDao statisticsDao) {
		this.statisticsDao = statisticsDao;
	}

}
