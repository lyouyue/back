package shop.navigation.service.imp;
import shop.navigation.dao.INavigationDao;
import shop.navigation.pojo.Navigation;
import shop.navigation.service.INavigationService;
import util.service.BaseService;
/**
 * 导航条service层实现类
 * @author 张攀攀
 *
 */
public class NavigationService extends BaseService<Navigation> implements INavigationService{
	@SuppressWarnings("unused")
	private INavigationDao navigationDao;
	public void setNavigationDao(INavigationDao navigationDao) {
		this.baseDao = this.navigationDao = navigationDao;
	}
}
