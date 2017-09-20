package wxmg.domAnalysisDemo;

/** 回复文本消息，测试使用
 * 
 * 
 *
 */
public class TextMessageBean {
	//开发者微信号
	 String toUserName;
	//发送方帐号（一个OpenID）
	 String fromUserName; 
	//消息创建时间 （整型）
	 int createTime; 
	//text
	 String msgType;
	//文本消息内容
	 String content;
	//消息id，64位整型
	 String msgId;
	public String getToUserName() {
		return toUserName;
	}
	public void setToUserName(String toUserName) {
		this.toUserName = toUserName;
	}
	public String getFromUserName() {
		return fromUserName;
	}
	public void setFromUserName(String fromUserName) {
		this.fromUserName = fromUserName;
	}
	public int getCreateTime() {
		return createTime;
	}
	public void setCreateTime(int createTime) {
		this.createTime = createTime;
	}
	public String getMsgType() {
		return msgType;
	}
	public void setMsgType(String msgType) {
		this.msgType = msgType;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getMsgId() {
		return msgId;
	}
	public void setMsgId(String msgId) {
		this.msgId = msgId;
	}
	 
	 
}
