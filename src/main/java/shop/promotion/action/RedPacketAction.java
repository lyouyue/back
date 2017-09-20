package shop.promotion.action;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import net.sf.json.JSONObject;
import shop.promotion.pojo.RedPacket;
import shop.promotion.service.IRedPacketService;
import shop.promotion.service.imp.RedPacketService;
import util.action.BaseAction;
@SuppressWarnings("serial")
public class RedPacketAction extends BaseAction {
	private IRedPacketService redPacketService;
	private RedPacket redPacket;
	private List<RedPacket> redPacketList;
	private String ids;
	private String id;
	public String toRedPacketPage() throws Exception {
		return SUCCESS;
	}
	public void saveOrUpdateRedPacket() throws Exception {
		redPacket=(RedPacket)redPacketService.saveOrUpdateObject(redPacket);
		if(redPacket.getRedPacketId()!=null){
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", "true");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	public void getRedPacketObject() throws Exception {
		redPacket = (RedPacket) redPacketService.getObjectById(id);
		JSONObject jo = JSONObject.fromObject(redPacket);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public void deleteRedPacket() throws Exception {
		Boolean isSuccess = redPacketService.deleteObjectsByIds("redPacketId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public void listRedPacket() throws Exception {
		int totalRecordCount = redPacketService.getCount(null);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		redPacketList = redPacketService.findListByPageHelper(null,pageHelper, " order by o.redPacketId desc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", redPacketList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public RedPacket getRedPacket() {
		return redPacket;
	}
	public void setRedPacket(RedPacket redPacket) {
		this.redPacket = redPacket;
	}
	public void setRedPacketService(RedPacketService redPacketService) {
		this.redPacketService = redPacketService;
	}
	public List<RedPacket> getRedPacketList() {
		return redPacketList;
	}
	public void setRedPacketList(List<RedPacket> redPacketList) {
		this.redPacketList = redPacketList;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
}
