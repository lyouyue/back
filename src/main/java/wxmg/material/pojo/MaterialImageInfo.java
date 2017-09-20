package wxmg.material.pojo;

import java.io.Serializable;
import util.pojo.BaseEntity;
import java.util.Date;

/**
 * 素材图片信息实体类
 * @author Administrator
 * 2014-09-09
 */
public class MaterialImageInfo extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 1019076249447451480L;
	/**素材图片信息ID**/
	private Integer materialImageInfoId; 
	/**公众号ID**/
	private Integer publicNumberId; 
	/**图片媒体ID**/
	private String picMediaId;
	/**图片Url**/
	private String picUrl; 
	/**图片名称**/
	private String picName; 
	/**图片大小**/
	private String picSize; 
	/**图片格式**/
	private Integer picFormatEnumId;
	/**信息是否发送**/
	private Integer infoSendFlag; 
	/**图片媒体ID获取时间**/
	private Date picMediaIdCreatedTime; 
	/**是否作为图文信息**/
	private Integer imageTxtFlag; 
	/**创建人**/
	private Integer createdBy; 
	/**创建时间**/
	private Date createTime; 
	/**最后修改人**/
	private Integer lastUpdatedBy;
	/**最后修改日期**/
	private Date lastUpdateDateDatetime; 
	/**删除标记**/
	private Integer deletedFlag; 
	/**删除人**/
	private Integer deletedBy;
	/**删除时间**/
	private Date deletionDate;
	/**备注**/
	private String remark;
	
	public Integer getMaterialImageInfoId() {
		return materialImageInfoId;
	}
	public void setMaterialImageInfoId(Integer materialImageInfoId) {
		this.materialImageInfoId = materialImageInfoId;
	}
	public Integer getPublicNumberId() {
		return publicNumberId;
	}
	public void setPublicNumberId(Integer publicNumberId) {
		this.publicNumberId = publicNumberId;
	}
	public String getPicMediaId() {
		return picMediaId;
	}
	public void setPicMediaId(String picMediaId) {
		this.picMediaId = picMediaId;
	}
	public String getPicUrl() {
		return picUrl;
	}
	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}
	public String getPicName() {
		return picName;
	}
	public void setPicName(String picName) {
		this.picName = picName;
	}
	public String getPicSize() {
		return picSize;
	}
	public void setPicSize(String picSize) {
		this.picSize = picSize;
	}
	public Integer getPicFormatEnumId() {
		return picFormatEnumId;
	}
	public void setPicFormatEnumId(Integer picFormatEnumId) {
		this.picFormatEnumId = picFormatEnumId;
	}
	public Integer getInfoSendFlag() {
		return infoSendFlag;
	}
	public void setInfoSendFlag(Integer infoSendFlag) {
		this.infoSendFlag = infoSendFlag;
	}
	public Date getPicMediaIdCreatedTime() {
		return picMediaIdCreatedTime;
	}
	public void setPicMediaIdCreatedTime(Date picMediaIdCreatedTime) {
		this.picMediaIdCreatedTime = picMediaIdCreatedTime;
	}
	public Integer getImageTxtFlag() {
		return imageTxtFlag;
	}
	public void setImageTxtFlag(Integer imageTxtFlag) {
		this.imageTxtFlag = imageTxtFlag;
	}
	public Integer getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(Integer createdBy) {
		this.createdBy = createdBy;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Integer getLastUpdatedBy() {
		return lastUpdatedBy;
	}
	public void setLastUpdatedBy(Integer lastUpdatedBy) {
		this.lastUpdatedBy = lastUpdatedBy;
	}
	public Date getLastUpdateDateDatetime() {
		return lastUpdateDateDatetime;
	}
	public void setLastUpdateDateDatetime(Date lastUpdateDateDatetime) {
		this.lastUpdateDateDatetime = lastUpdateDateDatetime;
	}
	public Integer getDeletedFlag() {
		return deletedFlag;
	}
	public void setDeletedFlag(Integer deletedFlag) {
		this.deletedFlag = deletedFlag;
	}
	public Integer getDeletedBy() {
		return deletedBy;
	}
	public void setDeletedBy(Integer deletedBy) {
		this.deletedBy = deletedBy;
	}
	public Date getDeletionDate() {
		return deletionDate;
	}
	public void setDeletionDate(Date deletionDate) {
		this.deletionDate = deletionDate;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
