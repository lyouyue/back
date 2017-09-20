package basic.service;
import util.service.IBaseService;
import basic.pojo.OPLog;
/**
 * 操作日志记录Service接口
 * @author LQS
 *
 */
public interface IOPLogService  extends IBaseService <OPLog> {

    /**
     * 保存管理员的登录日志
     * @param userTrueName 管理员名字
     * @param ip    访问者IP
     * @param opDesc 操作简介
     * @param opParams 操作参数
     * @throws Exception
     */
    public void saveOplog(String userTrueName, String ip, String opDesc, String opParams) throws Exception;
}
