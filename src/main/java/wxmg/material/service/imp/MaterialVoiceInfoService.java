package wxmg.material.service.imp;


import util.service.BaseService;
import wxmg.material.dao.IMaterialVoiceInfoDao;
import wxmg.material.pojo.MaterialVoiceInfo;
import wxmg.material.service.IMaterialVoiceInfoService;

/**业务层实现类*/
public class MaterialVoiceInfoService extends BaseService<MaterialVoiceInfo> implements IMaterialVoiceInfoService {
	 
	@SuppressWarnings("unused")
	/**数据访问层的实例*/
	private IMaterialVoiceInfoDao wxMaterialVoiceInfoDao;

	public void setWxMaterialVoiceInfoDao(
			IMaterialVoiceInfoDao wxMaterialVoiceInfoDao) {
		this.baseDao=this.wxMaterialVoiceInfoDao = wxMaterialVoiceInfoDao;
	}
  

}
