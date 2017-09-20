package shop.areaOrdersCount.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import basic.service.IAreaService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import shop.order.service.IOrdersService;
import util.action.BaseAction;
import util.other.Utils;

/**   
 * @作用：不同区域订单统计
 * @功能：
 * @作者:cq
 * @日期：2016年2月16日 下午5:25:06 
 * @版本：V1.0   
 */
@SuppressWarnings("serial")
public class AreaOrdersCountAction extends BaseAction{
	/**订单Service*/
	private IOrdersService ordersService;
	/**区域service*/
	private IAreaService areaService;
	private List<Map> firstAreaList;//一级地址
	private Integer areaId;
	//跳转到区域订单列表
	public String gotoAreaOrdersCountPage(){
		//查询出地区信息
		String firstHql="select a.name as name,a.areaId as aid,a.parentId as parent from BasicArea a where a.parentId=0 order by a.areaId";
    	firstAreaList=areaService.findListMapByHql(firstHql);
		return SUCCESS;
		
	}
	
	/**   
	 * @throws IOException 
	 * @作用：区域订单统计列表
	 * @功能：
	 * @作者:
	 * @日期：2016年2月16日 下午5:34:46 
	 * @版本：V1.0   
	 */
	public void areaOrdersCountList() throws IOException{
		//查询条件
		String createTime = request.getParameter("createTime");
		String createTime2 = request.getParameter("createTime2");
		String regionLocation = request.getParameter("regionLocation");//一级地址	
		String city = request.getParameter("city");//二级地址
		String country = request.getParameter("country");//三级地址
		String sql="SELECT b.areaId,count(a.ordersId) as count ,SUM(a.finalAmount) as sum,b.fullName FROM  shop_orders a,basic_area b WHERE 1=1 ";
		
		if(createTime!=null&&!"".equals(createTime)){
			sql+= " and UNIX_TIMESTAMP(a.createTime) >= UNIX_TIMESTAMP('"+createTime+"')";
		}
		if(createTime2!=null&&!"".equals(createTime2)){
			sql+= " and UNIX_TIMESTAMP(a.createTime) <= UNIX_TIMESTAMP('"+createTime2+"')";
		}
		if(regionLocation!=null&&!("").equals(regionLocation)){//一级地址
			if(city!=null&&!("").equals(city)){//二级地址
				if(country!=null&&!"".equals(country)){//三级地址
					sql+= " AND a.country=b.areaId AND b.parentId=a.city AND a.country="+country;
					sql+=" GROUP BY a.country";	
				}else{
				sql+= " AND a.country=b.areaId AND b.parentId=a.city AND a.city="+city;
				sql+=" GROUP BY a.country";
				}
			}else{
			sql+=" and a.city=b.areaId AND b.parentId=a.regionLocation and a.regionLocation="+regionLocation;
			sql+=" GROUP BY a.city";
			}
		}
		else//查询地址为空
		{
		sql+=" AND a.regionLocation=b.areaId GROUP BY a.regionLocation ORDER BY b.areaId";
		}
		String sqlCount="select count(d.areaId) as count from ("+sql+") d";
		int totalRecordCount = Integer.parseInt(String.valueOf(ordersService.findListMapBySql(sqlCount).get(0).get("count")));
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map<String, Object>> customerList = ordersService.findListMapPageBySql(sql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", customerList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//根据areaId 查询下级区域
	public void findAreaList() throws IOException{
		String firstHql="select a.name as name,a.areaId as areaId,a.parentId as parent from BasicArea a where a.parentId="+areaId+" order by a.areaId";
    	List<Map> areaList=areaService.findListMapByHql(firstHql);
		JSONArray jo = JSONArray.fromObject(areaList);//格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter pw;
		pw = response.getWriter();
		pw.write(String.valueOf(jo));
		pw.flush();
		pw.close();
	}
	
	/**
	 * 导出统计数据EXCEL
	 */
	public String exportCountModFuleExcel() throws IOException {
		//查询条件
		String createTime = request.getParameter("createTime");
		String createTime2 = request.getParameter("createTime2");
		String regionLocation = request.getParameter("regionLocation");//一级地址	
		String city = request.getParameter("city");//二级地址
		String country = request.getParameter("country");//三级地址
		String sql="SELECT b.areaId,count(a.ordersId) as count ,SUM(a.finalAmount) as sum,b.fullName FROM  shop_orders a,basic_area b WHERE 1=1 ";
		
		if(createTime!=null&&!"".equals(createTime)){
			sql+= " and UNIX_TIMESTAMP(a.createTime) >= UNIX_TIMESTAMP('"+createTime+"')";
		}
		if(createTime2!=null&&!"".equals(createTime2)){
			sql+= " and UNIX_TIMESTAMP(a.createTime) <= UNIX_TIMESTAMP('"+createTime2+"')";
		}
		if(regionLocation!=null&&!("").equals(regionLocation)){//一级地址
			if(city!=null&&!("").equals(city)){//二级地址
				if(country!=null&&!"".equals(country)){//三级地址
					sql+= " AND a.country=b.areaId AND b.parentId=a.city AND a.country="+country;
					sql+=" GROUP BY a.country";	
				}else{
				sql+= " AND a.country=b.areaId AND b.parentId=a.city AND a.city="+city;
				sql+=" GROUP BY a.country";
				}
			}else{
			sql+=" and a.city=b.areaId AND b.parentId=a.regionLocation and a.regionLocation="+regionLocation;
			sql+=" GROUP BY a.city";
			}
		}else{//查询地址为空
			sql+=" AND a.regionLocation=b.areaId GROUP BY a.regionLocation ORDER BY b.areaId";
		}
		List<Map<String,Object>> customerList = ordersService.findListMapBySql(sql);
		if (Utils.collectionIsNotEmpty(customerList)) {
			session.setAttribute("columnNames", ordersColumnNamesList());// 把所需要传递的columnNames列名集合放在session中。
			session.setAttribute("columnValues",ordersColumnValuesList(customerList));// 把所需要传递的columnValues列名对应的值集合放在session中。
			session.setAttribute("moduleName", "CountModFule");
			return SUCCESS;
		} else {
			this.addActionError("没有数据");
			return ERROR;
		}
	}

	/** excel列名 **/
	private List<String> ordersColumnNamesList() {
		List<String> typeNameList = new ArrayList<String>();
		typeNameList.add(0, "区域名称");
		typeNameList.add("订单数量");
		typeNameList.add("订单总金额");
		return typeNameList;
	}

	/** excel对应列的值 **/
	@SuppressWarnings("rawtypes")
	public List<List<String>> ordersColumnValuesList(List<Map<String,Object>> list)
			throws IOException {
		// 保存二维表样式数据 List <List<String>>
		List<List<String>> columnRowsList = new ArrayList<List<String>>();
		for (Map cc : list) {
			List<String> columnValuesList = null;
			columnValuesList = new ArrayList<String>();
			columnValuesList.add(String.valueOf(cc.get("fullName")));
			columnValuesList.add(String.valueOf(cc.get("count")));
			columnValuesList.add(String.valueOf(cc.get("sum")));
			columnRowsList.add(columnValuesList);// 把当前的行 添加到 列表中
		}
		return columnRowsList;
	}
	
	public void setOrdersService(IOrdersService ordersService) {
		this.ordersService = ordersService;
	}
	public void setAreaService(IAreaService areaService) {
		this.areaService = areaService;
	}
	public List<Map> getFirstAreaList() {
		return firstAreaList;
	}

	public void setFirstAreaList(List<Map> firstAreaList) {
		this.firstAreaList = firstAreaList;
	}

	public Integer getAreaId() {
		return areaId;
	}

	public void setAreaId(Integer areaId) {
		this.areaId = areaId;
	}


}
