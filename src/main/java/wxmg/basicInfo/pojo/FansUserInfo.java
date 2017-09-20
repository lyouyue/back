package wxmg.basicInfo.pojo;

import java.io.Serializable;

import util.pojo.BaseEntity;
/**
 * 粉丝用户信息
 * @author 郑月龙
 *
 */
public class FansUserInfo extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 3386341153753844521L;
	
	/**
	 * userId 用户ID
	 */
	private Long userId;
	/**
	 * fansGroupId 粉丝分组ID
	 */
	private Integer fansGroupId;
	/**
	 * customerId 客户ID
	 */
	private Long customerId;
	/**
	 * bindingFlag 是否绑定 待问
	 */
	private Integer bindingFlag;
	/**
	 * userOpenId 用户标识OPENID
	 */
	private String userOpenId;
	/**
	 * loginName 登录名
	 */
	private String loginName;
	/**
	 * password 登录密码
	 */
	private String password;
	/**
	 * nickName 昵称
	 */
	private String nickName;
	/**
	 * sex 性别0女 1 男
	 */
	private Integer sex;
	/**
	 * userCountry 用户所在国家
	 */
	private String userCountry;
	/**
	 * userProvince 用户所在省份
	 */
	private String userProvince;
	/**
	 * userCityb用户所在城市
	 */
	private String userCity;
	/**
	 * userLanguage 用户语言
	 */
	private String userLanguage;
	/**
	 * headimgUrl 用户头像
	 */
	private String headimgUrl;
	/**
	 * userSignature 用户签名
	 */
	private String userSignature;
	/**
	 * 用户是否订阅该公众号标识
	 */
	private Integer subscribe;
	/**
	 * 用户备注
	 */
	private String remark;
	/**
	 *用户关注时间 
	 */
	private Integer subscribe_time;
	/**
	 * UNIONID
	 */
	private String unionid;
	/**
	 *地理位置纬度 
	 */
	private String latitude;
	/**
	 *地理位置经度 
	 */
	private String longitude;
	/**
	 *地理位置精度 
	 */
	private String locationPrecision;
	/**
	 * 平台对粉丝的备注
	 */
	private String plateformRemark;
	
	
	public Long getUserId() {
		return userId;
	}
	public void setUserId(Long userId) {
		this.userId = userId;
	}
	public Integer getFansGroupId() {
		return fansGroupId;
	}
	public void setFansGroupId(Integer fansGroupId) {
		this.fansGroupId = fansGroupId;
	}
	public Long getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}
	public Integer getBindingFlag() {
		return bindingFlag;
	}
	public void setBindingFlag(Integer bindingFlag) {
		this.bindingFlag = bindingFlag;
	}
	public String getUserOpenId() {
		return userOpenId;
	}
	public void setUserOpenId(String userOpenId) {
		this.userOpenId = userOpenId;
	}
	public String getLoginName() {
		return loginName;
	}
	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getNickName() {
		return nickName;
	}
	public void setNickName(String nickName) {
		this.nickName = nickName;
	}
	public Integer getSex() {
		return sex;
	}
	public void setSex(Integer sex) {
		this.sex = sex;
	}
	public String getUserCountry() {
		return userCountry;
	}
	public void setUserCountry(String userCountry) {
		this.userCountry = userCountry;
	}
	public String getUserProvince() {
		return userProvince;
	}
	public void setUserProvince(String userProvince) {
		this.userProvince = userProvince;
	}
	public String getUserCity() {
		return userCity;
	}
	public void setUserCity(String userCity) {
		this.userCity = userCity;
	}
	public String getUserLanguage() {
		return userLanguage;
	}
	public void setUserLanguage(String userLanguage) {
		this.userLanguage = userLanguage;
	}
	public String getHeadimgUrl() {
		return headimgUrl;
	}
	public void setHeadimgUrl(String headimgUrl) {
		this.headimgUrl = headimgUrl;
	}
	public String getUserSignature() {
		return userSignature;
	}
	public void setUserSignature(String userSignature) {
		this.userSignature = userSignature;
	}
	public Integer getSubscribe() {
		return subscribe;
	}
	public void setSubscribe(Integer subscribe) {
		this.subscribe = subscribe;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public Integer getSubscribe_time() {
		return subscribe_time;
	}
	public void setSubscribe_time(Integer subscribe_time) {
		this.subscribe_time = subscribe_time;
	}
	public String getUnionid() {
		return unionid;
	}
	public void setUnionid(String unionid) {
		this.unionid = unionid;
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
	public String getPlateformRemark() {
		return plateformRemark;
	}
	public void setPlateformRemark(String plateformRemark) {
		this.plateformRemark = plateformRemark;
	}
	
}
