package wxmg.fansMessage.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 *粉丝消息集合 
 *（一个列表展示多个粉丝消息时用）
 */
public class FanMessageSet extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -798399734885964418L;
	
	private Integer id;
	/**公众号ID**/
	private Integer publicNumberId;
	/**公众号名称**/
	private String publicNumberName;
	/**粉丝名称**/
	private String nickName;
	/**粉丝用户OPENID**/
	private String fromUserName;
	/**是否回复**/
	private Integer replyFlag;
	/**创建时间**/
	private Integer createTime;
	/**回复时间**/
	private String replyFlagTime;
	/**内容**/
	private String content;
	/**消息类型**/
	private String messageType;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
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
	public Integer getReplyFlag() {
		return replyFlag;
	}
	public void setReplyFlag(Integer replyFlag) {
		this.replyFlag = replyFlag;
	}
	public Integer getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Integer createTime) {
		this.createTime = createTime;
	}
	public String getReplyFlagTime() {
		return replyFlagTime;
	}
	public void setReplyFlagTime(String replyFlagTime) {
		this.replyFlagTime = replyFlagTime;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getMessageType() {
		return messageType;
	}
	public void setMessageType(String messageType) {
		this.messageType = messageType;
	}
	public String getNickName() {
		return nickName;
	}
	public void setNickName(String nickName) {
		this.nickName = nickName;
	}
}
