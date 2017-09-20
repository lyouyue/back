package wxmg.material.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;

/**
 * 文本消息信息实体类
 * 
 * @author 李续
 */
public class TextMessageInfo extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4462919393162496712L;
	/**文本消息信息ID**/
	private Integer textMessageInfoId;
	/**公众号ID**/
	private Integer publicNumberId;
	/**公众号名称**/
	private String	publicNumberName;
	/**粉丝用户OPENID**/
	private String fansUserOpenId;
	/**消息ID**/
	private Integer msgId;
	/**内容**/
	private String content;
	/**是否回复**/
	private Integer replyFlag;
	/**是否收藏**/
	private Integer collectFlag;
	/**创建时间**/
	private Date createTime;
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
	public String getPublicNumberName() {
		return publicNumberName;
	}
	public void setPublicNumberName(String publicNumberName) {
		this.publicNumberName = publicNumberName;
	}
	public String getFansUserOpenId() {
		return fansUserOpenId;
	}
	public void setFansUserOpenId(String fansUserOpenId) {
		this.fansUserOpenId = fansUserOpenId;
	}
	public Integer getMsgId() {
		return msgId;
	}
	public void setMsgId(Integer msgId) {
		this.msgId = msgId;
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
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	

}
