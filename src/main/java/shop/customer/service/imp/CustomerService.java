package shop.customer.service.imp;
import it.sauronsoftware.base64.Base64;

import java.util.Date;
import java.util.Map;

import org.apache.commons.collections.map.HashedMap;
import shop.customer.dao.ICustomerDao;
import shop.customer.dao.IShopCustomerInfoDao;
import shop.customer.pojo.Customer;
import shop.customer.pojo.ShopCustomerInfo;
import shop.customer.service.ICustomerService;
import shop.store.dao.IShopInfoDao;
import shop.store.pojo.ShopInfo;
import util.action.SecurityCode;
import util.action.SecurityCode.SecurityCodeLevel;
import util.other.Utils;
import util.service.BaseService;
/**
 * 客户信息Service接口实现类
 * 
 * 
 * 
 */
public class CustomerService extends BaseService<Customer> implements ICustomerService {
	private ICustomerDao customerDao;
	private IShopCustomerInfoDao shopCustomerDao;
	private IShopInfoDao shopInfoDao;
	
	public boolean saveOrUpdateShengJiWoDeShenFen(Customer customer){
		Customer newCustomer = customerDao.getObjectById(String.valueOf(customer.getCustomerId()));
		newCustomer.setType(customer.getType());
		newCustomer = customerDao.saveOrUpdateObject(newCustomer);
		return true;
	}
	/**
	 * 注册用户
	 */
	public Customer saveCustomer(Customer customer,String openId,String nickname,Integer state) {
		customer.setLockedState(0);//可用的用户
		customer.setRegisterDate(new Date());//注册时间
		customer.setType(1);//默认设置会员类型为个人
		Customer c = customerDao.saveObject(customer);
		ShopCustomerInfo sci = new ShopCustomerInfo();// 新建会员个性信息
		sci.setCustomerId(c.getCustomerId());//存入用户ID
		sci.setSex(3);//性别  默认为 保密 3
		sci.setWxUserOpenId(openId);//微信标识
		if(state==1){
			sci.setWxName(nickname);//微信昵称
		}else{
			sci.setWxName(Base64.encode(nickname, "UTF-8"));//微信昵称
		}
		shopCustomerDao.saveOrUpdateObject(sci);// 保存会员个性信息
		return c;
	}
	/**
	 * 注册用户--手机
	 */
	public Customer saveCustomerByPhone(Customer customer) {
		customer.setLockedState(0);//可用的用户
		customer.setRegisterDate(new Date());//注册时间
		customer.setType(1);//默认设置会员类型为个人
		//产生4位随机字母
		String str = SecurityCode.getSecurityCode(4,SecurityCodeLevel.onlyChar, true);
		//获取用户的手机号
		String phone=customer.getLoginName();
		/*拼装用户loginName
	       规则：手机号+下斜线+随机字母（4位随机数），比如：94876_oppo）
		 */
		String loginName=phone+"_"+str;
		customer.setLoginName(loginName);
		Customer c = customerDao.saveObject(customer);
		return c;
	}
	
	/**
	 * 通过sql语句修改单个对象或者批量对象
	 */
	public boolean updateObject(String sql){
		return customerDao.updateBySQL(sql);
	}
	
	/**
	 * 注册
	 * @param customer 用户对象
	 * @param trueName  真实姓名
	 * @param cardNo  身份证号
	 * @param ip  
	 */
	@SuppressWarnings("static-access")
	public Customer saveRegister(Customer customer,String trueName,String cardNo,String ip,String registerType){
		Customer newCustomer=new Customer();
		newCustomer.setRegisterIp(ip);
		newCustomer.setRegisterDate(new Date());
		newCustomer.setLockedState(0);//0：未冻结1：已冻结
		newCustomer.setType(1);//默认设置会员类型为个人
		if(customer!=null){
			//产生4位随机字母
			String str = SecurityCode.getSecurityCode(4,SecurityCodeLevel.onlyChar, true);
			if(customer.getLoginName()==null){//pc端注册
				//获取用户的邮箱
				String email=customer.getEmail();
				/*拼装用户loginName
			       规则：邮箱@前字符+下斜线+随机字母（4位随机数），比如：94876_oppo）
				 */
				String loginName=email.split("@")[0]+"_"+str;
				newCustomer.setLoginName(loginName);
				Utils ut = new Utils();
				String encodeMd5 = ut.EncodeMd5(customer.getPassword());//密码加密
				String encodeMd52 = ut.EncodeMd5(encodeMd5);
				newCustomer.setPassword(encodeMd52); 
				newCustomer.setPhone(customer.getPhone());
				newCustomer.setEmail(customer.getEmail());
			}else{
				if(registerType!=null&&"1".equals(registerType)){
					newCustomer.setLoginName(customer.getLoginName());
					Utils ut = new Utils();
					String encodeMd5 = ut.EncodeMd5(customer.getPassword());//密码加密
					String encodeMd52 = ut.EncodeMd5(encodeMd5);
					newCustomer.setPassword(encodeMd52); 
				}else if(registerType!=null&&"3".equals(registerType)){//手机端手机号注册
					//获取用户的手机号
					String phone=customer.getLoginName();
					/*拼装用户loginName
				       规则：手机号+下斜线+随机字母（4位随机数），比如：94876_oppo）
					 */
					String loginName=phone+"_"+str;
					newCustomer.setLoginName(loginName);
					newCustomer.setPhone(phone);
				}else{
					//获取用户的邮箱
					String email=customer.getLoginName();
					/*拼装用户loginName
				       规则：邮箱@前字符+下斜线+随机字母（4位随机数），比如：94876_oppo）
					 */
					String loginName=email.split("@")[0]+"_"+str;
					newCustomer.setLoginName(loginName);
					newCustomer.setEmail(email);
					Utils ut = new Utils();
					String encodeMd5 = ut.EncodeMd5(customer.getPassword());//密码加密
					String encodeMd52 = ut.EncodeMd5(encodeMd5);
					newCustomer.setPassword(encodeMd52); 
				}
			}
			newCustomer = customerDao.saveOrUpdateObject(newCustomer);// 注册用户
			if(newCustomer!=null&&newCustomer.getCustomerId()!=null){
				//保存个性信息
				ShopCustomerInfo customerInfo = new ShopCustomerInfo();// 新建会员个性信息
				customerInfo.setCustomerId(newCustomer.getCustomerId());//存入用户ID
				customerInfo.setTrueName(trueName);//真实姓名
				customerInfo.setIdCard(cardNo);//身份证号码	
				shopCustomerDao.saveOrUpdateObject(customerInfo);
				//添加一个发票信息
				ShopInfo si=new  ShopInfo();
				si.setCustomerId(customer.getCustomerId());
				si.setIsClose(0);
				si.setCustomerName(customer.getLoginName());
				shopInfoDao.saveOrUpdateObject(si);
			}
			return newCustomer;
		}
		return null;
	}

	/**
	 * 升级会员级别为店铺
	 *
	 * @param customerId
	 * @return
	 */
	@Override
	public Map<String, Object> saveUpgradeShop(Integer customerId) {
		boolean isSuccess = false;
		String info = "升级成功";

		if (Utils.objectIsNotEmpty(customerId)) {
			Customer customer = customerDao.getObjectById(String.valueOf(customerId));
			//检查用户是否为空，且是否为用户角色
			if (Utils.objectIsNotEmpty(customer) && customer.getType().compareTo(1) == 0) {
				//修改用户为店铺，类型为2
				isSuccess = customerDao.updateCustomerType(customerId, 2);
			}
		}

		if (!isSuccess) {
			info = "升级失败";
		}

		Map<String, Object> result = new HashedMap();
		result.put("isSuccess", isSuccess);
		result.put("info", info);
		return result;
	}
	
	public void setCustomerDao(ICustomerDao customerDao) {
		this.baseDao = this.customerDao = customerDao;
	}
	public void setShopCustomerDao(IShopCustomerInfoDao shopCustomerDao) {
		this.shopCustomerDao = shopCustomerDao;
	}
	public void setShopInfoDao(IShopInfoDao shopInfoDao) {
		this.shopInfoDao = shopInfoDao;
	}
}
