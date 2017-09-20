package basic.action;

import basic.pojo.*;
import basic.service.*;
import com.octo.captcha.service.CaptchaServiceException;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.json.FastJsonUtils;
import util.other.Utils;
import util.other.WebUtil;
import util.other.jcaptcha.CaptchaServiceSingleton;
import wxmg.publicNo.service.IPublicNoInfoService;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

public class BackLoginAction extends BaseAction{
	private static final long serialVersionUID = -6379968278881017462L;
	private IUsersService usersService;//管理员Service
	private IPurviewService purviewService;//权限Service
	private IUsersActorService usersActorService;//管理员角色Service
	private IActorPurviewService actorPurviewService;//角色权限Service
	@SuppressWarnings("unused")
	private IOPLogService opLogService;//操作日志Service
	private Users users;//管理员
	private String falseMsg;
	@SuppressWarnings("rawtypes")
	private Map<String,List> pruviewMap = new HashMap<String,List>();
	/**图片流**/
    private ByteArrayInputStream imageStream;
    private BufferedImage bufferedImage;
    /**微信基础信息Service**/
    private IPublicNoInfoService publicNoInfoService;
	/*统计类型集合*/
	private String statisticsType;

	Logger logger = Logger.getLogger(this.getClass());
    /***************************end********************************************/

    public String gotoLoginPage(){
    	return SUCCESS;
    }
    public String header(){
    	return SUCCESS;
    }
    public String footer(){
    	return SUCCESS;
    }
    public String left(){
    	return SUCCESS;
    }
    @SuppressWarnings({ "rawtypes", "unchecked" })
	public String welcome(){
		Map keybook = (Map)servletContext.getAttribute("keybook");
		List<KeyBook> statisticsTypeList= (List<KeyBook>)keybook.get("statisticsType");
		statisticsType = FastJsonUtils.toJSONString(statisticsTypeList);
    	return SUCCESS;
    }
	/**获取默认 宽度和长度的验证码**/
	public String userFirstLogin() throws IOException{
		//生成验证码图片bufferedImage
        bufferedImage = util.other.jcaptcha.ImageCaptcha.genernateCaptchaImage(request,response);
        //将图片转换成字节流进行传输
        imageStream = convertImageToStream(bufferedImage);
        //设置验证码的失效时间计时
        request.getSession().setAttribute("verificationInvalidationTime", System.currentTimeMillis());
		return SUCCESS;
	}
	/**
	 * 将BufferedImage转换成ByteArrayInputStream
	 * @param image  图片
	 * @return ByteArrayInputStream 流
	 */
	private static ByteArrayInputStream convertImageToStream(BufferedImage image){
		ByteArrayInputStream inputStream = null;
		   ByteArrayOutputStream bos = new ByteArrayOutputStream();
		   byte [] bimage=null;
		   try {
		ImageIO.write(image, "jpg", bos);
		bimage=bos.toByteArray();
		inputStream = new ByteArrayInputStream(bimage);
		} catch (IOException e) {
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return inputStream;
	}

	//验证用户是否存在和密码是否正确
	public void checkingUsers() throws Exception {
		String userName = request.getParameter("userName");//管理员名称
		String password = request.getParameter("password");//密码
		String verificationCode = request.getParameter("verificationCode");//前台传递的验证码
		String captchaID = request.getSession().getId();//获取当前的sessionID
		//参数代表验证码是否输入正确，默认false用户输入不正确，true表示输入正确
		Boolean validateResponseForID = false;
		try {
			validateResponseForID = CaptchaServiceSingleton.getInstance().validateResponseForID(captchaID, verificationCode);
		}catch (CaptchaServiceException cse){
			logger.error("后台登录验证码Exception:"+cse);
		}
		//获取验证码的失效时间计时
		long verificationInvalidationTime = Long.parseLong(String.valueOf(request.getSession().getAttribute("verificationInvalidationTime")));
		String isExsit="0";//0默认，1:用户名或者密码错误，2验证码错误,3:验证码失效
		//获取失效时间，单位毫秒
		long sessionVerificationInvalidationTime =  Long.parseLong( String.valueOf(getFileUrlConfig().get("session_verificationInvalidationTime")) );
		//判断验证码状态，判断验证码时间是否超时
		if(((System.currentTimeMillis() - verificationInvalidationTime) > sessionVerificationInvalidationTime)){
			isExsit="3";
		}else if(validateResponseForID){
			//对用户登录做防sql注入处理使用占位符的查询方法
			Map<Object,Object> map=new HashMap<Object,Object>();
			map.put("userName", userName);
			map.put("password", password);
			users = (Users) usersService.findObjectByParamsMap(null, " where o.userName=:userName and o.password=:password ", map);
			if(users==null){
				isExsit="1";
			}else if(users.getLockState()==1){
				isExsit="4";
			}else{
				request.getSession().setAttribute("users", users);
				String Ip=WebUtil.getVisitorIP(request);
				request.getSession().setAttribute("userIp", Ip);
				SimpleDateFormat fmt = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());//格式大小写有区别
				String updateTime = fmt.format(new Date());
				request.getSession().setAttribute("time", updateTime);
				//删除服务器上保存的刷新时间
				request.getSession().removeAttribute("verificationInvalidationTime");

				//保存登录日志
				//opLogService.saveOplog(userName, Ip, "用户登录", "");
			}
		}else{
			isExsit="2";
		}
		JSONObject jo=new JSONObject();
		jo.accumulate("isExsit", isExsit);
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter pw=response.getWriter();
		pw.print(jo.toString());
		pw.flush();
		pw.close();
	}
	//后台管理员登录查询管理员权限
	/**
	 * 将已经选中的模块权限下对应的功能权限按照指定的规则进行组装
	 * 组装规则为map<purviewId_functionValue,functionValue>
	 * @param actorPurviewList
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void joinFunctions(List <ActorPurview> actorPurviewList) {
		Map functionsMap=(Map)session.getAttribute("functionsMap");
		if(functionsMap==null){
			functionsMap = new HashMap<String, String>();
		}
		//按照指定的规则进行功能权限的组装
		for (ActorPurview ap : actorPurviewList) {
			String functions=ap.getFunctions();
			if(functions!=null){
				String [] functionsArray=functions.split(",");
				if(functionsArray!=null&&functionsArray.length>0){
					for(String function:functionsArray){
						if (Utils.objectIsNotEmpty(function) && function != null && !"".equals(function)) {
							String[] functionInfos = function.split("_");
							if (Utils.objectIsNotEmpty(functionInfos) && functionInfos.length > 2) {
								String purviewId = functionInfos[0];
								String functionValue = functionInfos[2];
								functionsMap.put(purviewId + "_" + functionValue, functionValue);
							}
						}
					}
				}
			}
		}
		session.setAttribute("functionsMap", functionsMap);
	}

	// 后台管理员登录查询管理员权限
	@SuppressWarnings("unchecked")
	public String userLogin() {
		List<Purview> purviewList = new ArrayList<Purview>();
		users = (Users) request.getSession().getAttribute("users");
		List <UsersActor> usersActorList = usersActorService.findObjects(null, " where o.usersId='" + users.getUsersId() + "'");
		for (UsersActor ua : usersActorList) {
			List<ActorPurview> actorPurviewList = actorPurviewService.findObjects(null, " where o.actorId='" + ua.getActorId() + "'");
			for (ActorPurview ap : actorPurviewList) {
				Purview purview = (Purview) purviewService.getObjectByParams(" where o.purviewId='" + ap.getPurviewId() + "'");
				if (purview != null && purview.getParentId() != 0) {
					if (purviewList == null || purviewList.size() == 0) {
						purviewList.add(purview);
					} else {
						boolean flag = true;
						for (Purview p : purviewList) {
							if (p.getPurviewId().intValue() == purview.getPurviewId().intValue()) {
								flag = false;
								break;
							}
						}
						if (flag) {
							purviewList.add(purview);
						}
					}
				}
			}
			// 将已经选中的模块权限下对应的功能权限按照指定的规则进行组装
			joinFunctions(actorPurviewList);
		}
		String subPurviewIds="";
		// 查询去重以后的所有权限，根据父子关系放到Map中
		Map<String,Object> leftMap = new HashMap<String,Object>();
		int i=0;
		if(Utils.collectionIsNotEmpty(purviewList)){
			for (Purview p : purviewList) {
				List<Purview> list = new ArrayList<Purview>();
				if (p.getParentId().intValue() == 1) {
					for (Purview sp : purviewList) {
						if (sp.getParentId().intValue() == p.getPurviewId().intValue()) {
							list.add(sp);
						}
					}
					subPurviewIds+=p.getPurviewId()+",";
					if(i==0){
						leftMap.put(p.getPurviewName(), list);
						i++;
					}
				}
			}
			//查询导航栏权限
			if(!"".equals(subPurviewIds)){
				subPurviewIds=subPurviewIds.substring(0, subPurviewIds.lastIndexOf(","));
				List<Purview> subpurviewList=purviewService.findObjects(" where o.purviewId in ( "+subPurviewIds+" ) order by o.sortCode");
				session.setAttribute("purviewNameList", subpurviewList);
			}
			//设置左侧菜单默认展示第一个一级权限菜单
			request.setAttribute("purviewId", purviewList.get(0).getPurviewId());
		}
		session.setAttribute("users", users);
		session.setAttribute("map", leftMap);
		Map<?,?> pMap = (Map<?,?>)servletContext.getAttribute("accessTokens");
		if(Utils.objectIsEmpty(pMap)){
			publicNoInfoService.accessTokenInit();
		}
		return SUCCESS;
	}

	//查询单个权限
	public String selectPurview() throws UnsupportedEncodingException{
		//声明一个自定义类集合
		String id = request.getParameter("id");
		if(Utils.stringIsNotEmpty(id)){
			List<PurviewBean> purviewBeanList = new ArrayList<PurviewBean>();
			users = (Users)request.getSession().getAttribute("users");
			String pvIds=findActorPurview(users);//获取用户所有角色的权限
			Purview purview = (Purview) purviewService.getObjectByParams(" where o.purviewId='"+id+"' order by o.sortCode");
			List<Purview> list = purviewService.findObjects(" where o.parentId="+purview.getPurviewId()+" and o.purviewId in("+pvIds+") order by o.sortCode");
			String s = "0";//多层级的
			session.removeAttribute("map");
			pruviewMap.clear();
			if(list!=null&&list.size()>0){
				for(Purview p : list){
					List<Purview> findObjects = purviewService.findObjects(" where o.parentId="+p.getPurviewId()+" and o.purviewId in("+pvIds+") order by o.sortCode");
					if(findObjects!=null&&findObjects.size()>0){
						s = "1";
						PurviewBean pb = new PurviewBean();
						pb.setPurviewName(p.getPurviewName());
						pb.setPurviewList(findObjects);
						purviewBeanList.add(pb);
					}
				}
			}
			if("0".equals(s)){//不带层级的
				PurviewBean pb = new PurviewBean();
				pb.setPurviewName(purview.getPurviewName());
				pb.setPurviewList(list);
				purviewBeanList.add(pb);
			}
			session.setAttribute("map", purviewBeanList);
			request.getSession().setAttribute("name", purview.getPurviewName());
		}
		return SUCCESS;
	}


	/***
	 * 查找用户角色的所有权限
	 * @return
	 */
	public String findActorPurview(Users users){
		Set<Integer> empSet=new HashSet<Integer>();
		//查用户拥有的角色
		List<UsersActor> usersActorList = usersActorService.findObjects(" where o.usersId='"+users.getUsersId()+"'");
		//查询用户拥有角色对应的权限
		for(UsersActor ua : usersActorList){
			List<ActorPurview> actorPurviewList = actorPurviewService.findObjects(" where o.actorId="+ua.getActorId());
			for(ActorPurview ap : actorPurviewList){
				empSet.add(ap.getPurviewId());
			}
		}
		String pvIds="";
		Iterator<Integer> iterator = empSet.iterator();
		while(iterator.hasNext()){
			Integer next = iterator.next();
			pvIds+=next+",";
		}
		if(!"".equals(pvIds)){
			pvIds=pvIds.substring(0, pvIds.lastIndexOf(","));
		}
		return pvIds;
	}
	//用户退出操作
	public String goToExit(){
		//清空session数据
		session.invalidate();
		return SUCCESS;
	}
	//临时更新sessiong用户信息操作
	@SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	public void updateAdminInfo() throws IOException{
		//清空session数据
		session.removeAttribute("functionsMap");
		users = (Users)usersService.getObjectByParams(" where o.userName='admin' and o.password='admin'");
		Map<String, List<Purview>> map = new HashMap<String, List<Purview>>();
		List<Purview> purviewList = new ArrayList<Purview>();
		List <UsersActor> usersActorList = usersActorService.findObjects(null, " where o.usersId='" + users.getUsersId() + "'");
		for (UsersActor ua : usersActorList) {
			List<ActorPurview> actorPurviewList = actorPurviewService.findObjects(null, " where o.actorId='" + ua.getActorId() + "'");
			for (ActorPurview ap : actorPurviewList) {
				Purview purview = (Purview) purviewService.getObjectByParams(" where o.purviewId='" + ap.getPurviewId() + "'");
				if (purview != null && purview.getParentId() != 0) {
					if (purviewList == null || purviewList.size() == 0) {
						purviewList.add(purview);
					} else {
						boolean flag = true;
						for (Purview p : purviewList) {
							if (p.getPurviewId().intValue() == purview.getPurviewId().intValue()) {
								flag = false;
								break;
							}
						}
						if (flag) {
							purviewList.add(purview);
						}
					}
				}
			}
			// 将已经选中的模块权限下对应的功能权限按照指定的规则进行组装
			Map functionsMap= new HashMap<String, String>();
			//按照指定的规则进行功能权限的组装
			for (ActorPurview ap : actorPurviewList) {
				String functions=ap.getFunctions();
				if(functions!=null){
					String [] functionsArray=functions.split(",");
					if(functionsArray!=null&&functionsArray.length>0){
						for(String function:functionsArray){
							String [] functionInfos=function.split("_");
							String purviewId=functionInfos[0];
							String functionValue=functionInfos[2];
							functionsMap.put(purviewId+"_"+functionValue, functionValue);
						}
					}
				}
			}
			session.setAttribute("functionsMap", functionsMap);
		}
		JSONObject jo=new JSONObject();
		jo.accumulate("isSuccess", "true");
		PrintWriter out=response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public Users getUsers() {
		return users;
	}
	public void setUsers(Users users) {
		this.users = users;
	}
	public void setUsersService(IUsersService usersService) {
		this.usersService = usersService;
	}
	public void setPurviewService(IPurviewService purviewService) {
		this.purviewService = purviewService;
	}
	public void setUsersActorService(IUsersActorService usersActorService) {
		this.usersActorService = usersActorService;
	}
	public void setActorPurviewService(IActorPurviewService actorPurviewService) {
		this.actorPurviewService = actorPurviewService;
	}
	@SuppressWarnings("rawtypes")
	public Map<String, List> getPruviewMap() {
		return pruviewMap;
	}
	@SuppressWarnings("rawtypes")
	public void setPruviewMap(Map<String, List> pruviewMap) {
		this.pruviewMap = pruviewMap;
	}
	public String getFalseMsg() {
		return falseMsg;
	}
	public void setFalseMsg(String falseMsg) {
		this.falseMsg = falseMsg;
	}
	public ByteArrayInputStream getImageStream() {
		return imageStream;
	}
	public void setImageStream(ByteArrayInputStream imageStream) {
		this.imageStream = imageStream;
	}
	public BufferedImage getBufferedImage() {
		return bufferedImage;
	}
	public void setBufferedImage(BufferedImage bufferedImage) {
		this.bufferedImage = bufferedImage;
	}
	public void setPublicNoInfoService(IPublicNoInfoService publicNoInfoService) {
		this.publicNoInfoService = publicNoInfoService;
	}

	public void setOpLogService(IOPLogService opLogService) {
		this.opLogService = opLogService;
	}

	public String getStatisticsType() {
		return statisticsType;
	}

	public void setStatisticsType(String statisticsType) {
		this.statisticsType = statisticsType;
	}
}
