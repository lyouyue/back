package wxmg.tenant.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 租户信息实体类
 * @author Administrator
 * 2014-09-05	WXPublicNumberSendMsgInfo
 */
public class WXTenantInfo extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 364537410028703498L;
	/**租户信息ID**/
	private Integer tenantInfoId;
	/**租户名称**/
	private String tenantName;
	/**租户类型**/
	private Integer tenantTypeEnumId;
	/**租户状态**/
	private Integer tenantStatusEnumId;
	/**租期**/
	private String tenantPeriod;
	/**租户描述**/
	private String tenantDescription;
	/**创建人**/
	private Long createdBy;
	/**创建时间**/
	private Date createTime;
	/**最后修改人**/
	private Long lastUpdatedBy;
	/**最后修改日期**/
	private Date lastUpdateDate;
	/**删除标记**/
	private Integer deletedFlag;
	/**删除人**/
	private Long deletedBy;
	/**删除时间**/
	private Date deletionDate;
	/**客户ID（商铺用户）**/
	private Integer customerId;
	
	public Integer getTenantInfoId() {
		return tenantInfoId;
	}
	public void setTenantInfoId(Integer tenantInfoId) {
		this.tenantInfoId = tenantInfoId;
	}
	public String getTenantName() {
		return tenantName;
	}
	public void setTenantName(String tenantName) {
		this.tenantName = tenantName;
	}
	public Integer getTenantTypeEnumId() {
		return tenantTypeEnumId;
	}
	public void setTenantTypeEnumId(Integer tenantTypeEnumId) {
		this.tenantTypeEnumId = tenantTypeEnumId;
	}
	public Integer getTenantStatusEnumId() {
		return tenantStatusEnumId;
	}
	public void setTenantStatusEnumId(Integer tenantStatusEnumId) {
		this.tenantStatusEnumId = tenantStatusEnumId;
	}
	public String getTenantPeriod() {
		return tenantPeriod;
	}
	public void setTenantPeriod(String tenantPeriod) {
		this.tenantPeriod = tenantPeriod;
	}
	public String getTenantDescription() {
		return tenantDescription;
	}
	public void setTenantDescription(String tenantDescription) {
		this.tenantDescription = tenantDescription;
	}
	public Long getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(Long createdBy) {
		this.createdBy = createdBy;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Long getLastUpdatedBy() {
		return lastUpdatedBy;
	}
	public void setLastUpdatedBy(Long lastUpdatedBy) {
		this.lastUpdatedBy = lastUpdatedBy;
	}
	public Date getLastUpdateDate() {
		return lastUpdateDate;
	}
	public void setLastUpdateDate(Date lastUpdateDate) {
		this.lastUpdateDate = lastUpdateDate;
	}
	public Integer getDeletedFlag() {
		return deletedFlag;
	}
	public void setDeletedFlag(Integer deletedFlag) {
		this.deletedFlag = deletedFlag;
	}
	public Long getDeletedBy() {
		return deletedBy;
	}
	public void setDeletedBy(Long deletedBy) {
		this.deletedBy = deletedBy;
	}
	public Date getDeletionDate() {
		return deletionDate;
	}
	public void setDeletionDate(Date deletionDate) {
		this.deletionDate = deletionDate;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
}
