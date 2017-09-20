package wxmg.material.service.imp;

import util.service.BaseService;
import wxmg.material.dao.IMaterialImageTxtInfoDao;
import wxmg.material.pojo.MaterialImageTxtInfo;
import wxmg.material.service.IMaterialImageTxtInfoService;

/**
 * 素材图文接口实现类
 * @author 李续
 * 
 */
public class MaterialImageTxtInfoService extends BaseService<MaterialImageTxtInfo> implements IMaterialImageTxtInfoService {
	@SuppressWarnings("unused")
	private IMaterialImageTxtInfoDao materialImageTxtInfoDao;

	public void setMaterialImageTxtInfoDao(IMaterialImageTxtInfoDao materialImageTxtInfoDao) {
		this.baseDao = this.materialImageTxtInfoDao = materialImageTxtInfoDao;
	}

}
