package basic.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;

/***
 * 已读消息的记录
 * @author Edward_yang
 *	time：2017-8-17
 */
public class NewsReader  extends BaseEntity implements Serializable {

	private static final long serialVersionUID = -4793105244559114703L;
	
	private Integer readId;//已读消息公告记录的ID
	
	private Integer newsId;//消息公告的ID
	
	private Integer customerId;//用户的ID
	
	private Date  readtime; //阅读的时间

	public Integer getReadId() {
		return readId;
	}

	public void setReadId(Integer readId) {
		this.readId = readId;
	}

	public Integer getNewsId() {
		return newsId;
	}

	public void setNewsId(Integer newsId) {
		this.newsId = newsId;
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}

	public Date getReadtime() {
		return readtime;
	}

	public void setReadtime(Date readtime) {
		this.readtime = readtime;
	}
}
