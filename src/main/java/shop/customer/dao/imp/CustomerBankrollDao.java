package shop.customer.dao.imp;

import shop.customer.dao.ICustomerBankrollDao;
import shop.customer.pojo.CustomerBankroll;
import util.dao.BaseDao;
import util.pojo.ProcedureBean;

import java.math.BigDecimal;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 账户资金Dao接口实现类
 */
public class CustomerBankrollDao extends BaseDao<CustomerBankroll> implements ICustomerBankrollDao {
	/**
	 * 根据用户id查询 现金钱包 总余额
	 *
	 * @param customer_id
	 * @return
	 */
	@Override
	public BigDecimal getCustomerBalanceByCustomerId(Integer customer_id) throws Exception {

		String sql = "{call getBalanceByCustomerId(?,?)}";          //声明执行事务的sql，其中 ? 占位符为 IN、 OUT 还是 INOUT 参数，取决于已储存过程
		String outputKey = "balanceNow";							//定义返回结果中Map的key名称
		Map<String, Object> result = new HashMap<>();
		List<ProcedureBean> procedureBeanList = new ArrayList<>();
		//1.按顺序在集合中 添加 输入参数
		procedureBeanList.add(new ProcedureBean(ProcedureBean.Schema.IN, customer_id));
		procedureBeanList.add(new ProcedureBean(ProcedureBean.Schema.OUT, Types.DECIMAL, outputKey));
		//2.调用函数获得结果
		result = getDataByProcedure(sql, procedureBeanList);
		return new BigDecimal(String.valueOf(result.containsKey(outputKey) ? result.get(outputKey) : "0"));
	}

	/**
	 * 根据用户id查询 现金钱包 充值总额
	 *
	 * @param customer_id
	 * @return
	 */
	@Override
	public BigDecimal getBalanceRechargeByCustomerId(Integer customer_id) throws Exception {
		String sql = "{call getBalanceRechargeByCustomerId(?,?)}";          //准备执行事务的sql，其中 ? 占位符为 IN、 OUT 还是 INOUT 参数，取决于已储存过程
		String outputKey = "rechargeBalanceNow";							//定义返回结果中Map的key名称
		Map<String, Object> result = new HashMap<>();
		List<ProcedureBean> procedureBeanList = new ArrayList<>();
		//1.按顺序在集合中 添加 输入参数
		procedureBeanList.add(new ProcedureBean(ProcedureBean.Schema.IN, customer_id));
		procedureBeanList.add(new ProcedureBean(ProcedureBean.Schema.OUT, Types.DECIMAL, outputKey));
		//2.调用函数获得结果
		result = getDataByProcedure(sql, procedureBeanList);
		return new BigDecimal(String.valueOf(result.containsKey(outputKey) ? result.get(outputKey) : "0"));
	}

	/**
	 * 根据用户id查询 现金钱包金币 总额
	 *
	 * @param customer_id
	 * @return
	 * @throws Exception
	 */
	@Override
	public BigDecimal getBalanceCoinByCustomerId(Integer customer_id) throws Exception {
		String sql = "{call getBalanceCoinByCustomerId(?,?)}";          //准备执行事务的sql，其中 ? 占位符为 IN、 OUT 还是 INOUT 参数，取决于已储存过程
		String outputKey = "mallCoinNow";							//定义返回结果中Map的key名称
		Map<String, Object> result = new HashMap<>();
		List<ProcedureBean> procedureBeanList = new ArrayList<>();
		//1.按顺序在集合中 添加 输入参数
		procedureBeanList.add(new ProcedureBean(ProcedureBean.Schema.IN, customer_id));
		procedureBeanList.add(new ProcedureBean(ProcedureBean.Schema.OUT, Types.DECIMAL, outputKey));
		//2.调用函数获得结果
		result = getDataByProcedure(sql, procedureBeanList);
		return new BigDecimal(String.valueOf(result.containsKey(outputKey) ? result.get(outputKey) : "0"));
	}

	/**
	 * 同步现金钱包，用户余额、充值总额
	 *
	 * @throws Exception
	 */
	@Override
	public void saveBankRollBySync() throws Exception {
		String sql = "{call shopCustomerBankRollBalanceSync()}";          //准备执行事务的sql，其中 ? 占位符为 IN、 OUT 还是 INOUT 参数，取决于已储存过程
		//调用存储过程
		this.saveOrUpdateByProcedure(sql, null);
	}

	/**
	 * 同步现金钱包，用户总金币
	 *
	 * @throws Exception
	 */
	@Override
	public void saveBankRollMallCoinBySync() throws Exception {
		String sql = "{call shopCustomerBankRollMallCoinSync()}";          //准备执行事务的sql，其中 ? 占位符为 IN、 OUT 还是 INOUT 参数，取决于已储存过程
		//调用存储过程
		this.saveOrUpdateByProcedure(sql, null);
	}

	/**
	 * 删除过期的已同步的财务记录
	 *
	 * @param beforeSeconds 在...秒以前
	 * @throws Exception
	 */
	@Override
	public void deleteExpiredFinanceSynced(Integer beforeSeconds) throws Exception {
		String sql = "{call deleteExpiredFinanceSynced(?)}";          //准备执行事务的sql，其中 ? 占位符为 IN、 OUT 还是 INOUT 参数，取决于已储存过程

		List<ProcedureBean> procedureBeanList = new ArrayList<>();
		//1.按顺序在集合中 添加 输入参数
		procedureBeanList.add(new ProcedureBean(ProcedureBean.Schema.IN, beforeSeconds));
		//2.调用存储过程
		this.saveOrUpdateByProcedure(sql, procedureBeanList);
	}
}