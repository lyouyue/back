package wxmg.material.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;

/**
 * 素材图文信息实体类
 *  @author 李续
 */
public class MaterialImageTxtInfo extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 1L;
	/** 素材图文信息ID**/
	private Integer materialImageTxtInfoId;
	/**素材图片信息ID**/
	private Integer materialImageInfoId;
	/** 公众号ID**/
	private Integer publicNumberId; 
	/** 父图文信息ID**/
//	private Integer parentImtxtInfoId; 
	/** 图文信息排序号**/
//	private Integer imtxtInfoSortNumber; 
	/** 图文信息类型**/
	private Integer imageInfoTypeEnumId; 
	/** 素材图文信息ID**/
	private String imageTxtMediaId; 
	/** 素材图文标题**/
	private String materialTitle; 
	/** 图片摘要描述**/
	private String picDigestDescription; 
	/** 图片正文描述**/
	private String picDescription; 
	/** 点击链接跳转Url**/
	private String clickSkipUrl ;
	/** 作者**/
	private String author;
	/** 原文链接**/
	private String originalLink; 
	/** 信息是否发送**/
	private Integer infoSendFlag; 
	/** 创建人**/
	private Integer createdByBigint; 
	/** 创建时间**/
	private Date createTimeDatetime; 
	/**最后修改人**/
	private Integer lastUpdatedByBigint; 
	/** 最后修改日期**/
	private Date lastUpdateDateDatetime; 
	/** 删除标记**/
	private Integer deletedFlag; 
	/** 删除人**/
	private Integer deletedBy; 
	/** 删除时间**/
	private Date deletionDate;
	/** 备注**/
	private String remark;
	public Integer getMaterialImageTxtInfoId() {
		return materialImageTxtInfoId;
	}
	public void setMaterialImageTxtInfoId(Integer materialImageTxtInfoId) {
		this.materialImageTxtInfoId = materialImageTxtInfoId;
	}
	public Integer getPublicNumberId() {
		return publicNumberId;
	}
	public void setPublicNumberId(Integer publicNumberId) {
		this.publicNumberId = publicNumberId;
	}
	public Integer getImageInfoTypeEnumId() {
		return imageInfoTypeEnumId;
	}
	public void setImageInfoTypeEnumId(Integer imageInfoTypeEnumId) {
		this.imageInfoTypeEnumId = imageInfoTypeEnumId;
	}
	public String getImageTxtMediaId() {
		return imageTxtMediaId;
	}
	public void setImageTxtMediaId(String imageTxtMediaId) {
		this.imageTxtMediaId = imageTxtMediaId;
	}
	public String getMaterialTitle() {
		return materialTitle;
	}
	public void setMaterialTitle(String materialTitle) {
		this.materialTitle = materialTitle;
	}
	public String getPicDigestDescription() {
		return picDigestDescription;
	}
	public void setPicDigestDescription(String picDigestDescription) {
		this.picDigestDescription = picDigestDescription;
	}
	public String getPicDescription() {
		return picDescription;
	}
	public void setPicDescription(String picDescription) {
		this.picDescription = picDescription;
	}
	public String getClickSkipUrl() {
		return clickSkipUrl;
	}
	public void setClickSkipUrl(String clickSkipUrl) {
		this.clickSkipUrl = clickSkipUrl;
	}
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getOriginalLink() {
		return originalLink;
	}
	public void setOriginalLink(String originalLink) {
		this.originalLink = originalLink;
	}
	public Integer getInfoSendFlag() {
		return infoSendFlag;
	}
	public void setInfoSendFlag(Integer infoSendFlag) {
		this.infoSendFlag = infoSendFlag;
	}
	public Integer getCreatedByBigint() {
		return createdByBigint;
	}
	public void setCreatedByBigint(Integer createdByBigint) {
		this.createdByBigint = createdByBigint;
	}
	public Date getCreateTimeDatetime() {
		return createTimeDatetime;
	}
	public void setCreateTimeDatetime(Date createTimeDatetime) {
		this.createTimeDatetime = createTimeDatetime;
	}
	public Integer getLastUpdatedByBigint() {
		return lastUpdatedByBigint;
	}
	public void setLastUpdatedByBigint(Integer lastUpdatedByBigint) {
		this.lastUpdatedByBigint = lastUpdatedByBigint;
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
	public Integer getMaterialImageInfoId() {
		return materialImageInfoId;
	}
	public void setMaterialImageInfoId(Integer materialImageInfoId) {
		this.materialImageInfoId = materialImageInfoId;
	}

}