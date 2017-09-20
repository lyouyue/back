package shop.store.service;
import shop.store.pojo.ShopSettlementDetail;
import util.service.IBaseService;
import basic.pojo.Users;
/**
 * 店铺申请结算明细表service接口
 * @author 刘钦楠
 *
 */
public interface IShopSettlementDetailService extends IBaseService<ShopSettlementDetail>{
	/**
	 * 修改店铺申请结算审核状态
	 * @return
	 */
	public ShopSettlementDetail updateReviewStatus(String id,Users users,String reviewStatus);

	/**
	 * 保存或者修改结算记录
	 * @param shopSettlementDetail
	 * @return
     */
	public ShopSettlementDetail saveOrUpdateObject(ShopSettlementDetail shopSettlementDetail);
	/**
	 * 结算信息的审核与付款
	 */
	public boolean saveOrUpdatePayForShop(String settlementId,String paymentInfo)throws Exception ;
}
