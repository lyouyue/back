package shop.customer.service.imp;

import shop.customer.dao.IFundDetailSyncDao;
import shop.customer.pojo.FundDetail;
import shop.customer.pojo.FundDetailSync;
import shop.customer.service.IFundDetailSyncService;
import util.service.BaseService;

/**
 * 资金流水明细Service接口实现类
 */
public class FundDetailSyncService extends BaseService<FundDetailSync> implements IFundDetailSyncService {
	/**资金流水明细Dao**/
	private IFundDetailSyncDao fundDetailSyncDao;

	/**
	 * 保存资金流水到影子表（待同步）
	 *
	 * @param fundDetail
	 * @throws Exception
	 */
	@Override
	public void saveFundDetailSync(FundDetail fundDetail) {
		FundDetailSync sync = new FundDetailSync();
		sync.setCustomerId(fundDetail.getCustomerId());
		sync.setOrdersNo(fundDetail.getOrdersNo());
		sync.setAmount(fundDetail.getAmount());
		sync.setFundDetailsCode(fundDetail.getFundDetailsCode());
		sync.setFundDetailsType(fundDetail.getFundDetailsType());
		sync.setTransactionTime(fundDetail.getTransactionTime());
		sync.setSource(fundDetail.getSource());
		sync.setStatus(1);	// 1未同步，2已同步
		fundDetailSyncDao.saveObject(sync);
	}

	public void setFundDetailSyncDao(IFundDetailSyncDao fundDetailSyncDao) {
		this.fundDetailSyncDao = fundDetailSyncDao;
	}
}
