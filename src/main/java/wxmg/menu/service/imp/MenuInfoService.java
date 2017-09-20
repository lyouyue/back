package wxmg.menu.service.imp;

import java.util.ArrayList;
import java.util.List;

import util.service.BaseService;
import wxmg.menu.dao.IMenuInfoDao;
import wxmg.menu.pojo.MenuInfo;
import wxmg.menu.service.IMenuInfoService;
/**
 * 微信菜单信息Service接口实现类
 * @author LQS
 *
 */
public class MenuInfoService extends BaseService  <MenuInfo> implements IMenuInfoService {
	@SuppressWarnings("unused")
	private IMenuInfoDao wxMenuInfoDao;

	public void setWxMenuInfoDao(IMenuInfoDao wxMenuInfoDao) {
		this.baseDao =this.wxMenuInfoDao = wxMenuInfoDao;
	}
	
	/**
	 * 重新按照一级菜单下面的二级菜单进行重组
	 * @param wxMenuInfoList
	 * @return
	 */
	public List<MenuInfo> resortWXMenuInfoList(List <MenuInfo> wxMenuInfoList){
		List<MenuInfo> resortList=new ArrayList<MenuInfo>();
		for(MenuInfo firstWXMenuInfo:wxMenuInfoList){
			if(firstWXMenuInfo.getParentId().intValue()==0){//一级菜单
				resortList.add(firstWXMenuInfo);
				for(MenuInfo secondWXMenuInfo:wxMenuInfoList){
					if(firstWXMenuInfo.getWxmiId().intValue()==secondWXMenuInfo.getParentId().intValue()){
						resortList.add(secondWXMenuInfo);
					}
				}
			}
		}
		return resortList;
	}
	
	/**
	 * 组装菜单的json数据
	 * @param wxMenuInfoList
	 * @return
	 * 
		*		 {"button":[
		*	      {"type":"click","name":"今日歌曲","key":"V1001_TODAY_MUSIC"},
		*	      {
		*	           "name":"菜单",
		*	           "sub_button":[
		*	            { "type":"view","name":"搜索",url":"http://www.soso.com/"},
		*	            { "type":"click","name":"赞一下我们","key":"V1001_GOOD"}
		*		       ]
		*	       }
		*	      ]}
		*
		* {
		     "button":[
		     {	"type":"click","name":"今日歌曲","key":"V1001_TODAY_MUSIC"},
		      {
		           "name":"菜单",
		           "sub_button":[
		           
		            {"type":"view","name":"搜索", "url":"http://www.soso.com/"},
		            {"type":"view","name":"视频","url":"http://v.qq.com/"},
		            {"type":"click", "name":"赞一下我们","key":"V1001_GOOD"}
		            ]
		       }]
		 }
	 * 
	 */
	public String getMenuJsonString(List <MenuInfo> wxMenuInfoList){
		StringBuilder sb=new StringBuilder();
		StringBuilder firstsb=new StringBuilder();
		StringBuilder secondsb=new StringBuilder();
		if(wxMenuInfoList!=null&&wxMenuInfoList.size()>0){
			sb.append("{ \"button\":[ ");
			for(MenuInfo firstWXMenuInfo:wxMenuInfoList){
				if(firstWXMenuInfo.getParentId().intValue()==0){//一级菜单
					//resortList.add(firstWXMenuInfo);
					firstsb.append("{");
					if(firstWXMenuInfo.getIsOwnerSecondLevel().intValue()==0){//表示当前一级菜单没有二级菜单
						firstsb.append("\"type\":\""+firstWXMenuInfo.getType()+"\",");
						firstsb.append("\"name\":\""+firstWXMenuInfo.getName()+"\",");
						if("click".equals(firstWXMenuInfo.getType())){
							firstsb.append("\"key\":\""+firstWXMenuInfo.getTypeValue()+"\"");
						}else if("view".equals(firstWXMenuInfo.getType())){
							firstsb.append("\"url\":\""+firstWXMenuInfo.getTypeValue()+"\"");
						}
						
					}else if(firstWXMenuInfo.getIsOwnerSecondLevel().intValue()==1){//表示当前一级菜单具有二级菜单
						firstsb.append("\"name\":\""+firstWXMenuInfo.getName()+"\",");
						firstsb.append("\"sub_button\":[");
						secondsb=new StringBuilder();//重新创建，否则后面会有叠加重复
						for(MenuInfo secondWXMenuInfo:wxMenuInfoList){
							//当前二级菜单是当前一级菜单的子菜单
							if(firstWXMenuInfo.getWxmiId().intValue()==secondWXMenuInfo.getParentId().intValue()){//二级菜单
								secondsb.append("{");
								secondsb.append("\"type\":\""+secondWXMenuInfo.getType()+"\",");
								secondsb.append("\"name\":\""+secondWXMenuInfo.getName()+"\",");
								if("click".equals(secondWXMenuInfo.getType())){
									secondsb.append("\"key\":\""+secondWXMenuInfo.getTypeValue()+"\"");
								}else if("view".equals(secondWXMenuInfo.getType())){
									secondsb.append("\"url\":\""+secondWXMenuInfo.getTypeValue()+"\"");
								}
								secondsb.append("},");
							}
						}
						String secondjsonString=secondsb.toString();
						secondjsonString=secondjsonString.substring(0,secondjsonString.length()-1);
						firstsb.append(secondjsonString);
						firstsb.append("]");
					}
					
					firstsb.append("},");
				}
			}
			String firstjsonString=firstsb.toString();
			firstjsonString=firstjsonString.substring(0,firstjsonString.length()-1);
			sb.append(firstjsonString);
			sb.append("]}");
		}else{
			sb.append("");
		}
		
		return sb.toString();
	}
}
