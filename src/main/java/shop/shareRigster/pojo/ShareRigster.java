package shop.shareRigster.pojo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import util.pojo.BaseEntity;

public class ShareRigster extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -6003867400153381451L;
	/**
	 * 分享注册ID
	 * **/
	private Integer shareRegisterId;
	/**
	 *分享人ID 
	 **/
	private Integer shareCustomerId;
	private String scName;
	/**
	 * 注册人ID
	 * **/
	private Integer registerCustomerId;
	private String rcName;
	/**
	 * 分享时间
	 * **/
	private Date shareTime;
	/**
	 * 赠送金币数
	 * **/
	private BigDecimal giveCoinNumber;
	
	
	public Integer getShareRegisterId() {
		return shareRegisterId;
	}
	public void setShareRegisterId(Integer shareRegisterId) {
		this.shareRegisterId = shareRegisterId;
	}
	public Integer getShareCustomerId() {
		return shareCustomerId;
	}
	public void setShareCustomerId(Integer shareCustomerId) {
		this.shareCustomerId = shareCustomerId;
	}
	public Integer getRegisterCustomerId() {
		return registerCustomerId;
	}
	public void setRegisterCustomerId(Integer registerCustomerId) {
		this.registerCustomerId = registerCustomerId;
	}
	public Date getShareTime() {
		return shareTime;
	}
	public void setShareTime(Date shareTime) {
		this.shareTime = shareTime;
	}
	public BigDecimal getGiveCoinNumber() {
		return giveCoinNumber;
	}
	public void setGiveCoinNumber(BigDecimal giveCoinNumber) {
		this.giveCoinNumber = giveCoinNumber;
	}
	public String getScName() {
		return scName;
	}
	public void setScName(String scName) {
		this.scName = scName;
	}
	public String getRcName() {
		return rcName;
	}
	public void setRcName(String rcName) {
		this.rcName = rcName;
	}
	
}
