package shop.shops.service;
import shop.shops.pojo.Shops;
import util.service.IBaseService;
/**
 * 商城(线下实际商城)service层接口
 * @author 郑月龙
 *
 */
public interface IShopsService extends IBaseService<Shops>{
	public void updateObject(Shops shops);
	//删除线下商场
	public boolean deleteShops(String key,String ids);
}
