package wxmg.basicInfo.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 粉丝用户和公众号关联信息
 * @author 郑月龙
 */
public class FansPublicno extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 6749276180110063053L;
	/**
	 * 粉丝公众号关联ID
	 */
	private Long fansPublicNoId;
//	/**
//	 * 公众账号信息ID
//	 */
//	private Integer publicNumberId;
	/**
	 * 用户ID
	 */
	private Long userId;
	/**
	 * 公众账号信息ID
	 */
	private Long publicNumberId;
	/**
	 * 公众号名称
	 */
	private String publicNumberName;
	/**
	 * 用户标识OPENID
	 */
	private String userOpenId;
	/**
	 * 用户是否关注 0 未关注1 已关注
	 */
	private Integer subscribeFlag;
	/**
	 * 用户关注时间
	 */
	private Date subscribeTime;
	/**
	 * 开发者微信号
	 */
	private String toUserName;
	
	public String getToUserName() {
		return toUserName;
	}
	public void setToUserName(String toUserName) {
		this.toUserName = toUserName;
	}
	public Long getFansPublicNoId() {
		return fansPublicNoId;
	}
	public void setFansPublicNoId(Long fansPublicNoId) {
		this.fansPublicNoId = fansPublicNoId;
	}
	public Long getUserId() {
		return userId;
	}
	public void setUserId(Long userId) {
		this.userId = userId;
	}
	public Long getPublicNumberId() {
		return publicNumberId;
	}
	public void setPublicNumberId(Long publicNumberId) {
		this.publicNumberId = publicNumberId;
	}
	public String getPublicNumberName() {
		return publicNumberName;
	}
	public void setPublicNumberName(String publicNumberName) {
		this.publicNumberName = publicNumberName;
	}
	public String getUserOpenId() {
		return userOpenId;
	}
	public void setUserOpenId(String userOpenId) {
		this.userOpenId = userOpenId;
	}
	public Integer getSubscribeFlag() {
		return subscribeFlag;
	}
	public void setSubscribeFlag(Integer subscribeFlag) {
		this.subscribeFlag = subscribeFlag;
	}
	public Date getSubscribeTime() {
		return subscribeTime;
	}
	public void setSubscribeTime(Date subscribeTime) {
		this.subscribeTime = subscribeTime;
	}
}
