package shop.statistics;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import shop.order.service.IOrdersService;
import util.action.BaseAction;
import util.other.Utils;

/**   
 * @作用：会员统计 Action
 * @功能：
 * @作者: FuLei
 * @日期：2016年2月1日 下午4:19:31 
 * @版本：V1.0   
 */
@SuppressWarnings("serial")
public class CustomerStatisticsAction extends BaseAction {
	/**订单Service*/
	private IOrdersService ordersService;
	
	/**
	 * @功能：跳转会员统计列表页面
	 * @作者:  FuLei
	 * @参数： @return
	 * @返回值：String
	 * @日期: 2016年2月1日 下午4:13:24 
	 */
	public String gotoCustomerStatistics(){
		return SUCCESS;
	}
	/**
	 * @功能： 会员统计列表查询
	 * @作者:  FuLei
	 * @参数： @throws IOException
	 * @返回值：void
	 * @日期: 2016年2月1日 下午3:22:35 
	 */
	public void listCustomerStatistics() throws IOException{
		String headSql=" select e.customerId,e.loginName,e.salesCount,e.salesPrice,d.refundCount,d.refundPrice from ( ";
		String middleSql=" select c.customerId,c.loginName,count(o.ordersId) as salesCount,sum(os.salesPrice) as salesPrice from shop_orderslist os,shop_orders o ,basic_customer c where os.ordersId=o.ordersId and o.customerId=c.customerId and c.type=1 and o.settlementStatus=1 ";
		String footSql=" select c.customerId,c.loginName,count(a.returnsApplyId) as refundCount,sum(os.salesPrice) as refundPrice from shop_orderslist os,shop_returnsapply a,shop_orders o,basic_customer c where o.ordersId=a.ordersId and os.ordersId=a.ordersId and a.customerId=c.customerId and o.settlementStatus=1 and c.type=1 and a.returnsState=5";
		String createTime = request.getParameter("createTime");
		String createTime2 = request.getParameter("createTime2");
		String loginName = request.getParameter("loginName");
		if(loginName!=null&&!"".equals(loginName)){
			middleSql+=" and c.loginName like '%"+loginName.trim()+"%'";
			footSql+=" and c.loginName like '%"+loginName.trim()+"%'";
		}
		if(createTime!=null&&!"".equals(createTime)){
			middleSql+= " and UNIX_TIMESTAMP(o.createTime) >= UNIX_TIMESTAMP('"+createTime+"')";
			footSql+= " and UNIX_TIMESTAMP(o.createTime) >= UNIX_TIMESTAMP('"+createTime+"')";
		}
		if(createTime2!=null&&!"".equals(createTime2)){
			middleSql+= " and UNIX_TIMESTAMP(o.createTime) <= UNIX_TIMESTAMP('"+createTime2+"')";
			footSql+= " and UNIX_TIMESTAMP(o.createTime) <= UNIX_TIMESTAMP('"+createTime2+"')";
		}
		middleSql+=" group by customerId) e LEFT JOIN (";
		footSql+=" group by customerId) d on d.customerId=e.customerId ";
		String sql=headSql+middleSql+footSql;
		String sqlCount="select count(b.customerId) as count from ("+sql+") b";
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
		String headSql=" select e.customerId,e.loginName,e.salesCount,e.salesPrice,d.refundCount,d.refundPrice from ( ";
		String middleSql=" select c.customerId,c.loginName,count(o.ordersId) as salesCount,sum(os.salesPrice) as salesPrice from shop_orderslist os,shop_orders o ,basic_customer c where os.ordersId=o.ordersId and o.customerId=c.customerId and c.type=1 and o.settlementStatus=1 ";
		String footSql=" select c.customerId,c.loginName,count(a.returnsApplyId) as refundCount,sum(os.salesPrice) as refundPrice from shop_orderslist os,shop_returnsapply a,shop_orders o,basic_customer c where o.ordersId=a.ordersId and os.ordersId=a.ordersId and a.customerId=c.customerId and o.settlementStatus=1 and c.type=1 and a.returnsState=5";
		String createTime = request.getParameter("createTime");
		String createTime2 = request.getParameter("createTime2");
		String loginName = request.getParameter("loginName");
		if(loginName!=null&&!"".equals(loginName)){
			middleSql+=" and c.loginName like '%"+loginName.trim()+"%'";
			footSql+=" and c.loginName like '%"+loginName.trim()+"%'";
		}
		if(createTime!=null&&!"".equals(createTime)){
			middleSql+= " and UNIX_TIMESTAMP(o.createTime) >= UNIX_TIMESTAMP('"+createTime+"')";
			footSql+= " and UNIX_TIMESTAMP(o.createTime) >= UNIX_TIMESTAMP('"+createTime+"')";
		}
		if(createTime2!=null&&!"".equals(createTime2)){
			middleSql+= " and UNIX_TIMESTAMP(o.createTime) <= UNIX_TIMESTAMP('"+createTime2+"')";
			footSql+= " and UNIX_TIMESTAMP(o.createTime) <= UNIX_TIMESTAMP('"+createTime2+"')";
		}
		middleSql+=" group by customerId) e LEFT JOIN (";
		footSql+=" group by customerId) d on d.customerId=e.customerId ";
		String sql=headSql+middleSql+footSql;
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
		typeNameList.add(0, "会员名称");
		typeNameList.add("已付款订单数量");
		typeNameList.add("已付款订单金额");
		typeNameList.add("已退货订单数量");
		typeNameList.add("已退货订单金额");
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
			columnValuesList.add(String.valueOf(cc.get("loginName")));
			columnValuesList.add(String.valueOf(cc.get("salesCount")));
			columnValuesList.add(String.valueOf(cc.get("salesPrice")));
			columnValuesList.add(String.valueOf(cc.get("refundCount")));
			columnValuesList.add(String.valueOf(cc.get("refundPrice")));
			columnRowsList.add(columnValuesList);// 把当前的行 添加到 列表中
		}
		return columnRowsList;
	}
	
	public void setOrdersService(IOrdersService ordersService) {
		this.ordersService = ordersService;
	}
}
