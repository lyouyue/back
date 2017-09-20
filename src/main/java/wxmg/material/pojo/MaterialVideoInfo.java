package wxmg.material.pojo;

import java.util.Date;

import util.pojo.BaseEntity;

public class MaterialVideoInfo extends BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 530763870209823440L;
	/** 素材视频ID,增长策略自增 */
	private Integer materialVideoInfoId;
	/** 公众平台ID */
	private Integer publicNumberId;
	/**视频媒体号*/
	private String  videoMediaId;
	/**视频url*/
	private String videoUrl;
	/**视频缩略图url*/
    private String videoThumbUrl;
    /**视频标题*/
    private String videoTitle;
    /**视频名称*/
    private String videoName;
    /**视频格式*/
    private Integer videoFormatEnumId;
    /**视频大小*/
    private String videoSize;
    /**视频描述*/
    private String videoDescription;
    /**是否发送*/
    private String infoSendFlag;
    /**视频媒体ID获取时间*/
    private Date  videoMediaIdCreatedTime;
    /**创建人*/
    private Integer createdBy;
    /**创建时间*/
    private Date createTime;
    /**最后修改人*/
    private  Integer lastUpdatedBy;
    /**最后修改时间*/
    private  Date lastUpdateDate;
    /**删除标记*/
    private String deletedFlag;
    /**删除人*/
    private Integer deletedBy;
    /**删除时间*/
    private Date deletionDate;
    /**备注*/
    private String remark;
    
	public Integer getMaterialVideoInfoId() {
		return materialVideoInfoId;
	}
	public void setMaterialVideoInfoId(Integer materialVideoInfoId) {
		this.materialVideoInfoId = materialVideoInfoId;
	}
	public Integer getPublicNumberId() {
		return publicNumberId;
	}
	public void setPublicNumberId(Integer publicNumberId) {
		this.publicNumberId = publicNumberId;
	}
	public String getVideoMediaId() {
		return videoMediaId;
	}
	public void setVideoMediaId(String videoMediaId) {
		this.videoMediaId = videoMediaId;
	}
	public String getVideoUrl() {
		return videoUrl;
	}
	public void setVideoUrl(String videoUrl) {
		this.videoUrl = videoUrl;
	}
	public String getVideoThumbUrl() {
		return videoThumbUrl;
	}
	public void setVideoThumbUrl(String videoThumbUrl) {
		this.videoThumbUrl = videoThumbUrl;
	}
	public String getVideoTitle() {
		return videoTitle;
	}
	public void setVideoTitle(String videoTitle) {
		this.videoTitle = videoTitle;
	}
	public String getVideoName() {
		return videoName;
	}
	public void setVideoName(String videoName) {
		this.videoName = videoName;
	}
	public Integer getVideoFormatEnumId() {
		return videoFormatEnumId;
	}
	public void setVideoFormatEnumId(Integer videoFormatEnumId) {
		this.videoFormatEnumId = videoFormatEnumId;
	}
	public String getVideoSize() {
		return videoSize;
	}
	public void setVideoSize(String videoSize) {
		this.videoSize = videoSize;
	}
	public String getVideoDescription() {
		return videoDescription;
	}
	public void setVideoDescription(String videoDescription) {
		this.videoDescription = videoDescription;
	}
	public String getInfoSendFlag() {
		return infoSendFlag;
	}
	public void setInfoSendFlag(String infoSendFlag) {
		this.infoSendFlag = infoSendFlag;
	}
	public Date getVideoMediaIdCreatedTime() {
		return videoMediaIdCreatedTime;
	}
	public void setVideoMediaIdCreatedTime(Date videoMediaIdCreatedTime) {
		this.videoMediaIdCreatedTime = videoMediaIdCreatedTime;
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

    
}
