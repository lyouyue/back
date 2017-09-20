package wxmg.publicNo.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 微信基础信息
 * @author LQS
 *
 */
public class PublicNoInfo extends BaseEntity implements Serializable {
	private static final long serialVersionUID = -2486462501198465936L;
	//公众账号信息ID
	private Integer publicNumberId;
	//租户信息ID
	private Integer tenantInfoId;
	//验证的url（属于自己服务器的url）
	private String url;
	//令牌
	private String token;
	//凭据ID
	private String appId;
	//凭据密码
	private String appSecret;
	//微信号
	private String wxNo;
	//微信名称
	private String wxName;
	//所属公司名称
	private String companyName;
	//备注
	private String comments;
	//微信二维码图片URL
	private String qrCodeUrl;
	//开发者微信号
	private String toUserName;
	//公众号类型
	private Integer publicNumberType;
	//创建时间
	private Date createTime;
	//最后修改时间
	private Date lastUpdateDate;
	
	
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Date getLastUpdateDate() {
		return lastUpdateDate;
	}
	public void setLastUpdateDate(Date lastUpdateDate) {
		this.lastUpdateDate = lastUpdateDate;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
	public String getAppId() {
		return appId;
	}
	public void setAppId(String appId) {
		this.appId = appId;
	}
	public String getAppSecret() {
		return appSecret;
	}
	public void setAppSecret(String appSecret) {
		this.appSecret = appSecret;
	}
	public String getWxNo() {
		return wxNo;
	}
	public void setWxNo(String wxNo) {
		this.wxNo = wxNo;
	}
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	public String getWxName() {
		return wxName;
	}
	public void setWxName(String wxName) {
		this.wxName = wxName;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public Integer getPublicNumberId() {
		return publicNumberId;
	}
	public void setPublicNumberId(Integer publicNumberId) {
		this.publicNumberId = publicNumberId;
	}
	public Integer getTenantInfoId() {
		return tenantInfoId;
	}
	public void setTenantInfoId(Integer tenantInfoId) {
		this.tenantInfoId = tenantInfoId;
	}
	public String getQrCodeUrl() {
		return qrCodeUrl;
	}
	public void setQrCodeUrl(String qrCodeUrl) {
		this.qrCodeUrl = qrCodeUrl;
	}
	public String getToUserName() {
		return toUserName;
	}
	public void setToUserName(String toUserName) {
		this.toUserName = toUserName;
	}
	public Integer getPublicNumberType() {
		return publicNumberType;
	}
	public void setPublicNumberType(Integer publicNumberType) {
		this.publicNumberType = publicNumberType;
	}
	
}
