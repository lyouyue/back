package shop.customer.dao.imp;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.Transaction;
import org.hibernate.type.Type;
import shop.customer.dao.IMallCoinDao;
import shop.customer.pojo.MallCoin;
import util.dao.BaseDao;
import util.other.Utils;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;

/**
 * 金币Dao接口实现类
 * @author mf
 */
public class MallCoinDao extends BaseDao <MallCoin> implements IMallCoinDao {
    /**
     * 根据用户id及订单号查询金币明细
     * @param customerId
     * @param ordersNo
     * @return
     */
    public MallCoin getObjectByParam(Integer customerId, String ordersNo) {
        return get("where o.customerId="+customerId+" and o.ordersNo='"+ordersNo+"'");
    }

    /**
     * 根据用户id查询总支出
     *
     * @param customerId
     * @return
     * @throws Exception
     */
    @Override
    public BigDecimal getCoinExpenditureByCustomerId(Integer customerId) throws Exception {
        BigDecimal result = BigDecimal.ZERO;
        String url = "select sum(o.transactionNumber) from MallCoin o where o.customerId = ? and o.type = 2";
        Query query = getSessionForRead().createQuery(url);
        query.setParameter(0, customerId);
        Object obj = query.uniqueResult();
        if (Utils.objectIsNotEmpty(obj)) {
            result = new BigDecimal(String.valueOf(obj));
        }
        return result;
    }

    /**
     * 根据用户id查询总收入
     *
     * @param customerId
     * @return
     * @throws Exception
     */
    @Override
    public BigDecimal getCoinIncomeByCustomerId(Integer customerId) throws Exception {
        BigDecimal result = BigDecimal.ZERO;
        String url = "select sum(o.transactionNumber) from MallCoin o where o.customerId = ? and o.type = 1";
        Query query = getSessionForRead().createQuery(url);
        query.setParameter(0, customerId);
        Object obj = query.uniqueResult();
        if (Utils.objectIsNotEmpty(obj)) {
            result = new BigDecimal(String.valueOf(obj));
        }
        return result;
    }
}
