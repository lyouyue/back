package shop.homeIndex.pojo;

import java.io.Serializable;

import util.pojo.BaseEntity;
/**
 * 热门搜索实体类
 * @author Administrator
 * 2014-05-12
 */
@SuppressWarnings("serial")
public class TopSearch extends BaseEntity implements Serializable {
	/*热门搜索ID*/
	private Integer topSearchId;
	/*关键词*/
	private String keywords;
	/*排序*/
	private Integer sortCode;
	/*是否显示*/
	private Integer isShow;
	//在什么位置显示：1：pc端，2：微信端，3：app端
	private String showClient;
	
	public Integer getTopSearchId() {
		return topSearchId;
	}
	public void setTopSearchId(Integer topSearchId) {
		this.topSearchId = topSearchId;
	}
	public String getKeywords() {
		return keywords;
	}
	public void setKeywords(String keywords) {
		this.keywords = keywords;
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
	public String getShowClient() {
		return showClient;
	}
	public void setShowClient(String showClient) {
		this.showClient = showClient;
	}

}
