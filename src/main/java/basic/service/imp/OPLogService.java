package basic.service.imp;
import util.service.BaseService;
import basic.dao.IOPLogDao;
import basic.pojo.OPLog;
import basic.service.IOPLogService;

import java.util.Date;

/**
 * 操作日志记录Service接口实现类
 *
 * @author LQS
 *
 */
public class OPLogService extends BaseService  <OPLog> implements IOPLogService {
	@SuppressWarnings("unused")
	private IOPLogDao opLogDao;
	public void setOpLogDao(IOPLogDao opLogDao) {
		this.baseDao =this.opLogDao = opLogDao;
	}

	/**
	 * 保存管理员的登录日志
	 *
	 * @param userTrueName 管理员名字
	 * @param ip           访问者IP
	 * @param opDesc       操作简介
	 * @param opParams     操作参数
	 * @throws Exception
	 */
	@Override
	public void saveOplog(String userTrueName, String ip, String opDesc, String opParams) throws Exception {
		OPLog opLog = new OPLog();
		opLog.setOpDate(new Date());
		opLog.setUserTrueName(userTrueName);
		opLog.setIp(ip);
		opLog.setOpDesc(opDesc);
		opLog.setOpParams(opParams);
		opLogDao.saveObject(opLog);
	}
}
