package rating.buyersStrategy.action;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import rating.buyersStrategy.pojo.BuyersStrategy;
import rating.buyersStrategy.service.IBuyersStrategyService;
import util.action.BaseAction;
import util.other.Utils;
import util.upload.ImageFileUploadUtil;
import basic.pojo.KeyBook;
/**
 * 买家等级策略Action
 * @author wsy
 *
 */
@SuppressWarnings("serial")
public class BuyersStrategyAction extends BaseAction {
	/**买家等级策略service**/
	private IBuyersStrategyService buyersStrategyService;
	/**买家等级策略实体**/
	private BuyersStrategy buyersStrategy;
	private String ids;
	private String buyersLevelId;
	private File imagePath;//图片路径
	private String imagePathFileName;//套餐名
	/**跳转买家等级策略**/
	public String gotoBuyersStrategyPage(){
		return SUCCESS;
	}
	/**查看所有记录**/
	@SuppressWarnings({ "rawtypes" })
	public void listBuyersStrategy() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		String buyerRank=request.getParameter("buyerRank");
		//String type=request.getParameter("type");
		String hql="select bs.buyersLevelId as buyersLevelId, bs.buyersLevel as buyersLevel, bs.buyerRank as buyerRank, bs.levelIcon as levelIcon, "
				+ "bs.minRefValue as minRefValue, bs.maxRefValue as maxRefValue, bs.levelDiscountValue as levelDiscountValue, bs.lineOfCredit as lineOfCredit, "
				+ "bs.creditDate as creditDate,bs.type as type from BuyersStrategy bs where 1=1 ";
		//总条数查询
		String countHql="select count(bs.buyersLevelId) from BuyersStrategy bs";
		if(Utils.objectIsNotEmpty(selectFlag)){
			if(Utils.objectIsNotEmpty(buyerRank)){
				hql+=" and bs.buyersLevel='"+buyerRank.trim()+"'";
				countHql+=" and bs.buyersLevel='"+buyerRank.trim()+"'";
			}
			/*if(Utils.objectIsNotEmpty(buyerRank)){
				hql+=" and bs.buyerRank like '%"+buyerRank.trim()+"%'";
				countHql+=" and bs.buyerRank like '%"+buyerRank.trim()+"%'";
			}
			if(Utils.objectIsNotEmpty(type)){
				hql+=" and bs.type="+type;
				countHql+=" and bs.type="+type;
			}*/
		}
		hql+=" order by bs.buyersLevel ";
		int totalRecordCount = buyersStrategyService.getCountByHQL(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> lmap = buyersStrategyService.findListMapPage(hql, pageHelper);
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
	public void savaOrUpdateBuyersStrategy() throws Exception{
		if(buyersStrategy!=null){
			Integer buyersLevel = Integer.valueOf(request.getParameter("buyersLevel"));
			buyersStrategy.setBuyersLevel(buyersLevel);
			buyersStrategy = (BuyersStrategy) buyersStrategyService.saveOrUpdateObject(buyersStrategy);
			if(buyersStrategy.getBuyersLevelId()!=null){
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
		PrintWriter out = response.getWriter();
		// 1图片上传
		if (imagePath != null) {
			String otherImg = ImageFileUploadUtil.uploadImageFile(imagePath, imagePathFileName, getFileUrlConfig(), "image_customer");
			jo.accumulate("photoUrl", otherImg);
			jo.accumulate("visitFileUploadRoot", String.valueOf(getFileUrlConfig().get("uploadFileVisitRoot")));
		} else {
			jo.accumulate("photoUrl", "false1");
		}
		response.setContentType("text/html;charset=utf-8");
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**获取最新一条记录**/
	public void getBuyersStrategyObject() throws IOException{
		buyersStrategy = (BuyersStrategy) buyersStrategyService.getObjectById(buyersLevelId);
		JSONObject jo = JSONObject.fromObject(buyersStrategy);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**验证级别是否重复**/
		public void checkBuyersLevel() throws IOException{
			String buyersLevel = request.getParameter("buyersLevel");
			if(buyersLevel!=null && !"".equals(buyersLevel)){
				Integer count = buyersStrategyService.getCount(" where o.buyersLevel='"+buyersLevel+"'");
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
	public void deleteBuyersStrategy() throws IOException{
		Boolean isSuccess = buyersStrategyService.deleteObjectsByIds("buyersLevelId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public BuyersStrategy getBuyersStrategy() {
		return buyersStrategy;
	}
	public void setBuyersStrategy(BuyersStrategy buyersStrategy) {
		this.buyersStrategy = buyersStrategy;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getBuyersLevelId() {
		return buyersLevelId;
	}
	public void setBuyersLevelId(String buyersLevelId) {
		this.buyersLevelId = buyersLevelId;
	}
	public void setBuyersStrategyService(
			IBuyersStrategyService buyersStrategyService) {
		this.buyersStrategyService = buyersStrategyService;
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
}
