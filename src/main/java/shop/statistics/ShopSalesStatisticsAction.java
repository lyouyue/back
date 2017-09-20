package shop.statistics;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import shop.order.service.IOrdersService;
import util.action.BaseAction;
import util.other.Utils;

/**   
 * @作用：店铺销售排行统计 Action
 * @功能：
 * @作者: FuLei
 * @日期：2016年2月1日 上午11:27:26 
 * @版本：V1.0   
 */
@SuppressWarnings("serial")
public class ShopSalesStatisticsAction extends BaseAction {
	/**订单Service*/
	private IOrdersService ordersService;
	
	/**
	 * @功能：跳转店铺销售统计列表页面
	 * @作者:  FuLei
	 * @参数： @return
	 * @返回值：String
	 * @日期: 2016年2月1日 下午4:13:24 
	 */
	public String gotoShopSalesStatistics(){
		return SUCCESS;
	}
	/**
	 * @功能： 店铺销售统计列表查询
	 * @作者:  FuLei
	 * @参数： @throws IOException
	 * @返回值：void
	 * @日期: 2016年2月1日 下午3:22:35 
	 */
	public void listShopSalesStatistics() throws IOException{
		String sql="select c.shopInfoId as shopInfoId,c.logoUrl as logoUrl,c.customerName as customerName,c.shopName as shopName,d.count as count from (select g.shopInfoId as shopInfoId,g.logoUrl as logoUrl,g.customerName as customerName,g.shopName as shopName from shop_shopinfo g,basic_customer h where g.customerId=h.customerId and h.type=2) c left join (select count(b.shopInfoId) as count,b.shopInfoId as shopInfoId from shop_orders b where 1=1 ";
		String createTime = request.getParameter("createTime");
		String createTime2 = request.getParameter("createTime2");
		String shopName = request.getParameter("shopName");
		if(createTime!=null&&!"".equals(createTime)){
			sql+= " and UNIX_TIMESTAMP(b.createTime) >= UNIX_TIMESTAMP('"+createTime+"')";
		}
		if(createTime2!=null&&!"".equals(createTime2)){
			sql+= " and UNIX_TIMESTAMP(b.createTime) <= UNIX_TIMESTAMP('"+createTime2+"')";
		}
		sql+=" group by b.shopInfoId) d on c.shopInfoId=d.shopInfoId where 1=1 ";
		if(shopName!=null&&!"".equals(shopName)){
			sql+=" and c.shopName like '%"+shopName.trim()+"%'";
		}		
		sql+=" order by d.count desc";
		String sqlCount="select count(b.shopInfoId) as count from ("+sql+") b";
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
	
	/**
	 * 导出统计数据EXCEL
	 */
	public String exportCountModFuleExcel() throws IOException {
		String sql="select c.shopInfoId as shopInfoId,c.logoUrl as logoUrl,c.customerName as customerName,c.shopName as shopName,d.count as count from (select g.shopInfoId as shopInfoId,g.logoUrl as logoUrl,g.customerName as customerName,g.shopName as shopName from shop_shopinfo g,basic_customer h where g.customerId=h.customerId and h.type=2) c left join (select count(b.shopInfoId) as count,b.shopInfoId as shopInfoId from shop_orders b where 1=1 ";
		String createTime = request.getParameter("createTime");
		String createTime2 = request.getParameter("createTime2");
		String shopName = request.getParameter("shopName");
		if(createTime!=null&&!"".equals(createTime)){
			sql+= " and UNIX_TIMESTAMP(b.createTime) >= UNIX_TIMESTAMP('"+createTime+"')";
		}
		if(createTime2!=null&&!"".equals(createTime2)){
			sql+= " and UNIX_TIMESTAMP(b.createTime) <= UNIX_TIMESTAMP('"+createTime2+"')";
		}
		sql+=" group by b.shopInfoId) d on c.shopInfoId=d.shopInfoId where 1=1 ";
		if(shopName!=null&&!"".equals(shopName)){
			sql+=" and c.shopName like '%"+shopName.trim()+"%'";
		}		
		sql+=" order by d.count desc";
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
		typeNameList.add(0, "店铺名称");
		typeNameList.add("订单数量");
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
			columnValuesList.add(String.valueOf(cc.get("shopName")));
			columnValuesList.add(String.valueOf(cc.get("count")));
			columnRowsList.add(columnValuesList);// 把当前的行 添加到 列表中
		}
		return columnRowsList;
	}
	
	public void setOrdersService(IOrdersService ordersService) {
		this.ordersService = ordersService;
	}
}
