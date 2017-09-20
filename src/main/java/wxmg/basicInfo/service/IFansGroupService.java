package wxmg.basicInfo.service;

import util.service.IBaseService;
import wxmg.basicInfo.pojo.FansGroup;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 粉丝分组Service接口
 * @author 郑月龙
 *
 */
public interface IFansGroupService extends IBaseService <FansGroup>{

	public void updateGroupName(PublicNoInfo publicNoInfo,FansGroup fansGroup,String access_token);
	public void saveGroupName(PublicNoInfo publicNoInfo,FansGroup fansGroup,String access_token);
	public boolean updateSynchroGroupDate(PublicNoInfo publicNoInfo,String access_token);
	
}
