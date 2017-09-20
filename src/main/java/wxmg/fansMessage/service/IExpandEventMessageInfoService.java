package wxmg.fansMessage.service;

import java.util.List;
import java.util.Map;

import util.service.IBaseService;
import wxmg.basicInfo.pojo.FansUserInfo;
import wxmg.fansMessage.pojo.EventMessageInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;

public interface IExpandEventMessageInfoService extends IBaseService<EventMessageInfo>{
	public void sendMessageByOpenIdWithcustomerIdAndScene(int customerId,int scene,String sourceName,Map<Object,Object> params);
	public void sendMessageByOpenIdWithcustomerId(int customerId,String sendContent,String remark,String sendType);
	public void sendMessageByOpenIdWithScene(String access_token,int customerId,FansUserInfo fansUserInfo,PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList,int scene,String sourceName,Map<Object,Object> params);
	public void confirmEventSource(int customerId,boolean isNew,String access_token,FansUserInfo fansUserInfo,PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList,EventMessageInfo eventMessageInfo);
	public void saveConfirmScanEvent(String access_token,EventMessageInfo eventMessageInfo,PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList);
	public void confirmClickEvent(String access_token,EventMessageInfo eventMessageInfo, PublicNoInfo publicNoInfo,
			List<GlobalRetrunCode> globalRetrunCodeList,Map<Object,Object> fileUrlConfig);
	public void saveFanUserInfoAndCustomer(String access_token,EventMessageInfo eventMessageInfo,PublicNoInfo  publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList,String weixinInfo);
}
