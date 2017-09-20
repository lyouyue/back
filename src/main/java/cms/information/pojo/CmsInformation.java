package cms.information.pojo;

import util.pojo.BaseEntity;

/**
 * 信息表
 * @author FuLei
 * 
 */
public class CmsInformation extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = 4464844090251282893L;
	/**
	 * 信息id
	 */
	private Integer informationId;
	/**
	 * 所属分类ID
	 */
	private Integer categoryId;
	/**
	 * 信息类型
	 */
	private String informationType;
	/**
	 * 标题
	 */
	private String title;
	/**
	 * 摘要
	 */
	private String brief;
	/**
	 * 内容
	 */
	private String content;
	/**
	 * 作者
	 */
	private String author;
	/**
	 * 图片地址
	 */
	private String imgUrl;
	/**
	 * 主题图片真实名称
	 */
	private String imgTrueName;
	/**
	 * 外部访问地址
	 */
	private String outUrl;
	/**
	 * SEOTITLE
	 */
	private String seoTitle;
	/**
	 * SEO关键字
	 */
	private String keywords;
	/**
	 * 点击次数
	 */
	private Integer clickCount;
	/**
	 * 排序
	 */
	private Integer sortCode;
	/**
	 * 删除状态  0 正常状态   1 进入回收站，即伪删除
	 */
	private Short isDeal;
	/**
	 * 设置精华  0 非精华 1 精华
	 */
	private Short isEssence;
	/**
	 * 审核状态  0未审核 1已经审核 2不通过 
	 */
	private Short isPass;
	/**
	 * 是否开放评论  0 不开放  1 开放评论
	 */
	private Short isOpenDiscuss;
	/**
	 * 是否显示  0不显示 1 显示
	 */
	private Short isShow;
	/**
	 * 创建时间
	 */
	private String createTime;
	/**
	 * 修改时间
	 */
	private String updateTime;
	/**
	 * 创建人
	 */
	private String publishUser;
	/**
	 * 修改人
	 */
	private String modifyUser;
	
	/**
	 * 城市名称
	 */
	private String cityName;
	/**
	 * 小区名称
	 */
	private String districtName;
	public Integer getInformationId() {
		return informationId;
	}
	public void setInformationId(Integer informationId) {
		this.informationId = informationId;
	}
	public Integer getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(Integer categoryId) {
		this.categoryId = categoryId;
	}
	public String getInformationType() {
		return informationType;
	}
	public void setInformationType(String informationType) {
		this.informationType = informationType;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getBrief() {
		return brief;
	}
	public void setBrief(String brief) {
		this.brief = brief;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getImgUrl() {
		return imgUrl;
	}
	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}
	public String getImgTrueName() {
		return imgTrueName;
	}
	public void setImgTrueName(String imgTrueName) {
		this.imgTrueName = imgTrueName;
	}
	public String getOutUrl() {
		return outUrl;
	}
	public void setOutUrl(String outUrl) {
		this.outUrl = outUrl;
	}
	public String getSeoTitle() {
		return seoTitle;
	}
	public void setSeoTitle(String seoTitle) {
		this.seoTitle = seoTitle;
	}
	public String getKeywords() {
		return keywords;
	}
	public void setKeywords(String keywords) {
		this.keywords = keywords;
	}
	public Integer getClickCount() {
		return clickCount;
	}
	public void setClickCount(Integer clickCount) {
		this.clickCount = clickCount;
	}
	public Integer getSortCode() {
		return sortCode;
	}
	public void setSortCode(Integer sortCode) {
		this.sortCode = sortCode;
	}
	public Short getIsDeal() {
		return isDeal;
	}
	public void setIsDeal(Short isDeal) {
		this.isDeal = isDeal;
	}
	public Short getIsEssence() {
		return isEssence;
	}
	public void setIsEssence(Short isEssence) {
		this.isEssence = isEssence;
	}
	public Short getIsPass() {
		return isPass;
	}
	public void setIsPass(Short isPass) {
		this.isPass = isPass;
	}
	public Short getIsOpenDiscuss() {
		return isOpenDiscuss;
	}
	public void setIsOpenDiscuss(Short isOpenDiscuss) {
		this.isOpenDiscuss = isOpenDiscuss;
	}
	public Short getIsShow() {
		return isShow;
	}
	public void setIsShow(Short isShow) {
		this.isShow = isShow;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}
	public String getPublishUser() {
		return publishUser;
	}
	public void setPublishUser(String publishUser) {
		this.publishUser = publishUser;
	}
	public String getModifyUser() {
		return modifyUser;
	}
	public void setModifyUser(String modifyUser) {
		this.modifyUser = modifyUser;
	}
	public String getCityName() {
		return cityName;
	}
	public void setCityName(String cityName) {
		this.cityName = cityName;
	}
	public String getDistrictName() {
		return districtName;
	}
	public void setDistrictName(String districtName) {
		this.districtName = districtName;
	}
}
