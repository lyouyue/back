package shop.customer.action;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import shop.customer.service.ICustomerService;
import shop.customer.service.IMallCoinService;
import util.action.BaseAction;
import util.other.Utils;

/**
 * 统计数据导出到excel的Action
 * @author
 */
@SuppressWarnings("serial")
public class StatisticAnalysisExcelAction extends BaseAction {
	/**金币Service**/
	private IMallCoinService mallCoinService;
	/**取得用户名*/
	private String loginName;
	/**取得订单号*/
	private String ordersNo;
	/**起始时间**/
	private String createTime;
	/**结束时间**/
	private String endTime;
	/**导出excel文件的列名称**/
	private List<String> typeNameList = new ArrayList<String>();

	/**订单统计导出到excel*/
	 public String exportStatisticOrders() throws IOException{
		String sql="select o.serialNumber as serialNumber, b.loginName as loginName, o.ordersNo as ordersNo, o.transactionNumber as transactionNumber, "+
				" o.tradeTime as tradeTime, o.proportion as proportion, o.type as type from basic_customer b,shop_mall_coin o where 1=1 and o.customerId = b.customerId ";
		//查询订单编号不为空
		if(loginName!=null&&!"".equals(loginName.trim())){
			sql +=" and b.loginName like '%"+loginName.trim()+"%'";
		}
		if(ordersNo!=null&&!"".equals(ordersNo.trim())){
			sql +=" and o.ordersNo like '%"+ordersNo.trim()+"%'";
		}
		//结束时间
		if(Utils.objectIsNotEmpty(endTime)){
			sql +=" and o.tradeTime<='"+endTime.trim()+" 23:59:59 999'";
		}
		//起始时间为空
		if(Utils.objectIsNotEmpty(createTime)){
			sql +=" and o.tradeTime>='"+createTime.trim()+" 00:00:00 000'";
		}
		List<Map<String,Object>> countList = mallCoinService.findListMapBySql(sql+" order by o.tradeTime desc");
		if(countList != null && countList.size()>0){
			session.setAttribute("columnNames", ordersColumnNamesList());//把所需要传递的columnNames列名集合放在session中。
			session.setAttribute("columnValues", ordersColumnValuesList(countList));//把所需要传递的columnValues列名对应的值集合放在session中。
			session.setAttribute("moduleName", "StatisticOrders");
			return "success";
		} else {
			this.addActionError("没有数据");
			return "error";
		}
	}

	/**订单统计excel列名**/
	private List<String> ordersColumnNamesList(){
		typeNameList.add(0, "流水号");
		typeNameList.add("会员名称");
		typeNameList.add("订单号");
		typeNameList.add("交易数量(个)");
//		typeNameList.add("剩余数量");
		typeNameList.add("类型");
		typeNameList.add("交易时间");
//		typeNameList.add("分享比例");
		return typeNameList;
	}

	/**订单统计excel对应列的值**/
	public List<List<String>> ordersColumnValuesList(List<Map<String,Object>> list) throws IOException{
		//保存二维表样式数据 List <List<String>>
		List<List<String>> columnRowsList = new ArrayList<List<String>>();
		List<String> columnValuesList = null;
		for(Map<String,Object> cc : list){
			columnValuesList = new ArrayList<String>();
			columnValuesList.add(String.valueOf(cc.get("serialNumber")));
			columnValuesList.add(String.valueOf(cc.get("loginName")));
			if(Utils.objectIsNotEmpty(cc.get("ordersNo"))){
				columnValuesList.add(String.valueOf(cc.get("ordersNo")));
			}else{
				columnValuesList.add("");
			}
			columnValuesList.add(String.valueOf(cc.get("transactionNumber")));
			//columnValuesList.add(String.valueOf(cc.get("remainingNumber")));
			String type=String.valueOf(cc.get("type"));
			if("1".equals(type)){
				type="收入";
			}else if("2".equals(type)){
				type="支出";
			}else if("3".equals(type)){
				type="取消订单";
			}else if("4".equals(type)){
				type="交易作废";
			}
			columnValuesList.add(type);
			columnValuesList.add(String.valueOf(cc.get("tradeTime")));
			Object object = cc.get("proportion");
			/*String proportion="";
			if(object!=null){
				if(!"".equals(proportion)&&!"null".equals(proportion)){
					proportion = String.valueOf(object);
				}
			}*/
//			columnValuesList.add(proportion);
			columnRowsList.add(columnValuesList);//把当前的行 添加到 列表中
		}
		return columnRowsList;
	}

	public String getLoginName() {
		return loginName;
	}
	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}
	public String getOrdersNo() {
		return ordersNo;
	}
	public void setOrdersNo(String ordersNo) {
		this.ordersNo = ordersNo;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public List<String> getTypeNameList() {
		return typeNameList;
	}
	public void setTypeNameList(List<String> typeNameList) {
		this.typeNameList = typeNameList;
	}
	public void setMallCoinService(IMallCoinService mallCoinService) {
		this.mallCoinService = mallCoinService;
	}
}
