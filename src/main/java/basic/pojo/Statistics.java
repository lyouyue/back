package basic.pojo;

import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 统计表
 * @author wy
 */
public class Statistics  extends BaseEntity  implements java.io.Serializable {
	private static final long serialVersionUID = -2134545934642292448L;
	/**
	 * 统计表主键Id
	 */
	private Integer statisticsId;
	/**
	 * 统计模块类型
	 * 1：一周动态
	 * 2：商城统计
	 */
	private Integer statisticsType;
	/**
	 * 统计字段名称
	 */
	private String statisticsName;
	/**
	 * 统计字段名称编码
	 */
	private Integer statisticsCode;
	/**
	 * 统计字段数量
	 */
	private String statisticsNum;
	/**
	 * 统计字段链接
	 */
	private String statisticsUrl;
	/**
	 * 排序
	 */
	private Integer sortCode;
	/**
	 * 是否显示
	 */
	private Integer isShow;
	/**
	 * 背景颜色
	 */
	private String statisticColor;
	/**
	 * 更新时间
	 */
	private Date updateTime;
	
	public Integer getStatisticsId() {
		return statisticsId;
	}
	public void setStatisticsId(Integer statisticsId) {
		this.statisticsId = statisticsId;
	}
	public Integer getStatisticsType() {
		return statisticsType;
	}
	public void setStatisticsType(Integer statisticsType) {
		this.statisticsType = statisticsType;
	}
	public String getStatisticsName() {
		return statisticsName;
	}
	public void setStatisticsName(String statisticsName) {
		this.statisticsName = statisticsName;
	}
	public Integer getStatisticsCode() {
		return statisticsCode;
	}
	public void setStatisticsCode(Integer statisticsCode) {
		this.statisticsCode = statisticsCode;
	}
	public String getStatisticsNum() {
		return statisticsNum;
	}
	public void setStatisticsNum(String statisticsNum) {
		this.statisticsNum = statisticsNum;
	}
	public String getStatisticsUrl() {
		return statisticsUrl;
	}
	public void setStatisticsUrl(String statisticsUrl) {
		this.statisticsUrl = statisticsUrl;
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
	public String getStatisticColor() {
		return statisticColor;
	}
	public void setStatisticColor(String statisticColor) {
		this.statisticColor = statisticColor;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	
	
}