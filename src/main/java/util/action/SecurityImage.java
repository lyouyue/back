package util.action;

/**
 * SecurityImage - 类描述信息
 * ============================================================================
 * 版权所有 2011 - 今 北京华宇盈通科技有限公司，并保留所有权利。
 * ----------------------------------------------------------------------------
 * 提示：在未取得SHOPJSP商业授权之前，您不能将本软件应用于商业用途，否则SHOPJSP将保留追究的权力。
 * ----------------------------------------------------------------------------
 * 官方网站：http://www.shopjsp.com
 * ============================================================================
 */

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

import com.sun.image.codec.jpeg.ImageFormatException;
import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

/**
 * 工具类，生成验证码图片
 * @version 1.0 2012/08/21
 * @author 
 *
 */
public class SecurityImage {
    
    /**
     * 生成验证码图片
     * @param securityCode   验证码字符
     * @return  BufferedImage  图片
     */
    public static BufferedImage createImage(String securityCode){
        
        //验证码长度
        int codeLength = securityCode.length();
        //字体大小
        int fontSizes = 20;
        //参考值
        int fSize = 16;
        int fWidth = fSize + 1;
        //图片宽度
        int width = codeLength * fWidth + 6 ;
        //图片高度
        int height = fSize * 2 -3;
        
        //图片
        BufferedImage image=new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics g=image.createGraphics();
        
        //设置背景色
        g.setColor(Color.WHITE);
        //填充背景
        g.fillRect(0, 0, width, height);
        //设置边框颜色
        //g.setColor(Color.WHITE);
        //边框字体样式
        //g.setFont(new Font("Arial", Font.BOLD, height - 2));
        //绘制边框
        //g.drawRect(0, 0, width - 1, height -1);
        //绘制噪点
        //Random rand = new Random();
        //设置噪点颜色
        /*g.setColor(Color.YELLOW);
        for(int i = 0;i < codeLength * 6;i++){
            int x = rand.nextInt(width);
            int y = rand.nextInt(height);
            //绘制1*1大小的矩形
            g.drawRect(x, y, 1, 1);
        }*/
        //绘制验证码
        int codeY = height - 10;
        //自定义随机颜色
        int randomColor = Integer.parseInt( String.valueOf(Math.random()).substring(2,10) );
        //设置字体颜色和样式
        g.setColor(new Color(randomColor));
        g.setFont(new Font("Arial", Font.BOLD, fontSizes));
        for(int i = 0; i < codeLength;i++){
            g.drawString(String.valueOf(securityCode.charAt(i)), i*12+15, codeY);
        }
        //关闭资源
        g.dispose();
        return image;
    }
    
    /**
     * 返回验证码图片的流格式
     * @param securityCode  验证码
     * @return ByteArrayInputStream 图片流
     */
    public static ByteArrayInputStream getImageAsInputStream(String securityCode){
        BufferedImage image = createImage(securityCode);
        return convertImageToStream(image);
    }
    
    /**
     * 将BufferedImage转换成ByteArrayInputStream
     * @param image  图片
     * @return ByteArrayInputStream 流
     */
    private static ByteArrayInputStream convertImageToStream(BufferedImage image){
        ByteArrayInputStream inputStream = null;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        JPEGImageEncoder jpeg = JPEGCodec.createJPEGEncoder(bos);
        try {
            jpeg.encode(image);
            byte[] bts = bos.toByteArray();
            inputStream = new ByteArrayInputStream(bts);
        } catch (ImageFormatException e) {
            //String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        } catch (IOException e) {
            //String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        }
        return inputStream;
    }
}

