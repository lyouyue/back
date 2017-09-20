package wxmg.publicNo.service;

import util.service.IBaseService;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 微信基本信息Service接口
 * @author LQS
 *
 */
public interface IPublicNoInfoService  extends IBaseService <PublicNoInfo> {
	public void accessTokenInit();
	public String getToken(PublicNoInfo publicNoInfo);
	public PublicNoInfo getPublicNoInfo();
}
