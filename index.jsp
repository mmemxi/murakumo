<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.io.*" import="java.net.URLDecoder" import="java.util.*" %>
<%
// 引数の受け取り-----------------------------------------
request.setCharacterEncoding("UTF-8");
String Targetpage=request.getParameter("p");
String Targetym=request.getParameter("ym");
String Targetsearch=request.getParameter("search");
String Targetcat=request.getParameter("cat");
String Targetmode=request.getParameter("mode");
if (Targetpage == null){Targetpage="";}
if (Targetym == null){Targetym="";}
if (Targetcat == null){Targetcat="";}
if (Targetsearch == null){Targetsearch="";}
if (Targetmode == null){Targetmode="";}

// メールフォーム項目の受け取り---------------------------
String Eusername=request.getParameter("Eusername");
String Egroupname=request.getParameter("Egroupname");
String Eposition=request.getParameter("Eposition");
String Email=request.getParameter("Email");
String Esubject=request.getParameter("Esubject");
String Ebody=request.getParameter("Ebody");

// 基準URLの取得(=basepath)-------------------------------
String baseURL=request.getRequestURL().toString();
baseURL=baseURL.replace("index.jsp","");
String basepath=request.getRealPath("/")+request.getServletPath();
basepath=basepath.replace("index.jsp","");
basepath=basepath.replace("//","/");
%>
<!DOCTYPE html>
<!--[if IE 7]>
<html class="ie ie7" dir="ltr" lang="ja">
<![endif]-->
<!--[if IE 8]>
<html class="ie ie8" dir="ltr" lang="ja">
<![endif]-->
<!--[if !(IE 7) | !(IE 8)  ]><!-->
<html dir="ltr" lang="ja">
<!--<![endif]-->

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width" />

<%!
//--------------------------------------------
// グローバル変数
//--------------------------------------------
public int Articles=0;
public String[] ArticleFile;
public String[] ArticleTitle;
public String[] ArticleCategory;
public String[] ArticleDescription;
public String[] ArticleKeywords;
public HashMap CategoryHash;
public HashMap DescriptionHash;
public HashMap KeywordsHash;
//--------------------------------------------
// Config.txtから取得する内容
//--------------------------------------------
public String[] ConfigTable;
//--------------------------------------------
// タイトルの取得 
//--------------------------------------------
public String GetTitle(String key)
	{
	int i=0;
	String result;
	result="";
	for(i=0;i<Articles;i++)
		{
		if (ArticleFile[i].equals(key))
			{
			result=ArticleTitle[i];
			break;
			}
		}
	return result;
	}
//--------------------------------------------
// 見出し情報の取得
//--------------------------------------------
public void ReadIndex(String basepath)
	{
	String buf="";
	String str="";
	String str1="";
	String str2="";
	String str3="";
	String filedate="";
	String sbuf="";
	int fileseq=0;
	String ymd="";
	int yyyy=0;
	int mm=0;
	int dd=0;
	int i=0;
	int j=0;

	String inputFileName = basepath + "article/index.txt";
	String seoFileName = basepath + "article/seo.txt";
	String configFileName = basepath + "article/config.txt";

	String[] RTB=new String[8];
	BufferedReader bufFileData;

	// インデックス情報の読み込み
	Articles=0;
	try	{
		File inputFile = new File(inputFileName);
		FileInputStream fis = new FileInputStream(inputFile);
		InputStreamReader isr = new InputStreamReader(fis,"Windows-31J");
		bufFileData = new BufferedReader(isr);	
		while ((str=bufFileData.readLine()) != null)
			{
			buf+=str+"\r\n";
			Articles++;
			}
		bufFileData.close();
		}
	catch(FileNotFoundException e)
		{
		buf="";
		}
	catch(IOException e)
		{
		buf="";
		}
	if (Articles==0) return;

	str="";
	String[] TBL=buf.split("\r\n");
	ArticleFile=new String[Articles];
	ArticleTitle=new String[Articles];
	ArticleCategory=new String[Articles];
	ArticleDescription=new String[Articles];
	ArticleKeywords=new String[Articles];
	CategoryHash=new HashMap();

	for(i=0;i<Articles;i++)
		{
		sbuf=TBL[i]+"\tnodata\tnodata\tnodata";
		RTB=sbuf.split("\t");
		sbuf=RTB[4];
		ArticleFile[i]=RTB[0]+"-"+RTB[1];
		ArticleTitle[i]=RTB[3];
		ArticleDescription[i]=RTB[4];
		ArticleCategory[i]=RTB[2];
		ArticleKeywords[i]=RTB[5];
		if (CategoryHash.containsKey(RTB[2]))
			{
			j=Integer.parseInt(String.valueOf(CategoryHash.get(RTB[2])),10);
			}
		else j=0;
		j++;
		CategoryHash.put(RTB[2],String.valueOf(j));
		}

	// SEO情報の読み込み
	buf="";
	i=0;
	try	{
		File inputFile = new File(seoFileName);
		FileInputStream fis = new FileInputStream(inputFile);
		InputStreamReader isr = new InputStreamReader(fis,"Windows-31J");
		bufFileData = new BufferedReader(isr);	
		while ((str=bufFileData.readLine()) != null)
			{
			buf+=str+"\r\n";
			i++;
			}
		bufFileData.close();
		}
	catch(FileNotFoundException e)
		{
		buf="";
		}
	catch(IOException e)
		{
		buf="";
		}
	str="";
	TBL=buf.split("\r\n");
	DescriptionHash=new HashMap();
	KeywordsHash=new HashMap();

	for(j=0;j<i;j++)
		{
		RTB=TBL[j].split("\t");
		if (RTB[0].equals("")) continue;
		if (!(DescriptionHash.containsKey(RTB[0])))
			{
			DescriptionHash.put(RTB[0],RTB[1]);
			}
		if (!(KeywordsHash.containsKey(RTB[0])))
			{
			KeywordsHash.put(RTB[0],RTB[2]);
			}
		}

	// Config情報の読み込み
	buf="";
	try	{
		File inputFile = new File(configFileName);
		FileInputStream fis = new FileInputStream(inputFile);
		InputStreamReader isr = new InputStreamReader(fis,"Windows-31J");
		bufFileData = new BufferedReader(isr);	
		while ((str=bufFileData.readLine()) != null)
			{
			buf+=str+"\r\n";
			}
		bufFileData.close();
		}
	catch(FileNotFoundException e)
		{
		buf="";
		}
	catch(IOException e)
		{
		buf="";
		}
	str="";
	ConfigTable=buf.split("\r\n");
	}

// 個別記事指定で表示する--------------------------------------------------------------------
public String DrawContents(String filename,Boolean Shorten,String basepath,String baseurl)
	{
	String str="";
	String str1="";
	String str2="";
	String str3="";
	String tpic="";
	String filedate="";
	int fileseq=0;
	String ymd="";
	int yyyy=0;
	int mm=0;
	int dd=0;
	int RowCount=0;
	String inputFileName="";
	BufferedReader bufFileData;

	if (filename.length()<10)
		{
		str="対象の記事がありません。";
		return str;
		}
	filedate=filename.substring(0,8);
	fileseq=Integer.parseInt(filename.substring(9,10),10);
	yyyy=Integer.parseInt(filename.substring(0,4),10);
	mm=Integer.parseInt(filename.substring(4,6),10);
	dd=Integer.parseInt(filename.substring(6,8),10);
	ymd=String.valueOf(yyyy)+"."+String.valueOf(mm)+"."+String.valueOf(dd);
	if (fileseq != 1) ymd+="("+String.valueOf(fileseq)+")";

	inputFileName=basepath + "article/" + filename + ".txt";

	try	{
		File inputFile = new File(inputFileName);
		FileInputStream fis = new FileInputStream(inputFile);
		InputStreamReader isr = new InputStreamReader(fis,"Windows-31J");
		bufFileData = new BufferedReader(isr);	
		str1=bufFileData.readLine();
		str2=bufFileData.readLine();
		tpic=bufFileData.readLine();
		}
	catch(FileNotFoundException e)
		{
		str="対象の記事がありません。";
		return str;
		}
	catch(IOException e)
		{
		str="";
		return str;
		}

	//	分類の整理
	str1=str1.trim();
	if (str1.equals("")) str1="未分類";
	if (str1.equals(null)) str1="未分類";

	str="<article><header class='entry-header'><ul class='post-meta list-inline'>";
	str+="<li class='date'>"+ymd+"</li></ul>";
	str+="<h1 class='entry-title'>";
	str+="<a href='index.jsp?p="+filename+"' title='"+str2+"へのパーマリンク' rel='bookmark'>"+str2+"</a>";
	str+="</h1></header>";
	str+="<div class='entry-summary'>";
	
	//	見出し画像
	if (!tpic.equals("nothing"))
		{
		str+="<div class='excerpt-thumb'>";
		str+="<img src='"+baseurl+"article/images/"+tpic+"' style='max-width:100%;' >";
		str+="</div>";
		}

	RowCount=0;
	try	{
		while(bufFileData.ready())
			{
			str3=bufFileData.readLine();

			if ((str3.indexOf("#image=",0)!=-1))
				{
				if (Shorten) continue;
				str3=str3.substring(7,str3.length());
				str3="<div style='clear:both;'><img src='"+baseurl+"article/images/"+str3+"' style='max-width:100%;'></div>";
				}
			str+=str3;
			RowCount++;
			if ((RowCount>3)&&(Shorten))
				{
				str+="<div><a href='index.jsp?p="+filename+"' title='続きを読む' rel='bookmark'>続きを読む</a></div>";
				break;
				}
			}
		bufFileData.close();
		}
	catch(IOException e)
		{
		}
	str+="<div align=right><a href='index.jsp?cat="+str1+"' rel='bookmark'>カテゴリー："+str1+"</a></div>";
	str+="</div></article>";

	return str;
	}

// 年月指定で表示する--------------------------------------------------------------------
public String DrawContentsByYm(String YM,String basepath,String baseurl)
	{
	String str="";
	String fname="";
	int i=0;

	for(i=0;i<Articles;i++)
		{
		fname=ArticleFile[i];
		if (YM.equals(fname.substring(0,6)))
			{
			str+=DrawContents(fname,true,basepath,baseurl);
			}
		}
	return str;
	}
// カテゴリ指定で表示する--------------------------------------------------------------------
public String DrawContentsByCategory(String cat,String basepath,String baseurl)
	{
	String str="";
	String fname="";
	String fcategory="";
	int i=0;

	for(i=0;i<Articles;i++)
		{
		fname=ArticleFile[i];
		fcategory=ArticleCategory[i];
		if (cat.equals(fcategory))
			{
			str+=DrawContents(fname,true,basepath,baseurl);
			}
		}
	return str;
	}
// 検索指定で表示する----------------------------------------------------------------------
public String DrawContentsBySearch(String keyword,String basepath,String baseurl)
	{
	String str="";
	String fname="";
	String fcategory="";
	String s="";
	Boolean result=false;
	int i=0;
	int j=0;

	for(i=0;i<Articles;i++)
		{
		result=false;
		if (KeywordSearch(ArticleTitle[i],keyword)) result=true;
		if (KeywordSearch(ArticleCategory[i],keyword)) result=true;
		if (!result)
			{
			s=GetFileText(ArticleFile[i],basepath);
			if (KeywordSearch(s,keyword)) result=true;
			}
		if (result)
			{
			str+=DrawContents(ArticleFile[i],true,basepath,baseurl);
			}
		}

	return str;
	}
// -------------------------------------------------------------------------------------------
public Boolean KeywordSearch(String words,String keyword)
	{
	Boolean result;
	int i=0;
	String[] tbl=keyword.split("\\+");
	result=true;
	for(i=0;i<tbl.length;i++)
		{
		if (words.indexOf(tbl[i])==-1)
			{
			result=false;
			break;
			}
		}
	return result;
	}

public String GetFileText(String filename,String basepath)
	{
	String buf="";
	String str;
	BufferedReader bufFileData;
	String inputFileName=basepath + "article/" + filename + ".txt";
	try	{
		File inputFile = new File(inputFileName);
		FileInputStream fis = new FileInputStream(inputFile);
		InputStreamReader isr = new InputStreamReader(fis,"Windows-31J");
		bufFileData = new BufferedReader(isr);	
		while ((str=bufFileData.readLine()) != null)
			{
			buf+=str;
			}
		bufFileData.close();
		}
	catch(FileNotFoundException e)
		{
		buf="";
		}
	catch(IOException e)
		{
		buf="";
		}
	return buf;
	}
// 最近の記事一覧（３つまで表示）--------------------------------------------------------------------
public String DrawSide_Recents()
	{
	String str="";
	int i=0;
	int j=0;
	str="";

	if (Articles<=3) j=0;else j=Articles-3;
	for(i=Articles-1;i>=j;i--)
		{
		str+="<li><a href='index.jsp?p="+ArticleFile[i]+"' ";
		str+="title='"+ArticleTitle[i]+"'>"+ArticleTitle[i]+"</a></li>";
		}
	return str;
	}

// 年月別記事一覧-----------------------------------------------------------------------------------
public String DrawSide_Ym()
	{
	String str="";
	String ym="";
	String bym="";
	int yyyy=0;
	int mm=0;
	int i=0;
	int j=0;
	str="";

	for(i=0;i<Articles;i++)
		{
		ym=ArticleFile[i].substring(0,6);
		if (ym.equals(bym) == false)
			{
			if (bym.equals("") == false)
				{
				str+="<li><a href='index.jsp?ym="+bym+"' ";
				str+="title='"+String.valueOf(yyyy)+"年"+String.valueOf(mm)+"月'>";
				str+=String.valueOf(yyyy)+"年"+String.valueOf(mm)+"月("+String.valueOf(j)+")</a></li>";
				}
			bym=ym;
			j=0;
			}
		j++;
		yyyy=Integer.parseInt(ym.substring(0,4),10);
		mm=Integer.parseInt(ym.substring(4,6),10);
		}
	if (j != 0)
		{
		str+="<li><a href='index.jsp?ym="+bym+"' ";
		str+="title='"+String.valueOf(yyyy)+"年"+String.valueOf(mm)+"月'>";
		str+=String.valueOf(yyyy)+"年"+String.valueOf(mm)+"月("+String.valueOf(j)+")</a></li>";
		}
	return str;
	}
// カテゴリ別記事一覧-----------------------------------------------------------------------------------
public String DrawSide_Category()
	{
	String str="";
	String ym="";
	String bym="";
	int yyyy=0;
	int mm=0;
	int i=0;
	int j=0;
	str="";
	Object[] objKey = CategoryHash.keySet().toArray();

	for(i=0;i<objKey.length;i++)
		{
		str+="<li><a href='index.jsp?cat="+objKey[i]+"' ";
		str+="title='カテゴリー："+objKey[i]+"'>";
		str+=objKey[i]+"("+CategoryHash.get(objKey[i])+")</a></li>";
		}
	return str;
	}
//---------------------------------------------------------------------------------------------------------
// メールフォームを表示する
//---------------------------------------------------------------------------------------------------------
public String DrawMailForm()
	{
	String buf="";
	buf="<p><span style='font-size:24px;font-weight:bold;'>お問い合わせフォーム</span><br><br>";
	buf+="<span class=points>■</span>は必須項目になります。</p><br>";
	buf+="<form id='MAIN' method='post' action='index.jsp?mode=mailconfirm' style='background-color:#e0e0e0;padding:12px;'>";
/*
	buf+="<table border=0>";
	buf+="<tr><th class=formbox><span class=points>■</span>お名前　または会社名：</th>";
	buf+="<td><input class=Fields name='Eusername' size=40 maxlength=255></td></tr>";
	buf+="<tr><th class=formbox>部署名：</th>";
	buf+="<td><input class=Fields name='Egroupname' size=40 maxlength=255></td></tr>";
	buf+="<tr><th class=formbox>役職名：</th>";
	buf+="<td><input class=Fields name='Eposition' size=40 maxlength=255></td></tr>";
	buf+="<tr><th class=formbox><span class=points>■</span>メールアドレス：</th>";
	buf+="<td><input class=Fields name='Email' size=40 maxlength=255></td></tr>";
	buf+="<tr><th class=formbox>件名：</th>";
	buf+="<td><input class=Fields name='Esubject' size=40 maxlength=255></td></tr>";
	buf+="<tr><th class=formbox valign=top><span class=points>■</span>具体的内容：</th>";
	buf+="<td><textarea class=FieldAreas name='Ebody' cols=40 rows=15 style='resize: none;'></textarea></td></tr>";
	buf+="<tr><th></th><td align=right>";
//	buf+="<input type=button class=SetButton_Off value='送信内容の確認' onclick='CheckSubmits()'>";
//	buf+="<input type=button class=SetButton_Off value='戻る' onclick='history.back()'>";
	buf+="<input type=button class=flatbutton value='送信内容の確認' onclick='CheckSubmits()'>";
	buf+="<input type=button class=flatbutton value='戻る' onclick='history.back()'>";
	buf+="</td></tr></table></form>";
*/
	buf+="<span class=points>■</span>お名前　または会社名：<br>";
	buf+="<input class=Fields name='Eusername' size=40 maxlength=255><br><br>";
	buf+="部署名：<br>";
	buf+="<input class=Fields name='Egroupname' size=40 maxlength=255><br><br>";
	buf+="役職名：<br>";
	buf+="<input class=Fields name='Eposition' size=40 maxlength=255><br><br>";
	buf+="<span class=points>■</span>メールアドレス：<br>";
	buf+="<input class=Fields name='Email' size=40 maxlength=255><br><br>";
	buf+="件名：<br>";
	buf+="<input class=Fields name='Esubject' size=40 maxlength=255><br><br>";
	buf+="<span class=points>■</span>具体的内容：<br>";
	buf+="<textarea class=FieldAreas name='Ebody' cols=40 rows=15 style='resize: none;'></textarea><br><br>";
	buf+="<input type=button class=flatbutton value='送信内容の確認' onclick='CheckSubmits()'>";
	buf+="<input type=button class=flatbutton value='戻る' onclick='history.back()'>";
	buf+="</form>";

	return buf;
	}
//---------------------------------------------------------------------------------------------------------
// メール確認画面を表示する
//---------------------------------------------------------------------------------------------------------
public String DrawMailConfirm(String username,String groupname,String position,String mail,String subject,String body)
	{
	String buf="";
	buf="<p><span style='font-size:24px;font-weight:bold;'>送信内容の確認</span><br><br>";
	buf+="<table border=0>";
	buf+="<tr><th align=right>お名前　または会社名：</th><td><div id='Vusername'></div></td></tr>";
	buf+="<tr><th align=right>部署名：</th><td><div id='Vgroupname'></div></td></tr>";
	buf+="<tr><th align=right>役職名：</th><td><div id='Vposition'></div></td></tr>";
	buf+="<tr><th align=right>メールアドレス：</th><td><div id='Vmail'></div></td></tr>";
	buf+="<tr><th align=right>件名：</th><td><div id='Vsubject'></div></td></tr>";
	buf+="<th align=right valign=top>具体的内容：</th><td><div id='Vbody'></div></td></tr>";
	buf+="</table><hr>";
	buf+="<form method='POST' action='./RequestMail'>";
//	buf+="<input type='submit' class=SetButton_Off value='送信する'>";
//	buf+="<input type='button' class=SetButton_Off value='戻る' onclick='history.back()'>";
	buf+="<input type='submit' class=flatbutton value='送信する'>";
	buf+="<input type='button' class=flatbutton value='戻る' onclick='history.back()'>";
	buf+="<div style='visibility:hidden;'>";
	buf+="<input name='Eusername' size=1 value='"+username+"'>";
	buf+="<input name='Egroupname' size=1 value='"+groupname+"'>";
	buf+="<input name='Eposition' size=1 value='"+position+"'>";
	buf+="<input name='Email' size=1 value='"+mail+"'>";
	buf+="<input name='Esubject' size=1 value='"+subject+"'>";
	buf+="<textarea cols=1 rows=1 name='Ebody'>"+body+"</textarea>";
	buf+="</div></form>";
	return buf;
	}
%>
<%
//---------------------------------------------------------------------------------------------------------
// HEAD部分生成(title,meta description,meta keywords)
//---------------------------------------------------------------------------------------------------------
ReadIndex(basepath);		//	ヘッダ情報取得(index.txt,seo.txt,config.txt)
String cnt="";
int i=0;
int j=0;

//	titleの生成
if (!(Targetpage.equals("")))
	{
	cnt=GetTitle(Targetpage);
	out.println("<title>"+cnt+"</title>");
	}
else out.println("<title>"+ConfigTable[0]+"</title>");

// meta description,meta keywordsの生成-----------------
String metadescription="";
String metakeywords="";

if (DescriptionHash.containsKey("全て"))
	{
	metadescription=(String)DescriptionHash.get("全て");
	}
if (KeywordsHash.containsKey("全て"))
	{
	metakeywords=(String)KeywordsHash.get("全て");
	}
if (!(Targetcat.equals("")))	//	カテゴリ別表示である
	{
	if (DescriptionHash.containsKey(Targetcat))
		{
		metadescription=(String)DescriptionHash.get(Targetcat);
		}
	if (KeywordsHash.containsKey(Targetcat))
		{
		metakeywords=(String)KeywordsHash.get(Targetcat);
		}
	}
if (!(Targetpage.equals("")))	//	ページ直接指定である
	{
	for(i=0;i<Articles;i++)
		{
		if (ArticleFile[i].equals(Targetpage))
			{
			if (DescriptionHash.containsKey(ArticleCategory[i]))
				{
				metadescription=(String)DescriptionHash.get(ArticleCategory[i]);
				}
			if (KeywordsHash.containsKey(ArticleCategory[i]))
				{
				metakeywords=(String)KeywordsHash.get(ArticleCategory[i]);
				}
			if (!(ArticleDescription[i].equals("")))
				{
				metadescription=ArticleDescription[i];
				}
			if (!(ArticleKeywords[i].equals("")))
				{
				metakeywords=ArticleKeywords[i];
				}
			break;
			}
		}
	}

out.println("<meta name=\"description\" content=\""+metadescription+"\">");
if (!(metakeywords.equals("")))
	{
	out.println("<meta name=\"keywords\" content=\""+metakeywords+"\">");
	}

//---------------------------------------------------------------------------------------------------------
%>
<!--[if lt IE 9]>
<%
out.println("<script src=\""+baseURL+"js/html5.js\" type=\"text/javascript\"></script>");
%>
<![endif]-->

<link rel='stylesheet' id='themonic-style-css'  href='./css/murakumo.css' type='text/css' media='all' />
<link rel='stylesheet' id='themonic-style-css'  href='./css/murakumo_pc.css' type='text/css' media='all' />
<link rel='stylesheet' id='themonic-style-css'  href='./css/murakumo_print.css' type='text/css' media='all' />
<link rel='stylesheet' id='themonic-style-css'  href='./css/murakumo_addition.css' type='text/css' media='all' />
<!--[if lt IE 9]>
<%
out.println("<link rel='stylesheet' id='themonic-ie-css'  href='"+baseURL+"css/ie.css?ver=20130305' type='text/css' media='all' />");
%>
<![endif]-->
<%
out.println("<link rel='index' title='"+ConfigTable[0]+"' href='"+baseURL+"index.php' />");
%>
<link rel="stylesheet" type="text/css" href="./article/murakumo.css">
<%
// メールフォームの場合はＣＳＳ、スクリプトを適用-------------------------------------
if ((Targetmode.equals("mailform"))||(Targetmode.equals("mailconfirm"))||(Targetmode.equals("maildone")))
	{
	out.println("<link rel='stylesheet' href='./css/mailform.css' type='text/css'/>");
	out.println("<script src='"+baseURL+"js/mailform.js' type='text/javascript'></script>");
	}
//------------------------------------------------------------------------------------
%>
<script type='text/javascript' src='./js/l10n.js?ver=20101110'></script>
<meta name="generator" content="WordPress 3.2.1" />
<script type='text/javascript'>
function BootMurakumo()
	{
	var param=GetURLVars();
	if ("mode" in param)
		{
		if (param["mode"]=="mailconfirm")
			{
			SetValuesToField();
			}
		}
	}
function GetURLVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}
</script>
</head>

<body class="home blog custom-background-empty custom-font-enabled single-author" onload="BootMurakumo()">
<header id="masthead" class="site-header" role="banner">
<hgroup>
<a href="index.jsp" title="<%= ConfigTable[0] %>" rel="home"><%= ConfigTable[0] %></a>
<br .../> <a class="site-description"></a>
</hgroup>

<nav id="site-navigation" class="themonic-nav" role="navigation">
<div class="nav-menu"><ul><li class="current_page_item"><a href="index.jsp" title="ホーム">ホーム</a></li><li class="page_item page-item-2"><a href="index.jsp?mode=mailform" title="お問い合わせ">お問い合わせ</a></li></ul></div>
</nav><!-- #site-navigation -->
<div class="clear"></div>
</header><!-- #masthead -->

<div id="page" class="hfeed site">
<div id="main" class="wrapper">
<div class="wrap"><ul class="breadcrumb clearfix"></ul></div>
<div id="primary" class="site-content">
<div id="content" role="main">

<%
// ページメイン処理 ==========================================================================
// (1)引数指定がない場合 --------------------------------------------
if ((Targetpage.equals(""))&&(Targetym.equals(""))&&(Targetcat.equals(""))&&(Targetsearch.equals(""))&&(Targetmode.equals("")))
	{
	if (Articles<=5) j=0;else j=Articles-5;
	for(i=Articles-1;i>=j;i--)
		{
		cnt=DrawContents(ArticleFile[i],true,basepath,baseURL);
		out.println(cnt);
		}
	}
// (2)ページ直接指定の場合--------------------------------------------
if (!(Targetpage.equals("")))
	{
	cnt=DrawContents(Targetpage,false,basepath,baseURL);
	out.println(cnt);
	}
// (3)年月指定の場合--------------------------------------------------
if (!(Targetym.equals("")))
	{
	cnt=DrawContentsByYm(Targetym,basepath,baseURL);
	out.println(cnt);
	}
// (4)カテゴリ指定の場合----------------------------------------------
if (!(Targetcat.equals("")))
	{
	cnt=DrawContentsByCategory(Targetcat,basepath,baseURL);
	out.println(cnt);
	out.println("カテゴリ別表示:"+Targetcat);
	}
// (5)検索の場合------------------------------------------------------
if (!(Targetsearch.equals("")))
	{
	cnt=DrawContentsBySearch(Targetsearch,basepath,baseURL);
	out.println(cnt);
	}
// (6)メールフォームの場合--------------------------------------------
if (!(Targetmode.equals("")))
	{
	if (Targetmode.equals("mailform"))		out.println(DrawMailForm());
	if (Targetmode.equals("mailconfirm"))	out.println(DrawMailConfirm(Eusername,Egroupname,Eposition,Email,Esubject,Ebody));
//	if (Targetmode.equals("maildone"))		out.println(DrawMailDone());
	}
// -------------------------------------------------------------------

%>
<!-- JSP ファイルから読み込んで貼り付けるテスト -->

</div><!-- #content -->
</div><!-- #primary -->

<div id="secondary" class="widget-area" role="complementary">
<div class="widget widget_search">
<form role="search" method="get" id="searchform" action="index.jsp" >
<div><label class="screen-reader-text" for="s">検索:</label>
<input type="text" value="" name="search" id="search" />
<input type="submit" id="searchsubmit" value="検索" />
</div>
</form>
</div>

<!--　右サイドの記事一覧表示部分  -->

<div class="widget widget_recent_entries">
<p class="widget-title">最近の投稿</p>
<ul>
<%
out.println(DrawSide_Recents());
%>
</ul>
</div>

<div class="widget widget_recent_entries">
<p class="widget-title">年月別一覧</p>
<ul>
<%
out.println(DrawSide_Ym());
%>
</ul>
</div>

<div class="widget widget_recent_entries">
<p class="widget-title">カテゴリ別一覧</p>
<ul>
<%
out.println(DrawSide_Category());
%>
</ul>
</div>


<!--<div class="widget widget_pages">
<p class="widget-title">Pages</p>
<ul><li class="page_item page-item-2"><a href="index.jsp?p=2" title="サンプルページ">サンプルページ</a></li>
</ul></div>

<div class="widget widget_tag_cloud">
<p class="widget-title">Tag Cloud</p>
</div>-->
</div><!-- #secondary -->
</div><!-- #main .wrapper -->
</div><!-- #page -->

<footer id="colophon" role="contentinfo">
<div class="site-info">
<p>&copy; <%= ConfigTable[1] %></p>
<p><a href="index.jsp?mode=mailform">お問い合わせはこちら</a></p>
<%
// User Agent を取得
String environment="";
String user_agent = request.getHeader("user-agent");
// [iPhone][iPod][Android][Windows Phone][BlackBerry]が含まれている場合のみ、スマホ用JSPを呼び出すように対応する。
// ※Androidの場合は[Mobile]が含まれている場合のみ。
int iphone = user_agent.indexOf("iPhone");
int ipod = user_agent.indexOf("iPod");
int ipad = user_agent.indexOf("iPad");
int win = user_agent.indexOf("Windows Phone");
int bb = user_agent.indexOf("BlackBerry");
int android = user_agent.indexOf("Android");
int mobile = user_agent.indexOf("Mobile");

// 携帯
if(user_agent.indexOf("DoCoMo") == 0 || user_agent.indexOf("J-PHONE") == 0 || 
user_agent.indexOf("Vodafone") == 0 || user_agent.indexOf("SoftBank") == 0 || 
user_agent.indexOf("UP.Browser") == 0 || user_agent.indexOf("KDDI") == 0)
	{
	environment="携帯電話";
	}
else if ((iphone>-1)||(ipod>-1)||(win>-1)||(bb>-1)||((android>-1)&&(mobile>-1)))
	{
	environment="スマートフォン";
	}
else if ((ipad>-1)||((android>-1)&&(mobile==-1)))
	{
	environment="タブレット";
	}
else{
	environment="ＰＣ";
	}
//out.println("表示モード:"+environment);
%>

<div class="clear"></div>
</div><!-- .site-info -->
</footer><!-- #colophon -->
<div class="clear"></div>

<%
// Googleアナリティクスの貼り付け-----------------------------------------------------------
String s2="<script src=\""+baseURL+"js/analytics.js\" type=\"text/javascript\"></script>";
out.println(s2);
String s3="<script src=\""+baseURL+"js/selectnav.js?ver=1.0\" type=\"text/javascript\"></script>";
out.println(s3);
%>
</body>
</html>