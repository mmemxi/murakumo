import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import com.sun.mail.smtp.*;
import java.io.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RequestMail extends HttpServlet
	{
	//	メール送信関係の定数宣言
	static final String MailProtocol="smtp";											//	送信プロトコル
	static final String MailPort="587";													//	送信ポート

	//	TLS接続の指定
	static final String TLS_Auth="true";
	static final String TLS_Enable="true";
	static final String TLS_Required="true";

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
		{
		//	変数宣言
		String Eusername;
		String Egroupname;
		String Eposition;
		String Email;
		String Esubject;
		String Ebody;
		String Hbody;
		Boolean SendError;

		//	メール送信設定(config.txtより取得)
		String MailFrom="info@marketing-jp.info";							//	送信元メールアドレス
		String MailTo="mmemxi@yahoo.co.jp";									//	送信先メールアドレス
		String MailServer="email-smtp.us-east-1.amazonaws.com";				//	メールサーバー名
		String MailUser="AKIAI7LZXPO2CI2MAA2Q";								//	メールユーザー名
		String MailPassword="AsEAShL//yyFbCdmrwvtcRayMhPvNsnLVwtGZdSYnH5j";	//	メールパスワード

		//(1)エンコード方式の指定
		response.setContentType("text/html; charset=UTF-8");

		//(2)パラメータのエンコード方式の指定
		request.setCharacterEncoding("UTF-8");

		//(3)パラメータの取得
		Eusername=request.getParameter("Eusername");
		Egroupname=request.getParameter("Egroupname");
		Eposition=request.getParameter("Eposition");
		Email=request.getParameter("Email");
		Esubject=request.getParameter("Esubject");
		Ebody=request.getParameter("Ebody");
		MailFrom=request.getParameter("MailFrom");
		MailTo=request.getParameter("MailTo");
		MailServer=request.getParameter("MailServer");
		MailUser=request.getParameter("MailUser");
		MailPassword=request.getParameter("MailPassword");

		//(4)本文の作成
		Hbody="お名前または会社名："+Eusername+"\n部署名："+Egroupname+"\n役職名："+Eposition+"\nメールアドレス："+Email+"\n本文：\n"+Ebody;

		//(5)送信処理開始
		SendError=false;
		try	{
			// プロパティの設定
			Properties props = System.getProperties();
			props.put("mail.transport.protocol",MailProtocol);
			props.put("mail.smtp.port",MailPort);
			props.put("mail.smtp.auth",TLS_Auth);
			props.put("mail.smtp.starttls.enable",TLS_Enable);
			props.put("mail.smtp.starttls.required",TLS_Required);

			// セッションの取得
			Session session = Session.getInstance(props);

			// MimeMessageの取得と設定
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress(MailFrom));
			msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(MailTo, false));
			msg.setSubject(Esubject);
			msg.setText(Hbody);
			msg.setSentDate(new Date());

			// 送信
			SMTPTransport t = (SMTPTransport) session.getTransport("smtp");
			try	{
				t.connect(MailServer,MailUser,MailPassword);
				t.sendMessage(msg, msg.getAllRecipients());
				}
			finally
				{
				t.close();
				}
			}
		catch (Exception e)
			{
			SendError=true;
			e.printStackTrace();
			}
	
		//(6)処理結果ページへリダイレクト
		if (SendError)
			{
			response.sendRedirect("index.jsp?mode=maildoneNG");
			}
		else{
			response.sendRedirect("index.jsp?mode=maildoneOK");
			}
		}
	}

