package shop.customer.dao;

import shop.customer.pojo.FundDetail;
import util.dao.IBaseDao;

import java.math.BigDecimal;

/**
 * 资金流水明细Dao接口
 */
public interface IFundDetailDao extends IBaseDao<FundDetail> {

    /**
     * 根据用户id查询总支出
     * @param customerId
     * @return
     * @throws Exception
     */
    public BigDecimal getBalanceExpenditureByCustomerId(Integer customerId) throws Exception;

    /**
     * 根据用户id查询总收入
     * @param customerId
     * @return
     * @throws Exception
     */
    public BigDecimal getBalanceIncomeByCustomerId(Integer customerId) throws Exception;

}
