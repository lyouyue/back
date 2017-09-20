package wxmg.fansMessage.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 文本消息信息表
 * @author 郑月龙
 */
public class TextMessageInfo extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -1554680155424664814L;
	/**文本消息信息ID**/
	private Integer textMessageInfoId;
	/**公众号ID**/
	private Integer publicNumberId;
	/**公众号名称**/
	private String publicNumberName;
	/**粉丝用户OPENID**/
	private String fromUserName;
	/**消息ID**/
	private Long msgId;
	/**内容**/
	private String content;
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
	
	
	public Integer getTextMessageInfoId() {
		return textMessageInfoId;
	}
	public void setTextMessageInfoId(Integer textMessageInfoId) {
		this.textMessageInfoId = textMessageInfoId;
	}
	public Integer getPublicNumberId() {
		return publicNumberId;
	}
	public void setPublicNumberId(Integer publicNumberId) {
		this.publicNumberId = publicNumberId;
	}
	public Integer getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Integer createTime) {
		this.createTime = createTime;
	}
	public Long getMsgId() {
		return msgId;
	}
	public void setMsgId(Long msgId) {
		this.msgId = msgId;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getPublicNumberName() {
		return publicNumberName;
	}
	public void setPublicNumberName(String publicNumberName) {
		this.publicNumberName = publicNumberName;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
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
