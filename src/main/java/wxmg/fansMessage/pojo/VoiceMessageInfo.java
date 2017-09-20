package wxmg.fansMessage.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 语音消息信息
 * @author 郑月龙
 */
public class VoiceMessageInfo extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 4303092678050931181L;
	/**语音消息信息ID**/
	private Integer voiceMessageInfoId;
	/**公众号ID**/
	private Integer publicNumberId;
	/**公众号名称**/
	private String publicNumberName;
	/**粉丝用户OPENID**/
	private String fromUserName;
	/**消息ID**/
	private Long msgId;
	/**语音格式**/
	private String format;
	/**消息媒体ID**/
	private String mediaId;
	/**是否回复**/
	private Integer replyFlag;
	/**是否收藏**/
	private Integer collectFlag;
	/**创建时间**/
	private Integer createTime;
	/**开发者微信号**/
	private String toUserName;
	/**语音链接**/
	private String voiceUrl;
	/**回复时间**/
	private Date replyFlagTime;
	
	public Integer getVoiceMessageInfoId() {
		return voiceMessageInfoId;
	}
	public void setVoiceMessageInfoId(Integer voiceMessageInfoId) {
		this.voiceMessageInfoId = voiceMessageInfoId;
	}
	public Integer getPublicNumberId() {
		return publicNumberId;
	}
	public void setPublicNumberId(Integer publicNumberId) {
		this.publicNumberId = publicNumberId;
	}
	public String getPublicNumberName() {
		return publicNumberName;
	}
	public void setPublicNumberName(String publicNumberName) {
		this.publicNumberName = publicNumberName;
	}
	public Long getMsgId() {
		return msgId;
	}
	public void setMsgId(Long msgId) {
		this.msgId = msgId;
	}
	
	public String getFormat() {
		return format;
	}
	public void setFormat(String format) {
		this.format = format;
	}
	public String getMediaId() {
		return mediaId;
	}
	public void setMediaId(String mediaId) {
		this.mediaId = mediaId;
	}
	public Integer getReplyFlag() {
		return replyFlag;
	}
	public void setReplyFlag(Integer replyFlag) {
		this.replyFlag = replyFlag;
	}
	public Integer getCollectFlag() {
		return collectFlag;
	}
	public void setCollectFlag(Integer collectFlag) {
		this.collectFlag = collectFlag;
	}
	public Integer getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Integer createTime) {
		this.createTime = createTime;
	}
	public String getFromUserName() {
		return fromUserName;
	}
	public void setFromUserName(String fromUserName) {
		this.fromUserName = fromUserName;
	}
	public String getToUserName() {
		return toUserName;
	}
	public void setToUserName(String toUserName) {
		this.toUserName = toUserName;
	}
	public String getVoiceUrl() {
		return voiceUrl;
	}
	public void setVoiceUrl(String voiceUrl) {
		this.voiceUrl = voiceUrl;
	}
	public Date getReplyFlagTime() {
		return replyFlagTime;
	}
	public void setReplyFlagTime(Date replyFlagTime) {
		this.replyFlagTime = replyFlagTime;
	}
	
	
}
