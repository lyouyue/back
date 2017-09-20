package shop.customer.service.imp;

import shop.customer.dao.IMallCoinSyncDao;
import shop.customer.pojo.MallCoin;
import shop.customer.pojo.MallCoinSync;
import shop.customer.service.IMallCoinSyncService;
import util.service.BaseService;

/**
 * 金币流水Service接口实现类
 * @author zhangdingfang
 */
public class MallCoinSyncService extends BaseService<MallCoinSync> implements
		IMallCoinSyncService {
	/** 金币dao **/
	private IMallCoinSyncDao mallCoinSyncDao;

	/**
	 * 保存金币流水到影子表（待同步）
	 *
	 * @param mallCoin
	 * @throws Exception
	 */
	@Override
	public void saveMallCoinSync(MallCoin mallCoin) throws Exception {
		MallCoinSync mallCoinSync = new MallCoinSync();
		mallCoinSync.setOrdersId(mallCoin.getOrdersId());
		mallCoinSync.setOrdersNo(mallCoin.getOrdersNo());
		mallCoinSync.setCustomerId(mallCoin.getCustomerId());
		mallCoinSync.setSerialNumber(mallCoin.getSerialNumber());
		mallCoinSync.setType(mallCoin.getType());
		mallCoinSync.setTransactionNumber(mallCoin.getTransactionNumber());
		mallCoinSync.setTradeTime(mallCoin.getTradeTime());
		mallCoinSync.setOperatorTime(mallCoin.getOperatorTime());

		mallCoinSync.setRemarks(mallCoin.getRemarks());
		mallCoinSync.setFrozenNumber(mallCoin.getFrozenNumber());
		mallCoinSync.setProportion(mallCoin.getProportion());
		mallCoinSync.setSource(mallCoin.getSource());
		mallCoinSync.setStatus(1);	// 1未同步，2已同步

		mallCoinSyncDao.saveObject(mallCoinSync);
	}

	public void setMallCoinSyncDao(IMallCoinSyncDao mallCoinSyncDao) {
		this.mallCoinSyncDao = mallCoinSyncDao;
	}
}