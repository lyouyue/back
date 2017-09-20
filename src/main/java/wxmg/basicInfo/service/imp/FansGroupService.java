package wxmg.basicInfo.service.imp;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import util.service.BaseService;
import wxmg.util.wx.WXBasicUtil;
import wxmg.util.wx.WXGroupManager;
import wxmg.basicInfo.dao.IFansGroupDao;
import wxmg.basicInfo.pojo.FansGroup;
import wxmg.basicInfo.service.IFansGroupService;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 粉丝分组Service接口实现类
 * @author 郑月龙
 */
public class FansGroupService extends BaseService <FansGroup> implements IFansGroupService {
	@SuppressWarnings("unused")
	private IFansGroupDao fansGroupDao;
	
	//修改组名
	public void updateGroupName(PublicNoInfo publicNoInfo,FansGroup fansGroup,String access_token){
		try {
			/*json格式
			 * {"group":{"id":108,"name":"test2_modify2"}}
			 */
			JSONObject jsonObject = new JSONObject();
			jsonObject.accumulate("id", fansGroup.getId());
			jsonObject.accumulate("name", fansGroup.getName());
			JSONObject jsonObject2 = new JSONObject();
			jsonObject2.accumulate("group", jsonObject);
//			System.out.println("***********jsonObject2.toString() ="+jsonObject2.toString());
//			String strJson = WXGroupManager.postSubmit("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f", jsonObject2.toString(), "updateGroupName");//测试用
//			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			String strJson = WXGroupManager.postSubmit(access_token, jsonObject2.toString(), "updateGroupName");
//			System.out.println("***********strJson="+strJson);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		
		if (fansGroup != null) {
			fansGroup = (FansGroup) fansGroupDao.saveOrUpdateObject(fansGroup);
		}
	}
	//添加分组
	public void saveGroupName(PublicNoInfo publicNoInfo,FansGroup fansGroup,String access_token){
		String ids="";
		List<FansGroup> fansGroupList=selectGroup(publicNoInfo,access_token);//查找所有
		for(FansGroup fg:fansGroupList){
			ids=ids+fg.getId()+",";
		}
		String[] id=ids.split(",");
		int max=Integer.parseInt(id[0]);
		for(int i=1;i<id.length;i++){
			int a=Integer.parseInt(id[i]);
			if(max<a){
				max=a;
			}
		}
		try {
			 JSONObject jsonObject = new JSONObject();
//			 jsonObject.accumulate("id", 102);//测试用
			 jsonObject.accumulate("id", max+1);
//			 jsonObject.accumulate("name", "testGroup1");//测试用
			 jsonObject.accumulate("name", fansGroup.getName());
			 JSONObject jsonObject2 = new JSONObject();
			 jsonObject2.accumulate("group", jsonObject);
			 JSONObject jsonObject3 = JSONObject.fromObject(jsonObject2);
//			 System.out.println("***********jsonObject3 ="+jsonObject3);
//			 WXGroupManager.postSubmit("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f", jsonObject3.toString(), "createGroup");//测试用
			 WXGroupManager.postSubmit(access_token, jsonObject3.toString(), "createGroup");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		if (fansGroup != null&&publicNoInfo!=null) {
			fansGroup.setPublicNumberId(publicNoInfo.getPublicNumberId());
			fansGroup = (FansGroup) fansGroupDao.saveOrUpdateObject(fansGroup);
		}
	}
	//同步数据
	public boolean updateSynchroGroupDate(PublicNoInfo publicNoInfo,String access_token){
		List<FansGroup> fansGroupList = new ArrayList<FansGroup>();
		fansGroupList=selectGroup(publicNoInfo,access_token);//查找所有
		if(fansGroupList!=null&&fansGroupList.size()>0){
			fansGroupDao.deleteByParams("");
			for(FansGroup fansGroup:fansGroupList){
				fansGroup.setCreateTime(new Date());
				fansGroup.setIsValid(0);
				fansGroup.setPublicNumberId(publicNoInfo.getPublicNumberId());
				fansGroupDao.saveObject(fansGroup);
			}
			return true;
		}else{
			return false;
		}
	}
	//查找所有
	public List<FansGroup> selectGroup(PublicNoInfo publicNoInfo,String access_token){
		List<FansGroup> fansGroupList = new ArrayList<FansGroup>();
		try {
//			String strJson = WXGroupManager.searchAllGroups("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f");//测试用
			String strJson = WXGroupManager.searchAllGroups(access_token);
//			System.out.println("strJson = "+strJson);
			
			JSONObject fromObject = JSONObject.fromObject(strJson);
			Object object = fromObject.get("groups");
			JSONArray fromObject2 = JSONArray.fromObject(object);
			//json数组转换成 对象的集合
			for(Object obj:fromObject2){
				FansGroup fansGroup = new FansGroup();
				JSONObject fromObject3 = JSONObject.fromObject(obj);
				fansGroup.setId( Integer.parseInt(fromObject3.getString("id")));
				fansGroup.setName(fromObject3.getString("name"));
				fansGroup.setCount(Integer.parseInt(fromObject3.getString("count")));
				fansGroupList.add(fansGroup);
			}
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return fansGroupList;
	}
	public void setFansGroupDao(IFansGroupDao fansGroupDao) {
		this.baseDao = this.fansGroupDao = fansGroupDao;
	}
	
}
