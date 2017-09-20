package util.note.aliyun;

import java.io.IOException;
import java.io.PrintWriter;
import net.sf.json.JSONObject;
import util.action.BaseAction;
import util.action.SecurityCode;
import util.action.SecurityCode.SecurityCodeLevel;

import com.taobao.api.ApiException;
import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;

/**   
 * @作用：
 * @功能：
 * @作者:cq
 * @日期：2016年10月28日 下午3:38:55 
 * @版本：V1.0   
 */
@SuppressWarnings("serial")
public class ALiYunSms extends BaseAction{

	//传递手机号
	private String mobilePhone;
	//全局的
	private static final String ACCESS_CONTROL_ALLOW_ORIGIN="*";
	
	//aliyun  发送短信
	public void AliYunSendMsg() throws ApiException, IOException{
		JSONObject jo = new JSONObject();
			//生成验证码
			String securityCode = SecurityCode.getSecurityCode(6, SecurityCodeLevel.Simple, true);
		String url=String.valueOf(getFileUrlConfig().get("aliyun_url"));
		String extend=String.valueOf(getFileUrlConfig().get("extend"));
		String aliyun_sms_free_sign_name=String.valueOf(getFileUrlConfig().get("aliyun_sms_free_sign_name"));
		String aliyun_sms_type=String.valueOf(getFileUrlConfig().get("aliyun_sms_type"));
		String aliyun_appsecret=String.valueOf(getFileUrlConfig().get("aliyun_appsecret"));
		String aliyun_AppKey=String.valueOf(getFileUrlConfig().get("aliyun_AppKey"));
		String yunSDK_template=String.valueOf(getFileUrlConfig().get("sms_template_code"));
		TaobaoClient client = new DefaultTaobaoClient(url, aliyun_AppKey,aliyun_appsecret);
		AlibabaAliqinFcSmsNumSendRequest req = new AlibabaAliqinFcSmsNumSendRequest();
		req.setExtend(extend);
		req.setSmsType(aliyun_sms_type);
		req.setSmsFreeSignName(aliyun_sms_free_sign_name);
		req.setSmsParamString("{\"code\": '"+securityCode+"'}");
		req.setRecNum(mobilePhone);
		req.setSmsTemplateCode(yunSDK_template);
		AlibabaAliqinFcSmsNumSendResponse rsp = client.execute(req);
		System.out.println("发送结果"+rsp.getBody());
		//回传生成的验证码
		jo.accumulate("securityCode", securityCode);
		response.setContentType("text/html;charset=utf-8");
		response.setHeader("Access-Control-Allow-Origin", ACCESS_CONTROL_ALLOW_ORIGIN);
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}
}
