package wxmg.publicNo.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;

public class PublicNumberRoleRel  extends BaseEntity implements Serializable{

	private static final long serialVersionUID = -6334029668052000750L;
	//公众号角色关系ID
	private Integer publicNumberRoleRelId;
	//公众账号信息ID
	private Integer publicNumberId;
	//角色ID
	private Integer actorid;
	//角色名称
	private String roleName;
	//角色类型
	private Integer roleTypeEnumId;
	//公众号名称
	private String publicNumberName;
	//公众号原始ID
	private String pnOriginalId;
	//创建时间
	private Date createTime;
	//最后修改日期
	private Date lastUpdateDate;
	
	
	public Integer getPublicNumberRoleRelId() {
		return publicNumberRoleRelId;
	}
	public void setPublicNumberRoleRelId(Integer publicNumberRoleRelId) {
		this.publicNumberRoleRelId = publicNumberRoleRelId;
	}
	public Integer getPublicNumberId() {
		return publicNumberId;
	}
	public void setPublicNumberId(Integer publicNumberId) {
		this.publicNumberId = publicNumberId;
	}
	public Integer getActorid() {
		return actorid;
	}
	public void setActorid(Integer actorid) {
		this.actorid = actorid;
	}
	public String getRoleName() {
		return roleName;
	}
	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
	public Integer getRoleTypeEnumId() {
		return roleTypeEnumId;
	}
	public void setRoleTypeEnumId(Integer roleTypeEnumId) {
		this.roleTypeEnumId = roleTypeEnumId;
	}
	public String getPublicNumberName() {
		return publicNumberName;
	}
	public void setPublicNumberName(String publicNumberName) {
		this.publicNumberName = publicNumberName;
	}
	public String getPnOriginalId() {
		return pnOriginalId;
	}
	public void setPnOriginalId(String pnOriginalId) {
		this.pnOriginalId = pnOriginalId;
	}
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
	
	
}
