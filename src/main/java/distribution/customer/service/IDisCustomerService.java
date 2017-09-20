package distribution.customer.service;

import java.util.Map;

import shop.customer.pojo.CustomerBankroll;
import util.pojo.PageHelper;
import util.service.IBaseService;
import distribution.configure.pojo.DisConfigure;
import distribution.customer.pojo.DisCustomer;
/**
 * 分销用户关系：前台Action的service接口类
 * @author 
 */
public interface IDisCustomerService extends IBaseService <DisCustomer>{
	/**
	 * 根据用户ID获取用户关系表记录
	 * @param customerId
	 * @return
	 */
	public DisCustomer getDisCustomerByCustomerId(int customerId);
	
	/**
	 * 当用户资金发生变动,根据回值是否发送微信消息。
	 * 判断用户是否具备是否推广员资格  如果以前IsPromoter=0  计算后=1  就发消息
	 * @param customerId
	 * @return  1发消息（以前不具备，目前具备） 2不发消息（已有资格） 3不发送消息（任然不具有资格）4不发送（以前有资格，现在也有资格）   0用户不存在
	 */
	/*public int updateOrCheckIsPromoter(X15Customer customer,X15Configure x15Configure);*/
	/**
	 * 根据用户ID 修改字段值
	 * @param customerId
	 * @param type
	 * @param value
	 * @return
	 */
	public DisCustomer updateDisCustomer(DisCustomer disCustomer,String type,int value);
	
	public PageHelper getPageHelper(PageHelper pageHelper,Map<String,Object> map);
	
	public int updateOrCheckIsCriticalValue(DisCustomer customer, CustomerBankroll customerBankroll,DisConfigure disConfigure);
}
