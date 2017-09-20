package shop.store.service.imp;
import shop.store.dao.IShopInfoDao;
import shop.store.pojo.ShopInfo;
import shop.store.service.IShopInfoService;
import util.other.Utils;
import util.service.BaseService;
/**
 * ShopInfoService - 店铺基本信息的service实现层
 * @Author §j*fm§
 */
public class ShopInfoService extends BaseService<ShopInfo> implements IShopInfoService {
	private IShopInfoDao shopInfoDao;
	public void setShopInfoDao(IShopInfoDao shopInfoDao) {
		this.baseDao = this.shopInfoDao = shopInfoDao;
	}
	public boolean saveOrUpdateIsCloss(Integer isClose,String shopInfoIds){
		String sql = " update shop_shopinfo a SET a.isClose="+isClose+" where a.shopInfoId in ("+shopInfoIds+");";
		boolean flag = shopInfoDao.updateBySQL(sql);
		return flag;
	}

	/**
	 * 设置或取消VIP店铺
	 * @param isVip 要设置成的状态，0:不是VIP、1:是VIP
	 * @param shopInfoIds 店铺ID数组
	 * @return 修改成功返回true,否则返回false
	 */
	public boolean saveOrUpdateIsVip(Integer isVip,String[] shopInfoIds){
		boolean flag = false;
		for(int i=0;i<shopInfoIds.length;i++){
			if(Utils.objectIsNotEmpty(shopInfoIds[i])){
				String sql = " update shop_shopinfo a SET a.isVip="+isVip+" where a.shopInfoId ="+shopInfoIds[i]+";";
				flag = shopInfoDao.updateBySQL(sql);
			}
		}
		return flag;
	}
}
