package wxmg.sendMessage.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 公众号发送消息信息实体类
 * @author Administrator
 * 2014-09-05
 */
public class WXPublicNumberSendMsgInfo extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 1688934246734634358L;
	/**发送消息信息ID**/
	private Long sendMsgInfoId;
	/**公众号ID**/
	private Long publicNumberIdBigint;
	/**公众号名称**/
	private String publicNumberName;
	/**用户信息ID**/
	private Long userInfoId;
	/**用户名**/
	private String userName;
	/**粉丝用户ID**/
	private Long userId;
	/**粉丝用户名称**/
	private String fanUserName;
	/**素材图文信息ID**/
	private Long materialImageTxtInfoId;
	/**素材图文标题**/
	private String materialTitle;
	/**素材图片信息ID**/
	private Long materialImageInfoId;
	/**图片名称**/
	private String picName;
	/**素材语音信息ID**/
	private Long materialVoiceInfoId;
	/**语音名称**/
	private String voiceName;
	/**素材视频信息ID**/
	private Long materialVideoInfoId;
	/**视频名称**/
	private String videoName;
	/**消息信息ID**/
	private Long messageInfoId;
	/**发送消息类型
	 *  1文本消息：text
    2 图片消息：image
    3 语音消息：voice
    4视频消息：video
    5地理位置消息：location
    6链接消息：link
    7事件消息：event
	 * **/
	private Integer sendMsgTypeEnumId;
	/**发送消息内容**/
	private String sendMsgContent;
	/**备注**/
	private String remark;
	/**发送时间**/
	private Date sendTime;
	
	public Long getSendMsgInfoId() {
		return sendMsgInfoId;
	}
	public void setSendMsgInfoId(Long sendMsgInfoId) {
		this.sendMsgInfoId = sendMsgInfoId;
	}
	public Long getPublicNumberIdBigint() {
		return publicNumberIdBigint;
	}
	public void setPublicNumberIdBigint(Long publicNumberIdBigint) {
		this.publicNumberIdBigint = publicNumberIdBigint;
	}
	public String getPublicNumberName() {
		return publicNumberName;
	}
	public void setPublicNumberName(String publicNumberName) {
		this.publicNumberName = publicNumberName;
	}
	public Long getUserInfoId() {
		return userInfoId;
	}
	public void setUserInfoId(Long userInfoId) {
		this.userInfoId = userInfoId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public Long getUserId() {
		return userId;
	}
	public void setUserId(Long userId) {
		this.userId = userId;
	}
	public String getFanUserName() {
		return fanUserName;
	}
	public void setFanUserName(String fanUserName) {
		this.fanUserName = fanUserName;
	}
	public Long getMaterialImageTxtInfoId() {
		return materialImageTxtInfoId;
	}
	public void setMaterialImageTxtInfoId(Long materialImageTxtInfoId) {
		this.materialImageTxtInfoId = materialImageTxtInfoId;
	}
	public String getMaterialTitle() {
		return materialTitle;
	}
	public void setMaterialTitle(String materialTitle) {
		this.materialTitle = materialTitle;
	}
	public Long getMaterialImageInfoId() {
		return materialImageInfoId;
	}
	public void setMaterialImageInfoId(Long materialImageInfoId) {
		this.materialImageInfoId = materialImageInfoId;
	}
	public String getPicName() {
		return picName;
	}
	public void setPicName(String picName) {
		this.picName = picName;
	}
	public Long getMaterialVoiceInfoId() {
		return materialVoiceInfoId;
	}
	public void setMaterialVoiceInfoId(Long materialVoiceInfoId) {
		this.materialVoiceInfoId = materialVoiceInfoId;
	}
	public String getVoiceName() {
		return voiceName;
	}
	public void setVoiceName(String voiceName) {
		this.voiceName = voiceName;
	}
	public Long getMaterialVideoInfoId() {
		return materialVideoInfoId;
	}
	public void setMaterialVideoInfoId(Long materialVideoInfoId) {
		this.materialVideoInfoId = materialVideoInfoId;
	}
	public String getVideoName() {
		return videoName;
	}
	public void setVideoName(String videoName) {
		this.videoName = videoName;
	}
	public Long getMessageInfoId() {
		return messageInfoId;
	}
	public void setMessageInfoId(Long messageInfoId) {
		this.messageInfoId = messageInfoId;
	}
	public Integer getSendMsgTypeEnumId() {
		return sendMsgTypeEnumId;
	}
	public void setSendMsgTypeEnumId(Integer sendMsgTypeEnumId) {
		this.sendMsgTypeEnumId = sendMsgTypeEnumId;
	}
	public String getSendMsgContent() {
		return sendMsgContent;
	}
	public void setSendMsgContent(String sendMsgContent) {
		this.sendMsgContent = sendMsgContent;
	}
	public Date getSendTime() {
		return sendTime;
	}
	public void setSendTime(Date sendTime) {
		this.sendTime = sendTime;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}
