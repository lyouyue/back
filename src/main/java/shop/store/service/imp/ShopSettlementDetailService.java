package shop.store.service.imp;
import java.util.Date;

import shop.customer.pojo.CustomerBankroll;
import shop.customer.pojo.FundDetail;
import shop.customer.service.ICustomerBankrollService;
import shop.customer.service.IFundDetailService;
import shop.store.dao.IShopSettlementDetailDao;
import shop.store.pojo.ShopSettlementDetail;
import shop.store.service.IShopSettlementDetailService;
import util.other.Utils;
import util.service.BaseService;
import basic.pojo.Users;
/**
 * 店铺申请结算明细表service实现类
 *
 * @author 刘钦楠
 *
 */
public class ShopSettlementDetailService extends BaseService<ShopSettlementDetail> implements IShopSettlementDetailService {
	private IShopSettlementDetailDao shopSettlementDetailDao;
	/**资金流水Service**/
	private IFundDetailService fundDetailService;
	/**用户资金Service**/
	private ICustomerBankrollService customerBankrollService;
	/**
	 * 修改店铺申请结算审核状态 审核不可逆
	 *
	 * @return
	 */
	public ShopSettlementDetail updateReviewStatus(String id, Users users, String status) {
		ShopSettlementDetail shopSettlementDetail = shopSettlementDetailDao.getObjectById(id);
		if(shopSettlementDetail!=null&&"1".equals(status)){
			shopSettlementDetail.setReviewer(users.getUserName());
			shopSettlementDetail.setReviewerDate(new Date());
			shopSettlementDetail.setStatus(Integer.valueOf(status));
		}
		return shopSettlementDetail;
	}

	/**
	 * 保存或者修改结算记录
	 *
	 * @param shopSettlementDetail
	 * @return
	 */
	@Override
	public ShopSettlementDetail saveOrUpdateObject(ShopSettlementDetail shopSettlementDetail) {
		ShopSettlementDetail shopSettlementDetail1 = new ShopSettlementDetail();
		if (Utils.objectIsNotEmpty(shopSettlementDetail)) {//如果是付款时，则保存结算记录
			shopSettlementDetail1 = shopSettlementDetailDao.saveOrUpdateObject(shopSettlementDetail);
			try {
				if (shopSettlementDetail1.getStatus() == 4){	//如果结算状态为4，即已付款时，
					FundDetail fundDetail = new FundDetail();
					fundDetail.setCustomerId(shopSettlementDetail1.getCustomerId());
					fundDetail.setFundDetailsCode(String.valueOf(shopSettlementDetail1.getSettlementId()));
					fundDetail.setAmount(shopSettlementDetail1.getTotalCost());
					fundDetail.setFundDetailsType(1);    // 收入
					fundDetail.setSource(6);    //来源：商家结算
					fundDetail.setTransactionTime(new Date());
					fundDetailService.saveOrUpdateObject(fundDetail);
				}
			} catch (Exception e) {
				String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			}
		}
		return shopSettlementDetail1;
	}
	/**
	 * @throws Exception 
	 * @功能：结算信息的审核与付款
	 * @作者:  cyy
	 * @参数： @throws IOException
	 * @返回值：void
	 * @日期: 2016年8月10日 上午11:08:47
	 */
	@Override
	public boolean saveOrUpdatePayForShop(String settlementId,String paymentInfo) throws Exception {
		boolean isSuccess = false;
		ShopSettlementDetail shopSettlementDetail = (ShopSettlementDetail) shopSettlementDetailDao.get(" where o.settlementId="+settlementId);
		if(Utils.objectIsNotEmpty(shopSettlementDetail)&&Utils.objectIsNotEmpty(shopSettlementDetail.getSettlementId())){
			//status 1.待审核 2.审核通过 3.审核未通过 4已结算
			isSuccess = shopSettlementDetailDao.updateBySQL("UPDATE shop_settlement_detail SET status='4',paymentInfo='"+paymentInfo.trim()+"' WHERE settlementId='"+settlementId+"'");
//			//修改用户余额，增加消费明细
//			CustomerBankroll customerBankroll=(CustomerBankroll) customerBankrollService.getObjectByParams(" where o.customerId = "+shopSettlementDetail.getCustomerId());
//			//余额=当前余额+结算金额
//			customerBankroll.setBalance(customerBankroll.getBalance().add(shopSettlementDetail.getFinaltTotalCost()));
//			customerBankrollService.saveOrUpdateObject(customerBankroll);
			//增加消费明细
			FundDetail fundDetail = new FundDetail();
			fundDetail.setCustomerId(shopSettlementDetail.getCustomerId());
			fundDetail.setOrdersNo("");
			fundDetail.setFundDetailsCode(String.valueOf(shopSettlementDetail.getSettlementId()));//资金流水号
			fundDetail.setAmount(shopSettlementDetail.getFinaltTotalCost());//平台给店铺的结算金额
			fundDetail.setFundDetailsType(1);//消费类型 1收入 2支出
			fundDetail.setSource(6);//资金来源 1充值，2返利，3余额消费， 4提现，5退款 ，6结算
			fundDetail.setTransactionTime(new Date());
			fundDetailService.saveOrUpdateObject(fundDetail);
		}
		return isSuccess;
	}
	public void setShopSettlementDetailDao(
			IShopSettlementDetailDao shopSettlementDetailDao) {
		this.baseDao = this.shopSettlementDetailDao = shopSettlementDetailDao;
	}

	public void setFundDetailService(IFundDetailService fundDetailService) {
		this.fundDetailService = fundDetailService;
	}

	public void setCustomerBankrollService(
			ICustomerBankrollService customerBankrollService) {
		this.customerBankrollService = customerBankrollService;
	}
	
}
