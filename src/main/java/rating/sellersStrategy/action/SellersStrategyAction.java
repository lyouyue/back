package rating.sellersStrategy.action;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import net.sf.json.JSONObject;
import rating.sellersStrategy.pojo.SellersStrategy;
import rating.sellersStrategy.service.ISellersStrategyService;
import util.action.BaseAction;
import util.upload.ImageFileUploadUtil;
/**
 * 卖家等级策略Action
 * @author wsy
 *
 */
@SuppressWarnings("serial")
public class SellersStrategyAction extends BaseAction {
	/**卖家等级策略service**/
	private ISellersStrategyService sellersStrategyService;
	/**卖家等级策略实体**/
	private SellersStrategy sellersStrategy;
	private String ids;
	private String sellersLevelId;
	private File imagePath;//图片路径
	private String imagePathFileName;//套餐名
	/**跳转卖家等级策略**/
	public String gotoSellersStrategyPage(){
		return SUCCESS;
	}
	/**查看所有记录**/
	@SuppressWarnings({ "rawtypes" })
	public void listSellersStrategy() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		String hql="select ss.sellersLevelId as sellersLevelId, ss.sellersLevel as sellersLevel, ss.sellersRank as sellersRank, ss.levelIcon as levelIcon, "
				+ "ss.minRefValue as minRefValue, ss.maxRefValue as maxRefValue, ss.levelDiscountValue as levelDiscountValue "
				+ "from SellersStrategy ss where 1=1 order by ss.sellersLevelId";
		//总条数查询
		String countHql="select count(ss.sellersLevelId) from SellersStrategy ss";
		if("true".equals(selectFlag)){
		}
		int totalRecordCount = sellersStrategyService.getCountByHQL(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> lmap = sellersStrategyService.findListMapPage(hql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", lmap);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);//格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**保存新的记录**/
	public void savaOrUpdateSellersStrategy() throws Exception{
		if(sellersStrategy!=null){
			Integer sellersLevel = Integer.valueOf(request.getParameter("sellersLevel"));
			sellersStrategy.setSellersLevel(sellersLevel);
			sellersStrategy = (SellersStrategy) sellersStrategyService.saveOrUpdateObject(sellersStrategy);
			if(sellersStrategy.getSellersLevelId()!=null){
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
	/**异步ajax 图片上传**/
	public void uploadImage() throws Exception {
		JSONObject jo = new JSONObject();
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		// 1图片上传
		if (imagePath != null) {
			String otherImg = ImageFileUploadUtil.uploadImageFile(imagePath, imagePathFileName, getFileUrlConfig(), "image_customer");
			jo.accumulate("photoUrl", otherImg);
			jo.accumulate("visitFileUploadRoot", String.valueOf(getFileUrlConfig().get("uploadFileVisitRoot")));
		} else {
			jo.accumulate("photoUrl", "false1");
		}
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**获取最新一条记录**/
	public void getSellersStrategyObject() throws IOException{
		sellersStrategy = (SellersStrategy) sellersStrategyService.getObjectById(sellersLevelId);
		JSONObject jo = JSONObject.fromObject(sellersStrategy);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**验证级别是否重复**/
	public void checkSellersLevel() throws IOException{
		String sellersLevel = request.getParameter("sellersLevel");
		if(sellersLevel!=null && !"".equals(sellersLevel)){
			Integer count = sellersStrategyService.getCount(" where o.sellersLevel='"+sellersLevel+"'");
			if(count.intValue()==0){
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.print("ok");
				out.flush();
				out.close();
			}
		}
	}
	/**删除记录**/
	public void deleteSellersStrategy() throws IOException{
		Boolean isSuccess = sellersStrategyService.deleteObjectsByIds("sellersLevelId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public SellersStrategy getSellersStrategy() {
		return sellersStrategy;
	}
	public void setSellersStrategy(SellersStrategy sellersStrategy) {
		this.sellersStrategy = sellersStrategy;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getSellersLevelId() {
		return sellersLevelId;
	}
	public void setSellersLevelId(String sellersLevelId) {
		this.sellersLevelId = sellersLevelId;
	}
	public File getImagePath() {
		return imagePath;
	}
	public void setImagePath(File imagePath) {
		this.imagePath = imagePath;
	}
	public String getImagePathFileName() {
		return imagePathFileName;
	}
	public void setImagePathFileName(String imagePathFileName) {
		this.imagePathFileName = imagePathFileName;
	}
	public void setSellersStrategyService(
			ISellersStrategyService sellersStrategyService) {
		this.sellersStrategyService = sellersStrategyService;
	}
}
