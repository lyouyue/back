package phone.back.pojo;

import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 手机端分类信息
 * 
 *	2014-01-22
 */
public class PhoneHomeCategoryInfo extends BaseEntity{
	private static final long serialVersionUID = 1L;
	/**
	 * ID
	 */
	private Integer categoryInfoId;
	/**
	 * 分类ID
	 */
	private Integer categoryId;
	/**
	 * 标题
	 */
	private String title;
	/**
	 * 描述
	 */
	private String synopsis;
	/**
	 * 图片
	 */
	private String imageUrl;
	/**
	 * 链接
	 */
	private String link;
	/**
	 * App链接
	 */
	private String appLink;
	/**
	 * 排序
	 */
	private Integer sortCode;
	/**
	 * 是否显示
	 */
	private Integer isShow;
	/**
	 * 创建时间
	 */
	private Date createTime;
	/**
	 * 创建人
	 */
	private String publishUser;
	/**
	 * 修改时间
	 */
	private Date updateTime;
	/**
	 * 修改人
	 */
	private String modifyUser;
	//setter getter
	public Integer getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(Integer categoryId) {
		this.categoryId = categoryId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getSynopsis() {
		return synopsis;
	}
	public void setSynopsis(String synopsis) {
		this.synopsis = synopsis;
	}
	public String getImageUrl() {
		return imageUrl;
	}
	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
	public String getLink() {
		return link;
	}
	public void setLink(String link) {
		this.link = link;
	}
	public String getAppLink() {
		return appLink;
	}
	public void setAppLink(String appLink) {
		this.appLink = appLink;
	}
	public Integer getSortCode() {
		return sortCode;
	}
	public void setSortCode(Integer sortCode) {
		this.sortCode = sortCode;
	}
	public Integer getIsShow() {
		return isShow;
	}
	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public String getPublishUser() {
		return publishUser;
	}
	public void setPublishUser(String publishUser) {
		this.publishUser = publishUser;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public String getModifyUser() {
		return modifyUser;
	}
	public void setModifyUser(String modifyUser) {
		this.modifyUser = modifyUser;
	}
	public Integer getCategoryInfoId() {
		return categoryInfoId;
	}
	public void setCategoryInfoId(Integer categoryInfoId) {
		this.categoryInfoId = categoryInfoId;
	}
	
}
