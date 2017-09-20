package wxmg.globalReturnCode.pojo;

import java.io.Serializable;

import util.pojo.BaseEntity;
/**
 * 全局返回码
 * @author wy
 */
public class GlobalRetrunCode extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 5487560116158958795L;
	/**
	 * 全局返回码ID
	 */
	private Integer globalreturncodeId;
	/**
	 * 返回码
	 */
	private String returncode;
	/**
	 * 说明
	 */
	private String discretion;
	public Integer getGlobalreturncodeId() {
		return globalreturncodeId;
	}
	public void setGlobalreturncodeId(Integer globalreturncodeId) {
		this.globalreturncodeId = globalreturncodeId;
	}
	public String getReturncode() {
		return returncode;
	}
	public void setReturncode(String returncode) {
		this.returncode = returncode;
	}
	public String getDiscretion() {
		return discretion;
	}
	public void setDiscretion(String discretion) {
		this.discretion = discretion;
	}
	
}
