package promotion.service.imp;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import promotion.dao.IPlatformPromotionDao;
import promotion.pojo.PlatformPromotion;
import promotion.service.IPlatformPromotionService;
import util.common.EnumUtils;
import util.other.Utils;
import util.service.BaseService;
/**
* PlatformPromotionService - 平台管理促销活动Service接口实现类
* ============================================================================
* 版权所有 2010-2013 XXXX软件有限公司，并保留所有权利。
* 官方网站：http://www.shopjsp.com
* ============================================================================
* @author 孟琦瑞
*/
public class PlatformPromotionService extends BaseService  <PlatformPromotion> implements IPlatformPromotionService{
	private IPlatformPromotionDao platformPromotionDao;
	public void setPlatformPromotionDao(IPlatformPromotionDao platformPromotionDao) {
		this.baseDao =this.platformPromotionDao = platformPromotionDao;
	}

	public void updatePlatformPromotionState(){
		Date nowDate = new Date();//创建当前时间  用于比较促销活动是否过期
		SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
		String format = fm.format(nowDate);//格式化后的时间
		//System.out.println("促销活动定时器触发时间:++++++++++++++++"+format+"=====================================");
		//查询可以关闭的促销活动
		List<PlatformPromotion> platformPromotionList1 = platformPromotionDao.findObjects(" where o.isPass=2 and o.useStatus=1 and UNIX_TIMESTAMP(o.endTime) <= UNIX_TIMESTAMP('"+format+"')");
		if(platformPromotionList1!=null&&platformPromotionList1.size()>0){
			for(PlatformPromotion p:platformPromotionList1){
				//修改促销活动状态2，关闭
				p.setUseStatus(2);
				platformPromotionDao.saveOrUpdateObject(p);
				//查询该促销活动下的套餐
				String hql = "select o.productId as productId,o.salesPriceBack as salesPriceBack from ProductInfo o,StoreApplyPromotion sap,SalesPromotionDiscount spd where o.productId = sap.productId and sap.promotionState = 1 and sap.promotionId = "+p.getPromotionId()
						+" and spd.promotionId = sap.promotionId";
				List<Map> productList=platformPromotionDao.findListMapByHql(hql);
				//将套餐销售价格还原
				for(Map pro:productList){
					BigDecimal salesPrice = new BigDecimal(String.valueOf(pro.get("salesPriceBack")));
					String sql="update shop_productinfo set salesPrice="+salesPrice+" where productId ="+pro.get("productId");
					platformPromotionDao.updateBySQL(sql);
				}
			}
		}

		//查询可以开启的促销活动
		List<PlatformPromotion> platformPromotionList = platformPromotionDao.findObjects(" where o.isPass=2 and o.useStatus=0 and UNIX_TIMESTAMP(o.beginTime) <= UNIX_TIMESTAMP('"+format+"')");
		//如果存在
		if(platformPromotionList!=null&&platformPromotionList.size()>0){
			for(PlatformPromotion p:platformPromotionList){
				//修改促销活动状态为1，开启
				p.setUseStatus(1);
				platformPromotionDao.saveOrUpdateObject(p);
				//查询该促销活动下的套餐
				String hql = "select o.productId as productId,o.salesPrice as salesPrice,spd.discount as discount from ProductInfo o,StoreApplyPromotion sap,SalesPromotionDiscount spd where o.productId = sap.productId and sap.promotionState = 1 and sap.promotionId = "+p.getPromotionId()
						+" and spd.promotionId = sap.promotionId";
				List<Map> productList=platformPromotionDao.findListMapByHql(hql);
				//遍历修改套餐的销售价格，及备份原来的销售价格
				for(Map pro:productList){
					//得到套餐原来销售价格
					BigDecimal salesPrice = new BigDecimal(String.valueOf(pro.get("salesPrice")));
					//得到促销活动的折扣
					Double doubleDisCount = 10.0;
					if(Utils.objectIsNotEmpty(pro.get("discount"))){
						String strDiscount = String.valueOf(pro.get("discount"));
						doubleDisCount = Double.valueOf(strDiscount);
					}
					BigDecimal discount = new BigDecimal(doubleDisCount/10);
					//促销价格=套餐原销售价格*折扣
					BigDecimal discountPrice = salesPrice.multiply(discount);
					//修改套餐信息
					String sql="update shop_productinfo set salesPriceBack="+salesPrice+",salesPrice="+discountPrice+" where productId ="+pro.get("productId");
					platformPromotionDao.updateBySQL(sql);
				}
			}
		}

		//System.out.println("促销活动定时器触发结束时间========================"+fm.format(new Date())+"===================================");
	}

	public boolean updateObject(String sql){
		return platformPromotionDao.updateBySQL(sql);
	}
}