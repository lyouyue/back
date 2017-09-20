package wxmg.util.wx;

import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Date;
import java.util.Map;

import javax.swing.ImageIcon;

import org.apache.log4j.Logger;

import util.other.Utils;
import util.upload.FileTypeUtil;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

public class CreateQrVisitingCard {
	/**
	 * 日志
	 */
	public Logger logger = Logger.getLogger(this.getClass());
	BufferedImage image;
	void createImage(String fileLocation) {
		try {
			FileOutputStream fos = new FileOutputStream(fileLocation);
			BufferedOutputStream bos = new BufferedOutputStream(fos);
			JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(bos);
			encoder.encode(image);
			bos.close();
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}

	/**
	 * 
	 * @param customerId 用户ID
	 * @param photoUrl	头像地址
	 * @param token   
	 * @param fileUrlConfig
	 * @param name  昵称
	 * @param content 内容
	 * @param ticktType 二维码类型 1 临时 2 永久
	 * @return
	 * @throws IOException
	 * @throws Exception
	 */
	public String createQrVisitingCard(String customerId,String photoUrl,String token, Map<Object,Object> fileUrlConfig,String name,String content,int ticktType) throws IOException, Exception {
		String imgurl = (String) fileUrlConfig.get("qrBaseImage");
		// 改成这样:
		BufferedImage bimg = null;
		try {
			bimg = javax.imageio.ImageIO.read(new java.io.File(imgurl));
		} catch (Exception e) {}
		int imageWidth = bimg.getWidth();// 图片的宽度
		int imageHeight = bimg.getHeight();// 图片的高度
		image = new BufferedImage(imageWidth, imageHeight,BufferedImage.TYPE_INT_RGB);
		Graphics2D graphics = (Graphics2D) image.getGraphics();
		graphics.setColor(Color.BLACK);
		graphics.fillRect(0, 0, imageWidth, imageHeight);
		if (bimg != null)
		graphics.drawImage(bimg, 0, 0, null);
		graphics.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
		graphics.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        String ticket = WXBasicUtil.getTicket(token,customerId,ticktType);
        if(Utils.objectIsEmpty(photoUrl)){
        	photoUrl = String.valueOf(fileUrlConfig.get("website_weixin"));
        }
		ImageIcon photoIcon = new ImageIcon(photoUrl);
		ImageIcon imageIcon = new ImageIcon(download(ticket,2));
		int photoIndexX = imageWidth/2-167/2-5;
		graphics.drawImage(makeRoundedCorner(photoIcon.getImage()), photoIndexX,32,photoIndexX+167,199,0,0,167,167,null);
		graphics.drawImage(imageIcon.getImage(),229,377,391,538,0,0,imageIcon.getIconWidth(),imageIcon.getIconHeight(), null);
		Font f = new Font("黑体", Font.BOLD, 36);
		graphics.setFont(f);
		FontMetrics fm = graphics.getFontMetrics(f);//font为你所使用的字体
		if(name==null){
			name = String.valueOf(fileUrlConfig.get("website_wxName"));
		}
		int stringWidth = fm.stringWidth(name);
		graphics.drawString(name,imageWidth/2-stringWidth/2,252);
//		graphics.setColor(Color.WHITE);
//		graphics.setBackground(Color.WHITE);
//		graphics.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
//		graphics.drawString("我是"+name, 223, 149);
		Font font = new Font("黑体", Font.BOLD, 26);
		graphics.setFont(font);
		FontMetrics fms = graphics.getFontMetrics(f); //font为你所使用的字体
		int stringWidths = fms.stringWidth(content);
		graphics.drawString(content,imageWidth/2-stringWidths/2+50,290);
		//graphics.drawString(content,223,183); 
		graphics.dispose();
		String savePath = "/"+fileUrlConfig.get("wx")+"/"+fileUrlConfig.get("image_QRCode")+"/"+FileTypeUtil.getSerial(new Date(), fileUrlConfig.get("fileRule"))+"/"+customerId+"/wx.jpg";
		String filePath = fileUrlConfig.get("fileUploadRoot")+savePath;
		File file = new File(fileUrlConfig.get("fileUploadRoot")+"/"+fileUrlConfig.get("wx")+"/"+fileUrlConfig.get("image_QRCode")+"/"+FileTypeUtil.getSerial(new Date(), fileUrlConfig.get("fileRule"))+"/"+customerId);
		if(!file.exists()){
			file.mkdirs();
		}
		createImage(filePath);
		return savePath;
	}
	
	
	public static BufferedImage makeRoundedCorner(Image image) {
		int w=167;
		int h=167;
		BufferedImage output = new BufferedImage(w, h,BufferedImage.TYPE_INT_ARGB);
		Graphics2D g2 = output.createGraphics();
		g2.setComposite(AlphaComposite.Src);
		g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,RenderingHints.VALUE_ANTIALIAS_ON);
		g2.setColor(Color.WHITE);
		g2.fill(new RoundRectangle2D.Float(0, 0, w, h, w,w));
		g2.setComposite(AlphaComposite.SrcAtop);
		g2.drawImage(image, 0, 0,w,h,0,0,image.getWidth(null),image.getHeight(null), null);
		g2.dispose();
		return output;
	}
	
	
	public  byte[]  download(String ticket,int type) throws Exception {  
		InputStream in = null;
		try {
			String tokenURL = "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=" + ticket;
			if(type==1){
				tokenURL = ticket;
			}
			URL realUrl = new URL(tokenURL);
			HttpURLConnection conn = (HttpURLConnection) realUrl.openConnection();
			// 连接超时
			conn.setConnectTimeout(25000);
			// 读取超时 --服务器响应比较慢，增大时间
			conn.setReadTimeout(25000);
			HttpURLConnection.setFollowRedirects(true);
			// 请求方式
			conn.setRequestMethod("GET");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:21.0) Gecko/20100101 Firefox/21.0");
			conn.setRequestProperty("Referer", "https://api.weixin.qq.com/");
			conn.connect();
			// 获取URLConnection对象对应的输出流
			in = conn.getInputStream();
			byte[] btImg = readInputStream(in);//得到图片的二进制数据  
			if (conn != null) {
				// 关闭连接
				conn.disconnect();
			}
			return btImg;
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return null;
    }
	/** 
     * 从输入流中获取数据 
     * @param inStream 输入流 
     * @return 
     * @throws Exception 
     */  
    public byte[] readInputStream(InputStream inStream) throws Exception{  
        ByteArrayOutputStream outStream = new ByteArrayOutputStream();  
        byte[] buffer = new byte[1024];  
        int len = 0;  
        while( (len=inStream.read(buffer)) != -1 ){  
            outStream.write(buffer, 0, len);  
        }  
        inStream.close();  
        return outStream.toByteArray();  
    }  
}
