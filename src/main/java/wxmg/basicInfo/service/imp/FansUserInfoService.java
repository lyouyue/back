package wxmg.basicInfo.service.imp;

import it.sauronsoftware.base64.Base64;

import java.util.Date;
import java.util.List;

import net.sf.json.JSONObject;
import util.other.Utils;
import util.service.BaseService;
import wxmg.basicInfo.dao.IFansUserInfoDao;
import wxmg.basicInfo.pojo.FansPublicno;
import wxmg.basicInfo.pojo.FansUserInfo;
import wxmg.basicInfo.service.IFansPublicnoService;
import wxmg.basicInfo.service.IFansUserInfoService;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.util.wx.WXGlobalreturncode;
import wxmg.util.wx.WXGroupManager;
import wxmg.util.wx.WXUserManager;

/**
 * 粉丝用户信息Service接口实现类
 * @author 郑月龙
 */
public class FansUserInfoService extends BaseService <FansUserInfo> implements IFansUserInfoService {
	private IFansUserInfoDao fansUserInfoDao;
	private IFansPublicnoService fansPublicnoService;
	
	/**
	 * 获取粉丝用户列表后保存信息
	 * lyz
	 */
	public void saveOrUpdateUsersInfoList(String access_token,PublicNoInfo publicNoInfo,String [] openIdArray,List<GlobalRetrunCode> globalRetrunCodeList){
		if(Utils.objectIsNotEmpty(publicNoInfo)&&Utils.objectIsNotEmpty(openIdArray)&&openIdArray.length>0){
			//改进方法：
			//获取的粉丝openid要与数据库中openid进行去重，将不同的数据放入一个数组中，
			//去重时要先将数据库中已关注的openid进行去重。第二次将数据库中没有关注的openid
			int length=openIdArray.length;
			//拼接获取的粉丝列表openid串
//			String openidStr="";
			//循环存入所获取的粉丝，如果表里存在该粉丝并且处于关注状态则不进行保存操作，如果过处于非关注状态则修改状态，如果不存在改粉丝则进行保存
			for(int i=0; i<length; i++){
				//查询是否有粉丝
				FansUserInfo fansUserInfo=(FansUserInfo)fansUserInfoDao.get(" where o.userOpenId='"+openIdArray[i]+"'");
//				int fansGroupId=getFansGroupId(access_token,openIdArray[i],globalRetrunCodeList);//获取粉丝分组id
//				JSONObject jo=getUserInfo(access_token,openIdArray[i],globalRetrunCodeList);//获取粉丝信息
				if(Utils.objectIsEmpty(fansUserInfo)){//将表中没有的粉丝添加到表中
					fansUserInfo=saveFansUserInfo(openIdArray[i],0);
					//保存粉丝用户和公众号关联信息表
					if(fansUserInfo.getUserId()!=null){
						saveFansPublicno(publicNoInfo,fansUserInfo);
					}
				}else if(0==fansUserInfo.getSubscribe()){//将为未关注的粉丝改为已关注
//					fansUserInfo=saveFansUserInfo(openIdArray[i],fansUserInfo.getUserId());
					fansUserInfo.setSubscribe(1);
					fansUserInfo=fansUserInfoDao.saveOrUpdateObject(fansUserInfo);
					if(Utils.objectIsNotEmpty(fansUserInfo)&&Utils.objectIsNotEmpty(fansUserInfo.getUserId())){
						//修改粉丝用户和公众号关联信息表关注状态
						FansPublicno fansPublicno =(FansPublicno)fansPublicnoService.getObjectByParams(" where o.toUserName='"+publicNoInfo.getToUserName()+"' and o.userOpenId= '"+fansUserInfo.getUserOpenId()+"'");
						if(Utils.objectIsNotEmpty(fansPublicno)){
							fansPublicno.setSubscribeFlag(1);
							fansPublicnoService.saveOrUpdateObject(fansPublicno);
						}
					}
				}
//				if(i==length-1){
//					openidStr+="'"+openIdArray[i].toString()+"'";
//				}else{
//					openidStr+="'"+openIdArray[i].toString()+"',";
//				}
			}
			//已关注用户如果不在获取的分类列表中则改为未关注
			//获得粉丝列表的openid串
			//此方法有待改进
			/*if(Utils.objectIsNotEmpty(openidStr)){
				List<FansUserInfo> listFansUserInfo=fansUserInfoDao.findByNative(" where o.subscribe=1 and o.userOpenId not in("+openidStr+")");
				if(Utils.objectIsNotEmpty(listFansUserInfo)&&listFansUserInfo.size()>0){
					for(FansUserInfo f:listFansUserInfo){
						//修改粉丝用户表数据
						f.setSubscribe(0);
						FansUserInfo fansUser=(FansUserInfo)fansUserInfoDao.saveOrUpdateObject(f);
						//修改粉丝用户和公众号关联信息表关注状态
						if(Utils.objectIsNotEmpty(fansUser)&&Utils.objectIsNotEmpty(fansUser.getUserOpenId())){
							FansPublicno fansPublicno =(FansPublicno)fansPublicnoService.getObjectByParams(" where o.toUserName='"+publicNoInfo.getToUserName()+"' and o.userOpenId= '"+fansUser.getUserOpenId()+"'");
							if(Utils.objectIsNotEmpty(fansPublicno)){
								fansPublicno.setSubscribeFlag(0);
								FansPublicno fansPublic=(FansPublicno)fansPublicnoService.saveOrUpdateObject(fansPublicno);
							}
						}
					}
				}
			}*/
		}
	}
	
	//根据openid获取单个粉丝用户详细信息
	public JSONObject getUserInfo(String access_token,String openId,List<GlobalRetrunCode> globalRetrunCodeList){
		JSONObject jo = new JSONObject();
		String strJson = WXUserManager.getUserBasicInformation(access_token,openId,"zh_CN");
		// 对strJson串的判断 看是否返回错误消息
		String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
		if(backMessage==null){//为空则返回的正确值
			jo = JSONObject.fromObject(strJson);
		}
		return jo;
	}
	//获取粉丝用户分组id
	public int getFansGroupId(String access_token,String openId,List<GlobalRetrunCode> globalRetrunCodeList){
		JSONObject jsonObject = new JSONObject();
		jsonObject.accumulate("openid",openId);
		String sJson = WXGroupManager.postSubmit(access_token, jsonObject.toString(), "searchUserInGroup");//获取用户分组
		String baM=WXGlobalreturncode.getGlobalReturnCode(sJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
		int fansGroupId=0;
		if(baM==null){
			JSONObject jo = JSONObject.fromObject(sJson);
			fansGroupId=Integer.parseInt(jo.getString("groupid"));
		}
		return fansGroupId;
	}
	//保存粉丝用户信息表并返回fansUserInfo
	public FansUserInfo saveFansUserInfo(String openid,long userId){
		FansUserInfo  fansUserInfo=new FansUserInfo();
		if(userId>0){//userd>0则说明有该值 进行更新操作
			fansUserInfo.setUserId(userId);
		}
		fansUserInfo.setBindingFlag(0);
		fansUserInfo.setFansGroupId(0);
		fansUserInfo.setHeadimgUrl("--");
		fansUserInfo.setNickName(Base64.encode(openid, "UTF-8"));
		fansUserInfo.setRemark("--");
		fansUserInfo.setSubscribe(1);
		fansUserInfo.setUserOpenId(openid);
		fansUserInfo=(FansUserInfo)fansUserInfoDao.saveOrUpdateObject(fansUserInfo);
		return fansUserInfo;
	}
	//保存粉丝用户和公众号关联信息表
	public FansPublicno saveFansPublicno(PublicNoInfo publicNoInfo,FansUserInfo fansUserInfo){
		FansPublicno fansPublicno =(FansPublicno)fansPublicnoService.getObjectByParams(" where o.userId="+fansUserInfo.getUserId()+"  and o.publicNumberId="+publicNoInfo.getPublicNumberId());
		FansPublicno fansPublicnoA=new FansPublicno();
		if(fansPublicno==null){
			fansPublicnoA.setPublicNumberId((long)publicNoInfo.getPublicNumberId());
			fansPublicnoA.setPublicNumberName(publicNoInfo.getWxName());
			fansPublicnoA.setSubscribeFlag(1);
			fansPublicnoA.setSubscribeTime(new Date());
			fansPublicnoA.setUserOpenId(fansUserInfo.getUserOpenId());
			fansPublicnoA.setToUserName(publicNoInfo.getToUserName());
			fansPublicnoA.setUserId(fansUserInfo.getUserId());
			fansPublicnoA=(FansPublicno)fansPublicnoService.saveOrUpdateObject(fansPublicnoA);
		}
		return fansPublicnoA;
	}
	
	public void setFansUserInfoDao(IFansUserInfoDao fansUserInfoDao) {
		this.baseDao = this.fansUserInfoDao = fansUserInfoDao;
	}
	public void setFansPublicnoService(IFansPublicnoService fansPublicnoService) {
		this.fansPublicnoService = fansPublicnoService;
	}
}
