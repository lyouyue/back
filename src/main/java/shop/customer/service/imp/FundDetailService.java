package shop.customer.service.imp;

import java.math.BigDecimal;
import java.util.Date;

import org.apache.log4j.Logger;
import shop.customer.dao.IFundDetailDao;
import shop.customer.pojo.FundDetail;
import shop.customer.service.IFundDetailService;
import shop.customer.service.IFundDetailSyncService;
import util.other.SerialNumberUtil;
import util.other.Utils;
import util.service.BaseService;
import distribution.customer.dao.IDisCustomerDao;
import distribution.customer.pojo.DisCustomer;

/**
 * 资金流水明细Service接口实现类
 */
public class FundDetailService extends BaseService<FundDetail> implements IFundDetailService {
	/**资金流水明细Dao**/
	private IFundDetailDao fundDetailDao;
	private IFundDetailSyncService fundDetailSyncService;
	/**分销上下级关系Service**/
	private IDisCustomerDao disCustomerDao;

	/**
	 * 保存资金流水明细
	 *
	 * @param fundDetail
	 * @return
	 * @throws Exception
	 */
	@Override
	public FundDetail saveOrUpdateObject(FundDetail fundDetail) {
		fundDetail = fundDetailDao.saveObject(fundDetail);
		if (Utils.objectIsNotEmpty(fundDetail)) {
			fundDetailSyncService.saveFundDetailSync(fundDetail);
		}
		return fundDetail;
	}

	/**
	 * 根据用户id查询总支出
	 *
	 * @param customerId
	 * @return
	 * @throws Exception
	 */
	@Override
	public BigDecimal getBalanceExpenditureByCustomerId(Integer customerId) throws Exception {
		BigDecimal balance = fundDetailDao.getBalanceExpenditureByCustomerId(customerId);
		return balance;
	}

	/**
	 * 根据用户id查询总收入
	 *
	 * @param customerId
	 * @return
	 * @throws Exception
	 */
	@Override
	public BigDecimal getBalanceIncomeByCustomerId(Integer customerId) throws Exception {
		BigDecimal balance = fundDetailDao.getBalanceIncomeByCustomerId(customerId);
		return balance;
	}

	/**
	 * 保存返利资金流水明细
	 */
	public String saveOrderOver(int customerId,String totalNo,String code,BigDecimal amount,BigDecimal secAmount,BigDecimal thiAmount) throws Exception{
		DisCustomer disCustomer = disCustomerDao.get(" where o.customerId="+customerId);
		if(amount.compareTo(new BigDecimal(0))!=1){
			return "amountErr";//金额错误
		}

		if(Utils.objectIsNotEmpty(disCustomer)){
			logger.info("进行1级返利：" + disCustomer.getLevel1id());
			if(disCustomer.getLevel1id()>0){
				FundDetail fd = new FundDetail();
				fd.setCustomerId(disCustomer.getLevel1id());//用户ID
				fd.setOrdersNo(code);//订单号
				fd.setFundDetailsCode(SerialNumberUtil.FundSnNumber());//明细流水号
				fd.setAmount(amount);//一级返利金额
				fd.setFundDetailsType(1);//收入
				fd.setTransactionTime(new Date());//交易时间
				fd.setSource(2);//返利
				fd = fundDetailDao.saveObject(fd);//保存资金流水明细
				if (Utils.objectIsNotEmpty(fd)) {
					fundDetailSyncService.saveFundDetailSync(fd);
				}
				logger.info("1级返利完成：" + amount);
			}
			logger.info("进行2级返利：" + disCustomer.getLevel1id());
			if(disCustomer.getLevel2id()>0){
				FundDetail fd = new FundDetail();
				fd.setCustomerId(disCustomer.getLevel2id());//用户ID
				fd.setOrdersNo(code);//订单号
				fd.setFundDetailsCode(SerialNumberUtil.FundSnNumber());//明细流水号
				fd.setAmount(secAmount);//二级返利金额
				fd.setFundDetailsType(1);//收入
				fd.setTransactionTime(new Date());//交易时间
				fd.setSource(2);//返利
				fd = fundDetailDao.saveObject(fd);//保存资金流水明细
				if (Utils.objectIsNotEmpty(fd)) {
					fundDetailSyncService.saveFundDetailSync(fd);
				}
				logger.info("2级返利完成：" + secAmount);
			}
			logger.info("进行3级返利：" + disCustomer.getLevel1id());
			if(disCustomer.getLevel3id()>0){
				FundDetail fd = new FundDetail();
				fd.setCustomerId(disCustomer.getLevel3id());//用户ID
				fd.setOrdersNo(code);//订单号
				fd.setFundDetailsCode(SerialNumberUtil.FundSnNumber());//明细流水号
				fd.setAmount(thiAmount);//三级返利金额
				fd.setFundDetailsType(1);//收入
				fd.setTransactionTime(new Date());//交易时间
				fd.setSource(2);//返利
				fd = fundDetailDao.saveObject(fd);//保存资金流水明细
				if (Utils.objectIsNotEmpty(fd)) {
					fundDetailSyncService.saveFundDetailSync(fd);
				}
				logger.info("3级返利完成：" + thiAmount);
			}
		}
		return "success";
	}

	public void setFundDetailDao(IFundDetailDao fundDetailDao) {
		this.baseDao = this.fundDetailDao = fundDetailDao;
	}

	public void setFundDetailSyncService(IFundDetailSyncService fundDetailSyncService) {
		this.fundDetailSyncService = fundDetailSyncService;
	}

	public void setDisCustomerDao(IDisCustomerDao disCustomerDao) {
		this.disCustomerDao = disCustomerDao;
	}
}
