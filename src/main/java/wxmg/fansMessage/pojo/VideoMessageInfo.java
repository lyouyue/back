package wxmg.fansMessage.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 视频消息信息
 * @author 郑月龙
 */
public class VideoMessageInfo extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -8672418517320679739L;
	/**视频消息信息ID**/
	private Integer videoMessageInfoId;
	/**公众号ID**/
	private Integer publicNumberId;
	/**公众号名称**/
	private String publicNumberName;
	/**粉丝用户OPENID**/
	private String fromUserName;
	/**消息ID**/
	private Long msgId;
	/**消息媒体ID**/
	private String mediaId;
	/**缩略图媒体ID**/
	private String thumbMediaId;
	/**是否回复**/
	private Integer replyFlag;
	/**是否收藏**/
	private Integer collectFlag;
	/**创建时间**/
	private Integer createTime;
	/**开发者微信号**/
	private String toUserName;
	/**视频链接**/
	private String videoUrl;
	/**回复时间**/
	private Date replyFlagTime;
	
	public Integer getVideoMessageInfoId() {
		return videoMessageInfoId;
	}
	public void setVideoMessageInfoId(Integer videoMessageInfoId) {
		this.videoMessageInfoId = videoMessageInfoId;
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
	public Long getMsgId() {
		return msgId;
	}
	public void setMsgId(Long msgId) {
		this.msgId = msgId;
	}
	public String getMediaId() {
		return mediaId;
	}
	public void setMediaId(String mediaId) {
		this.mediaId = mediaId;
	}
	public String getThumbMediaId() {
		return thumbMediaId;
	}
	public void setThumbMediaId(String thumbMediaId) {
		this.thumbMediaId = thumbMediaId;
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
	public String getVideoUrl() {
		return videoUrl;
	}
	public void setVideoUrl(String videoUrl) {
		this.videoUrl = videoUrl;
	}
	public Date getReplyFlagTime() {
		return replyFlagTime;
	}
	public void setReplyFlagTime(Date replyFlagTime) {
		this.replyFlagTime = replyFlagTime;
	}
	
}
