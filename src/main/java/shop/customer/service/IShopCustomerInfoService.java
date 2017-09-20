package shop.customer.service;
import shop.customer.pojo.Customer;
import shop.customer.pojo.ShopCustomerInfo;
import util.service.IBaseService;
/**
 * 会员个性信息Service接口
 * 
 *
 */
public interface IShopCustomerInfoService extends IBaseService <ShopCustomerInfo> {
	public Boolean saveOrUpdateCustomerInfo(Customer customer,ShopCustomerInfo customerInfo);

	/**
	 * 同步用户的微信信息（微信名称，头像）
	 * @param openId
	 * @param wxName
	 * @param headimgurl
	 */
	public void updateSyncWxInfo(String openId, String wxName, String headimgurl);

	/**
	 * 根据微信用户的openId获得对象
	 * @param openId
	 * @return
	 */
	public ShopCustomerInfo getShopCustomerInfoByOpenId(String openId);
}
