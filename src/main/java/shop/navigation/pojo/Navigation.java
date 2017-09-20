package shop.navigation.pojo;
import util.pojo.BaseEntity;
/**
 * 前台导航条实体类
 * @author 王亚
 *
 */
public class Navigation extends BaseEntity{
	private static final long serialVersionUID = 680194864790760985L;
	/**
	 * 前台导航条Id
	 */
	private Integer navigationId;
	/**
	 * 前台导航条名称
	 */
	private String navigationName;
	/**
	 * 前台导航条url
	 */
	private String navigationUrl;
	/**
	 * 前台导航条排序号
	 */
	private Integer sortCode;
	/**
	 * 前台导航条是否使用
	 */
	private Integer isUser;
	/**
	 * 前台导航条是否显示
	 */
	private Integer isShowOnBar;
	/**
	 * 前台导航条SEO标题
	 */
	private String seoTitle;
	/**
	 * 前台导航条SEO关键字
	 */
	private String seoKeyWords;
	/**
	 * 前台导航条SEO简介
	 */
	private String seoDescrible;
	public Integer getNavigationId() {
		return navigationId;
	}
	public void setNavigationId(Integer navigationId) {
		this.navigationId = navigationId;
	}
	public String getNavigationName() {
		return navigationName;
	}
	public void setNavigationName(String navigationName) {
		this.navigationName = navigationName;
	}
	public String getNavigationUrl() {
		return navigationUrl;
	}
	public void setNavigationUrl(String navigationUrl) {
		this.navigationUrl = navigationUrl;
	}
	public Integer getSortCode() {
		return sortCode;
	}
	public void setSortCode(Integer sortCode) {
		this.sortCode = sortCode;
	}
	public Integer getIsUser() {
		return isUser;
	}
	public void setIsUser(Integer isUser) {
		this.isUser = isUser;
	}
	public Integer getIsShowOnBar() {
		return isShowOnBar;
	}
	public void setIsShowOnBar(Integer isShowOnBar) {
		this.isShowOnBar = isShowOnBar;
	}
	public String getSeoTitle() {
		return seoTitle;
	}
	public void setSeoTitle(String seoTitle) {
		this.seoTitle = seoTitle;
	}
	public String getSeoKeyWords() {
		return seoKeyWords;
	}
	public void setSeoKeyWords(String seoKeyWords) {
		this.seoKeyWords = seoKeyWords;
	}
	public String getSeoDescrible() {
		return seoDescrible;
	}
	public void setSeoDescrible(String seoDescrible) {
		this.seoDescrible = seoDescrible;
	}
	
}
