package shop.customer.service;

import shop.customer.pojo.FundDetail;
import shop.customer.pojo.FundDetailSync;
import util.service.IBaseService;

/**
 * 资金流水明细Service接口
 */
public interface IFundDetailSyncService extends IBaseService<FundDetailSync> {

    /**
     * 保存资金流水到影子表（待同步）
     * @param fundDetail
     * @throws Exception
     */
    public void saveFundDetailSync(FundDetail fundDetail);
}
