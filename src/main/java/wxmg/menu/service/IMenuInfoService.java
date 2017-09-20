package wxmg.menu.service;

import java.util.List;

import util.service.IBaseService;
import wxmg.menu.pojo.MenuInfo;
/**
 * 微信菜单信息Service接口
 * @author LQS
 *
 */
public interface IMenuInfoService  extends IBaseService <MenuInfo> {
	/**
	 * 重新按照一级菜单下面的二级菜单进行重组
	 * @param wxMenuInfoList
	 * @return
	 */
	public List<MenuInfo> resortWXMenuInfoList(List <MenuInfo> wxMenuInfoList);
	
	public String getMenuJsonString(List <MenuInfo> wxMenuInfoList);
}
