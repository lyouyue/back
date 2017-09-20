package distribution.configure.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;
import util.action.BaseAction;
import util.other.Utils;
import distribution.configure.pojo.DisConfigure;
import distribution.configure.service.IDisConfigureService;
/**
 * 获取分销配置
 * @author 
 *
 */

public class DisConfigureAction extends BaseAction{
	private static final long serialVersionUID = 497257768570134469L;
	/**分销配置Service**/
	private IDisConfigureService disConfigureService;
	/**分销信息实体类**/
	private DisConfigure disConfigure;
	
	/**
	 * 跳转到分销配置信息页
	 * @return
	 * @throws IOException 
	 */
	public String gotoConfigurePage() throws IOException{
		disConfigure=disConfigureService.getDisConfigure();
		return SUCCESS;
	}
	/**
	 * 保存分销模板信息
	 * @return
	 * @throws IOException 
	 */
	public void saveOrUpdateDisConfigure() throws IOException{
		boolean flag=false;
		disConfigure=(DisConfigure) disConfigureService.saveOrUpdateObject(disConfigure);
		if(Utils.objectIsNotEmpty(disConfigure)&&disConfigure.getConfigureId()!=null ){
			flag=true;
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("flag", flag);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 查询分销模板配置信息列表
	 * @return
	 * @throws IOException 
	 */
	public void getConfigureList() throws IOException{
		pageHelper.setPageSize(pageSize);
		pageHelper.setCurrentPage(currentPage);
		pageHelper=disConfigureService.getPageHelper(pageHelper,getMap());
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", pageHelper.getPageRecordCount());// total键 存放总记录数，必须的
		jsonMap.put("rows", pageHelper.getObjectList());// rows键 存放每页记录 list
		responseWriterMap(jsonMap);
	}
	
	public Map<String,Object>  getMap(){
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("drawingCode","");
		map.put("bankName","");
		map.put("customerName", "");
		return map;
	}
	
	public DisConfigure getDisConfigure() {
		return disConfigure;
	}
	public void setDisConfigure(DisConfigure disConfigure) {
		this.disConfigure = disConfigure;
	}
	public void setDisConfigureService(IDisConfigureService disConfigureService) {
		this.disConfigureService = disConfigureService;
	}
}
