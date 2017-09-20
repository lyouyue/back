package wxmg.basicInfo.service;

import java.util.List;

import util.service.IBaseService;
import wxmg.basicInfo.pojo.FansUserInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;

/**
 * 粉丝用户信息Service接口
 * @author 郑月龙
 */
public interface IFansUserInfoService extends IBaseService <FansUserInfo>{
	
	/**
	 * 获取粉丝用户列表后保存信息
	 * lyz
	 */
	public void saveOrUpdateUsersInfoList(String access_token,PublicNoInfo publicNoInfo,String [] openIdArray,List<GlobalRetrunCode> globalRetrunCodeList);
}
