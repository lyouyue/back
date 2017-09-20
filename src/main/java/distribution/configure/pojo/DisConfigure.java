package distribution.configure.pojo;
import java.io.Serializable;
import java.math.BigDecimal;

import util.pojo.BaseEntity;
/**
 * 分销配置表
 */
public class DisConfigure extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 5015986988777284059L;
	private Integer configureId;
	private BigDecimal rebatePrice;//消费返利阀值
	private BigDecimal redbag1price;
	private String redbag1name;
	private BigDecimal redbag2price;
	private String redbag2name;
	private BigDecimal redbag3price;
	private String redbag3name;
	private BigDecimal redbag4price;
	private String redbag4name;
	private BigDecimal redbag5price;
	private String redbag5name;
	private BigDecimal redbag6price;
	private String redbag6name;
	
	public Integer getConfigureId() {
		return configureId;
	}
	public void setConfigureId(Integer configureId) {
		this.configureId = configureId;
	}
	public BigDecimal getRebatePrice() {
		return rebatePrice;
	}
	public void setRebatePrice(BigDecimal rebatePrice) {
		this.rebatePrice = rebatePrice;
	}
	public BigDecimal getRedbag1price() {
		return redbag1price;
	}
	public void setRedbag1price(BigDecimal redbag1price) {
		this.redbag1price = redbag1price;
	}
	public String getRedbag1name() {
		return redbag1name;
	}
	public void setRedbag1name(String redbag1name) {
		this.redbag1name = redbag1name;
	}
	public BigDecimal getRedbag2price() {
		return redbag2price;
	}
	public void setRedbag2price(BigDecimal redbag2price) {
		this.redbag2price = redbag2price;
	}
	public String getRedbag2name() {
		return redbag2name;
	}
	public void setRedbag2name(String redbag2name) {
		this.redbag2name = redbag2name;
	}
	public BigDecimal getRedbag3price() {
		return redbag3price;
	}
	public void setRedbag3price(BigDecimal redbag3price) {
		this.redbag3price = redbag3price;
	}
	public String getRedbag3name() {
		return redbag3name;
	}
	public void setRedbag3name(String redbag3name) {
		this.redbag3name = redbag3name;
	}
	public BigDecimal getRedbag4price() {
		return redbag4price;
	}
	public void setRedbag4price(BigDecimal redbag4price) {
		this.redbag4price = redbag4price;
	}
	public String getRedbag4name() {
		return redbag4name;
	}
	public void setRedbag4name(String redbag4name) {
		this.redbag4name = redbag4name;
	}
	public BigDecimal getRedbag5price() {
		return redbag5price;
	}
	public void setRedbag5price(BigDecimal redbag5price) {
		this.redbag5price = redbag5price;
	}
	public String getRedbag5name() {
		return redbag5name;
	}
	public void setRedbag5name(String redbag5name) {
		this.redbag5name = redbag5name;
	}
	public BigDecimal getRedbag6price() {
		return redbag6price;
	}
	public void setRedbag6price(BigDecimal redbag6price) {
		this.redbag6price = redbag6price;
	}
	public String getRedbag6name() {
		return redbag6name;
	}
	public void setRedbag6name(String redbag6name) {
		this.redbag6name = redbag6name;
	}
}
