package wxmg.material.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;

/**实体类*/
public class MaterialVoiceInfo extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 696443246481311006L;
	/**素材语音信息ID*/
	private Integer materialVoiceInfoId; 
	
	/**公众号ID*/
	private Integer publicNumberId; 
	/**语音媒体ID*/
	private String voiceMediaId; 
	/**语音url*/
	private String voiceUrl; 
	/**语音名称*/
	private String voiceName; 
	/**语音格式*/
	private Integer voiceFormatEnumId; 
	/**语音大小*/
	private String voiceSize; 
	/**信息是否发送*/
	private String infoSendFlag; 
	/**语音媒体ID获取时间*/
	private Date voiceMediaIdCreatedTime; 
	/**语音UUID*/
//	private String voiceUuid; 
	/**创建人*/
	private int createdBy; 
	/**创建时间*/
	private Date createTime; 
	/**最后修改人*/
	private Integer lastUpdatedBy; 
	/**最后修日期*/
	private Date lastUpdateDate; 
	/**删除标记*/
	private String deletedFlag; 
	/**删除人*/
	private Integer deletedBy; 
	/**删除时间*/
	private Date deletionDate; 
	/**备注*/
	private String remark; 
	
	
	public Integer getMaterialVoiceInfoId() {
		return materialVoiceInfoId;
	}
	public void setMaterialVoiceInfoId(Integer materialVoiceInfoId) {
		this.materialVoiceInfoId = materialVoiceInfoId;
	}
	public Integer getPublicNumberId() {
		return publicNumberId;
	}
	public void setPublicNumberId(Integer publicNumberId) {
		this.publicNumberId = publicNumberId;
	}
	public String getVoiceMediaId() {
		return voiceMediaId;
	}
	public void setVoiceMediaId(String voiceMediaId) {
		this.voiceMediaId = voiceMediaId;
	}
	public String getVoiceUrl() {
		return voiceUrl;
	}
	public void setVoiceUrl(String voiceUrl) {
		this.voiceUrl = voiceUrl;
	}
	public String getVoiceName() {
		return voiceName;
	}
	public void setVoiceName(String voiceName) {
		this.voiceName = voiceName;
	}
	public Integer getVoiceFormatEnumId() {
		return voiceFormatEnumId;
	}
	public void setVoiceFormatEnumId(Integer voiceFormatEnumId) {
		this.voiceFormatEnumId = voiceFormatEnumId;
	}
	public String getVoiceSize() {
		return voiceSize;
	}
	public void setVoiceSize(String voiceSize) {
		this.voiceSize = voiceSize;
	}
	public String getInfoSendFlag() {
		return infoSendFlag;
	}
	public void setInfoSendFlag(String infoSendFlag) {
		this.infoSendFlag = infoSendFlag;
	}
	public Date getVoiceMediaIdCreatedTime() {
		return voiceMediaIdCreatedTime;
	}
	public void setVoiceMediaIdCreatedTime(Date voiceMediaIdCreatedTime) {
		this.voiceMediaIdCreatedTime = voiceMediaIdCreatedTime;
	}
//	public String getVoiceUuid() {
//		return voiceUuid;
//	}
//	public void setVoiceUuid(String voiceUuid) {
//		this.voiceUuid = voiceUuid;
//	}
	public int getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(int createdBy) {
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
	public Date getLastUpdateDate() {
		return lastUpdateDate;
	}
	public void setLastUpdateDate(Date lastUpdateDate) {
		this.lastUpdateDate = lastUpdateDate;
	}
	public String getDeletedFlag() {
		return deletedFlag;
	}
	public void setDeletedFlag(String deletedFlag) {
		this.deletedFlag = deletedFlag;
	}
	public Integer getDeletedBy() {
		return deletedBy;
	}
	public void setDeletedBy(Integer deletedby) {
		this.deletedBy = deletedby;
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
	
}
