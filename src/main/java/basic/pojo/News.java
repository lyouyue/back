package basic.pojo;

import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;

/***
 * 系统公告消息发送的内容
 * @author Edward_yang
 *	time：2017-8-17
 */
public class News extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 2224530714153232787L;
	
	private Integer newsId;//消息ID
	
	private Integer userId;//发布用户ID
	
	private Integer readId;//已读信息的ID
	
	private String title; //公告标题
	
	private Date  pudate;//发布时间
	
	private String note;// 内容

	public Integer getNewsId() {
		return newsId;
	}

	public void setNewsId(Integer newsId) {
		this.newsId = newsId;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Integer getReadId() {
		return readId;
	}

	public void setReadId(Integer readId) {
		this.readId = readId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Date getPudate() {
		return pudate;
	}

	public void setPudate(Date pudate) {
		this.pudate = pudate;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}


	
	
}
