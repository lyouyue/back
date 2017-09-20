package shop.customer.dao.imp;

import org.hibernate.Query;
import shop.customer.dao.IFundDetailDao;
import shop.customer.pojo.FundDetail;
import util.dao.BaseDao;
import util.other.Utils;

import java.math.BigDecimal;

/**
 * 资金流水明细Dao接口实现类
 */
public class FundDetailDao extends BaseDao<FundDetail> implements IFundDetailDao {
    /**
     * 根据用户id查询总支出
     *
     * @param customerId
     * @return
     * @throws Exception
     */
    @Override
    public BigDecimal getBalanceExpenditureByCustomerId(Integer customerId) throws Exception {
        String url = "select sum(o.amount) from FundDetail o where o.customerId = ? and o.fundDetailsType = 2";
        Query query = getSessionForRead().createQuery(url);
        query.setParameter(0, customerId);
        Object result = query.uniqueResult();
        BigDecimal balance = Utils.objectIsNotEmpty(result) ? new BigDecimal(String.valueOf(result)) : BigDecimal.ZERO;
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
        String url = "select sum(o.amount) from FundDetail o where o.customerId = ? and o.fundDetailsType = 1";
        Query query = getSessionForRead().createQuery(url);
        query.setParameter(0, customerId);
        query.getQueryString();
        Object result = query.uniqueResult();
        BigDecimal balance = Utils.objectIsNotEmpty(result) ? new BigDecimal(String.valueOf(result)) : BigDecimal.ZERO;
        return balance;
    }
}
