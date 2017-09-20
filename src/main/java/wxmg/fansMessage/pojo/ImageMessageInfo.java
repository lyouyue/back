package wxmg.fansMessage.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 图片消息信息	
 * @author 郑月龙
 */
public class ImageMessageInfo extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -5487387946334150216L;
	/**图片消息信息ID**/
	private Integer picMessageInfoId;
	/**公众号ID**/
	private Integer publicNumberId;
	/**公众号名称**/
	private String publicNumberName;
	/**粉丝用户OPENID**/
	private String fromUserName;
	/**消息ID**/
	private Long msgId;
	/**图片链接**/
	private String picUrl;
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
	/**回复时间**/
	private Date replyFlagTime;
	
	
	public Integer getPicMessageInfoId() {
		return picMessageInfoId;
	}
	public void setPicMessageInfoId(Integer picMessageInfoId) {
		this.picMessageInfoId = picMessageInfoId;
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
	public String getPicUrl() {
		return picUrl;
	}
	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
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
	public Date getReplyFlagTime() {
		return replyFlagTime;
	}
	public void setReplyFlagTime(Date replyFlagTime) {
		this.replyFlagTime = replyFlagTime;
	}
	
}
