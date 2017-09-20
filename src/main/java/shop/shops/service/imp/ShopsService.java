package shop.shops.service.imp;
import shop.shops.dao.IShopsDao;
import shop.shops.dao.IShopsShopinfoDao;
import shop.shops.pojo.Shops;
import shop.shops.service.IShopsService;
import util.service.BaseService;
/**
 * 商城(线下实际商城)service层实现类
 * @author 郑月龙
 *
 */
public class ShopsService extends BaseService<Shops> implements IShopsService{
	private IShopsDao shopsDao;
	private IShopsShopinfoDao ShopsShopinfoDao;
	public void setShopsDao(IShopsDao shopsDao) {
		this.baseDao = this.shopsDao = shopsDao;
	}
	public void setShopsShopinfoDao(IShopsShopinfoDao shopsShopinfoDao) {
		this.ShopsShopinfoDao = shopsShopinfoDao;
	}
	public void updateObject(Shops shops){
		String sqlUpdate="update shop_shops_shopinfo set city="+shops.getCity()+",regionLocation="+shops.getRegionLocation()+" where shopsId = "+shops.getShopsId();
		this.ShopsShopinfoDao.updateObject(sqlUpdate);
		this.shopsDao.saveOrUpdateObject(shops);
	}
	
	//删除线下商场
		public boolean deleteShops(String key,String ids){
			boolean b=true;
			String [] idss=ids.split(",");
			String queryParams=" where 1=1 and ";
			if(idss.length>1){//删除多个对象
				queryParams+="(";
				for(int i=0;i<idss.length;i++){
					if(i==0){
						queryParams+="o."+key+"='"+idss[i]+"'";
					}else{
						queryParams+=" or o."+key+"='"+idss[i]+"'";
					}
				}
				queryParams+=")";
			}else{
				queryParams+=" o."+key+"='"+idss[0]+"'";//删除一个对象
			}
			boolean success = shopsDao.deleteByParams(queryParams);
			//删除关联表中的数据
			boolean success2 = ShopsShopinfoDao.deleteByParams(queryParams);
			if(!success||!success2){
				b=false;
			}
			return b;
		}
}
