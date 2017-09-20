package wxmg.material.service.imp;


import util.service.BaseService;
import wxmg.material.dao.IMaterialVideoInfoDao;
import wxmg.material.pojo.MaterialVideoInfo;
import wxmg.material.service.IMaterialVideoInfoService;

public class MaterialVideoInfoService extends BaseService<MaterialVideoInfo> implements IMaterialVideoInfoService {
  
	@SuppressWarnings("unused")
	private IMaterialVideoInfoDao wxMaterialVideoInfoDao;
	public void setWxMaterialVideoInfoDao(
			IMaterialVideoInfoDao wxMaterialVideoInfoDao) {
		this.baseDao=this.wxMaterialVideoInfoDao = wxMaterialVideoInfoDao;
	}



}
