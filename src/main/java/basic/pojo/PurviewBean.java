package basic.pojo;

import java.io.Serializable;
import java.util.List;
/**
 * 自定义内部类
 * 用于权限的排序
 * @author LQS
 */
public class PurviewBean  implements Serializable{
	private static final long serialVersionUID = -1549447345801501420L;
	/**权限名称**/
	private String purviewName;
	/**子权限集合**/
	private List<Purview> purviewList;
	//setter getter
	public String getPurviewName() {
		return purviewName;
	}
	public void setPurviewName(String purviewName) {
		this.purviewName = purviewName;
	}
	public List<Purview> getPurviewList() {
		return purviewList;
	}
	public void setPurviewList(List<Purview> purviewList) {
		this.purviewList = purviewList;
	}
}
