package wxmg.fansMessage.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 语音识别消息信息
 * @author 郑月龙
 */
public class VoiceIdentifyMessageInfo extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -2560741721659473082L;
	/**语音识别消息信息ID**/
	private Integer voiceIdentifyMessageInfoId;
	/**公众号ID**/
	private Integer publicNumberId;
	/**公众号名称**/
	private String publicNumberName;
	/**粉丝用户OPENID**/
	private String fromUserName;
	/**语音消息媒体ID**/
	private String mediaId;
	/**语音格式**/
	private String format;
	/**语音识别结果**/
	private String recognition;
	/**消息ID**/
	private Long msgId;
	/**是否回复**/
	private Integer replyFlag;
	/**是否收藏**/
	private Integer collectFlag;
	/**创建时间**/
	private Integer createTime;
	/**开发者微信号**/
	private String toUserName;
	/**回复时间**/
	private Date replyFlagTime;
	
	public Integer getVoiceIdentifyMessageInfoId() {
		return voiceIdentifyMessageInfoId;
	}
	public void setVoiceIdentifyMessageInfoId(Integer voiceIdentifyMessageInfoId) {
		this.voiceIdentifyMessageInfoId = voiceIdentifyMessageInfoId;
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
	public String getMediaId() {
		return mediaId;
	}
	public void setMediaId(String mediaId) {
		this.mediaId = mediaId;
	}
	
	public String getFormat() {
		return format;
	}
	public void setFormat(String format) {
		this.format = format;
	}
	public String getRecognition() {
		return recognition;
	}
	public void setRecognition(String recognition) {
		this.recognition = recognition;
	}
	public Long getMsgId() {
		return msgId;
	}
	public void setMsgId(Long msgId) {
		this.msgId = msgId;
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
	public Date getReplyFlagTime() {
		return replyFlagTime;
	}
	public void setReplyFlagTime(Date replyFlagTime) {
		this.replyFlagTime = replyFlagTime;
	}
	
}
