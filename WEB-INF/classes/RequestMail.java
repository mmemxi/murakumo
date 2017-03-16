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
	//	���[�����M�֌W�̒萔�錾
	static final String MailProtocol="smtp";											//	���M�v���g�R��
	static final String MailPort="587";													//	���M�|�[�g

	//	TLS�ڑ��̎w��
	static final String TLS_Auth="true";
	static final String TLS_Enable="true";
	static final String TLS_Required="true";

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
		{
		//	�ϐ��錾
		String Eusername;
		String Egroupname;
		String Eposition;
		String Email;
		String Esubject;
		String Ebody;
		String Hbody;
		Boolean SendError;

		//	���[�����M�ݒ�(config.txt���擾)
		String MailFrom="info@marketing-jp.info";							//	���M�����[���A�h���X
		String MailTo="mmemxi@yahoo.co.jp";									//	���M�惁�[���A�h���X
		String MailServer="email-smtp.us-east-1.amazonaws.com";				//	���[���T�[�o�[��
		String MailUser="AKIAI7LZXPO2CI2MAA2Q";								//	���[�����[�U�[��
		String MailPassword="AsEAShL//yyFbCdmrwvtcRayMhPvNsnLVwtGZdSYnH5j";	//	���[���p�X���[�h

		//(1)�G���R�[�h�����̎w��
		response.setContentType("text/html; charset=UTF-8");

		//(2)�p�����[�^�̃G���R�[�h�����̎w��
		request.setCharacterEncoding("UTF-8");

		//(3)�p�����[�^�̎擾
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

		//(4)�{���̍쐬
		Hbody="�����O�܂��͉�Ж��F"+Eusername+"\n�������F"+Egroupname+"\n��E���F"+Eposition+"\n���[���A�h���X�F"+Email+"\n�{���F\n"+Ebody;

		//(5)���M�����J�n
		SendError=false;
		try	{
			// �v���p�e�B�̐ݒ�
			Properties props = System.getProperties();
			props.put("mail.transport.protocol",MailProtocol);
			props.put("mail.smtp.port",MailPort);
			props.put("mail.smtp.auth",TLS_Auth);
			props.put("mail.smtp.starttls.enable",TLS_Enable);
			props.put("mail.smtp.starttls.required",TLS_Required);

			// �Z�b�V�����̎擾
			Session session = Session.getInstance(props);

			// MimeMessage�̎擾�Ɛݒ�
			Message msg = new MimeMessage(session);
			msg.setFrom(new InternetAddress(MailFrom));
			msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(MailTo, false));
			msg.setSubject(Esubject);
			msg.setText(Hbody);
			msg.setSentDate(new Date());

			// ���M
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
	
		//(6)�������ʃy�[�W�փ��_�C���N�g
		if (SendError)
			{
			response.sendRedirect("index.jsp?mode=maildoneNG");
			}
		else{
			response.sendRedirect("index.jsp?mode=maildoneOK");
			}
		}
	}

