package phone.back.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import phone.back.pojo.PhoneKeyBook;
import phone.back.service.IPhoneKeyBookService;
import util.action.BaseAction;

import com.opensymphony.xwork2.ActionContext;
/**
 * 手机端 数据字典Action类
 * 
 *	2014-01-22
 */
@SuppressWarnings("serial")
public class PhoneKeyBookAction extends BaseAction{
	private IPhoneKeyBookService phoneKeyBookService;
	private PhoneKeyBook phoneKeyBook;
	private List<PhoneKeyBook> phoneKeyBookList = new ArrayList<PhoneKeyBook>();
	private String homeKeyBookId;
	private String ids;
	
	//跳转到数据字典列表页面
	public String gotoPhoneKeyBookPage(){
		return SUCCESS;
	}
	
	//查询所有信息列表
	@SuppressWarnings("unchecked")
	public void listPhoneKeyBook() throws IOException{
		int totalRecordCount = phoneKeyBookService.getCount(" order by o.type,o.value");
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		String [] selectColumns={"homeKeyBookId","value","name","type","typeName"};
		phoneKeyBookList = phoneKeyBookService.findListByPageHelper(selectColumns,pageHelper, " order by o.type,o.value");//" order by o.type,o.value"
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", phoneKeyBookList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	//保存或者修改
	public void saveOrUpdatePhoneKeyBook() throws IOException{
		if(phoneKeyBook!=null){
			phoneKeyBook = (PhoneKeyBook) phoneKeyBookService.saveOrUpdateObject(phoneKeyBook);
			if(phoneKeyBook.getHomeKeyBookId()!=null){
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
	public void getPhoneKeyBookInfo() throws IOException{
		phoneKeyBook = (PhoneKeyBook) phoneKeyBookService.getObjectByParams(" where o.homeKeyBookId='"+homeKeyBookId+"'");
		JSONObject jo = JSONObject.fromObject(phoneKeyBook);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	//删除记录
	public void deletePhoneKeyBook() throws IOException{
		Boolean isSuccess = phoneKeyBookService.deleteObjectsByIds("homeKeyBookId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	//更新初始化数据字典
	@SuppressWarnings("unchecked")
	public void updateInServletContextPhoneKeyBook() throws IOException{
		Map<String, Object> servletContext = ActionContext.getContext().getApplication();
		Boolean isSuccess = false;//返回值，是否更新成功，默认是否
		if (servletContext != null) {
			Map<String,List<PhoneKeyBook>> map = new HashMap<String,List<PhoneKeyBook>>();
			List<String> typeNameList = phoneKeyBookService.distinctType("type", "");//查找类型名称
			for(String typeName : typeNameList){
				List<PhoneKeyBook> homeKeyBookList = phoneKeyBookService.findObjects(null," where o.type = '"+typeName+"' order by o.homeKeyBookId asc ");//根据类型名称查出对象集合
				map.put(typeName, homeKeyBookList);
			}
			servletContext.put("phonekeybook", map);
			isSuccess = true;
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	public String getHomeKeyBookId() {
		return homeKeyBookId;
	}

	public void setHomeKeyBookId(String homeKeyBookId) {
		this.homeKeyBookId = homeKeyBookId;
	}

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	public PhoneKeyBook getPhoneKeyBook() {
		return phoneKeyBook;
	}

	public void setPhoneKeyBook(PhoneKeyBook phoneKeyBook) {
		this.phoneKeyBook = phoneKeyBook;
	}

	public List<PhoneKeyBook> getPhoneKeyBookList() {
		return phoneKeyBookList;
	}

	public void setPhoneKeyBookList(List<PhoneKeyBook> phoneKeyBookList) {
		this.phoneKeyBookList = phoneKeyBookList;
	}

	public void setPhoneKeyBookService(IPhoneKeyBookService phoneKeyBookService) {
		this.phoneKeyBookService = phoneKeyBookService;
	}
	
}
