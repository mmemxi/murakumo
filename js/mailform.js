String.prototype.trim = function()
	{
    return this.replace(/^[ ]+|[ ]+$/g, '');
	}
// ＧＥＴパラメータの取得--------------------------------------------------
function GetURLVars()
	{
	var vars = {}; 
	var param = location.search.substring(1).split('&');
	for(var i = 0; i < param.length; i++)
		{
		var keySearch = param[i].search(/=/);
		var key = '';
		if(keySearch != -1) key = param[i].slice(0, keySearch);
		var val = param[i].slice(param[i].indexOf('=', 0) + 1);
		if(key != '') vars[key] = decodeURI(val);
		}
	return vars; 
	}
// 入力内容の確認処理-----------------------------------------------------
function CheckSubmits()
	{
	var Fusername=document.forms[0].Eusername.value;
	var Fgroupname=document.forms[0].Egroupname.value;
	var Fpotision=document.forms[0].Eposition.value;
	var Fmail=document.forms[0].Email.value;
	var Fsubject=document.forms[0].Esubject.value;
	var Fbody=document.forms[0].Ebody.value;
	for(i=0;i<document.forms[0].elements.length;i++)
		{
		document.forms[0].elements[i].style.backgroundColor="f8f8ff";
		}

	Fusername=Fusername.trim();
	if (Fusername=="")
		{
		document.forms[0].Eusername.style.backgroundColor="fff0f0";
		alert("お名前または会社名を入力してください。");
		return;
		}

	Fmail=Fmail.trim();
	if (Fmail=="")
		{
		document.forms[0].Email.style.backgroundColor="fff0f0";
		alert("メールアドレスを入力してください。");
		return;
		}
	if (Fmail.indexOf("@",0)==-1)
		{
		document.forms[0].Email.style.backgroundColor="fff0f0";
		alert("メールアドレスの形式が正しくありません。");
		return;
		}

	Fbody=Fbody.trim();
	if (Fbody=="")
		{
		document.forms[0].Ebody.style.backgroundColor="fff0f0";
		alert("内容を入力してください。");
		return;
		}
	document.forms[0].submit();
	}
// 入力内容を表示フィールドにセットする----------------------------------------
function SetValuesToField()
	{
	window["Vusername"].innerHTML=document.forms[0].Eusername.value;
	window["Vgroupname"].innerHTML=document.forms[0].Egroupname.value;
	window["Vposition"].innerHTML=document.forms[0].Eposition.value;
	window["Vmail"].innerHTML=document.forms[0].Email.value;
	window["Vsubject"].innerHTML=document.forms[0].Esubject.value;
	ebody=document.forms[0].Ebody.value;
	window["Vbody"].innerHTML=ebody.replace(/\n/g,"<br>");
	}
