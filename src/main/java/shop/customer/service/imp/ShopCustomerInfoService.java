package shop.customer.service.imp;
import org.springframework.web.context.ServletContextAware;

import shop.customer.dao.ICustomerDao;
import shop.customer.dao.IShopCustomerInfoDao;
import shop.customer.pojo.Customer;
import shop.customer.pojo.ShopCustomerInfo;
import shop.customer.service.IShopCustomerInfoService;
import util.other.Utils;
import util.service.BaseService;
import util.upload.FileUploadUtil;
import wxmg.basicInfo.pojo.FansUserInfo;
import wxmg.basicInfo.service.IFansUserInfoService;

import javax.servlet.ServletContext;

import java.util.Map;

/**
 * 会员个性信息Service接口实现类
 * 
 *
 */
public class ShopCustomerInfoService extends BaseService  <ShopCustomerInfo> implements IShopCustomerInfoService, ServletContextAware {
	private IShopCustomerInfoDao shopCustomerInfoDao;
	private ICustomerDao customerDao;
	private IFansUserInfoService fansUserInfoService;
	private ServletContext servletContext;
	public Boolean saveOrUpdateCustomerInfo(Customer customer,ShopCustomerInfo customerInfo){
		boolean falg = true;
		try {
			Customer newCustomer = customerDao.getObjectById(String.valueOf(customer.getCustomerId()));
			ShopCustomerInfo newCustomerInfo = shopCustomerInfoDao.getObjectById(String.valueOf(customerInfo.getShopCustomerInfoId()));
			//会员邮箱
			newCustomer.setEmail(customer.getEmail());
			newCustomer.setPhone(customer.getPhone());
			//会员信息真实姓名
			newCustomerInfo.setTrueName(customerInfo.getTrueName());
			newCustomerInfo.setSex(customerInfo.getSex());
			newCustomerInfo.setRegionLocation(customerInfo.getRegionLocation());
			newCustomerInfo.setAddress(customerInfo.getAddress());
			newCustomerInfo.setTelephone(customerInfo.getTelephone());
			newCustomerInfo.setQq(customerInfo.getQq());
			newCustomer = customerDao.saveOrUpdateObject(newCustomer);
			newCustomerInfo = shopCustomerInfoDao.saveOrUpdateObject(newCustomerInfo);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			falg = false;
		}
		return falg;
	}

	/**
	 * 同步用户的微信信息（微信名称，头像）
	 *
	 * @param openId
	 * @param wxName
	 * @param headimgurl
	 */
	@Override
	public void updateSyncWxInfo(String openId, String wxName, String headimgurl) {
		if (Utils.objectIsEmpty(openId)) return;

		if (Utils.objectIsNotEmpty(wxName)) {
			shopCustomerInfoDao.updateBySQL("update shop_customerinfo set wxName='" + wxName + "' where wxUserOpenId = '" + openId + "'");
		}

		//检查是否有传入头像
		if (Utils.objectIsEmpty(headimgurl)) {
			//检查微信用户信息表
			FansUserInfo fansUserInfo = (FansUserInfo) fansUserInfoService.getObjectByParams("where o.userOpenId='" + openId + "'");
			if (Utils.objectIsNotEmpty(fansUserInfo) && Utils.objectIsNotEmpty(fansUserInfo.getHeadimgUrl())) {
				@SuppressWarnings("rawtypes")
				Map map = (Map) servletContext.getAttribute("fileUrlConfig");
				String rootFolder = String.valueOf(map.get("fileUploadRoot"));
				String folderName = String.valueOf(map.get("shop")) + "/" + String.valueOf(map.get("image_customer"));
				String fileRule = String.valueOf(map.get("fileRule"));
				headimgurl = FileUploadUtil.uploadHttpImage(fansUserInfo.getHeadimgUrl(), rootFolder, folderName, fileRule);
			}
		}

		if (Utils.objectIsNotEmpty(headimgurl)) {
			ShopCustomerInfo shopCustomerInfo = this.getShopCustomerInfoByOpenId(openId);
			if (Utils.objectIsNotEmpty(shopCustomerInfo)) {
				Integer customerId = shopCustomerInfo.getCustomerId();
				customerDao.updateBySQL("update basic_customer set photoUrl='" + headimgurl + "' where customerId = " + customerId);
			}
		}
	}

	/**
	 * 根据微信用户的openId获得对象
	 *
	 * @param openId
	 * @return
	 */
	@Override
	public ShopCustomerInfo getShopCustomerInfoByOpenId(String openId) {
		if (Utils.objectIsNotEmpty(openId)) {
			return shopCustomerInfoDao.get("where o.wxUserOpenId = '" + openId + "' ORDER BY o.shopCustomerInfoId desc limit 1");
		}
		return null;
	}

	@Override
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}

	public void setShopCustomerInfoDao(IShopCustomerInfoDao shopCustomerInfoDao) {
		this.baseDao = this.shopCustomerInfoDao = shopCustomerInfoDao;
	}
	public void setCustomerDao(ICustomerDao customerDao) {
		this.customerDao = customerDao;
	}

	public void setFansUserInfoService(IFansUserInfoService fansUserInfoService) {
		this.fansUserInfoService = fansUserInfoService;
	}
}
