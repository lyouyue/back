package wxmg.basicInfo.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 粉丝分组
 * @author 郑月龙
 */
public class FansGroup extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -4775622075327822995L;
	
	/**
	 * 粉丝分组ID
	 */
	private Integer fansGroupId;
	/**
	 * 公众账号信息ID
	 */
	private Integer publicNumberId;
	/**
	 * 平台组id
	 */
	private Integer id;
	/**
	 * 组名称
	 */
	private String name;
	/**
	 * 人数
	 */
	private Integer count;
	/**
	 * 创建时间
	 */
	private Date createTime;
	/**
	 * 是否有效
	 */
	private Integer isValid;
	
	public Integer getFansGroupId() {
		return fansGroupId;
	}
	public void setFansGroupId(Integer fansGroupId) {
		this.fansGroupId = fansGroupId;
	}
	public Integer getPublicNumberId() {
		return publicNumberId;
	}
	public void setPublicNumberId(Integer publicNumberId) {
		this.publicNumberId = publicNumberId;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getCount() {
		return count;
	}
	public void setCount(Integer count) {
		this.count = count;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Integer getIsValid() {
		return isValid;
	}
	public void setIsValid(Integer isValid) {
		this.isValid = isValid;
	}
    
}
