package wxmg.fansMessage.pojo;

import java.io.Serializable;

import util.pojo.BaseEntity;
/**
 * 事件消息信息
 * @author 郑月龙
 */
public class EventMessageInfo extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 7797310336426765883L;
	/**
	 * 事件消息信息ID
	 */
	private Integer eventMessageInfoId;
	/**
	 * 公众号ID
	 */
	private Integer publicNumberId;
	/**
	 * 公众号名称
	 */
	private String publicNumberName;
	/**
	 * 粉丝用户OPENID
	 */
	private String fromUserName;
	/**
	 * 事件类型
	 */
	private String event;
	/**
	 * 事件KEY值
	 */
	private String eventKey;
	/**
	 * 二维码的TICKET
	 */
	private String ticket;
	/**
	 * 地理位置纬度
	 */
	private String latitude;
	/**
	 * 地理位置经度
	 */
	private String longitude;
	/**
	 * 地理位置精度
	 */
	private String locationPrecision;
	/**
	 * 是否回复
	 */
	private Integer replyFlag;
	/**
	 * 是否收藏
	 */
	private Integer collectFlag;
	/**
	 * 创建时间
	 */
	private Integer createTime;
	/**
	 * 开发者微信号
	 */
	private String toUserName;
	/**
	 * 群发的消息ID
	 */
	private Long msgID;
	/**
	 * 群发的结构
	 */
	private String status;
	/**
	 * 粉丝数
	 */
	private Integer totalCount;
	/**
	 * 过滤数
	 */
	private Integer filterCount;
	/**
	 *发送成功的粉丝数 
	 */
	private Integer sentCount;
	/**
	 *发送失败的粉丝数 
	 */
	private Integer errorCount;
	/**
	 *消息类型
	 */
	private String msgType;
	public Integer getEventMessageInfoId() {
		return eventMessageInfoId;
	}
	public void setEventMessageInfoId(Integer eventMessageInfoId) {
		this.eventMessageInfoId = eventMessageInfoId;
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
	public String getEvent() {
		return event;
	}
	public void setEvent(String event) {
		this.event = event;
	}
	public String getEventKey() {
		return eventKey;
	}
	public void setEventKey(String eventKey) {
		this.eventKey = eventKey;
	}
	public String getTicket() {
		return ticket;
	}
	public void setTicket(String ticket) {
		this.ticket = ticket;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	public String getLocationPrecision() {
		return locationPrecision;
	}
	public void setLocationPrecision(String locationPrecision) {
		this.locationPrecision = locationPrecision;
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
	public String getToUserName() {
		return toUserName;
	}
	public void setToUserName(String toUserName) {
		this.toUserName = toUserName;
	}
	public Long getMsgID() {
		return msgID;
	}
	public void setMsgID(Long msgID) {
		this.msgID = msgID;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Integer getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}
	public Integer getFilterCount() {
		return filterCount;
	}
	public void setFilterCount(Integer filterCount) {
		this.filterCount = filterCount;
	}
	public Integer getSentCount() {
		return sentCount;
	}
	public void setSentCount(Integer sentCount) {
		this.sentCount = sentCount;
	}
	public Integer getErrorCount() {
		return errorCount;
	}
	public void setErrorCount(Integer errorCount) {
		this.errorCount = errorCount;
	}
	public String getMsgType() {
		return msgType;
	}
	public void setMsgType(String msgType) {
		this.msgType = msgType;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	 
	
}
