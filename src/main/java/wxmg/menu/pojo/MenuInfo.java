package wxmg.menu.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 微信菜单信息
 * @author LQS
 *
 */
public class MenuInfo extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 6500637744860894396L;
	/**
	 * 微信菜单信息ID
	 */
	private Integer wxmiId;
	/**
	 * 父菜单Id
	 */
	private Integer parentId;
	/**
	 * 父菜单名称
	 */
	private String parentName;
	/**
	 * 类型：菜单的响应动作类型，目前有click、view两种类型 
	 */
	private String type;
	/**
	 * 类型值：key和url,存放json串片段
	 * 菜单key值,click类型必须,用于消息接口推送，不超过128字节
	 * 菜单url值,view类型必须,网页链接，用户点击菜单可打开链接，不超过256字节
	 */
	private String typeValue;
	/**
	 * 标题：菜单标题，不超过16个字节，子菜单不超过40个字节 
	 */
	private String name ;
	/**
	 * 公众账号信息ID
	 */
	private Integer publicNumberId;
	/**
	 * 是否具有二级菜单
	 */
	private Integer isOwnerSecondLevel;
	/**
	 * 创建时间
	 */
	private Date createTime;
	/**
	 * 排列次序
	 */
	private Integer sortIndex;
	/**
	 * 最后修改人
	 */
	private Long lastUpdatedBy;
	/**
	 * 最后修改日期
	 */
	private Date lastUpdateDate;
	
	public Integer getWxmiId() {
		return wxmiId;
	}
	public void setWxmiId(Integer wxmiId) {
		this.wxmiId = wxmiId;
	}
	public Integer getParentId() {
		return parentId;
	}
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	public String getParentName() {
		return parentName;
	}
	public void setParentName(String parentName) {
		this.parentName = parentName;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getTypeValue() {
		return typeValue;
	}
	public void setTypeValue(String typeValue) {
		this.typeValue = typeValue;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getPublicNumberId() {
		return publicNumberId;
	}
	public void setPublicNumberId(Integer publicNumberId) {
		this.publicNumberId = publicNumberId;
	}
	public Integer getIsOwnerSecondLevel() {
		return isOwnerSecondLevel;
	}
	public void setIsOwnerSecondLevel(Integer isOwnerSecondLevel) {
		this.isOwnerSecondLevel = isOwnerSecondLevel;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Integer getSortIndex() {
		return sortIndex;
	}
	public void setSortIndex(Integer sortIndex) {
		this.sortIndex = sortIndex;
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
	
}
