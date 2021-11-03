if(!dojo.hostenv.findModule("xg.shared.util",false)){
dojo.provide("xg.shared.util");
xg.append=function(_1){
return (document.getElementById("xj_baz17246")||document.body).appendChild(_1);
};
xg.listen=function(_2,_3,_4,_5){
dojo.event.connect("string"==_2?dojo.byId(_2):_2,_3,"function"==typeof _4?_4:function(){
_5.apply(_4,arguments);
});
};
xg.stop=function(_6){
dojo.event.browser.stopEvent(_6);
};
xg.qh=function(_7){
return _7.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/\"/g,"&quot;");
};
xg.toggle=function(_8,_9){
_8=dojo.byId(_8);
if(arguments.length==1){
_9=(_8.style.display=="none");
}
_8.style.display=_9?"":"none";
};
xg.$=function(_a,_b){
if(_a.substr(0,1)=="#"){
return dojo.byId(_a.substr(1));
}
return xg.$$(_a,_b)[0];
};
xg.$$=function(_c,_d){
if(_c.substr(0,1)=="#"){
return [dojo.byId(_c.substr(1))];
}
_c=_c.split(".",2);
if("string"==typeof _d){
_d=document.getElementById(_d);
}
if(!_c[1]){
return (_d||document.body).getElementsByTagName(_c[0]);
}
return dojo.html.getElementsByClass(_c[1],_d,_c[0]);
};
xg.parent=function(el,_f){
_f=(_f||"").split(".");
var tag=_f[0].toUpperCase();
var cls=_f[1]?new RegExp("(^|\\s+)"+_f[1]+"(\\s+|$)"):"";
while(el=el.parentNode){
if((!tag||el.tagName==tag)&&(!cls||el.className.match(cls))){
return el;
}
}
return null;
};
xg._xhr=function(_12,url,_14,cb1,cb2){
var req={url:url,method:_12,encoding:"utf-8",mimetype:"text/plain",load:function(_18,_19,_1a){
var ct=_1a.getResponseHeader("Content-Type"),ret;
try{
if(ct.indexOf("text/javascript")!=-1){
ret=dj_eval(_1a.responseText);
}else{
if(ct.indexOf("text/json")!=-1){
ret=dj_eval("("+_1a.responseText+")");
}else{
if(ct.indexOf("/xml")!=-1){
ret=_1a.responseXML;
}else{
ret=_1a.responseText;
}
}
}
}
catch(e){
ret=null;
}
"function"==typeof cb1?cb1(_1a,ret):cb2.call(cb1,_1a,ret);
}};
if(_14){
if(_14.constructor!=Object){
req.formNode=_14;
}else{
if("undefined"!=typeof _14["preventCache"]){
req.preventCache=_14["preventCache"];
delete _14["preventCache"];
}
if("undefined"!=typeof _14["formNode"]){
req.formNode=_14["formNode"];
delete _14["formNode"];
}
req.content=_14;
}
}
return dojo.io.bind(req);
};
xg.get=function(url,_1e,cb1,cb2){
return xg._xhr("get",url,_1e,cb1,cb2);
};
xg.post=function(url,_22,cb1,cb2){
return xg._xhr("post",url,_22,cb1,cb2);
};
xg.shared.util={ignoreOverlayHide:false,chatAppletContainerVisible:undefined,createElement:function(_25){
var el=document.createElement("div");
el.innerHTML=_25.replace(/^\s+/,"").replace(/\s+$/,"");
return el.firstChild||undefined;
},getOffset:function(el,_28){
var x=0,y=0;
var _2b=[];
for(;_28;_28=_28.parentNode){
_2b.push(_28);
}
for(var cur=el;cur;cur=cur.offsetParent){
var p=dojo.style.getStyle(cur,"position");
if(p=="relative"||p=="absolute"){
var _2e=0;
for(var i=0;i<_2b.length;i++){
if(cur==_2b[i]){
_2e=1;
break;
}
}
if(_2e){
break;
}
}
x+=cur.offsetLeft||0;
y+=cur.offsetTop||0;
if(cur.tagName=="BODY"){
break;
}
}
return {x:x,y:y};
},getOffsetX:function(el,_31){
var e=x$(el).offset(),n=x$(_31).offset();
return {x:e.left-n.left,y:e.top-n.top};
},_widgetParsingStrategy:0,safeBindUrl:function(url){
return url.replace(/\[/g,"%5B").replace(/\]/g,"%5D");
},isValidUrl:function(str){
var _36=/^(ftp|https?):\/\/(\w+(:\w*)?@?)?([a-zA-Z0-9_.-]+)(:\d+)?(\/([\w#!:.?+=&%@!\/-]*)?)?$/;
return _36.test(str);
},parseUrlParameters:function(url){
var _38=url.split("?");
var _39=new Object;
if(_38.length>1){
var _3a=_38[1].split("&");
for(var idx=0;idx<_3a.length;idx++){
var kv=_3a[idx].split("=");
_39[kv[0]]=kv[1];
}
}
return _39;
},parseWidgets:function(_3d){
var _3d=_3d||document.getElementsByTagName("body")[0]||document.body;
var _3e=new dojo.xml.Parse();
var _3f=_3e.parseElement(_3d,null,true);
dojo.widget.getParser().createComponents(_3f);
},fixImagesInIE:function(_40,_41,_42,_43){
if(!(dojo.render.html.ie50||dojo.render.html.ie55||dojo.render.html.ie60)){
return;
}
dojo.lang.forEach(_40,function(img){
if(dojo.lang.inArray(xg.shared.util.fixedImageURLs,img.src)){
return;
}
var _45=function(){
var _46=new Image();
_46.onload=_46.onerror=_46.onabort=function(){
img.src=img.src;
xg.shared.util.fixTransparencyInIEProper(img,_42,_43);
xg.shared.util.fixedImageURLs.push(img.src);
};
_46.src=img.src;
};
if(_41){
_45();
}else{
window.setTimeout(_45,0);
}
});
},fixedImageURLs:[],fixTransparencyInIEProper:function(img,_48,_49){
if(img&&(dojo.render.html.ie50||dojo.render.html.ie55||dojo.render.html.ie60)&&img.src.match(/png/)&&dojo.style.isShowing(img)){
_48=_48?_48:img.width;
_49=_49?_49:img.height;
img.style.width=_48+"px";
img.style.height=_49+"px";
img.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+img.src+"', sizingMethod='scale')";
img.src=xg.shared.util.cdn("/xn_resources/widgets/index/gfx/x.gif");
}
if(img){
img.style.visibility="visible";
}
},fixTransparencyInIE:function(_4a){
if(dojo.render.html.ie50||dojo.render.html.ie55||dojo.render.html.ie60){
dojo.lang.forEach(_4a.getElementsByTagName("img"),function(img){
xg.shared.util.fixTransparencyInIEProper(img);
});
}
},fixDialogPosition:function(dlg){
var _4d=xg.$("div.xg_floating_container",dlg);
var vh=parseInt(dojo.html.getViewportHeight());
_4d.style.height="auto";
_4d.style.overflow="visible";
var h=parseInt(_4d.offsetHeight);
if(h>vh*0.9){
_4d.style.height=parseInt(vh*0.9)+"px";
_4d.style.overflow="auto";
}
var drh=dojo.render.html;
_4d.style.marginTop=(drh.ie&&(drh.ie60||drh.ie55||drh.ie50)?0:-parseInt(_4d.offsetHeight/2))+"px";
},nl2br:function(s){
s=s.replace(/\r\n/g,"\n");
result="";
dojo.lang.forEach(s.split("\n"),function(_52){
result+=_52;
if(!_52.match(/<.?OBJECT\b|<.?EMBED\b|<.?PARAM\b|<.?APPLET\b|<.?IFRAME\b|<.?SCRIPT\b|<.?BR\b|<.?ADDRESS\b|<.?BLOCKQUOTE\b|<.?CENTER\b|<.?DIR\b|<.?DIV\b|<.?DL\b|<.?FIELDSET\b|<.?FORM\b|<.?H1\b|<.?H2\b|<.?H3\b|<.?H4\b|<.?H5\b|<.?H6\b|<.?HR\b|<.?ISINDEX\b|<.?MENU\b|<.?NOFRAMES\b|<.?NOSCRIPT\b|<.?OL\b|<.?P\b|<.?PRE\b|<.?TABLE\b|<.?UL\b|<.?DD\b|<.?DT\b|<.?FRAMESET\b|<.?LI\b|<.?TBODY\b|<.?TD\b|<.?TFOOT\b|<.?TH\b|<.?THEAD\b|<.?TR\b/i)){
result+="<br />";
}
result+="\n";
});
return dojo.string.trim(result).replace(/(<br \/>)+$/,"");
},showOverlay:function(){
var o=dojo.byId("xg_overlay");
if(o.style.display=="none"){
o.style.height=this.getPageHeight()+"px";
o.style.display="block";
}
xg.shared.util.chatAppletContainerVisible=x$("#appletContainer").css("visibility");
x$("#appletContainer").css("visibility","hidden");
},hideOverlay:function(){
if(xg.shared.util.ignoreOverlayHide==true){
return;
}
var o=dojo.byId("xg_overlay");
if(o.style.display!="none"){
o.style.display="none";
}
if(typeof xg.shared.util.chatAppletContainerVisible!="undefined"){
x$("#appletContainer").css("visibility",xg.shared.util.chatAppletContainerVisible);
}
},getPageHeight:function(){
var _55;
if(window.innerHeight&&window.scrollMaxY){
_55=window.innerHeight+window.scrollMaxY;
}else{
if(document.body.scrollHeight>document.body.offsetHeight){
_55=document.body.scrollHeight;
}else{
_55=document.body.offsetHeight;
}
}
var _56;
if(self.innerHeight){
_56=self.innerHeight;
}else{
if(document.documentElement&&document.documentElement.clientHeight){
_56=document.documentElement.clientHeight;
}else{
if(document.body){
_56=document.body.clientHeight;
}
}
}
if(_55<_56){
pageHeight=_56;
}else{
pageHeight=_55;
}
return pageHeight;
},setMaxLength:function(_57,_58){
x$(_57).bind("keypress",function(e){
var key=e.which||e.keyCode;
if(key!=8&&key!=46&&key!=37&&key!=39&&key!=38&&key!=40&&_57.value.length>=_58){
e.preventDefault();
}
});
},setAdvisableMaxLength:function(_5b,_5c,_5d,_5e,_5f,_60){
if(!_5e){
_5e=function(){
return _5b.value;
};
}
var _61=0,_62=_5b.parentNode,_63=function(){
if(_5e().length>_5c){
_5f.innerHTML=xg.shared.nls.text("messageIsTooLong",_5e().length,_5c);
dojo.html.addClass(_5f,"hint_textarea");
if(!_61){
dojo.html.addClass(_5b.parentNode,"error");
dojo.html.addClass(_5f,"error");
}
_61=1;
}else{
dojo.html.removeClass(_5f,"hint_textarea");
if(_61){
_5f.innerHTML=_5d||"";
dojo.html.removeClass(_5b.parentNode,"error");
dojo.html.removeClass(_5f,"error");
}
_61=0;
}
if(xg.shared.util.maxAdvisableLengthTimer!=null){
clearTimeout(xg.shared.util.maxAdvisableLengthTimer);
xg.shared.util.maxAdvisableLengthTimer=null;
}
};
if(!_5f){
_5f=document.createElement("small");
_5b.nextSibling?_62.insertBefore(_5f,_5b.nextSibling):_62.appendChild(_5f,_5b);
}
dojo.html.addClass(_5f,"maxlength_advisement");
_5f.innerHTML=_5d||"";
var _64=this.addOnChange(_5b,_63,_60);
return _64.trigger;
},maxAdvisableLengthTimer:null,setAdvisableMaxLengthWithCountdown:function(_65,_66,_67,_68){
var _69=0;
if("undefined"==typeof _67){
_67=dojo.dom.nextElement(_65,"span");
}
var _6a=_65.id+"_chars_left";
var _6b=dojo.byId(_6a);
var _6c=function(){
var n=_66-_65.value.replace(/\r\n/g,"\n").length;
if(!_68||n<0){
if(!_6b){
_6b=document.createElement("small");
x$(_6b).addClass("right");
_6b.id=_6a;
_67.appendChild(_6b);
}
}
if(_6b){
if(n>=0){
_6b.innerHTML="&nbsp;"+n;
}else{
_6b.innerHTML="&nbsp;-"+Math.abs(n);
}
}
if(_65.value.length>_66){
if(!_69){
dojo.html.addClass(_6b.parentNode,"simpleerrordesc");
}
_69=1;
}else{
if(_69){
dojo.html.removeClass(_6b.parentNode,"simpleerrordesc");
}
_69=0;
}
};
this.addOnChange(_65,_6c);
_6c();
return _6c;
},addOnChange:function(_6e,_6f,_70){
var _71=this.createQuiescenceTimer(_70||50,_6f);
dojo.event.connect(_6e,"onkeyup",_71.trigger);
dojo.event.connect(_6e,"onkeypress",_71.trigger);
dojo.event.connect(_6e,"onblur",_71.trigger);
dojo.event.connect(_6e,"oncut",_71.trigger);
dojo.event.connect(_6e,"onpaste",_71.trigger);
dojo.event.connect(_6e,"onchange",_71.trigger);
return _71;
},modalDialog:function(_72){
x$(".xg_floating_module").remove();
x$(".dy-modal").remove();
if((typeof _72)=="string"){
args={bodyHtml:_72};
}else{
args=_72;
}
var _73=args.wideDisplay?" dy-modal-wide":"";
var _74=args.title?"<h3>"+xg.qh(args.title)+"</h3>":null;
var _75=args.titleHtml?args.titleHtml:_74;
var _76=args.bodyHtml;
var _77=" <div> <div class=\"xg_floating_container dy-modal"+_73+"\">     <div class=\"dy-modal-close\">         <a class=\"xg_icon xg_icon-close xj_close\" href=\"#\">"+xg.shared.nls.text("close")+"</a>     </div>     <div class=\"module\"> "+_75+"         <div class=\"form\"> "+_76+"         </div>     </div> </div> </div>";
var _78=x$(_77)[0];
this.showOverlay();
xg.append(_78);
this.fixDialogPosition(_78);
if(args.noClose){
x$(".dy-modal-close",_78).hide();
}else{
x$(".xj_close",_78).click(function(_79){
_79.preventDefault();
xg.shared.util.hideOverlay();
x$(_78).remove();
});
}
return _78;
},alert:function(_7a){
if(dojo.byId("xg_lightbox_alert")){
dojo.dom.removeNode(dojo.byId("xg_lightbox_alert"));
}
if((typeof _7a)=="string"){
args={bodyHtml:_7a};
}else{
args=_7a;
}
args.onOk=args.onOk?args.onOk:function(){
};
args.autoCloseTime=args.autoCloseTime?args.autoCloseTime:0;
if(!args.okButtonText){
args.okButtonText=xg.shared.nls.text("ok");
}
var _7b=args.wideDisplay?" xg_floating_container_wide":"";
var _7c=args.customDisplayClass?" "+args.customDisplayClass:"";
var _7d=args.title?"<h2>"+dojo.string.escape("html",args.title)+"</h2>":null;
var _7e=args.titleHtml?args.titleHtml:_7d;
var _7f=dojo.string.trim("                 <div class=\"xg_floating_module\" id=\"xg_lightbox_alert\">                     <div class=\"xg_floating_container xg_lightborder xg_module"+_7b+_7c+"\">                         <div class=\"xg_module_head "+(_7e?"":"notitle")+"\">                             "+(_7e?_7e:"")+"                         </div>                         <div class=\"xg_module_body\"> "+((args.bodyHtmlRaw)?(args.bodyHtmlRaw):("<p>"+args.bodyHtml+"</p>")));
if(args.autoCloseTime<1&&!args.noButtons){
_7f+=dojo.string.trim("                             <p class=\"buttongroup\">                                 <input type=\"button\" class=\"button\" value=\""+dojo.string.escape("html",args.okButtonText)+"\" />                             </p>");
}
_7f+=dojo.string.trim("                         </div>                     </div>                 </div>");
var _80=dojo.html.createNodesFromText(_7f)[0];
this.showOverlay();
xg.append(_80);
this.fixDialogPosition(_80);
if(args.noClose||args.autoCloseTime<1){
if(!args.noButtons){
dojo.event.connect(dojo.html.getElementsByClass("button",_80)[0],"onclick",dojo.lang.hitch(this,function(_81){
dojo.event.browser.stopEvent(_81);
if(!args.noClose){
dojo.dom.removeNode(_80);
this.hideOverlay();
}
args.onOk(_80);
}));
}
}else{
setTimeout(dojo.lang.hitch(this,function(){
dojo.dom.removeNode(_80);
this.hideOverlay();
args.onOk(_80);
}),args.autoCloseTime);
}
return _80;
},progressDialog:function(_82){
if(dojo.byId("xg_lightbox_alert")){
dojo.dom.removeNode(dojo.byId("xg_lightbox_alert"));
}
var _83=dojo.string.trim("                 <div class=\"xg_floating_module\" id=\"xg_lightbox_alert\">                     <div class=\"xg_floating_container xg_lightborder\">                         <div class=\"xg_module_head "+(_82.title?"":"notitle")+"\">                             "+(_82.title?"<h2>"+dojo.string.escape("html",_82.title)+"</h2>":"")+"                         </div>                         <div class=\"xg_module_body\">                             <p class=\"spinner\">"+_82.bodyHtml+"</p>                         </div>                     </div>                 </div>");
var _84=dojo.html.createNodesFromText(_83)[0];
this.showOverlay();
xg.append(_84);
this.fixDialogPosition(_84);
return {hide:dojo.lang.hitch(this,function(){
dojo.dom.removeNode(_84);
this.hideOverlay();
})};
},showDialogAndRedirect:function(_85){
if(dojo.byId("xg_lightbox_alert")){
dojo.dom.removeNode(dojo.byId("xg_lightbox_alert"));
}
var _86=dojo.string.trim("                 <div class=\"xg_floating_module\" id=\"xg_lightbox_alert\">                     <div class=\"xg_floating_container xg_lightborder\">                         <div class=\"xg_module_head "+(_85.title?"":"notitle")+"\">                             "+(_85.title?"<h2>"+dojo.string.escape("html",_85.title)+"</h2>":"")+"                         </div>                         <div class=\"xg_module_body\">                             <p>"+_85.bodyHtml+"</p>                         </div>                     </div>                 </div>");
var _87=dojo.html.createNodesFromText(_86)[0];
this.showOverlay();
xg.append(_87);
window.location=_85.target;
},confirm:function(_88){
_88.title=_88.title?_88.title:xg.shared.nls.text("confirmation");
_88.okButtonText=_88.okButtonText?_88.okButtonText:xg.shared.nls.text("ok");
if(!_88.cancelButtonText){
_88.cancelButtonText=xg.shared.nls.html("cancel");
}
_88.onOk=_88.onOk?_88.onOk:function(){
};
_88.onCancel=_88.onCancel?_88.onCancel:function(){
};
if(_88.bodyText){
_88.bodyHtml="<p>"+dojo.string.escape("html",_88.bodyText)+"</p>";
}
var _89=_88.wideDisplay?" xg_floating_container_wide":"";
var _8a=dojo.html.createNodesFromText(dojo.string.trim("                <div class=\"xg_floating_module\">                     <div class=\"xg_floating_container xg_lightborder"+_89+"\">                         <div class=\"xg_module_head\">                             <h2>"+((_88.titleHtml)?(_88.titleHtml):(dojo.string.escape("html",_88.title)))+"</h2>                         </div>                         <div class=\"xg_module_body\">                             <form>                                 <input type=\"hidden\" name=\"xg_token\" value=\""+xg.token+"\" />                                  "+_88.bodyHtml+"                                  <p class=\"buttongroup\">                                      <input type=\"submit\" class=\"button action-primary\" value=\""+dojo.string.escape("html",_88.okButtonText)+"\"/> "+(_88.extraButton&&_88.extraButton.title?"<a class=\"xj_custom action-secondary\" href=\"#\">"+_88.extraButton.title+"</a> ":"")+("<a class=\"xj_cancel action-secondary\" href=\"#\">"+_88.cancelButtonText+"</a>")+"</p>                             </form>                         </div>                     </div>                 </div>"))[0];
if(!_88.noOverlay){
this.showOverlay();
}
xg.append(_8a);
this.fixDialogPosition(_8a);
var _8b="<iframe id=\"confirm_iframe\" src=\"about:blank\" scrolling=\"no\" frameborder=\"0\" />";
var _8c=this.getPositionedAndSizedIframe(_8b,_8a).appendTo("body");
var _8d=function(){
dojo.dom.removeNode(_8c[0]);
};
this.applyStyleArgsToDialog(_88,_8a);
this.applyStyleArgsToDialog(_88,_8c,_8a);
xg.listen(xg.$(".xj_cancel",_8a),"onclick",this,function(_8e){
xg.stop(_8e);
xg.shared.util.hideOverlay();
_8d();
dojo.dom.removeNode(_8a);
if(_88.onCancel){
_88.onCancel(_8a);
}
});
if(_88.extraButton&&_88.extraButton.title){
xg.listen(xg.$(".xj_custom",_8a),"onclick",this,function(){
xg.shared.util.hideOverlay();
_8d();
dojo.dom.removeNode(_8a);
if(_88.extraButton.onClick){
_88.extraButton.onClick(_8a);
}
});
}
xg.listen(xg.$("form",_8a),"onsubmit",this,function(_8f){
xg.stop(_8f);
if(_88.closeOnlyIfOnOk){
if(_88.onOk(_8a)){
xg.shared.util.hideOverlay();
_8d();
dojo.style.hide(_8a);
}
}else{
xg.shared.util.hideOverlay();
_8d();
dojo.style.hide(_8a);
_88.onOk(_8a);
}
});
return _8a;
},getPositionedAndSizedIframe:function(_90,_91){
var _92=x$(".xg_floating_container",_91);
var _93=x$(_90).css({"position":"fixed","top":"50%","left":"50%","filter":"progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)","width":_92.outerWidth(),"height":_92.outerHeight()-2,"margin-left":-(_92.outerWidth()/2)+7,"margin-top":-(_92.outerHeight()/2),"z-index":_92.parent().css("z-index")-1});
return _93;
},dropdownMenu:function(_94){
var _95=_94.hideDelay?_94.hideDelay:1000;
var _96=x$(_94.srcNode);
var _97=x$(_94.menuNode);
if(_94.removeExisting){
x$(".dropdown_menu").remove();
}
_96.addClass("dropdown_link");
_97.addClass("xg_floating_container dropdown_menu");
if(!_96.find(".downarrow")[0]){
_96.append("<span class=\"downarrow xg_sprite xg_sprite-caret-down xg_lightborder\">&nbsp;</span>");
}
if(!_97.parent().is("body")){
_97.appendTo("body");
}
_97.hide();
var _98=function(_99){
if(_97[0].timer){
clearTimeout(_97[0].timer);
_97[0].timer=null;
}
if(_97.is(":visible")){
return;
}
x$(".dropdown_menu").hide();
var o=_96.offset();
_97.css({"z-index":"100","position":"absolute","top":(o.top+_96.outerHeight())+"px"});
if(_94.align=="right"){
_97.css({"right":(o.left+_96.width())+"px"});
}else{
_97.css({"left":o.left+"px"});
}
_97.show();
if(_99=="hover"){
_97.mouseout(function(_9b){
if(_9b.relatedTarget==_96[0]){
return;
}
this.timer=setTimeout(function(){
_97.hide();
},_94.hideDelay);
});
_97.mouseover(function(_9c){
if(this.timer){
clearTimeout(this.timer);
this.timer=null;
}
});
}
if(_99=="click"){
var _9d=true;
var _9e=function(_9f){
if(_9d){
_9d=false;
return;
}
var _a0=x$(_9f.target);
if(_a0.hasClass("dropdown_menu")||_a0.parents(".dropdown_menu")[0]){
return;
}
x$("body").unbind("click",_9e);
_97.hide();
};
x$("body").click(_9e);
}
};
if(_94.showOnClick){
_96.click(function(_a1){
_a1.preventDefault();
_98("click");
});
}
if(_94.showOnHover){
_96.mouseover(function(_a2){
_98("hover");
});
}
},applyStyleArgsToDialog:function(_a3,_a4,_a5){
var css=[];
var _a7=["position","top","left","bottom","right","margin-top","margin-left","margin-bottom","margin-right"];
if(_a5==null){
_a5=_a4;
}
var _a8=x$(".xg_floating_container",_a4);
for(var i=0;i<_a7.length;i++){
var _aa=_a7[i];
if(_a3[_aa]){
css[_aa]=typeof (_a3[_aa])=="function"?_a3[_aa](_a8):_a3[_aa];
}
}
x$(_a4).css(css);
},promptToJoin:function(_ab,_ac,_ad,_ae,_af,_b0){
if(typeof _ac=="function"){
_ad=_ac;
_ac=false;
}
if(_ac){
this.promptIsPending();
return;
}
if(this.joined||!_ab){
_ad();
return;
}
_b0=_b0||"signUp";
_af=_af||{title:xg.shared.nls.text("signIn"),onClick:dojo.lang.hitch(this,function(){
this.joined=true;
_ae();
})};
xg.shared.util.confirm({title:xg.shared.nls.text("joinNow"),bodyHtml:"<p>"+dojo.string.escape("html",_ab)+"</p>",okButtonText:xg.shared.nls.text(_b0),onOk:dojo.lang.hitch(this,function(){
this.joined=true;
_ad();
}),extraButton:_af});
},promptIsPending:function(){
xg.shared.util.alert({title:xg.shared.nls.text("pendingPromptTitle"),bodyHtml:"<p>"+xg.shared.nls.html("youCanDoThis")+"</p>"});
},selectOnClick:function(_b1){
dojo.event.connect(_b1,"onfocus",function(_b2){
dojo.html.selectInputText(_b1);
});
dojo.event.connect(_b1,"onclick",function(_b3){
dojo.html.selectInputText(_b1);
});
var _b4=_b1.value;
dojo.event.connect(_b1,"onkeyup",function(_b5){
dojo.html.selectInputText(_b1);
_b1.value=_b4;
});
},preventEnterFromSubmittingForm:function(_b6,_b7){
if(!_b7){
_b7=function(){
};
}
dojo.event.connect(_b6,"onkeydown",function(_b8){
if(_b8.keyCode==13){
dojo.event.browser.stopEvent(_b8);
_b7();
}
});
},setPlaceholder:function(_b9,_ba){
if(_b9.value!=""){
return;
}
_b9.value=_ba;
dojo.event.connect(_b9,"onfocus",function(_bb){
if(_b9.value==_ba){
_b9.value="";
}
});
dojo.event.connect(_b9,"onblur",function(_bc){
if(_b9.value==""){
_b9.value=_ba;
}
});
dojo.event.connect(_b9.form,"onsubmit",function(_bd){
if(_b9.value==_ba){
_b9.value="";
}
});
},createCsrfTokenHiddenInput:function(){
var _be=document.createElement("input");
_be.type="hidden";
_be.name="xg_token";
_be.value=xg.token;
return _be;
},crc32:function(_bf){
var _c0="00000000 77073096 EE0E612C 990951BA 076DC419 706AF48F E963A535 9E6495A3 0EDB8832 79DCB8A4 E0D5E91E 97D2D988 09B64C2B 7EB17CBD E7B82D07 90BF1D91 1DB71064 6AB020F2 F3B97148 84BE41DE 1ADAD47D 6DDDE4EB F4D4B551 83D385C7 136C9856 646BA8C0 FD62F97A 8A65C9EC 14015C4F 63066CD9 FA0F3D63 8D080DF5 3B6E20C8 4C69105E D56041E4 A2677172 3C03E4D1 4B04D447 D20D85FD A50AB56B 35B5A8FA 42B2986C DBBBC9D6 ACBCF940 32D86CE3 45DF5C75 DCD60DCF ABD13D59 26D930AC 51DE003A C8D75180 BFD06116 21B4F4B5 56B3C423 CFBA9599 B8BDA50F 2802B89E 5F058808 C60CD9B2 B10BE924 2F6F7C87 58684C11 C1611DAB B6662D3D 76DC4190 01DB7106 98D220BC EFD5102A 71B18589 06B6B51F 9FBFE4A5 E8B8D433 7807C9A2 0F00F934 9609A88E E10E9818 7F6A0DBB 086D3D2D 91646C97 E6635C01 6B6B51F4 1C6C6162 856530D8 F262004E 6C0695ED 1B01A57B 8208F4C1 F50FC457 65B0D9C6 12B7E950 8BBEB8EA FCB9887C 62DD1DDF 15DA2D49 8CD37CF3 FBD44C65 4DB26158 3AB551CE A3BC0074 D4BB30E2 4ADFA541 3DD895D7 A4D1C46D D3D6F4FB 4369E96A 346ED9FC AD678846 DA60B8D0 44042D73 33031DE5 AA0A4C5F DD0D7CC9 5005713C 270241AA BE0B1010 C90C2086 5768B525 206F85B3 B966D409 CE61E49F 5EDEF90E 29D9C998 B0D09822 C7D7A8B4 59B33D17 2EB40D81 B7BD5C3B C0BA6CAD EDB88320 9ABFB3B6 03B6E20C 74B1D29A EAD54739 9DD277AF 04DB2615 73DC1683 E3630B12 94643B84 0D6D6A3E 7A6A5AA8 E40ECF0B 9309FF9D 0A00AE27 7D079EB1 F00F9344 8708A3D2 1E01F268 6906C2FE F762575D 806567CB 196C3671 6E6B06E7 FED41B76 89D32BE0 10DA7A5A 67DD4ACC F9B9DF6F 8EBEEFF9 17B7BE43 60B08ED5 D6D6A3E8 A1D1937E 38D8C2C4 4FDFF252 D1BB67F1 A6BC5767 3FB506DD 48B2364B D80D2BDA AF0A1B4C 36034AF6 41047A60 DF60EFC3 A867DF55 316E8EEF 4669BE79 CB61B38C BC66831A 256FD2A0 5268E236 CC0C7795 BB0B4703 220216B9 5505262F C5BA3BBE B2BD0B28 2BB45A92 5CB36A04 C2D7FFA7 B5D0CF31 2CD99E8B 5BDEAE1D 9B64C2B0 EC63F226 756AA39C 026D930A 9C0906A9 EB0E363F 72076785 05005713 95BF4A82 E2B87A14 7BB12BAE 0CB61B38 92D28E9B E5D5BE0D 7CDCEFB7 0BDBDF21 86D3D2D4 F1D4E242 68DDB3F8 1FDA836E 81BE16CD F6B9265B 6FB077E1 18B74777 88085AE6 FF0F6A70 66063BCA 11010B5C 8F659EFF F862AE69 616BFFD3 166CCF45 A00AE278 D70DD2EE 4E048354 3903B3C2 A7672661 D06016F7 4969474D 3E6E77DB AED16A4A D9D65ADC 40DF0B66 37D83BF0 A9BCAE53 DEBB9EC5 47B2CF7F 30B5FFE9 BDBDF21C CABAC28A 53B39330 24B4A3A6 BAD03605 CDD70693 54DE5729 23D967BF B3667A2E C4614AB8 5D681B02 2A6F2B94 B40BBE37 C30C8EA1 5A05DF1B 2D02EF8D";
var n,x,crc=0;
crc=crc^(-1);
for(var i=0;i<_bf.length;i++){
n=(crc^_bf.charCodeAt(i))&255;
x="0x"+_c0.substr(n*9,8);
crc=(crc>>>8)^x;
}
crc=crc^(-1);
if(crc<0){
crc+=Math.pow(2,32);
}
return crc;
},cdn:function(url,_c6){
var _c7;
if(xg.useMultiCdn){
var _c8;
var _c9=url.match(/^https?:\/\/([^\/]+)([^?]+)?/);
if(_c9&&(_c9.length>1)){
fullHost=_c9[1];
var _ca=fullHost.split(".");
_c8=_ca[0];
}else{
_c8=xg.cdnDefaultPolicyHost;
}
var ext=false;
var _cc=_c9&&(_c9.length>2)?_c9[2]:url;
var _cd=_cc.match(/\.([^\/.]+)$/);
if(_cd&&(_cd.length>1)){
ext=_cd[1];
}
var _ce=[];
if(_c8 in xg.cdnPolicy){
for(var _cf in xg.cdnPolicy[_c8]){
var _d0=xg.cdnPolicy[_c8][_cf];
if(ext&&(_cf=="ext")&&dojo.lang.inArray(_d0[0],ext)){
_ce=_d0[1];
break;
}else{
if(_cf=="type"){
}else{
if(_cf=="default"){
_ce=_d0;
break;
}
}
}
}
}else{
_ce.push(xg.cdnHost);
}
var _d1=_ce.length;
var _d2;
if(_d1>1){
_d2=_ce[this.crc32(_cc)%_d1];
}else{
_d2=_ce[0];
}
_c7=url.match(/^https?:\/\//)?url.replace(/^https?:\/\/[^\/]+/,"http://"+_d2):"http://"+_d2+url;
_c7=_c7.replace(/\/xn_resources\/widgets/,"/"+xg.staticRoot+"/widgets");
_c7=_c7.replace(/\/xn_resources\//,"/"+ning.CurrentApp.id+"/");
}else{
_c7=url.replace(/.*\/xn_resources\/widgets(.*)/,(xg.cdnHost?("http://"+xg.cdnHost):xg.cdn)+"/"+xg.staticRoot+"/widgets"+"$1");
_c7=_c7.replace(/.*\/xn_resources(.*)/,(xg.cdnHost?("http://"+xg.cdnHost):xg.cdn)+"/"+ning.CurrentApp.id+"$1");
}
if(url!==_c7&&_c6!==false){
_c7=this.addParameter(_c7,"v",xg.version);
}
return _c7;
},getParameter:function(url,_d4){
var _d5=url.split("?",2);
if(_d5[1]){
var _d6=_d5[1].split("&");
for(var i=0;i<_d6.length;i++){
var _d8=_d6[i].split("=",2);
if(_d8[0]==_d4){
return _d8[1];
}
}
}
return null;
},removeParameter:function(url,_da){
var _db=url.split("?",2);
if(_db[1]){
var _dc=_db[1].split("&");
var _dd=[];
for(var i=0;i<_dc.length;i++){
var _df=_dc[i].split("=",2);
if(_df[0]!=_da){
_dd.push(_dc[i]);
}
}
if(_dd.length>0){
_db[1]=_dd.join("&");
return _db.join("?");
}else{
return _db[0];
}
}else{
return url;
}
},addParameter:function(url,_e1,_e2){
url=xg.shared.util.removeParameter(url,_e1);
var _e3=url.indexOf("?")>-1?"&":"?";
return url+_e3+encodeURIComponent(_e1)+"="+encodeURIComponent(_e2);
},parseFormattedNumber:function(_e4){
if(_e4){
var _e5=_e4.replace(/\D+/g,"");
return parseInt(_e5);
}
return NaN;
},formatNumber:function(_e6,_e7){
var sep=_e7||xg.num_thousand_sep||",";
if((_e6<1000)&&(_e6>-1000)){
return _e6+"";
}
var _e9=_e6<0;
_e6=Math.abs(_e6)+"";
var _ea=_e6.length;
var _eb=(3-(_ea%3))%3;
var _ec="";
for(i=0;i<_ea;i++){
_ec+=_e6.charAt(i);
_eb=(_eb+1)%3;
if((_eb==0)&&(i<_ea-1)){
_ec+=sep;
}
}
return _e9?"-"+_ec:_ec;
},createQuiescenceTimer:function(_ed,_ee){
var _ef=0;
return {trigger:function(){
_ef++;
var _f0=_ef;
window.setTimeout(function(){
if(_f0==_ef){
_ee();
}
},_ed);
}};
},setCookie:function(_f1,_f2,_f3,_f4){
var _f5=null;
if(_f3){
var now=new Date();
_f5=new Date();
var _f7=24*60*60*1000;
_f5.setTime(now.getTime()+(_f7*_f3));
}
document.cookie=encodeURIComponent(_f1)+"="+encodeURIComponent(_f2)+"; path=/"+(_f5?"; expires="+_f5.toGMTString():"")+(_f4?"; domain="+_f4:"");
},getCookie:function(_f8){
var _f9=document.cookie.indexOf(_f8+"=");
var len=_f9+_f8.length+1;
if((!_f9)&&(_f8!=document.cookie.substring(0,_f8.length))){
return null;
}
if(_f9==-1){
return null;
}
var end=document.cookie.indexOf(";",len);
if(end==-1){
end=document.cookie.length;
}
return decodeURIComponent(document.cookie.substring(len,end));
},postSynchronously:function(url,_fd){
_fd=_fd||{};
_fd.xg_token=xg.token;
var _fe=x$("<form method=\"post\"></form>").attr("action",url);
for(name in _fd){
_fe.append(x$("<input type=\"hidden\"/>").attr("name",name).attr("value",_fd[name]));
}
_fe.appendTo(document.body).submit();
},addHint:function(_ff,hint){
var _101=x$(_ff);
if(_101.attr("value")==""){
_101.attr("value",hint);
}
_101.focus(function(){
if(this.value==hint){
x$(this).attr("value","").removeClass("hint");
}
}).blur(function(){
if(this.value==""){
x$(this).attr("value",hint).addClass("hint");
}
});
},addHints:function(_102,_103,hint){
_103=_103||false;
hint=hint||"";
x$(_102).each(function(){
xg.shared.util.addHint(this,_103?x$(this).attr("_hint"):hint);
});
},setMaxLengthWithCount:function(_105,_106,_107,args){
if(_105&&_106){
if(!args){
args={};
}
var _109="enforceMaxLength" in args?args.enforceMaxLength:false;
var _10a="negativeCountClass" in args?args.negativeCountClass:"length-exceeded";
var _10b=("onNegative" in args)&&(typeof args.onNegative=="function")?args.onNegative:false;
var _10c=("onNonNegative" in args)&&(typeof args.onNonNegative=="function")?args.onNonNegative:false;
var _10d=("neverHideCount" in args)&&args.neverHideCount;
var _10e=function(_10f,_110,_111,_112,_113){
var _114=x$(_10f).val().length;
if(_112&&(_114>_111)){
x$(_10f).val(x$(_10f).val().substr(0,_111));
_114=_111;
}
if(_113.length>0){
if(_114>_111){
x$(_110).addClass(_113);
}else{
x$(_110).removeClass(_113);
}
}
var _115=parseInt(x$(_110).html());
var _116=_111-_114;
if((_115>=0)&&(_116<0)&&_10b){
_10b.call();
}else{
if((_115<0)&&(_116>=0)&&_10c){
_10c.call();
}
}
x$(_110).text(args.showCharsLabel?xg.shared.nls.text("nChars",_116):_116);
};
x$(_105).bind("keyup keypress blur cut paste change",function(_117){
var key=_117.which||_117.keyCode;
if(_109&&(x$(_105).val().length>=_107)&&(key!=8)){
_117.preventDefault();
}
_10e(_105,_106,_107,_109,_10a);
});
x$(_105).bind("focus",function(_119){
x$(_106).css("visibility","visible");
});
x$(_105).bind("blur",function(_11a){
if((x$(_105).val().length<_107)&&!_10d){
x$(_106).css("visibility","hidden");
}
});
}
},postSynchronously:function(url,_11c){
_11c=_11c||{};
_11c.xg_token=xg.token;
var form=x$("<form method=\"post\"></form>").attr("action",url);
for(name in _11c){
form.append(x$("<input type=\"hidden\"/>").attr("name",name).attr("value",_11c[name]));
}
xg.append(form[0]);
form[0].submit();
},track:function(_11e,page,_120,_121,_122,_123){
xn.track.pageView(10,_11e+"-"+page+"-"+_120+(_121?"-"+_121:""),_122,{},_123);
},clickTrack:function(){
var _124=x$(this).attr("_thriftkey").split("-");
var _125=x$(this).attr("href");
xg.shared.util.track(_124[0],_124[1],_124[2],_124[3],"",function(){
xg.shared.util.redirectToUrl(_125);
});
return false;
},redirectToUrl:function(url){
if(url!="#"){
window.location=url;
}
}};
}
if(!dojo.hostenv.findModule("xg.index.i18n",false)){
dojo.provide("xg.index.i18n");
dojo.lang.mixin(xg.index.i18n,{html:function(_1){
return this.text.apply(this,arguments).replace(/ & /g," &amp; ");
},text:function(_2){
var _3=this[_2]?this[_2]:_2,_4;
if("function"==typeof _3){
for(var i=1,_4=[];i<arguments.length;i++){
_4[i-1]=arguments[i];
}
return _3.apply(this,_4);
}else{
if("object"==typeof _3){
var _6="";
if(arguments.length>1&&_3[arguments[1]]){
_6=_3[arguments[1]];
}else{
var _7;
if(arguments.length>1){
_7=arguments[1];
}
var _8=xg.shared.nls.choosePluralizationForm.call(this,_7);
_6=_3[_8];
}
if(!_6){
if(window.console&&console.log){
console.log("Message not found for string \""+_2+"\" pluralization form \""+_8+"\"");
}
return "";
}
arguments[0]=_6;
return this.sprintf.apply(this,arguments);
}else{
arguments[0]=_3;
return this.sprintf.apply(this,arguments);
}
}
},sprintf:function(){
var _9=arguments[0];
for(var i=1;i<arguments.length;i++){
_9=_9.replace(/%s/,arguments[i]);
var _b=new RegExp("%"+i+"\\$s","g");
_9=_9.replace(_b,arguments[i]);
}
return _9;
}});
}
if(!dojo.hostenv.findModule("xg.shared.messagecatalogs.en_US",false)){
dojo.provide("xg.shared.messagecatalogs.en_US");
dojo.evalObjPath("xg.feed.nls",true);
dojo.lang.mixin(xg.feed.nls,xg.index.i18n,{edit:"Edit",title:"Title:",feedUrl:"URL:",show:"Show:",titles:"Titles Only",titlesAndDescriptions:"Detail View",display:"Display",cancel:"Cancel",save:"Save",loading:"Loading\u2026",items:"items"});
dojo.evalObjPath("xg.opensocial.nls",true);
dojo.lang.mixin(xg.opensocial.nls,xg.index.i18n,{edit:"Edit",title:"Title:",untitled:"Untitled",appUrl:"URL:",cancel:"Cancel",save:"Save",removeBox:"Remove Box",removeBoxText:function(_1){
return "<p>Are you sure you want to remove the \""+_1+"\" box from My Page?</p><p>You'll still be able to access this App from My Apps.</p>";
},removeApplication:"Remove App",removeApplicationText:"Are you sure you want to remove this App? It will no longer be accessible on your My Apps Page.",removeApplicationNetwork:"Remove Ning App",removeApplicationTextNetwork:"Are you sure you want to remove this Ning App? It will no longer be accessible on your Ning Network.",removeBoxAndRemoveApplication:"Remove Box / Remove App",removeBoxAndRemoveApplicationHelp:"<p>'Remove Box' will remove this App box from your profile page only.</p><p>'Remove App' will remove the App from your profile page and My Apps list.</p>",allowSendAlerts:"Send alerts to me and my friends",allowSendAlertsOnMain:"Send alerts to members",canAddActivities:"Add updates to Latest Activity",canAddActivitiesOnMain:"Add Updates to Latest Activity",applicationSettingsOnMain:"%1$s Settings",allowThisApplicationToOnMain:"Allow %1$s to:",addApplication:"Add App",addNingApp:"Add Ning App",yourApplicationIsBeingAdded:"Your App is being added.",yourNingAppIsBeingAdded:"Your Ning App is being added.",yourApplicationIsBeingRemoved:"Your App is being removed.",onlyEmailMsgSupported:"Only EMAIL message type is supported",msgExpectedToContain:"Message is expected to contain all fields: type, title and body",msgObjectExpected:"Message object expected",recipientsShdBeStringOrArray:"Recipients can only be a string (comma-separated list is ok) or an Array",recipientsShdBeSpecified:"Recipients should be specified and can not be empty",unauthorizedSender:"Unauthorized Sender: only logged-in members can send messages",unauthorizedRecipients:"Unauthorized recipients specified to send mail to",rateLimitExceeded:"Rate limit exceeded",operationCancelled:"Operation cancelled",youAreAboutToAdd:function(_2,_3){
return "<p>You are about to add <strong>"+_2+"</strong> to your My Page. This App was developed by a third party.</p><p>By clicking 'Add App' you agree to the <a "+_3+">Apps Terms of Use</a>.</p>";
},youAreAboutToAddNing:function(_4,_5){
return "<p>You are about to add <strong>"+_4+"</strong> to your My Page. This App was developed by Ning.</p><p>By clicking 'Add App' you agree to the <a "+_5+">Apps Terms of Use</a>.</p>";
},youAreAboutToAddNetwork:function(_6,_7){
return "<p>You are about to add <strong>"+_6+"</strong> to your Ning Network. This Ning App was developed by a third party.</p><p>By adding this Ning App to your Ning Network you are agreeing to share your information as well as the information of the members of your Ning Network with the third party who developed it.</p><p>By clicking 'Add Ning App' you agree to the <a "+_7+">Apps Terms of Use</a>.</p>";
},youAreAboutToAddNetworkNing:function(_8,_9){
return "<p>You are about to add <strong>"+_8+"</strong> to your Ning Network. This Ning App was developed by Ning.</p><p>By adding this Ning App to your Ning Network you are agreeing to share your information as well as the information of the members of your Ning Network with the third party who developed it.</p><p>By clicking 'Add Ning App' you agree to the <a "+_9+">Apps Terms of Use</a>.</p>";
},followingMessageWasSent:function(_a,_b,_c){
return "<p>Following message was sent to "+_a+". <blockquote><strong><em>"+_b+"</em></strong><br/>"+_c+"</blockquote></p>";
},reviewIsTooLong:function(_d,_e){
return "Your review is "+_d+" characters long.  The maximum is "+_e+".";
},mustSupplyRating:"Please supply a rating along with your review.",mustSupplyReview:"Your review must include some text.",messageWasNotSent:function(_f){
return "<p>Message was <strong>not</strong> sent because: <strong>"+_f+"</strong>.";
},settingIsDontSendMessage:"Message setting is set to \"Don't send messages\"",applicationSettings:"App Settings",messageSent:"Message Sent",messageNotSent:"Message Not Sent",allowThisApplicationTo:"Allow this App to:",updateSettings:"Save",isOnMyPage:"Add a box on My Apps Page",youNeedToAddEmailRecipient:"You need to add an email recipient.",yourMessageIsBeingSent:"Your message is being sent.",sendingLabel:"Sending...",deleteReview:"Delete Review",deleteReviewQ:"Delete review?",replaceReview:"Replace Review",replaceReviewQ:"You have already added a review.  Would you like to replace the existing review?","delete":"Delete",thereHasBeenAnError:"There has been an error",whatsThis:"What's This?",hideThisApp:"Hide App from Directory",blacklistConfirmation:"This App will be hidden from the directory, and will be removed from all member profile pages.",addToProfilePages:"Display on members' My Apps pages",visibleToMembers:"Be visible to members on the Main Page",searchNingApps:"Search Ning Apps",youveReachedMaxApps:"You've reached the maximum number of %1$s Apps you can add to your My Apps page.  Please <a %2$s>remove an App</a> to add a new one.",maxNingAppsReached:"You've reached the maximum number of Ning Apps you can add to your Ning Network. Remove a Ning App to add a new one, or browse the <a %1$s>Ning App Directory</a>."});
dojo.evalObjPath("xg.opensocialapps.nls",true);
dojo.lang.mixin(xg.opensocialapps.nls,xg.index.i18n,{change:"Change",save:"Save",deleteApplication:"Delete Application",deleteFeature:"Delete Feature",deleteApplicationText:"Are you sure you want to delete this application? It will automatically be removed for all users who added this application. Would you like to continue?",takeOffline:"Take Application Offline",takeOfflineText:"Are you sure you want to take this application offline? It will automatically be removed for all users who added this application. Would you like to continue?",dontRecommendApp:"Don't Recommend App",recommendApp:"Recommend App",staffPickApp:"Staff Pick App",dontStaffPick:"Don't Staff Pick App",areYouSure:"Are you sure?"});
dojo.evalObjPath("xg.forum.nls",true);
dojo.lang.mixin(xg.forum.nls,xg.index.i18n,{items:"items",numberOfCharactersExceedsMaximum:function(n,_11){
return "The number of characters ("+n+") exceeds the maximum ("+_11+")";
},pleaseEnterFirstPost:"Please write the first post for the discussion",pleaseEnterTitle:"Please enter a title for the discussion",warnLostChanges:"Any text you've added to your discussion will be lost.",save:"Save",cancel:"Cancel",yes:"Yes",no:"No",edit:"Edit",ok:"OK",deleteCategory:"Delete Category",discussionsWillBeDeleted:"The discussions in this category will be deleted.",whatDoWithDiscussions:"What would you like to do with the discussions in this category?",moveDiscussionsTo:"Move discussions to:",deleteDiscussions:"Delete discussions","delete":"Delete",deleteReply:"Delete Reply",deleteReplyQ:"Delete this reply?",deletingReplies:"Deleting Replies\u2026",doYouWantToRemoveReplies:"Do you also want to remove the replies to this comment?",pleaseKeepWindowOpen:"Please keep this browser window open while processing continues. It may take a few minutes.",contributorSaid:function(x){
return x+" said:";
},display:"Display",from:"From",show:"Show",htmlCharacters:"HTML Characters",view:"View",discussions:"discussions",discussionsFromACategory:"Discussions from a category\u2026",MaxCategoryNotificationTitle:"Maximum limit reached",MaxCategoryNotificationMsg:"Sorry, you can create up to %s categories only."});
dojo.evalObjPath("xg.groups.nls",true);
dojo.lang.mixin(xg.groups.nls,xg.index.i18n,{pleaseChooseAName:"Please choose a name for your group.",pleaseChooseAUrl:"Please choose a web address for your group.",urlCanContainOnlyLetters:"The web address can contain only letters and numbers (no spaces).",descriptionTooLong:function(n,_14){
return "The length of your group's description ("+n+") exceeds the maximum ("+_14+")";
},nameTaken:"Our apologies - that name has already been taken. Please choose another name.",urlTaken:"Our apologies - that web address has already been taken. Please choose another web address.",edit:"Edit",from:"From",show:"Show",groups:"groups",pleaseEnterName:"Please enter your name",pleaseEnterEmailAddress:"Please enter your email address",xIsNotValidEmailAddress:function(x){
return x+" is not a valid email address";
},save:"Save",cancel:"Cancel"});
dojo.evalObjPath("xg.html.nls",true);
dojo.lang.mixin(xg.html.nls,xg.index.i18n,{contentsTooLong:function(_16){
return "You've exceeded the maximum number of characters this Text Box can support. Please remove "+_16+" characters.";
},tooManyEmbeds:function(_17,_18,_19){
return "You can only place "+_17+" widget"+((_17>1)?("s"):(""))+" in a Text Box. Please remove "+_18+" widget"+((_18>1)?("s"):(""))+". <a "+_19+">Learn more</a>.";
},edit:"Edit",wereSorry:"We're Sorry",save:"Save",cancel:"Cancel",saving:"Saving\u2026"});
dojo.evalObjPath("xg.index.nls",true);
dojo.lang.mixin(xg.index.nls,xg.index.i18n,{disable:"Disable",disableSignInSignUpWithX:function(_1a){
return "Disable Sign in/Sign up with "+_1a;
},NMembersHaveConnectedOnXWithY:function(_1b,_1c,_1d){
return _1b+" "+((_1b>1)?("members have connected their profiles on "):("member has connected their profile on "))+_1c+" to their "+_1d+" account, and may no longer be able to sign in.";
},thereWasAnErrorUpdatingFacebook:"There was an error saving your Facebook credentials. Please try again.",thereWasAnErrorUpdatingTwitter:"There was an error saving your Twitter credentials. Please try again.",pleaseEnterAnApplicationIDToContinue:"Please enter an Application ID to continue",pleaseEnterAnAPIKeyToContinue:"Please enter an API Key to continue",pleaseEnterAnApplicationSecretToContinue:"Please enter an Application Secret to continue",pleaseEnterAKeyToContinue:"Please enter a Key to continue",pleaseEnterASecretToContinue:"Please enter a Secret to continue",enableSocialSignIn:"Enable Social Sign-In",makeItEvenEasier:"Make it even easier for your members to sign up and sign in by enabling Social Sign-In. Allow members to access your Ning network by using:",facebook:"Facebook",google:"Google",yahoo:"Yahoo",readMoreOrGet:"<a %1$s>Read more</a> or get started now.",getStarted:"Get Started",addMedia:"Add Media",pasteEmbedCodeFrom:"Paste embed code from Youtube, etc. below:",insertPlainText:"Insert Plain Text",pasteTextFromWord:"Paste text from Word, a website, etc. below to remove all formatting:",addLink:"Add Link",editLink:"Edit Link",linkText:"Link Text",linkUrl:"Link Url",openInColon:"Open in:",sameWindow:"Same Window",newWindow:"New Window",clickHereToDownload:"Click here to download",anErrorHasOccurred:"An error has occurred. Please try again.",exporting:"Exporting\u2026",exportingXofY:function(x,y){
return "Exporting "+x+" of "+y+"\u2026";
},onlyNCMayExport:"Only the network creator may export content.",contentExportIsEmpty:"No %1$s were downloaded because your Ning Network does not have any %1$s.",learnMore:"Learn More",introducingNingApi:"Introducing the Ning API",ningPlatformOpen:"Ning's Platform is now open for you to take your Ning Network everywhere:",createCustomMobile:function(x){
return "Create custom mobile applications with <a "+x+">support from Ning's partners</a>.";
},integrateYourNetwork:function(x){
return "Integrate your network into external applications with <a "+x+">documentation support</a>.";
},startNowApi:function(x){
return "Start now in the new <a "+x+">Ning API</a> section of your dashboard. All API usage is free for Pro Networks until the end of 2010.";
},setUp:"Set Up",dismiss:"Dismiss",remindLater:"Remind me later",connectedAsName:"Connected as %1$s.",creatingFacebookApp:"Creating Facebook App\u2026",wereSorryExclamation:"We\u2019re Sorry!",enterLinkUrl:"Enter a link URL:",sent:"Sent",messageHasBeenSent:"The message has been sent to %1$s.",pleaseEnterYourFullName:"Please enter your full name.",pleaseEnterAValidEmailAddress:"Please enter a valid email address.",pleaseChooseACountry:"Please choose a country.",pleaseChooseACategoryForYourNetwork:"Please choose a category for your network.",richText:"Rich Text",source:"Source",htmlSource:"HTML",toggleBold:"Toggle Bold",toggleItalic:"Toggle Italic",toggleUnderline:"Toggle Underline",justifyLeft:"Justify Left",justifyCenter:"Justify Center",justifyRight:"Justify Right",toggleStrikethrough:"Toggle Strikethrough",indentLeft:"Indent Left",indentRight:"Indent Right",insertHorizontalRule:"Insert Horizontal Rule",insertOrderedList:"Insert Ordered List",insertUnorderedList:"Insert Unordered List",insertImage:"Insert Image",attachFile:"Attach File",createLink:"Create Link",removeLink:"Remove Link",removeFormatting:"Remove Formatting",warnLostChanges:"Any text you've added to your broadcast message will be lost.",warnLostTermsChanges:"Any text you've changed in your custom Terms of Service will be lost.",xxSmall:"XX-Small",xSmall:"X-Small",small:"Small",medium:"Medium",large:"Large",xLarge:"X-Large",xxLarge:"XX-Large",error:"Error",processingFailed:"Sorry, processing failed. Please try again later.",saveChanges:"Save Changes?",doYouWantToSaveChanges:"Do you want to save your changes?",discard:"Discard",onlyNWords:"Only %1$s words are allowed in the Keywords field.",youCannotEnter:"You cannot enter more than %1$s characters",messageCannotBeMore:"Your message cannot be more than %1$s characters.",pleaseEnterMessage:"Please enter a message body.",subjectCannotBeMore:"Your subject cannot be more than %1$s characters.",pleaseEnterSubject:"Please enter a subject.",warning:"Warning",customCssWarning:"Any CSS you've added on the Advanced tab will be removed if you change themes.",yes:"Yes",edit:"Edit",save:"Save",done:"Done",badgeSize:"Badge Size",size:"Size",changesSaved:"Your changes have been successfully saved.",tweetsFromThisNetwork:"Tweets from this network will now indicate they are from the Application Name you specified.",connectToTwitter:"Connect to Twitter",connect:"Connect",toPostUpdates:"To post updates on Twitter, you must connect your profile on %s to Twitter.",postToTwitter:"Post to Twitter",postHasBeenSent:"Your post has been sent!",postTooLong:"Your post cannot be over %1$s characters",postCannotBeEmpty:"You need to add text to post an update.",problemConnectingTwitter:"Our apologies - there was a problem connecting to Twitter. Please try again later.",post:"Post",overwriteSitemap:"Automatically updating your sitemap will overwrite your current one.",pleaseAddProfilePhoto:"Please add a profile photo.",yourMessageIsBeingSent:"Your message is being sent.",thankYouQuestionSent:"Thank you, your question has been sent to the administrator of %1$s.",youNeedToAddEmailRecipient:"You need to add an email recipient.",checkPageOut:function(_23){
return "Check out this page on "+_23;
},checkingOutTitle:function(_24,_25){
return "Check out \""+_24+"\" on "+_25;
},selectOrPaste:"You need to select a video or paste the 'embed' code",selectOrPasteMusic:"You need to select a song or paste the URL",cannotKeepFiles:"You will have to choose your files again if you wish to view more options. Would you like to continue?",pleaseSelectPhotoToUpload:"Please select a photo to upload.",addingLabel:"Adding...",sendingLabel:"Sending...",addingInstructions:"Please leave this window open while your content is being added.",looksLikeNotImage:"One or more files do not seem to be in .jpg, .gif, or .png format. Would you like to try uploading anyway?",looksLikeNotVideo:"The file you selected does not seem to be in .mov, .mpg, .mp4, .avi, .3gp, .3g2 or .wmv format. Would you like to try uploading anyway?",looksLikeNotMusic:"The file you selected does not seem to be in .mp3 format. Would you like to try uploading anyway?",showingNFriends:{"f1":"Showing 1 friend matching %2$s. <a href=\"#\">Show everyone</a>","f2":"Showing %1$s friends matching \"%2$s\". <a href=\"#\">Show everyone</a>"},sendInvitation:"Send Invitation",sendMessage:"Send Message",latestActivityShowsAllTheActivityHappening:"Latest Activity shows all the activity happening on your Ning Network right now. Still want to remove it?",sendInvitationToNFriends:{"f1":"Send invitation to 1 friend?","f2":"Send invitation to %s friends?"},sendMessageToNFriends:{"f1":"Send message to 1 friend?","f2":"Send message to %s friends?"},nFriendsSelected:{"f1":"1 friend selected","f2":"%s friends selected"},nInvitesLeftToday:{"f1":"1 invite left today","f2":"%s invites left today"},nInvitesLeftThisMonth:{"f1":"1 invite left this month","f2":"%s invites left this month"},nSharesLeftToday:{"f1":"1 share left today","f2":"%s shares left today"},nSharesLeftThisMonth:{"f1":"1 share left this month","f2":"%s shares left this month"},yourMessageOptional:"<label>Your Message</label> (Optional)",subjectIsTooLong:function(n){
return "Your subject is too long. Please use "+n+" characters or less.";
},messageIsTooLong:function(n){
return "Your message is too long. Please use "+n+" characters or less.";
},tooManyInvites:"Too Many Invitations",onlyFirstNInvitesSent:{"f1":"You only have 1 invite remaining \u2014 this will send an invitation to the first recipient.","f2":"You only have %1$s invites remaining \u2014 this will send invitations to the first %1$s recipients."},tooManyPeopleSelected:"Too Many People Selected",invitedXButHaveYleft:"Sorry! You tried to send %1$s invites. That would put you over the limit of %2$s invitations for the month.",upgradeToMforNinvites:"<a %1$s><b>Upgrade to %2$s</b></a> to invite up to %3$s people every month.",pleaseChoosePeople:"Please choose some people to invite.",noPeopleSelected:"No People Selected",pleaseEnterEmailAddress:"Please enter your email address.",pleaseEnterPassword:function(_28){
return "Please enter your password for "+_28+".";
},sorryWeDoNotSupport:"Sorry, we don't support the web address book for your email address. Try clicking 'Address Book Application' below to use addresses from your computer.",pleaseSelectSecondPart:"Please select the second part of your email address, e.g., gmail.com.",atSymbolNotAllowed:"Please ensure that the @ symbol is not in the first part of the email address.",resetTextQ:"Reset Text?",resetTextToOriginalVersion:"Are you sure you wish to reset all of your text to the original version? All of your changes will be lost.",changeQuestionsToPublic:"Change questions to public?",changingPrivateQuestionsToPublic:"Changing private questions to public will expose all members' answers. Are you sure?",saveProfileQuestions:"Save Profile Questions?",areYouSureYouWantToDeleteQuestions:"Deleting profile questions or modifying answer types will remove the existing answers from member profiles. Do you want to continue?",pleaseEnterASiteName:"Please enter a name for the Ning Network, e.g. Paris Cyclists",pleaseEnterShorterSiteName:"Please enter a shorter name (max 64 characters)",thereIsAProblem:"There is a problem with your information",thisSiteIsOnline:"This Ning Network is Online",online:"<strong>Online</strong>",onlineSiteCanBeViewed:"<strong>Online</strong> - This Ning Network can be viewed with respect to your privacy settings. ",takeOffline:"Take Offline",thisSiteIsOffline:"This Ning Network is Offline",offline:"<strong>Offline</strong>",offlineOnlyYouCanView:"<strong>Offline</strong> - Only you can view this Ning Network.",takeOnline:"Take Online",basicTheme:"Basic Theme",allOptions:"All Options",addYourOwnCss:"Advanced",canBeSelectedOnlyOnce:function(_29){
return _29+" can be selected as an 'Answer Type' only once";
},pleaseEnterTheChoicesFor:function(_2a){
return "Please enter the choices for \""+_2a+"\" e.g. Hiking, Reading, Shopping";
},pleaseEnterTheChoices:"Please enter the choices e.g. Hiking, Reading, Shopping",bannedPasswordStrings:function(){
return ["password","passphrase","passwd","pass word","pass-word","pass phrase","pass-phrase"].join("|");
},wereSorry:"We're Sorry",youCantSendMessageUntilFriend:"You can't send a message until %s accepts your friend request.",pleaseRemoveQuestionsAskingForPasswords:"Please remove questions asking for passwords from your members.",upToTenProfileQuestions:"You can only select up to 10 profile questions for advanced search. Uncheck other questions to change which questions are added to advanced search.",upToNProfileQuestions:function(n){
return "You can only have up to "+n+" profile questions.";
},email:"email",subject:"Subject",message:"Message",send:"Send",cancel:"Cancel",areYouSureYouWant:"Are you sure you want to do this?",processing:"Processing\u2026",pleaseKeepWindowOpen:"Please keep this browser window open while processing continues. It may take a few minutes.",complete:"Complete!",processIsComplete:"Process is complete.",ok:"OK",body:"Body",pleaseEnterASubject:"Please enter a subject",pleaseEnterAMessage:"Please enter a message",pleaseChooseFriends:"Please select some friends before sending your message.",thereHasBeenAnError:"There has been an error",thereWasAProblem:"There was a problem adding your content. Please try again later.",fileNotFound:"File not found",pleaseProvideADescription:"Please provide a description",pleaseEnterSomeFeedback:"Please enter some feedback",title:"Title:",copyHtmlCode:"Copy HTML Code",change:"Change",changing:"Changing...",htmlNotAllowed:"HTML not allowed",noFriendsFound:"No friends found that match your search.",yourSubject:"Your Subject",yourMessage:"Your Message",pleaseEnterFbApiKey:"Please enter your Facebook API key.",pleaseEnterValidFbApiKey:"Please enter a valid Facebook API key.",pleaseEnterFbApiSecret:"Please enter your Facebook API secret.",pleaseEnterValidFbApiSecret:"Please enter a valid Facebook API secret.",pleaseEnterFbTabName:"Please enter a name for your Facebook application tab.",pleaseEnterValidFbTabName:function(_2c){
return "Please enter a shorter name for your Facebook application tab.  The maximum length is "+_2c+" character"+(_2c==1?"":"s")+".";
},newTab:"New Tab",resetToDefaults:"Reset to Defaults",youNaviWillbeRestored:"Your navigation tabs will be restored to the default setting.",hiddenWarningTop:"This tab has not been added to your Ning Network. There is a limit of %1$s top-level tabs. Please remove top-level tabs or make top-level tabs into sub-tabs. %2$s",hiddenWarningSub:function(n){
return "This sub-tab has not been added to your Ning Network. There is a limit of "+n+" sub-tabs per top-level tab. "+"Please remove sub-tabs or make sub-tabs into top-level tabs.";
},removeConfirm:"Removing this tab will remove its sub-tabs as well. Click OK to continue.",no:"No",youMustSpecifyTabName:"You must specify a tab name",networkPrivacyChangeTitle:"Change Privacy",confirmNetworkPrivacyChange:"Are you sure you want to change the privacy settings of your Ning Network?",orWriteYourOwnMessage:"\u2026or write your own message",youCanOnlyAddUpToNContentItems:"You can only add %1$s content items.",add:"Add",addAContentItem:"Add a Content Item",enterTheUrlOfASpecific:"Enter the URL of a specific discussion, forum category, video, photo, note, event, page or group for this role to administer:",unsupportedUrl:"Unsupported URL",removeUserFromRole:"Remove Member from Role?",areYouSureRemoveUser:"Are you sure you want to remove %1$s from this role?",areYouSureRemoveInvite:"Are you sure you want to cancel the invitations sent to the selected member(s)?",noContentItemFoundAtUrl:"No content item was found at that URL.",totalColonN:"Total: %1$s",fileIsTooLarge:"This file is too large.",fileIsZeroBytes:"This file is 0 bytes.",fileTypeIsInvalid:"This file type is invalid.",reachedUploadLimit:"You have reached the upload limit.",youHaveUnsavedChanges:"You have unsaved changes. Are you sure you want to navigate away?",selectedTooManyFiles:{"f1":"You have selected too many files. You may select up to 1 file to upload at once.","f2":"You have selected too many files. You may select up to %s files to upload at once."},didNotSelectAnyFiles:"You did not select any files to upload.",sorryUploadsFailed:"Sorry uploads failed",failedToUploadFiles:"We tried to upload the file(s) you selected, but encountered errors. Please try again.",uploadedFilesButErrors:"We have uploaded your files, but encountered errors with the following:",editDetailsForSuccessfulUploads:"You may want to go back and try these files again later. You will now be taken to a page to edit your successfully uploaded files.",overCustomCssSizeLimit:"Hey There! You are %1$s characters over the maximum number of CSS characters that this Ning Network can support and still be speedy. Reduce the size of your custom CSS or contact the <a %2$s>Ning Help Center</a> for assistance.",careful:"Careful!",youreGettingCloseToTheMaximum:"You're getting close to the maximum of %1$s features you can add to your Main Page.",youveReachedTheMaximumNumberOfFeatures:"You've reached the maximum of %1$s features you can add to your Main Page.",youveExceededTheMaximumNumberOfEmbeds:"You've exceeded the maximum of %1$s widgets on your Main Page. Please remove %2$s of your %3$s widgets.",learnMoreAboutEmbeds:"<a %1$s>Learn more about how widgets can slow down your Main Page.</a>",justRemoveAFeature:"Just remove a feature to add something new.",withXFeaturesYouveExceeded:"With %1$s features, you've exceeded the maximum of %2$s features you can add to your Main Page.",justRemoveXFeatures:"Just remove %1$s features to add something new.",youveReachedTheMaximumNumberOfNingApps:"You've reached the maximum number of Ning Apps you can add to your Ning Network.  Remove a Ning App to add a new one.",frameBustingMsg:"If you're trying to set up your own domain for your Ning Network, please <a %1$s>click here</a> for more information on how to set it up properly. Or, <strong><a %2$s>click here to go to the original site</a></strong>.",frameBustingMsgTitle:"We're sorry, this site can't be embedded in a frame.",memberPickerSearchSparseText:"There are no member with the name \"%1$s\".",memberPickerFriendsSparseText:"You haven't made any friends yet. Try viewing all members instead.",memberPickerSparseText:"There are no members to display",softBlockMessagingForComments:"You have exceeded the maximum number of posts allowed, and you cannot post a new comment right now. Please try again in a few hours.",softBlockMessagingForNewContent:"You have exceeded the maximum number of posts allowed, and you cannot post new content right now. Please try again in a few hours.",showMore:"Show More",showLess:"Show Less",invalidCustomURL:"A Custom URL may not contain \"?\" or \".\"",theFileCouldNotBeDeleted:"The file could not be deleted.",theSplashPageCouldNotBeSet:"The splash page could not be set.",theSplashPageCouldNotBeCleared:"The splash page could not be cleared.",customizeLink:"Customize Link",deleteThisFile:"Are you sure you want to delete this file?",newHomepageVisit:"This file is now your homepage. To check it out, go to <a %1$s>%2$s</a>",defaultHomepageRestored:"Your default homepage has been restored.",addConsumer:"Create Key",renameConsumer:"Edit Key",deleteConsumer:"Revoke Key",revoke:"Revoke",deleteConsumerConfirm:"Are you sure you want to revoke this API key? Any members who are currently using %1$s will lose access to it.",pleaseEnterAName:"Please enter a name"});
dojo.evalObjPath("xg.music.nls",true);
dojo.lang.mixin(xg.music.nls,xg.index.i18n,{play:"play",error:"Error",pleaseSelectTrackToUpload:"Please select a song to upload.",pleaseEnterTrackLink:"Please enter a song URL.",thereAreUnsavedChanges:"There are unsaved changes.",processingFailed:"Sorry, processing failed. Please try again later.",autoplay:"Autoplay",showPlaylist:"Show Playlist",playLabel:"Play",url:"URL",rssXspfOrM3u:"rss, xspf, or m3u",save:"Save",cancel:"Cancel",customizePlayerColors:"Customize Colors",edit:"Edit",shufflePlaylist:"Shuffle Playlist",fileIsNotAnMp3:"One of the files does not seem to be an MP3. Try uploading it anyway?",entryNotAUrl:"One of the entries does not appear to be a URL. Make sure all entries start with <kbd>http://</kbd>"});
dojo.evalObjPath("xg.page.nls",true);
dojo.lang.mixin(xg.page.nls,xg.index.i18n,{numberOfCharactersExceedsMaximum:function(n,_2f){
return "The number of characters ("+n+") exceeds the maximum ("+_2f+")";
},pleaseEnterContent:"Please enter the page content",pleaseEnterTitle:"Please enter a title for the page",pleaseEnterAComment:"Please enter a comment",save:"Save",cancel:"Cancel",edit:"Edit",close:"Close",displayPagePosts:"Display Page Posts",directory:"Directory",displayTab:"Display tab",addAnotherPage:"Add Another Page",tabText:"Tab text",urlDirectory:"URL directory",displayTabForPage:"Whether to display a tab for the page",tabTitle:"Tab Title",remove:"Remove",thereIsAProblem:"There is a problem with your information"});
dojo.evalObjPath("xg.photo.nls",true);
dojo.lang.mixin(xg.photo.nls,xg.index.i18n,{random:"Random",loop:"Loop",untitled:"Untitled",photos:"Photos",edit:"Edit",photosFromAnAlbum:"Albums",show:"Show",rows:"rows",cancel:"Cancel",customizePlayerColors:"Customize Colors",save:"Save",numberOfCharactersExceedsMaximum:function(n,_31){
return "The number of characters ("+n+") exceeds the maximum ("+_31+")";
},pleaseSelectPhotoToUpload:"Please select a photo to upload.",importingNofMPhotos:function(n,m){
return "Importing <span id=\"currentP\">"+n+"</span> of "+m+" photos.";
},enterAlbumTitle:"Please enter a title for the album",enterPhotosTitle:"Please enter titles for the photos",starting:"Starting\u2026",done:"Done!",from:"From",display:"Display",takingYou:"Taking you to see your photos\u2026",anErrorOccurred:"Unfortunately an error occurred. Please report this issue using the link at the bottom of the page.",weCouldntFind:"We couldn't find any photos! Why don't you try one of the other options?",wereSorry:"We're Sorry",makeThisTheAlbumCover:"Make this the album cover",thisIsTheAlbumCover:"This is the album cover"});
dojo.evalObjPath("xg.activity.nls",true);
dojo.lang.mixin(xg.activity.nls,xg.index.i18n,{edit:"Edit",show:"Show",events:"events",setWhatActivityGetsDisplayed:"Set what activity gets displayed",save:"Save",cancel:"Cancel"});
dojo.evalObjPath("xg.profiles.nls",true);
dojo.lang.mixin(xg.profiles.nls,xg.index.i18n,{select:"Select:",wereSorryExclamation:"We\u2019re Sorry!",problemOccurred:"A problem occurred. Please try again.",close:"Close",shortenUrl:"Shorten URL",connectToTwitter:"Connect to Twitter",toPostStatus:"To post your Status updates on Twitter, you must connect your profile on %s to Twitter.",addTwitterAccount:"Add Twitter Account",toConnectTwitterAccount:"To connect a new account to Twitter, sign out of Twitter, then click the \"Connect\" button below. Then, sign in with the credentials for the new account.",connect:"Connect",youAreConnectedAsX:"You are connected as %s",youAreConnectedAsFanPage:"You are connected as the %s Facebook Page",ageMustBeAtLeast0:"Age must be at least zero",wereSorryProper:"We're Sorry",pleaseEnterSubject:"Please enter a subject.",messageIsTooLong:function(n){
return "Your message is too long. Please use "+n+" characters or less.";
},comments:"comments",requestLimitExceeded:"Friend Request Limit Exceeded",removeFriendTitle:function(_35){
return "Remove "+_35+" As Friend?";
},removeFriendConfirm:function(_36){
return "Are you sure you want to remove "+_36+" as a friend?";
},pleaseEnterValueForPost:"Please add some text to the body of the post",postTooLong:"Please limit your blog post to %1$s characters",edit:"Edit",selectCredits:"Please select how many credits you would like.",recentlyAdded:"Recently Added",featured:"Featured",iHaveRecentlyAdded:"I've Recently Added",fromTheSite:"From the Ning Network",cancel:"Cancel",save:"Save",loading:"Loading\u2026",pleaseEnterPostBody:"Please enter something for the post body",pleaseEnterChatter:"Please enter something for your comment",warnLostChanges:"Any text you've added to your blog post will be lost.",letMeApproveChatters:"Let me approve comments before posting?",noPostChattersImmediately:"No \u2013 post comments immediately",yesApproveChattersFirst:"Yes \u2013 approve comments first",memberHasChosenToModerate:function(_37){
return _37+" has chosen to moderate comments.";
},reallyDeleteThisPost:"Really delete this post?",commentWall:"Comment Wall",commentWallNComments:{"f1":"Comment Wall (1 comment)","f2":"Comment Wall (%s comments)"},statusTooLong:function(_38){
return "Your status cannot be over "+_38+" characters.";
},statusCannotBeEmpty:"You need to add text to post an update.",errorUpdatingStatus:"An error occurred while updating your status. Please try again later.",statusHintTooLong:"Please limit your Status update prompt to be under %1$s characters.",youPostedY:"You posted '%1$s'",linkHasBeenPosted:"The link has been posted to Latest Activity",commentTooLong:"Your comment cannot be over %1$s characters.",display:"Display",from:"From",show:"Show",rows:"rows",posts:"posts",htmlCharacters:"HTML Characters",networkError:"Error",wereSorry:"We're sorry, but we are unable to save your new layout at this time. This is likely due to a lost Internet connection. Please check your connection and try again.",returnToDefaultWarning:"This will move all features on your My Page back to the default settings. Would you like to proceed?",unableToCompleteAction:"Sorry, we were unable to complete your last action. Please try again later.",selectAtLeastOneMessage:"Sorry, you have to select at least one message to perform that action.",selectedSendersBlocked:{"f1":"The selected sender has been blocked.","f2":"The selected senders have been blocked."},bulkConfirm_blockSender:"This will block the senders of the checked messages.",bulkConfirm_delete:"This will delete the checked messages.",sendingHeader:"Sending message",sendingLabel:"Sending ...",messageSent:"Message Sent",yourMessageHasBeenSent:"Your message has been sent!",nameIsEmpty:"Please enter your name.",countryIsEmpty:"Please enter your country.",zipIsEmpty:"Please enter your zip code.",zipIsIncorrect:"Please enter a valid zip code.",locationIsEmpty:"Please enter your city/state.",birthdays:"birthdays",deleteMessage:"Are you sure you want to delete the selected message?",deleteMessages:function(n){
return "Are you sure you want to delete the "+n+" selected messages?";
},blockSender:"Are you sure you want to block the selected member?",blockSenders:function(n){
return "Are you sure you want to block the "+n+" selected members?";
}});
dojo.evalObjPath("xg.shared.nls",true);
dojo.lang.mixin(xg.shared.nls,xg.index.i18n,{fileDoesNotSeem:"The file does not seem to be in .jpg, .gif, or .png format. Would you like to try uploading it anyway?",unsavedChanges:"You have unsaved changes.",areYouSure:"Are You Sure?",pasteText:"Paste as Plain Text",noFileAtUrl:"There is no file at that URL. Please try again.",edit:"Edit","delete":"Delete",uploadFileAnyType:"Upload a file of any type. The file will appear as a link.",linkUrl:"Link URL",title:"Title",uploadFile:"Upload File",media:"Media",file:"File",image:"Image",url:"URL",padding:"Padding",fromMyComputer:"From my computer",fromUrl:"From a URL",link:"Link",linkColon:"Link:",imageColon:"Image:",width:"Width",layout:"Layout",addImage:"Add Image",font:"Font",size:"Size",color:"Color",blockquote:"Blockquote",unorderedList:"Unordered list",orderedList:"Ordered list",removeFormatting:"Remove formatting",addColon:"Add:",visualMode:"Visual Mode",htmlEditor:"HTML Editor",fullscreen:"Fullscreen",returnToNormalSize:"Return to normal size",returnToVisualMode:"Return to Visual Mode",reasonColon:"Reason:",spam:"Spam",contentHasBeenFlagged:"This content has been flagged",contentHasBeenUnFlagged:"The content has been restored",porn:"Sexual Content",illegal:"Illegal",flag:"Flag",inappropriate:"Inappropriate",toPostToTwitter:"To post to Twitter, please add some text",error:"Error",friendLimitExceeded:"Friend Limit Exceeded",requestLimitExceeded:"Friend Request Limit Exceeded",addNameAsFriend:function(_3b){
return "Add "+_3b+" as a friend?";
},nameMustBeFriendsToMessage:"You and %1$s must be friends before you can send messages.",nameMustConfirmFriendship:function(_3c){
return _3c+" will have to accept your friendship.";
},nameMustConfirmYourFriendship:"%1$s will have to confirm your friendship.",addPersonalMessage:"Add a personal message",includePersonalMessage:"Include personal message",typePersonalMessage:"Type your personal message\u2026",thereHasBeenAnError:"There has been an error",message:"Message",send:"Send",addAsFriend:"Add as Friend",friendRequestSent:"Friend Request Sent!",yourFriendRequestHasBeenSent:"Your friend request has been sent.",yourMessage:"Your Message",updateMessage:"Update Message",updateMessageQ:"Update Message?",removeWords:"To make sure your email is delivered successfully, we recommend going back to change or remove the following words:",warningMessage:"It looks like there are some words in this email that might send your email to a Spam folder.",errorMessage:"There are 6 or more words in this email that might send your email to a Spam folder.",goBack:"Go Back",sendAnyway:"Send Anyway",messageIsTooLong:function(n,m){
return "We're sorry. The maximum number of characters is "+m+".";
},yourMessageIsTooLong:function(n){
return "Your message is too long. Please use "+n+" characters or less.";
},locationNotFound:function(_40){
return "<em>"+_40+"</em> not found.";
},confirmation:"Confirmation",showMap:"Show Map",hideMap:"Hide Map",yourCommentMustBeApproved:"Your comment must be approved before everyone can see it.",nComments:{"f1":"1 Comment","f2":"%s Comments"},pleaseEnterAComment:"Please enter a comment",uploadAPhoto:"Upload a Photo",uploadAnImage:"Upload an image",gifJpgPngLimit:"(GIF, JPEG or PNG; limit %s)",uploadAPhotoEllipsis:"Upload a Photo\u2026",uploadAnImageEllipsis:"Upload an Image\u2026",useExistingImage:"Use existing image:",useExistingPhoto:"Use existing photo:",existingPhoto:"Existing photo",noPhoto:"No photo",uploadPhotoFromComputer:"Upload a photo from your computer",currentPhoto:"Current photo",existingImage:"Existing image",useThemeImage:"Use theme image:",themeImage:"Theme Image",noImage:"No image",uploadImageFromComputer:"Upload an image from your computer",tileThisImage:"Tile this image",done:"Done",currentImage:"Current image",pickAColor:"Select a Color",openColorPicker:"Open Color Picker",transparent:"Transparent",loading:"Loading\u2026",ok:"OK",save:"Save",cancel:"Cancel",saving:"Saving\u2026",addAnImage:"Add an Image",editImage:"Edit Image",uploadAFile:"Upload a File",fileSizeLimit:"Size limit: %1$sMB",pleaseEnterAWebsite:"Please enter a website address",bold:"Bold",italic:"Italic",underline:"Underline",strikethrough:"Strikethrough",addHyperink:"Add Hyperlink",options:"Options",wrapTextAroundImage:"Wrap text around image?",alignImage:"Align image on the...",left:"Left",center:"Center",right:"Right",full:"Full",close:"Close",createThumbnail:"Create thumbnail?",resizeImage:"Resize image?",pixels:"pixels",createSmallerVersion:"Create a smaller version of your image to display. Set the width in pixels.",createSmallerVersionSetLongestDimension:"Create a smaller version of your image to display. Set the longest dimension in pixels.",popupWindow:"Popup Window?",linkToOriginal:"Link to original?",linkToFullSize:"Link to the full-size version of the image in a popup window.",add:"Add",update:"Update",keepWindowOpen:"Please keep this browser window open while upload continues.",cancelUpload:"Cancel Upload",pleaseSelectAFile:"Please select an Image File",pleaseSpecifyAThumbnailSize:"Please specify a thumbnail size",thumbnailSizeMustBeNumber:"The thumbnail size must be a number",orUseExistingImage:"or use the existing image",addExistingImage:"or insert an existing image",addExistingFile:"or insert an existing file",clickToEdit:"Click to edit",requestSent:"Request Sent!",pleaseCorrectErrors:"Please correct these errors",noo:"NEW",none:"NONE",joinNow:"Join Now",join:"Join",signIn:"Sign In",signUp:"Sign Up",addToFavorites:"Favorite",removeFromFavorites:"Remove from Favorites",follow:"Follow",stopFollowing:"Stop Following",pendingPromptTitle:"Membership Pending Approval",youCanDoThis:"You can do this once your membership has been approved by the administrators.",editYourTags:"Edit Your Tags",addTags:"Add Tags",editLocation:"Edit Location",editTypes:"Edit Event Type",imageSizeLimit:"(Limit 10 MB)",nChars:{"f1":"1 character","f2":"%1$s characters"},youHaveUnsavedChanges:"You have unsaved changes. Are you sure you want to navigate away?",commentWall:"Comment Wall",commentWallNComments:{"f1":"Comment Wall (1 comment)","f2":"Comment Wall (%s comments)"},choosePluralizationForm:function(n){
if(n==1){
return "f1";
}else{
return "f2";
}
}});
dojo.evalObjPath("xg.video.nls",true);
dojo.lang.mixin(xg.video.nls,xg.index.i18n,{edit:"Edit",display:"Display",detail:"Detail",player:"Player",from:"From",show:"Show",videos:"videos",cancel:"Cancel",customizePlayerColors:"Customize Colors",save:"Save",numberOfCharactersExceedsMaximum:function(n,_43){
return "The number of characters ("+n+") exceeds the maximum ("+_43+")";
},approve:"Approve",approving:"Approving\u2026",keepWindowOpenWhileApproving:"Please keep this browser window open while videos are being approved. This process may take a few minutes.","delete":"Delete",deleting:"Deleting\u2026",keepWindowOpenWhileDeleting:"Please keep this browser window open while videos are being deleted. This process may take a few minutes.",pasteInEmbedCode:"Please enter embed code for a video below.",invalidUrlFormat:"The URL you entered appears to be an invalid URL format.",pleaseSelectVideoToUpload:"Please select a video to upload.",embedCodeContainsMoreThanOneVideo:"The embed code contains more than one video. Please make sure it has only one <object> and/or <embed> tag.",embedCodeMissingTag:"The embed code is missing an &lt;embed&gt; or &lt;object&gt; tag.",fileIsNotAMov:"This file does not seem to be a .mov, .mpg, .mp4, .avi, .3gp, .3g2 or .wmv. Try uploading it anyway?",embedHTMLCode:"HTML Embed Code:",directLink:"Direct Link",addToMyspace:"Add to MySpace",shareOnFacebook:"Share on Facebook"});
dojo.evalObjPath("xg.uploader.nls",true);
dojo.lang.mixin(xg.uploader.nls,xg.index.i18n,{fileBrowserHeader:"My Computer",fileRoot:"My Computer",fileInformationHeader:"Information",uploadHeader:"Files to Upload",dragOutInstructions:"Drag files out to remove them",dragInInstructions:"Drag Files Here",selectInstructions:"Select a File",files:"Files",totalSize:"Total Size",fileName:"Name",fileSize:"Size",nextButton:"Next >",okayButton:"OK",yesButton:"Yes",noButton:"No",uploadButton:"Upload",cancelButton:"Cancel",backButton:"Back",continueButton:"Continue",uploadingStatus:function(n,m){
return "Uploading "+n+" of "+m;
},uploadLimitWarning:function(n){
return "You can upload "+n+" files at a time.";
},uploadLimitCountdown:{"0":"You've added the maximum number of files.","f1":"You can upload 1 more file.","f2":"You can upload %s more files."},uploadingLabel:"Uploading...",uploadingInstructions:"Please leave this window open while your upload is in progress",iHaveTheRight:"I have the right to upload these files under the <a href=\"/main/authorization/termsOfService\">Terms of Service</a>",updateJavaTitle:"Update Java",updateJavaDescription:"The bulk uploader requires a more recent version of Java. Click \"Okay\" to get Java.",batchEditorLabel:"Edit Information for All Items",applyThisInfo:"Apply this info to the files below",titleProperty:"Title",descriptionProperty:"Description",tagsProperty:"Tags",viewableByProperty:"Can be viewed by",viewableByEveryone:"Anyone",viewableByFriends:"Just My Friends",viewableByMe:"Just Me",albumProperty:"Album",artistProperty:"Artist",enableDownloadLinkProperty:"Enable download link",enableProfileUsageProperty:"Allow people to put this song on their pages",licenseProperty:"License",creativeCommonsVersion:"3.0",selectLicense:"\u2014 Select license \u2014",copyright:"\xa9 All Rights Reserved",ccByX:function(n){
return "Creative Commons Attribution "+n;
},ccBySaX:function(n){
return "Creative Commons Attribution Share Alike "+n;
},ccByNdX:function(n){
return "Creative Commons Attribution No Derivatives "+n;
},ccByNcX:function(n){
return "Creative Commons Attribution Non-commercial "+n;
},ccByNcSaX:function(n){
return "Creative Commons Attribution Non-commercial Share Alike "+n;
},ccByNcNdX:function(n){
return "Creative Commons Attribution Non-commercial No Derivatives "+n;
},publicDomain:"Public Domain",other:"Other",errorUnexpectedTitle:"Oops!",errorUnexpectedDescription:"There's been an error. Please try again.",errorTooManyTitle:"Too Many Items",errorTooManyDescription:function(n){
return "We're sorry, but you can only upload "+n+" items at a time.";
},errorNotAMemberTitle:"Not Allowed",errorNotAMemberDescription:"We're sorry, but you need to be a member to upload.",errorContentTypeNotAllowedTitle:"Not Allowed",errorContentTypeNotAllowedDescription:"We're sorry, but you're not allowed to upload this type of content.",errorUnsupportedFormatTitle:"Oops!",errorUnsupportedFormatDescription:"We're sorry, but we don't support this type of file.",errorUnsupportedFileTitle:"Oops!",errorUnsupportedFileDescription:"foo.exe is in an unsupported format.",errorUploadUnexpectedTitle:"Oops!",errorUploadUnexpectedDescription:function(_4e){
return _4e?("There appears to be a problem with the "+_4e+" file. Please remove it from the list before uploading the rest of your files."):"There appears to be a problem with the file at the top of the list. Please remove it before uploading the rest of your files.";
},cancelUploadTitle:"Cancel Upload?",cancelUploadDescription:"Are you sure you want to cancel the remaining uploads?",uploadSuccessfulTitle:"Upload Completed",uploadSuccessfulDescription:"Please wait while we take you to your uploads...",uploadPendingDescription:"Your files were successfully uploaded and are awaiting approval.",photosUploadHeader:"Photos to Upload",photosDragOutInstructions:"Drag photos out to remove them",photosDragInInstructions:"Drag Photos Here",photosSelectInstructions:"Select a Photo",photosFiles:"Photos",photosUploadingStatus:function(n,m){
return "Uploading Photo "+n+" of "+m;
},photosErrorTooManyTitle:"Too Many Photos",photosErrorTooManyDescription:function(n){
return "We're sorry, but you can only upload "+n+" photos at a time.";
},photosErrorContentTypeNotAllowedDescription:"We're sorry, but photo uploading has been disabled.",photosErrorUnsupportedFormatDescription:"We're sorry, but you can only upload .jpg, .gif or .png format images.",photosErrorUnsupportedFileDescription:function(n){
return n+" is not a .jpg, .gif or .png file.";
},photosBatchEditorLabel:"Edit Information for All Photos",photosApplyThisInfo:"Apply this info to the photos below",photosErrorUploadUnexpectedDescription:function(_53){
return _53?("There appears to be a problem with the "+_53+" file. Please remove it from the list before uploading the rest of your photos."):"There appears to be a problem with the photo at the top of the list. Please remove it before uploading the rest of your photos.";
},photosUploadSuccessfulDescription:"Please wait while we take you to your photos...",photosUploadPendingDescription:"Your photos were successfully uploaded and are awaiting approval.",photosUploadLimitWarning:function(n){
return "You can upload "+n+" photos at a time.";
},photosUploadLimitCountdown:{"0":"You've added the maximum number of photos.","f1":"You can upload 1 more photo.","f2":"You can upload %s more photos."},photosIHaveTheRight:"I have the right to upload these photos under the <a href=\"/main/authorization/termsOfService\">Terms of Service</a>",videosUploadHeader:"Videos to Upload",videosDragInInstructions:"Drag Videos Here",videosDragOutInstructions:"Drag videos out to remove them",videosSelectInstructions:"Select a Video",videosFiles:"Videos",videosUploadingStatus:function(n,m){
return "Uploading Video "+n+" of "+m;
},videosErrorTooManyTitle:"Too Many Videos",videosErrorTooManyDescription:function(n){
return "We're sorry, but you can only upload "+n+" videos at a time.";
},videosErrorContentTypeNotAllowedDescription:"We're sorry, but video uploading has been disabled.",videosErrorUnsupportedFormatDescription:"We're sorry, but you can only upload .avi, .mov, .mp4, .wmv or .mpg format videos.",videosErrorUnsupportedFileDescription:function(x){
return x+" is not a .avi, .mov, .mp4, .wmv or .mpg file.";
},videosBatchEditorLabel:"Edit Information for All Videos",videosApplyThisInfo:"Apply this info to the videos below",videosErrorUploadUnexpectedDescription:function(_59){
return _59?("There appears to be a problem with the "+_59+" file. Please remove it from the list before uploading the rest of your videos."):"There appears to be a problem with the video at the top of the list. Please remove it before uploading the rest of your videos.";
},videosUploadSuccessfulDescription:"Please wait while we take you to your videos...",videosUploadPendingDescription:"Your videos were successfully uploaded and are awaiting approval.",videosUploadLimitWarning:function(n){
return "You can upload "+n+" videos at a time.";
},videosUploadLimitCountdown:{"0":"You've added the maximum number of videos.","f1":"You can upload 1 more video.","f2":"You can upload %s more videos."},videosIHaveTheRight:"I have the right to upload these videos under the <a href=\"/main/authorization/termsOfService\">Terms of Service</a>",musicUploadHeader:"Songs to Upload",musicTitleProperty:"Song Title",musicDragOutInstructions:"Drag songs out to remove them",musicDragInInstructions:"Drag Songs Here",musicSelectInstructions:"Select a Song",musicFiles:"Songs",musicUploadingStatus:function(n,m){
return "Uploading Song "+n+" of "+m;
},musicErrorTooManyTitle:"Too Many Songs",musicErrorTooManyDescription:function(n){
return "We're sorry, but you can only upload "+n+" songs at a time.";
},musicErrorContentTypeNotAllowedDescription:"We're sorry, but song uploading has been disabled.",musicErrorUnsupportedFormatDescription:"We're sorry, but you can only upload .mp3 format songs.",musicErrorUnsupportedFileDescription:function(x){
return x+" is not a .mp3 file.";
},musicBatchEditorLabel:"Edit Information for All Songs",musicApplyThisInfo:"Apply this info to the songs below",musicErrorUploadUnexpectedDescription:function(_5f){
return _5f?("There appears to be a problem with the "+_5f+" file. Please remove it from the list before uploading the rest of your songs."):"There appears to be a problem with the song at the top of the list. Please remove it before uploading the rest of your songs.";
},musicUploadSuccessfulDescription:"Please wait while we take you to your songs...",musicUploadPendingDescription:"Your songs were successfully uploaded and are awaiting approval.",musicUploadLimitWarning:function(n){
return "You can upload "+n+" songs at a time.";
},musicUploadLimitCountdown:{"0":"You've added the maximum number of songs.","f1":"You can upload 1 more song.","f2":"You can upload %s more songs."},musicIHaveTheRight:"I have the right to upload these songs under the <a href=\"/main/authorization/termsOfService\">Terms of Service</a>"});
dojo.evalObjPath("xg.events.nls",true);
dojo.lang.mixin(xg.events.nls,xg.index.i18n,{pleaseEnterTitle:"Please enter a title for the event",pleaseEnterDescription:"Please enter a description for the event",messageIsTooLong:function(n){
return "Your message is too long. Please use "+n+" characters or less.";
},pleaseEnterLocation:"Please enter a location for the event",pleaseEnterType:"Please enter at least one type for the event",sendMessageToGuests:"Send Message to Guests",sendMessageToGuestsThat:"Send message to guests that:",areAttending:"Are attending",mightAttend:"Might attend",haveNotYetRsvped:"Have not yet RSVPed",areNotAttending:"Are not attending",yourMessage:"Your Message",send:"Send",sending:"Sending\u2026",yourMessageIsBeingSent:"Your message is being sent.",messageSent:"Message Sent!",yourMessageHasBeenSent:"Your message has been sent.",chooseRecipient:"Please choose a recipient.",pleaseEnterAMessage:"Please enter a message",thereHasBeenAnError:"There has been an error",datePickerDateFormat:"mm/dd/yyyy",monday:"Monday",tuesday:"Tuesday",wednesday:"Wednesday",thursday:"Thursday",friday:"Friday",saturday:"Saturday",sunday:"Sunday",mondayAbbreviated:"Mon",tuesdayAbbreviated:"Tue",wednesdayAbbreviated:"Wed",thursdayAbbreviated:"Thu",fridayAbbreviated:"Fri",saturdayAbbreviated:"Sat",sundayAbbreviated:"Sun",mondayShort:"M",tuesdayShort:"T",wednesdayShort:"W",thursdayShort:"T",fridayShort:"F",saturdayShort:"S",sundayShort:"S",januaryShort:"J",februaryShort:"F",marchShort:"M",aprilShort:"A",mayShort:"M",juneShort:"J",julyShort:"J",augustShort:"A",septemberShort:"S",octoberShort:"O",novemberShort:"N",decemberShort:"D",januaryAbbreviated:"Jan",februaryAbbreviated:"Feb",marchAbbreviated:"Mar",aprilAbbreviated:"Apr",mayAbbreviated:"May",juneAbbreviated:"Jun",julyAbbreviated:"Jul",augustAbbreviated:"Aug",septemberAbbreviated:"Sep",octoberAbbreviated:"Oct",novemberAbbreviated:"Nov",decemberAbbreviated:"Dec",january:"January",february:"February",march:"March",april:"April",may:"May",june:"June",july:"July",august:"August",september:"September",october:"October",november:"November",december:"December"});
dojo.evalObjPath("xg.notes.nls",true);
dojo.lang.mixin(xg.notes.nls,xg.index.i18n,{addNewNote:"Add New Note",pleaseEnterNoteTitle:"Please enter a note title!",noteTitleTooLong:"Note title is too long",pleaseEnterNoteEntry:"Please enter a note entry",noteHasBeenChanged:"Note has been changed."});
dojo.evalObjPath("xg.gifts.nls",true);
dojo.lang.mixin(xg.gifts.nls,xg.index.i18n,{thereHasBeenAnError:"There has been an error",pleaseSelectGift:"Please select a gift.",buyCredits:"Buy Credits",moreCreditsRequired:"More Credits Required",added:"Added!",creditsRequired:"Credits Required:",xCreditsForYUSD:"%1$s Credits \u2013 $%2$s USD",xCreditsForYUSDBonus:"%1$s Credits \u2013 $%2$s USD, <span %4$s>%3$s% Bonus</span>",purchaseCreditsToSend:"Please purchase some credits to send this gift.",purchaseCredits:"Purchase Credits:",byMakingPurchase:"By making a purchase, you are agreeing to the <a %1$s>Virtual Gifts Terms</a>.",payPalCheckout:"PayPal Checkout",close:"Close",removeCategory:"Remove Category",thisWillRemoveThisCategory:"This will remove this category from the Gift Store as well as all gifts in that category. You can add this category back at any time, and the gifts will reappear in the Gift Store.",pleaseEnterMessage:"Please enter a message.",unableToCompleteAction:"We were unable to complete your last action. Please try again later.",messageHasToBeShorter:"Message has to be shorter than %1$s characters.",pleaseEnterAGiftName:"Please enter a gift name.",pleaseEnterAGiftImage:"Please select a gift image.",pleaseEnterName:"Please enter your name.",pleaseEnterPhone:"Please enter your phone number.",pleaseEnterPayPal:"Please enter your PayPal email address.",contactEmailInvalid:"The contact email does not seem to be valid.",pleaseEnterStreetAddress:"Please enter your street address.",pleaseEnterCity:"Please enter your city.",pleaseEnterStateOrProvince:"Please enter your state or province.",pleaseEnterPostalCode:"Please enter your postal code.",pleaseEnterDescription:"Please enter a description for your Ning Network.",credits:"Credits",xCredits:"%1$s Credits",totalCostXCredits:function(x){
if(x==1){
return "Total Cost: 1 Credit";
}else{
return "Total Cost: "+x+" Credits";
}
},oneCredit:"1 Credit",free:"Free",wereSorry:"We're Sorry",giftSent:"Gift Sent!",feature:"Feature",stopFeaturing:"Stop Featuring",yourGiftsHasBeenSentToXMembers:{"f1":"Your gift has been sent. You now have %2$s credits left.","f2":"Your gifts have been sent to %1$s members. You now have %2$s credits left."},yourGiftsHasBeenSentToXMembersModerate:{"f1":"Your gift has been sent but the recipient has chosen to moderate gifts, and will need to approve the gifts before they appear. You now have %2$s credits left.","f2":"Your gifts have been sent to %1$s members. Some recipients have chosen to moderate gifts, and will need to approve the gifts before they appear. You now have %2$s credits left."},unableToSendGiftsMsg:"There was some problem sending your gifts. Please try again.",cannotDeleteCategory:"You cannot remove this category because you must have a minimum of %1$s categories in the Gift Store. Please add another category before removing this one.",cannotDeleteGiftItem:"<p>You cannot remove this gift because there must be a minimum of %1$s gifts in the Gift Store. Please <a %2$s>add another gift</a> before removing this one. You can also <a %3$s>upload a custom gift</a>.</p>",searchGifts:"Search Gifts",removeACategory:"Remove a Category",clickToSelectTheCategoryYouWouldLikeToRemove:"Click to select a category you would like to remove, and then click the \"X\" icon that appears to the right side of the category name. You will be asked to confirm the removal. Please note that you cannot remove the All, Custom, Featured or Awards categories.",renameACategory:"Rename a Category",clickToSelectTheCategoryYouWouldLikeToRename:"Click to select a category you would like to rename, and then click the \"Edit\" link that appears to the right of the category name. Please note that you cannot rename the All, Custom, Featured or Awards categories.",pleaseSelectARecipient:"Please select a recipient",pleaseEnterKeywordToSearch:"Please enter a keyword to search",giftMessageHasHTMLConfirmTitle:"Please Check Your Gift Message",giftMessageHasHTMLConfirmBody:"HTML will be removed from your message. Do you still want to send your gift?",sendGift:"Send Gift",editMessage:"Edit Message",imagesMustBeUnder:"Please select a gift image that is under 10 KB. The image you selected is too large. <a href=\"http://help.ning.com/cgi-bin/ning.cfg/php/enduser/std_adp.php?p_faqid=3720\" target=\"_blank\">Need help?</a>",giftImageUnder:"Please select a gift image that is under 10 KB. The image you selected is too large. <a %1$s>Click here</a> to get help creating a custom gift image.",imageInInvalidFormat:"Please select an accepted image type (PNG, GIF, or JPEG).",enterAMessageFor:"Enter a Message for %1$s",enterAMessage:"Enter a Message",waitWhileRedirect:"Please wait while we redirect you to PayPal\u2026",yourGiftHasBeenAddedToYourProfilePage:"Your gift has been added to your profile page. You now have %1$s credits left.",ncOnly:"Network Creator Only",autoManageGiftStore:"Automatic Ning Gift Management",autoManageGiftStoreExpl:"Choose whether the Gift Store updates automatically.",autoManageGiftStoreOnExpl:"The Gift Store will automatically update with new and seasonal Ning Gifts. ",autoManageGiftStoreOffExpl:"All Ning Gifts will be removed from the Gift Store. You can pick and choose which Ning Gifts appear in the Gift Store by going to \"Add Ning Gifts\".",onCap:"On",offCap:"Off",unlimited:"Unlimited",nLeft:"%1$s Left",sellingOut:"Selling Out",awards:"Awards",notEnoughGiftsLeft:"Not enough gifts left. Please choose fewer recipients.",next:"Next &gt;",previous:"&lt; Previous",searchMembers:"Search Members",showFriendsOnly:"Show Friends Only",maxN:function(n){
return "max "+n;
},nSelected:function(_64,n){
return "<span "+_64+">"+n+"</span> Selected";
},addRecipients:"Add Recipients"});
}
if(!dojo.hostenv.findModule("xg.shared.messagecatalogs.pt_BR",false)){
dojo.provide("xg.shared.messagecatalogs.pt_BR");
dojo.evalObjPath("xg.feed.nls",true);
dojo.lang.mixin(xg.feed.nls,xg.index.i18n,{edit:"Editar",title:"T\xedtulo:",feedUrl:"URL:",show:"Exibir",titles:"Apenas t\xedtulos",titlesAndDescriptions:"Exibi\xe7\xe3o detalhada",display:"Mostrar",cancel:"Cancelar",save:"Salvar",loading:"Carregando...",items:"itens"});
dojo.evalObjPath("xg.opensocial.nls",true);
dojo.lang.mixin(xg.opensocial.nls,xg.index.i18n,{edit:"Editar",title:"T\xedtulo:",untitled:"sem t\xedtulo",appUrl:"URL:",cancel:"Cancelar",save:"Salvar",removeBox:"Remover Caixa",removeBoxText:function(_1){
return "<p>Tem certeza de que deseja remover a caixa \""+_1+"\" de Minha p\xe1gina?</p><p>Voc\xea ainda poder\xe1 acessar este App a partir de Meus Apps.</p>";
},removeApplication:"Remover App",removeApplicationText:"Tem certeza de que deseja remover este App? Ele n\xe3o poder\xe1 mais ser acessado na sua p\xe1gina Meus Apps.",removeApplicationNetwork:"Remover Aplicativo do Ning",removeApplicationTextNetwork:"Tem certeza de que deseja remover este Ning App? Ele n\xe3o poder\xe1 mais ser acessado em sua Rede do Ning.",removeBoxAndRemoveApplication:"Remover caixa / Remover App",removeBoxAndRemoveApplicationHelp:"<p>'Remover caixa' remover\xe1 a caixa deste App apenas da sua p\xe1gina de perfil.</p><p>'Remover App' remover\xe1 o App da sua p\xe1gina de perfil e da lista Meus Apps.</p>",allowSendAlerts:"Permitir que este Profile App envie alertas para mim e para meus amigos",allowSendAlertsOnMain:"Permitir que este Aplicativo do Ning envie alertas a todos os membros desta rede social",canAddActivities:"Adicionar atualiza\xe7\xf5es \xe0s atividades mais recentes",canAddActivitiesOnMain:"Adicione atualiza\xe7\xf5es ao m\xf3dulo de atividade mais recente da P\xe1gina principal",applicationSettingsOnMain:"Configura\xe7\xf5es do %1$s",allowThisApplicationToOnMain:"Permitir que %1$s:",addApplication:"Adicionar App",addNingApp:"Adicionar Aplicativo do Ning",yourApplicationIsBeingAdded:"Seu App est\xe1 sendo adicionado.",yourNingAppIsBeingAdded:"Seu Aplicativo do Ning est\xe1 sendo adicionado.",yourApplicationIsBeingRemoved:"Seu App est\xe1 sendo removido.",onlyEmailMsgSupported:"O tipo de mensagem EMAIL \xe9 o \xfanico compat\xedvel",msgExpectedToContain:"A mensagem deve conter os campos: tipo, t\xedtulo e corpo",msgObjectExpected:"Objeto de mensagem esperado",recipientsShdBeStringOrArray:"Os destinat\xe1rios s\xf3 podem ser uma cadeia de caracteres (por exemplo, uma lista separada por v\xedrgulas) ou uma Matriz",recipientsShdBeSpecified:"Os destinat\xe1rios devem ser especificados e n\xe3o podem ficar vazios",unauthorizedSender:"Remetente N\xe3o Autorizado: apenas membros que efetuaram login podem enviar mensagens",unauthorizedRecipients:"Destinat\xe1rios n\xe3o autorizados especificados para enviar email para",rateLimitExceeded:"Limite de classifica\xe7\xe3o excedido",operationCancelled:"Opera\xe7\xe3o cancelada",youAreAboutToAdd:function(_2,_3){
return "<p>Voc\xea est\xe1 prestes a adicionar <strong>"+_2+"</strong> \xe0 Minha p\xe1gina. Este App foi desenvolvido por um terceiro.</p><p>Ao clicar em 'Adicionar App', voc\xea declara concordar com os <a "+_3+">Termos de Uso de Apps</a>.</p>";
},youAreAboutToAddNing:function(_4,_5){
return "<p>Voc\xea est\xe1 prestes a adicionar <strong>"+_4+"</strong> \xe0 Minha p\xe1gina. Este App foi desenvolvido pela Ning.</p><p>Ao clicar em 'Adicionar App', voc\xea declara concordar com os <a "+_5+">Termos de Uso de Apps</a>.</p>";
},youAreAboutToAddNetwork:function(_6,_7){
return "<p>Voc\xea est\xe1 prestes a adicionar <strong>"+_6+"</strong> \xe0 sua Rede do Ning. Este Ning App foi desenvolvido por um terceiro.</p><p>Ao adicion\xe1-lo \xe0 sua Rede do Ning, voc\xea concorda em compartilhar suas informa\xe7\xf5es, bem como as informa\xe7\xf5es dos membros de sua Rede do Ning, com a Ning.</p><p>Ao clicar em 'Adicionar Ning App', voc\xea declara concordar com os <a "+_7+">Termos de Uso de Apps</a>.</p>";
},youAreAboutToAddNetworkNing:function(_8,_9){
return "<p>Voc\xea est\xe1 prestes a adicionar <strong>"+_8+"</strong> \xe0 sua Rede do Ning. Este Ning App foi desenvolvido pela Ning.</p><p>Ao adicion\xe1-lo \xe0 sua Rede do Ning, voc\xea concorda em compartilhar suas informa\xe7\xf5es, bem como as informa\xe7\xf5es dos membros de sua Rede do Ning, com a Ning.</p><p>Ao clicar em 'Adicionar Ning App', voc\xea declara concordar com os <a "+_9+">Termos de Uso de Apps</a>.</p>";
},followingMessageWasSent:function(_a,_b,_c){
return "<p>A mensagem a seguir foi enviada para "+_a+". <blockquote><strong><em>"+_b+"</em></strong><br/>"+_c+"</blockquote></p>";
},reviewIsTooLong:function(_d,_e){
return "Seu coment\xe1rio possui "+_d+" caracteres.  O m\xe1ximo permitido \xe9 "+_e+".";
},mustSupplyRating:"Forne\xe7a uma classifica\xe7\xe3o com o seu coment\xe1rio.",mustSupplyReview:"Seu coment\xe1rio deve conter algum texto.",messageWasNotSent:function(_f){
return "<p>A mensagem <strong>n\xe3o</strong> foi enviada porque: <strong>"+_f+"</strong>.";
},settingIsDontSendMessage:"A configura\xe7\xe3o de mensagens est\xe1 definida para n\xe3o enviar mensagens",applicationSettings:"Configura\xe7\xf5es do App",messageSent:"Mensagem Enviada",messageNotSent:"Mensagem N\xe3o Enviada",allowThisApplicationTo:"Permitir que este App:",updateSettings:"Salvar",isOnMyPage:"Adicionar uma caixa \xe0 p\xe1gina Meus Apps",youNeedToAddEmailRecipient:"Voc\xea precisa adicionar um destinat\xe1rio para o email.",yourMessageIsBeingSent:"Sua mensagem est\xe1 sendo enviada.",sendingLabel:"Enviando...",deleteReview:"Excluir Coment\xe1rio",deleteReviewQ:"Excluir coment\xe1rio?",replaceReview:"Substituir Coment\xe1rio",replaceReviewQ:"Voc\xea j\xe1 adicionou um coment\xe1rio.  Deseja substituir o coment\xe1rio existente?","delete":"Excluir",thereHasBeenAnError:"Erro",whatsThis:"O que \xe9 isso?",hideThisApp:"Ocultar App do diret\xf3rio",blacklistConfirmation:"Este App ser\xe1 ocultado do diret\xf3rio e ser\xe1 removido de todas as p\xe1ginas de perfil dos membros.",addToProfilePages:"Exibir nas p\xe1ginas Meus Apps dos membros",visibleToMembers:"Estar vis\xedvel para os membros na P\xe1gina principal",searchNingApps:"Pesquisar Ning Apps",youveReachedMaxApps:"Voc\xea atingiu o n\xfamero m\xe1ximo de %1$s Apps que podem ser adicionados \xe0 sua p\xe1gina Meus Apps.  <a %2$s>Remova um App</a> para adicionar outro.",maxNingAppsReached:"Voc\xea atingiu o n\xfamero m\xe1ximo de Ning Apps que podem ser adicionados \xe0 sua Rede do Ning. Remova um Ning App para adicionar outro ou procure no <a %1$s>Diret\xf3rio de Ning Apps</a>."});
dojo.evalObjPath("xg.opensocialapps.nls",true);
dojo.lang.mixin(xg.opensocialapps.nls,xg.index.i18n,{change:"Alterar",save:"Salvar",deleteApplication:"Delete Application",deleteFeature:"Excluir recurso",deleteApplicationText:"Are you sure you want to delete this application? It will automatically be removed for all users who added this application. Would you like to continue?",takeOffline:"Passar para offline",takeOfflineText:"Are you sure you want to take this application offline? It will automatically be removed for all users who added this application. Would you like to continue?",dontRecommendApp:"Don't Recommend App",recommendApp:"Recommend App",staffPickApp:"Staff Pick App",dontStaffPick:"Don't Staff Pick App",areYouSure:"Tem certeza?"});
dojo.evalObjPath("xg.forum.nls",true);
dojo.lang.mixin(xg.forum.nls,xg.index.i18n,{items:"itens",numberOfCharactersExceedsMaximum:function(n,_11){
return "O n\xfamero de caracteres ("+n+") ultrapassa o n\xfamero m\xe1ximo ("+_11+") ";
},pleaseEnterFirstPost:"Escreva a mensagem inicial deste t\xf3pico",pleaseEnterTitle:"Digite um t\xedtulo para o evento.",save:"Salvar",cancel:"Cancelar",yes:"Sim",no:"N\xe3o",edit:"Editar",ok:"OK",deleteCategory:"Excluir categoria",discussionsWillBeDeleted:"Os t\xf3picos nesta categoria ser\xe3o exclu\xeddos.",whatDoWithDiscussions:"O que voc\xea quer fazer com os t\xf3picos nesta categoria?",moveDiscussionsTo:"Mover os t\xf3picos para:",deleteDiscussions:"Excluir t\xf3picos","delete":"Excluir",deleteReply:"Excluir resposta",deleteReplyQ:"Excluir esta resposta?",deletingReplies:"Excluindo respostas\u2026",doYouWantToRemoveReplies:"Voc\xea deseja excluir as respostas a este coment\xe1rio.",pleaseKeepWindowOpen:"Deixe esta janela do navegador aberta enquanto o processo estiver em andamento. Isso pode levar alguns minutos.",contributorSaid:function(x){
return x+" disse:";
},display:"Mostrar",from:"De",show:"Exibir",view:"Visualizar",discussions:"discuss\xf5es",discussionsFromACategory:"Discuss\xf5es de uma categoria...",MaxCategoryNotificationTitle:"Limite m\xe1ximo atingido",MaxCategoryNotificationMsg:"Infelizmente, voc\xea s\xf3 pode criar, no m\xe1ximo, %s categorias."});
dojo.evalObjPath("xg.groups.nls",true);
dojo.lang.mixin(xg.groups.nls,xg.index.i18n,{pleaseChooseAName:"Escolha um nome para seu grupo.",pleaseChooseAUrl:"Escolha um endere\xe7o web para seu grupo.",urlCanContainOnlyLetters:"O endere\xe7o web deve conter apenas letras e n\xfameros (sem espa\xe7os).",descriptionTooLong:function(n,_14){
return "O tamanho da descri\xe7\xe3o de seu grupo ("+n+") ultrapassa o tamanho m\xe1ximo ("+_14+") ";
},nameTaken:"Desculpe-nos - este nome j\xe1 foi utilizado. Escolha outro nome.",urlTaken:"Desculpe-nos - este endere\xe7o web j\xe1 foi cadastrado. Escolha outro.",edit:"Editar",from:"De",show:"Exibir",groups:"grupos",pleaseEnterName:"Digite seu nome",pleaseEnterEmailAddress:"Seu endere\xe7o de e-mail",xIsNotValidEmailAddress:function(x){
return x+" n\xe3o \xe9 um endere\xe7o de email v\xe1lido";
},save:"Salvar",cancel:"Cancelar"});
dojo.evalObjPath("xg.html.nls",true);
dojo.lang.mixin(xg.html.nls,xg.index.i18n,{contentsTooLong:function(_16){
return "Voc\xea excedeu o n\xfamero m\xe1ximo de caracteres suportados nesta caixa de texto. Remova "+_16+" characters.";
},tooManyEmbeds:"Voc\xea pode colocar apenas %1$s widgets em uma caixa de texto. Remova %2$s widgets. <a %3$s>Saiba mais</a>.",edit:"Editar",wereSorry:"Desculpe",save:"Salvar",cancel:"Cancelar",saving:"Salvando\u2026",addAWidget:function(url){
return "<a href=\""+url+"\">Adicionar um componente gr\xe1fico</a> a esta caixa de texto ";
}});
dojo.evalObjPath("xg.index.nls",true);
dojo.lang.mixin(xg.index.nls,xg.index.i18n,{sent:"Enviado",messageHasBeenSent:"A mensagem foi enviada para %1$s.",richText:"Rich Text",source:"Origem",toggleBold:"Ativar/desativar negrito",toggleItalic:"Ativar/desativar it\xe1lico",toggleUnderline:"Ativar/desativar sublinhado",justifyLeft:"Justificar \xe0 esquerda",justifyCenter:"Centralizar",justifyRight:"Justificar \xe0 direita",toggleStrikethrough:"Ativar/desativar tachado",indentLeft:"Recuar \xe0 esquerda",indentRight:"Recuar \xe0 direita",insertHorizontalRule:"Inserir r\xe9gua horizontal",insertOrderedList:"Inserir lista ordenada",insertUnorderedList:"Inserir lista n\xe3o ordenada",insertImage:"Inserir imagem",createLink:"Criar link",removeLink:"Remover link",removeFormatting:"Remover formata\xe7\xe3o",xxSmall:"XX-Pequeno",xSmall:"X-Pequeno",small:"Pequeno",medium:"M\xe9dio",large:"Grande",xLarge:"X-Grande",xxLarge:"XX-Grande",error:"Erro",processingFailed:"Falha no processamento. Tente novamente mais tarde.",saveChanges:"Salvar altera\xe7\xf5es?",doYouWantToSaveChanges:"Deseja salvar suas altera\xe7\xf5es?",discard:"Descartar",onlyNWords:"Apenas %1$s palavras s\xe3o permitidas no campo Palavras-chave.",youCannotEnter:"N\xe3o \xe9 poss\xedvel digitar mais de %1$s caracteres",messageCannotBeMore:"Sua mensagem n\xe3o pode ter mais de %1$s caracteres.",pleaseEnterMessage:"Digite um corpo para a mensagem.",subjectCannotBeMore:"O assunto n\xe3o pode ter mais de %1$s caracteres.",pleaseEnterSubject:"Digite um assunto.",warning:"Aviso",customCssWarning:"Se os temas forem alterados, qualquer CSS adicionado \xe0 guia Avan\xe7ado ser\xe1 removido.",yes:"Sim",edit:"Editar",save:"Salvar",done:"Pronto",badgeSize:"Tamanho do badge",size:"Tamanho",changesSaved:"Suas altera\xe7\xf5es foram salvas com \xeaxito.",tweetsFromThisNetwork:"Agora, os tweets desta rede indicar\xe3o que foram originados do Nome de aplicativo especificado por voc\xea.",connectToTwitter:"Conectar-se ao Twitter",connect:"Conectar",toPostUpdates:"Para postar atualiza\xe7\xf5es no Twitter, conecte seu perfil de %s ao Twitter.",postToTwitter:"Postar no Twitter",postHasBeenSent:"Sua postagem foi enviada.",postTooLong:"Sua postagem n\xe3o pode ter mais de %1$s caracteres",postCannotBeEmpty:"\xc9 necess\xe1rio adicionar texto para postar uma atualiza\xe7\xe3o.",problemConnectingTwitter:"Pedimos desculpas - ocorreu um problema ao estabelecer conex\xe3o com o Twitter. Tente novamente mais tarde.",post:"Postar",overwriteSitemap:"Atualizar o mapa do site automaticamente substituir\xe1 o mapa existente.",pleaseAddProfilePhoto:"Adicione uma foto ao perfil.",yourMessageIsBeingSent:"Sua mensagem est\xe1 sendo enviada.",youNeedToAddEmailRecipient:"Voc\xea precisa adicionar um destinat\xe1rio para o email.",checkPageOut:function(_18){
return "Verifique essa p\xe1gina em "+_18;
},checkingOutTitle:function(_19,_1a){
return "Verifique \""+_19+"\" em "+_1a;
},selectOrPaste:"Voc\xea precisa selecionar um v\xeddeo ou colar o c\xf3digo 'embutido'.",selectOrPasteMusic:"Voc\xea precisa selecionar uma m\xfasica ou colar o URL.",cannotKeepFiles:"Voc\xea ter\xe1 que escolher seus arquivos novamente se desejar visualizar mais op\xe7\xf5es.  Deseja continuar?",pleaseSelectPhotoToUpload:"Selecione uma foto para carregar,",addingLabel:"Adicionando.. .",sendingLabel:"Enviando...",addingInstructions:"Deixe esta janela aberta enquanto seu conte\xfado estiver sendo acrescentado.",looksLikeNotImage:"Um ou mais arquivos n\xe3o parecem estar no formato .jpg, .gif, ou .png.  Gostaria de tentar carreg\xe1-los mesmo assim?",looksLikeNotVideo:"O arquivo selecionado por voc\xea n\xe3o parece estar no formato .mov, .mpg, .mp4, .avi, .3gp, .3g2 ou .wmv. Deseja tentar carregar mesmo assim?",looksLikeNotMusic:"O arquivo que voc\xea selecionou n\xe3o parece estar no formato .mp3.  Gostaria de tentar carreg\xe1-los mesmo assim?",showingNFriends:function(n,_1c){
switch(n){
case 1:
return "Exibindo 1 amigo que atende ao crit\xe9rio \""+_1c+"\". <a href=\"#\">Exibir todos</a> ";
default:
return "Exibindo "+n+" amigos que atendem ao crit\xe9rio \""+_1c+"\". <a href=\"#\">Exibir todos</a> ";
}
},sendInvitation:"Enviar um convite",sendMessage:"Enviar mensagem",latestActivityShowsAllTheActivityHappening:"A Atividade mais recente mostra todas as atividades que est\xe3o acontecendo em sua Rede do Ning no momento. Deseja remover mesmo assim?",sendInvitationToNFriends:function(n){
switch(n){
case 1:
return "Enviar convite a 1 amigo? ";
default:
return "Enviar convite a "+n+" amigos? ";
}
},sendMessageToNFriends:function(n){
switch(n){
case 1:
return "Enviar mensagem para 1 amigo? ";
default:
return "Enviar mensagem para "+n+" amigos? ";
}
},nFriendsSelected:function(n){
switch(n){
case 1:
return "Um amigo selecionado";
default:
return n+" amigos selecionados";
}
},yourMessageOptional:"<label>Sua mensagem</label> (opcional)",subjectIsTooLong:function(n){
return "Seu assunto est\xe1 muito longo. Use "+n+" caracteres ou menos.";
},messageIsTooLong:function(n){
return "A mensagem est\xe1 muito longa. Use at\xe9 "+n+" caracteres.";
},pleaseChoosePeople:"Selecione algumas pessoas para convidar.",noPeopleSelected:"N\xe3o h\xe1 pessoas selecionadas",pleaseEnterEmailAddress:"Seu endere\xe7o de e-mail",pleaseEnterPassword:function(_22){
return "Digite sua senha para "+_22+". ";
},sorryWeDoNotSupport:"Desculpe-nos, a sua lista de contatos da web n\xe3o \xe9 compat\xedvel com nosso sistema. Tente clicar em 'Aplicativo de Contatos' abaixo para utilizar endere\xe7os de seu computador",pleaseSelectSecondPart:"Selecione a segunda parte de seu endere\xe7o de email, por exemplo, gmail.com.",atSymbolNotAllowed:"Certifique-se que o s\xedmbolo @ n\xe3o fa\xe7a parte do endere\xe7o de e-mail.",resetTextQ:"Reiniciar o texto?",resetTextToOriginalVersion:"Voc\xea quer mesmo reiniciar todo o seu texto para a vers\xe3o original? Todas as altera\xe7\xf5es ser\xe3o perdidas.",changeQuestionsToPublic:"Alterar as perguntas para p\xfablicas?",changingPrivateQuestionsToPublic:"Alterar as perguntas para p\xfablicas ir\xe1 expor as respostas dos membros. Voc\xea quer mesmo fazer isso?",saveProfileQuestions:"Salvar perguntas do perfil?",areYouSureYouWantToDeleteQuestions:"A exclus\xe3o de perguntas do perfil ou a modifica\xe7\xe3o de tipos de respostas remover\xe1 as respostas existentes dos perfis dos membros. Deseja continuar?",pleaseEnterASiteName:"Digite um nome para a Rede do Ning, por exemplo, Ciclistas de Paris",pleaseEnterShorterSiteName:"Digite um nome mais curto (m\xe1x. de 64 caracteres)",thereIsAProblem:"H\xe1 um problema com sua informa\xe7\xe3o.",thisSiteIsOnline:"Esta Rede do Ning est\xe1 Online.",online:"<strong>Online</strong>",onlineSiteCanBeViewed:"<strong>Online</strong> - Esta Rede do Ning pode ser visualizada de acordo com suas configura\xe7\xf5es de privacidade. ",takeOffline:"Passar para offline",thisSiteIsOffline:"Esta Rede do Ning est\xe1 Offline.",offline:"<strong>Offline</strong>",offlineOnlyYouCanView:"<strong>Offline</strong> - Somente voc\xea pode visualizar esta Rede do Ning.",takeOnline:"Passar para online",basicTheme:"Tema b\xe1sico",allOptions:"Todas as op\xe7\xf5es",addYourOwnCss:"Avan\xe7ado",canBeSelectedOnlyOnce:function(_23){
return _23+" pode ser selecionado como um 'Tipo de Resposta' apenas uma vez";
},pleaseEnterTheChoicesFor:function(_24){
return "Digite as escolhas para \""+_24+"\" por exemplo, Caminhar, Ler, Fazer compras ";
},pleaseEnterTheChoices:"Digite as escolhas, por exemplo, Caminhar, Ler, Fazer compras",bannedPasswordStrings:function(){
return ["password","passphrase","passwd","pass word","pass-word","pass phrase","pass-phrase"].join("|");
},wereSorry:"Desculpe",youCantSendMessageUntilFriend:"N\xe3o \xe9 poss\xedvel enviar uma mensagem at\xe9 que %s aceite sua solicita\xe7\xe3o de amigo.",pleaseRemoveQuestionsAskingForPasswords:"Please remove questions asking for passwords from your members.",upToTenProfileQuestions:"\xc9 poss\xedvel adicionar at\xe9 dez perguntas de perfil \xe0 pesquisa avan\xe7ada. Caso deseja alterar as perguntas que ser\xe3o adicionadas \xe0 pesquisa avan\xe7ada, desmarque algumas perguntas primeiro.",upToNProfileQuestions:function(n){
return "Voc\xea pode ter no m\xe1ximo "+n+" perguntas de perfil.";
},email:"e-mail",subject:"Assunto",message:"Mensagem",send:"Enviar",cancel:"Cancelar",areYouSureYouWant:"Voc\xea realmente deseja fazer isto?",processing:"Processando\u2026",pleaseKeepWindowOpen:"Deixe esta janela do navegador aberta enquanto o processo estiver em andamento. Isso pode levar alguns minutos.",complete:"Conclu\xeddo!",processIsComplete:"O processo foi conclu\xeddo",ok:"OK",body:"Corpo",pleaseEnterASubject:"Digite um assunto",pleaseEnterAMessage:"Digite uma mensagem.",pleaseChooseFriends:"Selecione alguns amigos antes de enviar sua mensagem.",thereHasBeenAnError:"Erro",thereWasAProblem:"Houve um problema ao acrescentar seu conte\xfado.  Tente novamente mais tarde.",fileNotFound:"Arquivo n\xe3o encontrado",pleaseProvideADescription:"Forne\xe7a uma descri\xe7\xe3o",pleaseEnterSomeFeedback:"Digite seus coment\xe1rios",title:"T\xedtulo:",copyHtmlCode:"Copiar c\xf3digo HTML",change:"Alterar",changing:"Alterando...",htmlNotAllowed:"N\xe3o \xe9 permitido usar HTML",noFriendsFound:"N\xe3o foram encontrados amigos que atendam seus crit\xe9rios.",yourSubject:"Seu assunto",yourMessage:"Sua mensagem",pleaseEnterFbApiKey:"Digite sua senha de API do Facebook.",pleaseEnterValidFbApiKey:"Digite sua senha de API do Facebook v\xe1lida.",pleaseEnterFbApiSecret:"Digite o segredo da API do Facebook.",pleaseEnterValidFbApiSecret:"Digite um segredo de API do Facebook v\xe1lido.",pleaseEnterFbTabName:"Digite o um nome para a guia do seu aplicativo Facebook.",pleaseEnterValidFbTabName:function(_26){
return "Digite o um nome mais curto para a guia do seu aplicativo Facebook. O tamanho m\xe1ximo \xe9 "+_26+" caracteres"+(_26==1?"":"s")+".";
},newTab:"Nova Guia",resetToDefaults:"Restaurar Padr\xf5es",youNaviWillbeRestored:"Suas guias de navega\xe7\xe3o ser\xe3o restauradas para a configura\xe7\xe3o padr\xe3o.",hiddenWarningSub:function(n){
return "Esta subguia n\xe3o foi adicionada \xe0 sua Rede do Ning. H\xe1 um limite de "+n+" subguias por guia de alto n\xedvel. "+"Remova subguias ou crie subguias dentro de guias de alto n\xedvel.";
},no:"N\xe3o",youMustSpecifyTabName:"\xc9 preciso especificar um nome de guia",networkPrivacyChangeTitle:"Alterar privacidade",confirmNetworkPrivacyChange:"Tem certeza de que deseja alterar as configura\xe7\xf5es de privacidade da sua Rede do Ning?",orWriteYourOwnMessage:"... ou escreva sua pr\xf3pria mensagem",youCanOnlyAddUpToNContentItems:"\xc9 poss\xedvel adicionar apenas %1$s itens de conte\xfado.",add:"Adicionar",addAContentItem:"Adicionar um item de conte\xfado",enterTheUrlOfASpecific:"Insira a URL de um t\xf3pico, categoria de f\xf3rum, v\xeddeo, foto, nota, evento, p\xe1gina ou grupo espec\xedfico dessa fun\xe7\xe3o para fins de administra\xe7\xe3o:",unsupportedUrl:"URL sem suporte",removeUserFromRole:"Remover membro da fun\xe7\xe3o?",areYouSureRemoveUser:"Tem certeza de que deseja remover %1$s desta fun\xe7\xe3o?",areYouSureRemoveInvite:"Tem certeza de que deseja cancelar os convites enviados ao(s) membro(s) selecionado(s)?",noContentItemFoundAtUrl:"Nenhum item de conte\xfado foi encontrado nessa URL.",totalColonN:"Total: %1$s",fileIsTooLarge:"Este arquivo \xe9 grande demais.",fileIsZeroBytes:"Este arquivo tem 0 bytes.",fileTypeIsInvalid:"Este tipo de arquivo \xe9 inv\xe1lido.",reachedUploadLimit:"Voc\xea atingiu o limite de carregamento.",youHaveUnsavedChanges:"Voc\xea tem altera\xe7\xf5es n\xe3o salvas. Tem certeza de que deseja navegar mesmo assim?",selectedTooManyFiles:{"f1":"Voc\xea selecionou arquivos em excesso. Voc\xea pode selecionar 1 arquivo de cada vez para carregar.","f2":"Voc\xea selecionou arquivos em excesso. Voc\xea pode selecionar at\xe9 %s arquivos de cada vez para carregar."},didNotSelectAnyFiles:"Voc\xea n\xe3o selecionou nenhum arquivo para carregar.",sorryUploadsFailed:"Falha no carregamento.",failedToUploadFiles:"Tentamos carregar o(s) arquivo(s) selecionados, mas foram encontrados erros. Tente novamente.",uploadedFilesButErrors:"Seus arquivos foram carregados, mas os seguintes erros foram encontrados:",editDetailsForSuccessfulUploads:"Tente carregar esses arquivos novamente mais tarde. Agora, voc\xea ser\xe1 levado at\xe9 uma p\xe1gina para editar os seus arquivos carregados com \xeaxito.",overCustomCssSizeLimit:"Aten\xe7\xe3o: h\xe1 %1$s caracteres CSS a mais do que o n\xfamero permitido nesta Rede do Ning para que sua velocidade seja mantida. Reduza o tamanho do CSS personalizado ou entre em contato com o <a %2$s>Centro de Suporte do Ning</a> para obter ajuda.",overCustomCssSizeLimit:"Aten\xe7\xe3o: h\xe1 %1$s caracteres CSS a mais do que o n\xfamero permitido nesta rede social para que sua velocidade seja mantida. Reduza o tamanho do CSS personalizado ou entre em contato com o <a %2$s>Centro de Suporte do Ning</a> para obter ajuda.",careful:"Cuidado.",youreGettingCloseToTheMaximum:"Voc\xea est\xe1 pr\xf3ximo do n\xfamero m\xe1ximo de %1$s recursos que podem ser adicionados \xe0 sua p\xe1gina principal.",youveReachedTheMaximumNumberOfFeatures:"Voc\xea atingiu o n\xfamero m\xe1ximo de %1$s recursos que podem ser adicionados \xe0 sua p\xe1gina principal.",youveExceededTheMaximumNumberOfEmbeds:"Voc\xea excedeu o n\xfamero m\xe1ximo de %1$s widgets em sua p\xe1gina principal. Remova %2$s dos seus %3$s widgets.",learnMoreAboutEmbeds:"<a %1$s>Saiba mais sobre como os widgets podem tornar sua p\xe1gina principal mais lenta.</a>",justRemoveAFeature:"Basta remover um recurso para adicionar algo novo.",withXFeaturesYouveExceeded:"Com %1$s recursos, voc\xea excedeu o n\xfamero m\xe1ximo de %2$s recursos que podem ser adicionados \xe0 sua p\xe1gina principal.",justRemoveXFeatures:"Basta remover %1$s recursos para adicionar algo novo.",youveReachedTheMaximumNumberOfNingApps:"Voc\xea atingiu o n\xfamero m\xe1ximo de Ning Apps que podem ser adicionados \xe0 sua Rede do Ning.  Remova um Ning App para adicionar outro.",frameBustingMsg:"Voc\xea est\xe1 tentando configurar seu pr\xf3prio dom\xednio para sua Rede do Ning. <a %1$s>Clique aqui</a> para obter mais informa\xe7\xf5es sobre como configur\xe1-lo de forma adequada. Ou <strong><a %2$s>clique aqui para ir at\xe9 o site original</a></strong>.",connectedAsName:"Conectado como %1$s.",creatingFacebookApp:"Criando Facebook App\u2026",wereSorryExclamation:"Lamentamos o inconveniente.",enterLinkUrl:"Digite a URL de um link:",htmlSource:"HTML",attachFile:"Anexar arquivo",frameBustingMsgTitle:"Infelizmente, este site n\xe3o pode ser incorporado em um quadro.",memberPickerSearchSparseText:"N\xe3o h\xe1 nenhum membro com o nome \"%1$s\".",memberPickerFriendsSparseText:"Voc\xea ainda n\xe3o fez nenhum amigo. Em vez disso, tente exibir todos os membros.",memberPickerSparseText:"N\xe3o h\xe1 membros a serem exibidos",clickHereToDownload:"Clique aqui para baixar",anErrorHasOccurred:"Ocorreu um erro. Tente novamente.",exporting:"Exportando\u2026",exportingXofY:function(x,y){
return "Exportando "+x+" de "+y+"\u2026";
},onlyNCMayExport:"Apenas o criador da rede pode exportar conte\xfado.",contentExportIsEmpty:"Nenhum(a) %1$s foi baixado(a), pois sua Rede do Ning n\xe3o possui nenhum(a) %1$s.",enableSpamPrevention:"Habilitar novas ferramentas de preven\xe7\xe3o contra spam",takeAdvantageTwo:"Aproveite duas novas ferramentas para impedir spam:",preventSpammersAndUnwanted:"Impedir remetentes de spam e membros indesejados. Exigir que novos membros respondam corretamente a um question\xe1rio para entrar.",createQuiz:"Criar um question\xe1rio \xbb",requireMembersToVerify:"Exigir que todos os membros confirmem seus endere\xe7os de email.",enableEmailVerification:"Habilitar confirma\xe7\xe3o de email \xbb",setUp:"Configurar",dismiss:"Ignorar",learnMore:"Saiba mais",remindLater:"Lembrar mais tarde",nInvitesLeftToday:{"f1":"1 convite restante hoje","f2":"%s convites restantes hoje"},nSharesLeftToday:{"f1":"1 compartilhamento restante hoje","f2":"%s compartilhamentos restantes hoje"},tooManyPeopleSelected:"Muitas pessoas selecionadas",invitedXButHaveYleft:"Desculpe! Voc\xea tentou enviar %1$s convites. Essa quantidade ultrapassa o limite de %2$s convites no m\xeas.",upgradeToMforNinvites:"<a %1$s><b>Atualize para o %2$s</b></a> para convidar at\xe9 %3$s pessoas por m\xeas.",hiddenWarningTop:"Esta guia n\xe3o foi adicionada \xe0 sua Rede do Ning. H\xe1 um limite de %1$s guias de alto n\xedvel. Remova as guias de alto n\xedvel ou crie guias de alto n\xedvel em subguias. %2$s",removeConfirm:"A remo\xe7\xe3o dessa guia tamb\xe9m remover\xe1 suas subguias. Clique em OK para continuar.",nInvitesLeftThisMonth:{"f1":"1 convite restante este m\xeas","f2":"%s convites restantes este m\xeas"},nSharesLeftThisMonth:{"f1":"1 compartilhamento restante este m\xeas","f2":"%s compartilhamentos restantes este m\xeas"},tooManyInvites:"Convites em excesso",onlyFirstNInvitesSent:{"f1":"Voc\xea s\xf3 possui mais 1 convite \u2014 ele ser\xe1 enviado ao primeiro destinat\xe1rio.","f2":"Voc\xea s\xf3 possui mais %1$s convites \u2014 eles ser\xe3o enviados aos primeiros %1$s destinat\xe1rios."},disable:"Desabilitar",disableSignInSignUpWithX:function(_2a){
return "Desabilitar acesso/registro em "+_2a;
},NMembersHaveConnectedOnXWithY:function(_2b,_2c,_2d){
return _2b+" "+((_2b>1)?("membros conectaram seus perfis em "):("membro conectou seu perfil em "))+_2c+" \xe0 conta do "+_2d+" e talvez n\xe3o possa mais entrar.";
},thereWasAnErrorUpdatingFacebook:"Ocorreu um erro ao salvar suas credenciais do Facebook. Tente novamente.",thereWasAnErrorUpdatingTwitter:"Ocorreu um erro ao salvar suas credenciais do Twitter. Tente novamente.",pleaseEnterAnApplicationIDToContinue:"Digite um ID de aplicativo para continuar",pleaseEnterAnAPIKeyToContinue:"Digite uma Senha de API para continuar",pleaseEnterAnApplicationSecretToContinue:"Digite um Segredo de aplicativo para continuar",pleaseEnterAKeyToContinue:"Digite uma Senha para continuar",pleaseEnterASecretToContinue:"Digite um Segredo para continuar",enableSocialSignIn:"Habilitar acesso por sites de rede social",makeItEvenEasier:"Facilite ainda mais o registro e o acesso de seus membros habilitando o acesso por sites de rede social. Permite que os membros acessem a sua rede do Ning usando:",facebook:"Facebook",google:"Google",yahoo:"Yahoo",readMoreOrGet:"<a %1$s>Saiba mais</a> ou comece a usar agora mesmo.",getStarted:"Come\xe7ar",addMedia:"Adicionar m\xeddia",pasteEmbedCodeFrom:"Cole abaixo o c\xf3digo incorporado do YouTube, etc.:",insertPlainText:"Inserir texto sem formata\xe7\xe3o",pasteTextFromWord:"Cole texto do Word, de um site, etc. abaixo para remover toda a formata\xe7\xe3o:",addLink:"Adicionar link",editLink:"Editar link",linkText:"Texto do link",linkUrl:"URL do link",openInColon:"Abrir em:",sameWindow:"Mesma janela",newWindow:"Nova janela",introducingNingApi:"Apresentando a API do Ning",ningPlatformOpen:"Agora, a Plataforma do Ning est\xe1 aberta para que voc\xea possa levar a sua Rede do Ning a qualquer lugar:",createCustomMobile:function(x){
return "Crie aplicativos m\xf3veis personalizados com <a "+x+">suporte de parceiros do Ning</a>.";
},integrateYourNetwork:function(x){
return "Integre sua rede a aplicativos externos com <a "+x+">suporte de documenta\xe7\xe3o</a>.";
},startNowApi:function(x){
return "Comece agora na nova se\xe7\xe3o <a "+x+">API do Ning</a> do seu painel. Todo o uso da API \xe9 gratuito para redes do Pro at\xe9 o final de 2010.";
},pleaseEnterYourFullName:"Digite seu nome completo.",pleaseEnterAValidEmailAddress:"Digite um endere\xe7o de email v\xe1lido.",pleaseChooseACountry:"Escolha um pa\xeds.",pleaseChooseACategoryForYourNetwork:"Escolha uma categoria para sua rede.",warnLostTermsChanges:"Qualquer texto que tenha sido alterado nos Termos de servi\xe7o personalizados ser\xe1 perdido.",thankYouQuestionSent:"Obrigado, sua pergunta foi enviada para o administrador de %1$s.",showMore:"Mostrar mais",showLess:"Mostrar menos",invalidCustomURL:"Um URL personalizado n\xe3o pode conter \"?\" ou \".\"",theFileCouldNotBeDeleted:"N\xe3o foi poss\xedvel excluir o arquivo.",theSplashPageCouldNotBeSet:"N\xe3o foi poss\xedvel definir a p\xe1gina de abertura.",theSplashPageCouldNotBeCleared:"N\xe3o foi poss\xedvel apagar a p\xe1gina de abertura.",customizeLink:"Personalizar link",deleteThisFile:"Tem certeza de que deseja excluir este arquivo?",newHomepageVisit:"Agora, este arquivo est\xe1 na sua p\xe1gina inicial. Para conferir, v\xe1 para <a %1$s>%2$s</a>",defaultHomepageRestored:"Sua p\xe1gina inicial padr\xe3o foi restaurada.",addConsumer:"Criar senha",renameConsumer:"Editar senha",deleteConsumer:"Revogar senha",revoke:"Revogar",deleteConsumerConfirm:"Tem certeza de que deseja revogar esta senha de API? Todos os membros que est\xe3o usando o %1$s perder\xe3o acesso a ele.",pleaseEnterAName:"Digite um nome"});
dojo.evalObjPath("xg.music.nls",true);
dojo.lang.mixin(xg.music.nls,xg.index.i18n,{play:"executar",error:"Erro",pleaseSelectTrackToUpload:"Selecione uma m\xfasica para carregar",pleaseEnterTrackLink:"Digite o URL da m\xfasica.",thereAreUnsavedChanges:"H\xe1 altera\xe7\xf5es que n\xe3o foram salvas.",processingFailed:"Falha no processamento. Tente novamente mais tarde.",autoplay:"Reprodu\xe7\xe3o autom\xe1tica",showPlaylist:"Exibir lista de reprodu\xe7\xe3o",playLabel:"Executar",url:"URL",rssXspfOrM3u:"rss, xspf ou m3u",save:"Salvar",cancel:"Cancelar",customizePlayerColors:"Personalizar cores",edit:"Editar",shufflePlaylist:"Lista de reprod. aleat\xf3ria",fileIsNotAnMp3:"Um dos arquivos n\xe3o parece estar no formato MP3. Tentar carregar assim mesmo?",entryNotAUrl:"Uma das entradas n\xe3o parece ser uma URL. Certifique-se que todas as entradas come\xe7am com <kbd>http://</kbd>"});
dojo.evalObjPath("xg.page.nls",true);
dojo.lang.mixin(xg.page.nls,xg.index.i18n,{numberOfCharactersExceedsMaximum:function(n,_32){
return "O n\xfamero de caracteres ("+n+") ultrapassa o n\xfamero m\xe1ximo ("+_32+") ";
},pleaseEnterContent:"Digite o conte\xfado da p\xe1gina",pleaseEnterTitle:"Digite um t\xedtulo para o evento.",pleaseEnterAComment:"Digite um coment\xe1rio.",save:"Salvar",cancel:"Cancelar",edit:"Editar",close:"Fechar",displayPagePosts:"Exibir mensagens da p\xe1gina",directory:"Diret\xf3rio",displayTab:"Mostrar guia",addAnotherPage:"Adicionar outra p\xe1gina",tabText:"Texto da guia",urlDirectory:"Diret\xf3rio URL",displayTabForPage:"Se \xe9 para exibir uma guia para a p\xe1gina",tabTitle:"T\xedtulo da guia",remove:"Remover",thereIsAProblem:"H\xe1 um problema com sua informa\xe7\xe3o."});
dojo.evalObjPath("xg.photo.nls",true);
dojo.lang.mixin(xg.photo.nls,xg.index.i18n,{random:"Aleat\xf3rio",loop:"Loop",untitled:"sem t\xedtulo",photos:"Fotos",edit:"Editar",photosFromAnAlbum:"\xc1lbuns",show:"Exibir",rows:"linhas",cancel:"Cancelar",customizePlayerColors:"Personalizar cores",save:"Salvar",numberOfCharactersExceedsMaximum:function(n,_34){
return "O n\xfamero de caracteres ("+n+") ultrapassa o n\xfamero m\xe1ximo ("+_34+") ";
},pleaseSelectPhotoToUpload:"Selecione uma foto para carregar,",importingNofMPhotos:function(n,m){
return "Importando <span id=\"currentP\">"+n+"</span> de "+m+" fotos. ";
},enterAlbumTitle:"Digite um t\xedtulo para o \xe1lbum",enterPhotosTitle:"Digite t\xedtulos para as fotos",starting:"Iniciando\u2026",done:"Pronto",from:"De",display:"Mostrar",takingYou:"Agora vamos ver suas fotos\u2026",anErrorOccurred:"Infelizmente ocorreu um erro. Informe o problema usando o link na parte inferior da p\xe1gina.",weCouldntFind:"N\xe3o foi poss\xedvel localizar nenhuma foto. Por que voc\xea n\xe3o tenta uma das outras op\xe7\xf5es?",wereSorry:"Desculpe",makeThisTheAlbumCover:"Tornar esta a capa do \xe1lbum",thisIsTheAlbumCover:"Esta \xe9 a capa do \xe1lbum"});
dojo.evalObjPath("xg.activity.nls",true);
dojo.lang.mixin(xg.activity.nls,xg.index.i18n,{edit:"Editar",show:"Exibir",events:"eventos",setWhatActivityGetsDisplayed:"Configurar qual atividade \xe9 exibida",save:"Salvar",cancel:"Cancelar"});
dojo.evalObjPath("xg.profiles.nls",true);
dojo.lang.mixin(xg.profiles.nls,xg.index.i18n,{close:"Fechar",shortenUrl:"Abreviar URL",connectToTwitter:"Conectar-se ao Twitter",toPostStatus:"Para postar suas atualiza\xe7\xf5es de status no Twitter, conecte seu perfil do %s ao Twitter.",addTwitterAccount:"Adicionar conta do Twitter",toConnectTwitterAccount:"Para conectar uma nova conta ao Twitter, saia do Twitter e clique no bot\xe3o \"Conectar\", abaixo. Em seguida, fa\xe7a login usando as credenciais da nova conta.",connect:"Conectar",ageMustBeAtLeast0:"Age must be at least zero",wereSorryProper:"Desculpe",messageIsTooLong:function(n){
return "A mensagem est\xe1 muito longa. Use at\xe9 "+n+" caracteres.";
},comments:"coment\xe1rios",requestLimitExceeded:"Limite de Solicita\xe7\xe3o de Amigos Excedido",removeFriendTitle:function(_38){
return "Remover "+_38+" como amigo?";
},removeFriendConfirm:function(_39){
return "Tem certeza de que deseja remover "+_39+" como amigo?";
},postTooLong:"Limite sua postagem no blog a %1$s caracteres",edit:"Editar",selectCredits:"Selecione a quantidade de cr\xe9ditos desejada.",linkHasBeenPosted:"O link foi postado nas atividades mais recentes",recentlyAdded:"Rec\xe9m-adicionados(as)",featured:"Apresentado",iHaveRecentlyAdded:"Adicionei recentemente",fromTheSite:"Da Rede do Ning",cancel:"Cancelar",save:"Salvar",loading:"Carregando...",pleaseEnterPostBody:"Digite algo para o corpo da mensagem",pleaseEnterChatter:"Digite algo para seu coment\xe1rio",letMeApproveChatters:"Os coment\xe1rios passam pelo meu crivo antes de serem publicados?",noPostChattersImmediately:"N\xe3o - Publique os coment\xe1rios imediatamente",yesApproveChattersFirst:"Sim - Passam pelo meu crivo antes",memberHasChosenToModerate:function(_3a){
return _3a+" optou por moderar os coment\xe1rios.";
},reallyDeleteThisPost:"Excluir realmente este lan\xe7amento?",commentWall:"P\xe1gina de Coment\xe1rios",commentWallNComments:{"f1":"P\xe1gina de coment\xe1rios (1 coment\xe1rio)","f2":"P\xe1gina de coment\xe1rios (%s coment\xe1rios)"},statusTooLong:function(_3b){
return "Seu status n\xe3o pode ter mais de "+_3b+" caracteres.";
},statusCannotBeEmpty:"\xc9 necess\xe1rio adicionar texto para postar uma atualiza\xe7\xe3o.",errorUpdatingStatus:"Erro ao atualizar seu status. Tente novamente mais tarde.",statusHintTooLong:"Limite o prompt da atualiza\xe7\xe3o de status a menos de %1$s caracteres.",youPostedY:"Voc\xea postou '%1$s'",commentTooLong:"Seu coment\xe1rio n\xe3o pode ter mais de %1$s caracteres.",display:"Mostrar",from:"De",show:"Exibir",rows:"linhas",posts:"lan\xe7amentos",networkError:"Erro",wereSorry:"Desculpe, mas n\xe3o \xe9 poss\xedvel salvar o novo layout. Isso se deve provavelmente \xe0 perda da conex\xe3o com a Internet. Verifique a conex\xe3o e tente novamente.",returnToDefaultWarning:"Isso retornar\xe1 todos os recursos da sua se\xe7\xe3o Minha p\xe1gina \xe0s configura\xe7\xf5es padr\xe3o. Deseja continuar?",unableToCompleteAction:"Desculpe, mas n\xe3o foi poss\xedvel concluir a \xfaltima a\xe7\xe3o. Tente novamente mais tarde.",selectAtLeastOneMessage:"Selecione pelo menos uma mensagem para executar essa a\xe7\xe3o.",selectedSendersBlocked:function(n){
switch(n){
case 1:
return "O remetente selecionado foi bloqueado.";
default:
return "Os remetentes selecionados foram bloqueados.";
}
},bulkConfirm_blockSender:"Isso bloquear\xe1 os remetentes das mensagens marcadas.",bulkConfirm_delete:"Isso excluir\xe1 as mensagens marcadas.",sendingHeader:"Enviando mensagem",sendingLabel:"Enviando...",messageSent:"Mensagem Enviada",yourMessageHasBeenSent:"Sua mensagem foi enviada!",nameIsEmpty:"Digite seu nome.",countryIsEmpty:"Digite seu pa\xeds.",zipIsEmpty:"Digite seu CEP.",zipIsIncorrect:"Digite um CEP v\xe1lido.",locationIsEmpty:"Digite sua cidade/seu estado.",birthdays:"anivers\xe1rios",deleteMessage:"Tem certeza de que deseja excluir a mensagem selecionada?",deleteMessages:function(n){
return "Tem certeza de que deseja excluir as "+n+" mensagens selecionadas?";
},blockSender:"Tem certeza de que deseja bloquear o membro selecionado?",blockSenders:function(n){
return "Tem certeza de que deseja bloquear os "+n+" membros selecionados?";
},wereSorryExclamation:"Lamentamos o inconveniente.",youAreConnectedAsX:"Voc\xea est\xe1 conectado como %s",pleaseEnterValueForPost:"Adicione texto ao corpo da postagem",warnLostChanges:"Qualquer texto que voc\xea tenha adicionado \xe0 sua postagem no blog ser\xe1 perdido.",select:"Selecione:",problemOccurred:"Ocorreu um problema. Tente novamente.",youAreConnectedAsFanPage:"Voc\xea est\xe1 conectado \xe0 p\xe1gina do Facebook %s"});
dojo.evalObjPath("xg.shared.nls",true);
dojo.lang.mixin(xg.shared.nls,xg.index.i18n,{error:"Erro",friendLimitExceeded:"Limite de Amigos Excedido",requestLimitExceeded:"Limite de Solicita\xe7\xe3o de Amigos Excedido",addNameAsFriend:function(_3f){
return "Adicionar "+_3f+" como amigo?";
},nameMustConfirmFriendship:function(_40){
return _40+" precisar\xe1 confirmar que \xe9 seu amigo.";
},nameMustBeFriendsToMessage:"Voc\xea e %1$s devem ser amigos para que voc\xea possa enviar mensagens.",nameMustConfirmYourFriendship:"%1$s precisar\xe1 confirmar se \xe9 seu amigo.",addPersonalMessage:"Adicionar uma mensagem pessoal",typePersonalMessage:"Digite uma mensagem pessoal...",includePersonalMessage:"Incluir mensagem pessoal",thereHasBeenAnError:"Erro",message:"Mensagem",send:"Enviar",addAsFriend:"Adicionar como amigo",friendRequestSent:"Solicita\xe7\xe3o de Amigo Enviada!",yourFriendRequestHasBeenSent:"Sua solicita\xe7\xe3o de amigo foi enviada!",yourMessage:"Sua mensagem",updateMessage:"Atualizar mensagem",updateMessageQ:"Atualizar mensagem?",removeWords:"Para ter certeza de que seu e-mail ser\xe1 entregue com sucesso, recomendamos voltar para mudar ou remover as seguintes palavras:",warningMessage:"Parece que h\xe1 algumas palavras neste e-mail que pode envi\xe1-lo para uma pasta de Spam.",errorMessage:"H\xe1 6 ou mais palavras neste e-mail que pode enviar seu e-mail para uma pasta de spam.",goBack:"Voltar",sendAnyway:"Enviar assim mesmo",messageIsTooLong:function(n){
return "A mensagem est\xe1 muito longa. Use at\xe9 "+n+" caracteres.";
},yourMessageIsTooLong:function(n){
return "A mensagem est\xe1 muito longa. Use at\xe9 "+n+" caracteres.";
},locationNotFound:function(_43){
return "<em>"+local+"</em> n\xe3o encontrado.";
},confirmation:"Confirma\xe7\xe3o",showMap:"Exibir mapa",hideMap:"Ocultar mapa",yourCommentMustBeApproved:"Seu coment\xe1rio deve ser aprovado antes que algu\xe9m possa v\xea-lo.",nComments:function(n){
switch(n){
case 1:
return "1 coment\xe1rio";
default:
return n+" coment\xe1rios";
}
},pleaseEnterAComment:"Digite um coment\xe1rio.",uploadAPhoto:"Carregar uma foto",uploadAnImage:"Carregar uma imagem",gifJpgPngLimit:"(GIF, JPEG ou PNG; limite %s)",uploadAPhotoEllipsis:"Carregar uma foto\u2026",uploadAnImageEllipsis:"Carregar uma imagem...",useExistingImage:"Usar imagem existente:",useExistingPhoto:"Usar foto existente:",existingPhoto:"Foto existente",noPhoto:"Nenhuma foto",uploadPhotoFromComputer:"Carregar uma foto de seu computador",currentPhoto:"Foto atual",existingImage:"Imagem existente",useThemeImage:"Usar imagem tem\xe1tica:",themeImage:"Imagem tem\xe1tica",noImage:"Sem imagens",uploadImageFromComputer:"Carregar uma imagem de seu computador",tileThisImage:"Colocar a imagem lado a lado",done:"Pronto",currentImage:"Imagem atual",pickAColor:"Selecione uma cor",openColorPicker:"Abra o Seletor de Cores",transparent:"Transparente",loading:"Carregando...",ok:"OK",save:"Salvar",cancel:"Cancelar",saving:"Salvando\u2026",addAnImage:"Adicionar uma imagem",uploadAFile:"Carregar arquivo",pleaseEnterAWebsite:"Digite um endere\xe7o de site.",bold:"Negrito",italic:"It\xe1lico",underline:"Sublinhar",strikethrough:"Riscar",addHyperink:"Adicionar hiperlink",options:"Op\xe7\xf5es",wrapTextAroundImage:"Dispor texto ao redor da imagem?",imageOnLeft:"Imagem \xe0 esquerda?",imageOnRight:"Imagem \xe0 direita?",createThumbnail:"Criar miniatura?",pixels:"pixels",createSmallerVersion:"Criar uma imagem menor que sua imagem para exibi\xe7\xe3o. Configure a largura em pixels.",createSmallerVersionSetLongestDimension:"Crie uma vers\xe3o menor da imagem para exibi\xe7\xe3o. Defina a maior dimens\xe3o em pixels.",popupWindow:"Janela pop-up?",linkToFullSize:"Fazer um link \xe0 vers\xe3o de tamanho original da imagem em uma janela pop-up.",add:"Adicionar",keepWindowOpen:"Mantenha esta janela do navegador aberta enquanto o carregamento estiver em andamento.",cancelUpload:"Cancelar carregamento",pleaseSelectAFile:"Selecione um arquivo de imagem",pleaseSpecifyAThumbnailSize:"Especifique o tamanho da miniatura",thumbnailSizeMustBeNumber:"O tamanho da miniatura deve ser um n\xfamero",addExistingImage:"ou coloque uma imagem existente",addExistingFile:"ou insira um arquivo existente",clickToEdit:"Clique para editar",requestSent:"Pedido enviado!",pleaseCorrectErrors:"Corrija estes erros",noo:"NOVO",none:"NENHUM",joinNow:"Associar-se agora",join:"Associar-se",signIn:"Inscri\xe7\xe3o",signUp:"Registro",addToFavorites:"Favorito",removeFromFavorites:"Remover dos Favoritos",follow:"Seguir",stopFollowing:"Parar de acompanhar",pendingPromptTitle:"Associa\xe7\xe3o esperando aprova\xe7\xe3o",youCanDoThis:"Voc\xea pode faz\xea-lo t\xe3o logo sua associa\xe7\xe3o tenha sido aprovada pelos administradores.",editYourTags:"Editar suas tags",addTags:"Adicionar tags",editLocation:"Editar local",editTypes:"Editar tipo de evento",imageSizeLimit:"(Limite de 10 MB)",nChars:{"f1":"1 caractere","f2":"%1$s caracteres"},youHaveUnsavedChanges:"Voc\xea tem altera\xe7\xf5es n\xe3o salvas. Tem certeza de que deseja navegar mesmo assim?",commentWall:"P\xe1gina de Coment\xe1rios",commentWallNComments:{"f1":"P\xe1gina de coment\xe1rios (1 coment\xe1rio)","f2":"P\xe1gina de coment\xe1rios (%s coment\xe1rios)"},choosePluralizationForm:function(n){
if(n==1){
return "f1";
}else{
return "f2";
}
},toPostToTwitter:"Para postar no Twitter, adicione texto",editImage:"Editar imagem",alignImage:"Alinhar imagem...",left:"\xc0 esquerda",center:"Ao centro",right:"\xc0 direita",resizeImage:"Redimensionar imagem?",linkToOriginal:"Link para o original?",update:"Atualizar",orUseExistingImage:"ou use a imagem existente",fileSizeLimit:"Limite de tamanho: %1$s MB",reasonColon:"Motivo:",spam:"Spam",contentHasBeenFlagged:"Este conte\xfado foi marcado",contentHasBeenUnFlagged:"O conte\xfado foi restaurado",porn:"Conte\xfado sexual",illegal:"Ilegal",flag:"Marcar",inappropriate:"N\xe3o apropriado",linkUrl:"URL do link",pasteText:"Colar como texto sem formata\xe7\xe3o",noFileAtUrl:"N\xe3o h\xe1 arquivos nesse URL. Tente novamente.",uploadFileAnyType:"Carregue um arquivo de qualquer tipo. O arquivo ser\xe1 exibido como um link.",uploadFile:"Carregar arquivo",media:"M\xeddia",file:"Arquivo",image:"Imagem",padding:"Preenchimento",fromMyComputer:"Do meu computador",fromUrl:"De um URL",link:"Link",linkColon:"Link:",imageColon:"Imagem:",width:"Largura",layout:"Layout",addImage:"Adicionar imagem",font:"Fonte",color:"Cor",blockquote:"Blockquote",unorderedList:"Lista n\xe3o ordenada",orderedList:"Lista ordenada",addColon:"Adicionar:",visualMode:"Modo visual",htmlEditor:"Editor de HTML",fullscreen:"Tela inteira",returnToNormalSize:"Voltar ao tamanho normal",returnToVisualMode:"Voltar ao Modo visual",full:"Completo"});
dojo.evalObjPath("xg.video.nls",true);
dojo.lang.mixin(xg.video.nls,xg.index.i18n,{edit:"Editar",display:"Mostrar",detail:"Detalhes",player:"Player",from:"De",show:"Exibir",videos:"v\xeddeos",cancel:"Cancelar",customizePlayerColors:"Personalizar cores",save:"Salvar",numberOfCharactersExceedsMaximum:function(n,_47){
return "O n\xfamero de caracteres ("+n+") ultrapassa o n\xfamero m\xe1ximo ("+_47+") ";
},approve:"Aprovar",approving:"Aprovando...",keepWindowOpenWhileApproving:"Deixe esta janela do navegador aberta enquanto os v\xeddeos est\xe3o sendo aprovados. Este processo pode levar alguns minutos.","delete":"Excluir",deleting:"Excluindo...",keepWindowOpenWhileDeleting:"Deixe esta janela do navegador aberta enquanto os v\xeddeos est\xe3o sendo exclu\xeddos. Este processo pode levar alguns minutos.",pasteInEmbedCode:"Digite abaixo o c\xf3digo incorporado de um v\xeddeo.",invalidUrlFormat:"A URL digitada parece estar em um formato inv\xe1lido.",pleaseSelectVideoToUpload:"Selecione um v\xeddeo para carregar.",embedCodeContainsMoreThanOneVideo:"O c\xf3digo incorporado cont\xe9m mais de um v\xeddeo. Certifique de que possui apenas um tag <object> e/ou <embed>.",embedCodeMissingTag:"No c\xf3digo incorporado falta um tag &lt;embed&gt; ou &lt;object&gt;.",fileIsNotAMov:"Este arquivo n\xe3o parece estar no formato .mov, .mpg, .mp4, .avi, .3gp, .3g2 ou .wmv. Deve-se tentar carregar assim mesmo?",embedHTMLCode:"C\xf3digo HTML:",directLink:"Link direto",addToMyspace:"Adicionar ao MySpace",shareOnFacebook:"Compartilhar no Facebook"});
dojo.evalObjPath("xg.uploader.nls",true);
dojo.lang.mixin(xg.uploader.nls,xg.index.i18n,{fileBrowserHeader:"Meu Computador",fileRoot:"Meu Computador",fileInformationHeader:"Informa\xe7\xf5es",uploadHeader:"Arquivos para carregar",dragOutInstructions:"Arraste os arquivos para remov\xea-los",dragInInstructions:"Arraste os arquivos aqui",selectInstructions:"Selecione um arquivo",files:"Arquivos",totalSize:"Tamanho total",fileName:"Nome",fileSize:"Tamanho",nextButton:"Pr\xf3ximo >",okayButton:"OK",yesButton:"Sim",noButton:"N\xe3o",uploadButton:"Carregar",cancelButton:"Cancelar",backButton:"Voltar",continueButton:"Continuar",uploadingStatus:function(n,m){
return "Carregando"+n+" de "+m;
},uploadLimitWarning:function(n){
return "Voc\xea pode carregar "+n+" arquivos por vez. ";
},uploadLimitCountdown:function(n){
switch(n){
case 0:
return "Voc\xea adicionou o n\xfamero m\xe1ximo de m\xfasicas. ";
case 1:
return "P\xe1gina de Coment\xe1rios (um coment\xe1rio)";
default:
return "P\xe1gina de Coment\xe1rios ("+n+" coment\xe1rios) Tem certeza de que deseja pesquisar mesmo assim?";
}
},uploadingLabel:"Carregando...",uploadingInstructions:"Deixe esta janela aberta enquanto o carregamento est\xe1 em andamento",iHaveTheRight:"Tenho o direito de carregar estes arquivos conforme os <a href=\"/main/authorization/termsOfService\">Termos de Servi\xe7o</a>",updateJavaTitle:"Atualizar Java",updateJavaDescription:"O carregador por blocos exige uma vers\xe3o mais recente de Java.  Clique em \"OK\" para obter Java.",batchEditorLabel:"Editar as informa\xe7\xf5es para todos os itens",applyThisInfo:"Aplicar estas informa\xe7\xf5es aos arquivos abaixo",titleProperty:"T\xedtulo",descriptionProperty:"Descri\xe7\xe3o",tagsProperty:"Tags",viewableByProperty:"Pode ser vista por",viewableByEveryone:"Qualquer um",viewableByFriends:"Somente meus amigos",viewableByMe:"Somente eu",albumProperty:"\xc1lbum",artistProperty:"Artista",enableDownloadLinkProperty:"Habilitar link para download",enableProfileUsageProperty:"Permitir que pessoas coloquem esta m\xfasica em suas p\xe1ginas",licenseProperty:"Licen\xe7a",creativeCommonsVersion:"3.0",selectLicense:"\u2014 Selecionar licen\xe7a \u2014",copyright:"\xa9 Todos os direitos reservados",ccByX:function(n){
return "Atribui\xe7\xe3o da Creative Commons "+n;
},ccBySaX:function(n){
return "Atribui\xe7\xe3o-Compartilhamento pela mesma Licen\xe7a da Creative Commons "+n;
},ccByNdX:function(n){
return "Atribui\xe7\xe3o-Vedada a Cria\xe7\xe3o de Obras Derivadas Creative Commons "+n;
},ccByNcX:function(n){
return "Atribui\xe7\xe3o-Uso N\xe3o-Comercial da Creative Commons "+n;
},ccByNcSaX:function(n){
return "Atribui\xe7\xe3o-Uso N\xe3o-Comercial-Compartilhamento pela mesma Licen\xe7a da Creative Commons "+n;
},ccByNcNdX:function(n){
return "Atribui\xe7\xe3o-Uso N\xe3o-Comercial-Vedada a Cria\xe7\xe3o de Obras Derivadas da Creative Commons "+n;
},publicDomain:"Dom\xednio p\xfablico",other:"Outros",errorUnexpectedTitle:"Opa!",errorUnexpectedDescription:"Ocorreu um erro. Tente novamente.",errorTooManyTitle:"H\xe1 itens demais",errorTooManyDescription:function(n){
return "Desculpe, mas voc\xea s\xf3 pode carregar "+n+" itens por vez. ";
},errorNotAMemberTitle:"N\xe3o permitido",errorNotAMemberDescription:"Desculpe, voc\xea precisa ser associado para carregar.",errorContentTypeNotAllowedTitle:"N\xe3o permitido",errorContentTypeNotAllowedDescription:"Desculpe, voc\xea n\xe3o tem permiss\xe3o para carregar este tipo de conte\xfado.",errorUnsupportedFormatTitle:"Opa!",errorUnsupportedFormatDescription:"Desculpe, este tipo de arquivo n\xe3o \xe9 suportado.",errorUnsupportedFileTitle:"Opa!",errorUnsupportedFileDescription:"foo.exe \xe9 um formato n\xe3o suportado.",errorUploadUnexpectedTitle:"Opa!",errorUploadUnexpectedDescription:function(_53){
return _53?("Parece haver um problema com o arquivo "+_53+". Remova-o da lista antes de carregar os arquivos restantes."):"Parece haver um problema com o arquivo no topo da lista. Remova-o da lista antes de carregar os arquivos restantes.";
},cancelUploadTitle:"Cancelar carregamento?",cancelUploadDescription:"Tem certeza que deseja cancelar os carregamentos restantes?",uploadSuccessfulTitle:"Carregamento conclu\xeddo.",uploadSuccessfulDescription:"Espere enquanto o levamos ao que voc\xea carregou...",uploadPendingDescription:"Seus arquivos foram carregados com \xeaxito e est\xe3o aguardando aprova\xe7\xe3o.",photosUploadHeader:"Fotos para carregar",photosDragOutInstructions:"Arraste as fotos para fora para remov\xea-las",photosDragInInstructions:"Arraste suas fotos aqui",photosSelectInstructions:"Selecione uma foto",photosFiles:"Fotos",photosUploadingStatus:function(n,m){
return "Carregando foto"+n+" de "+m;
},photosErrorTooManyTitle:"H\xe1 fotos demais",photosErrorTooManyDescription:function(n){
return "Desculpe, voc\xea pode carregar apenas "+n+" fotos por vez. ";
},photosErrorContentTypeNotAllowedDescription:"Desculpe, o recurso para carregar fotos est\xe1 desabilitado.",photosErrorUnsupportedFormatDescription:"Desculpe, voc\xea pode carregar imagens apenas nos formatos .jpg, .gif ou .png.",photosErrorUnsupportedFileDescription:function(n){
return n+" n\xe3o \xe9 arquivo a .jpg, .gif ou .png.";
},photosBatchEditorLabel:"Editar informa\xe7\xf5es sobre todas as fotos",photosApplyThisInfo:"Aplicar estas informa\xe7\xf5es \xe0s fotos abaixo",photosErrorUploadUnexpectedDescription:function(_58){
return _58?("Parece haver um problema com o arquivo "+_58+". Remova-o da lista antes de carregar as fotos restantes."):"Parece haver um problema com a foto no topo da lista. Remova-a da lista antes de carregar as fotos restantes.";
},photosUploadSuccessfulDescription:"Aguarde enquanto o levamos \xe0s suas fotos...",photosUploadPendingDescription:"Suas fotos foram carregadas com \xeaxito e est\xe3o aguardando aprova\xe7\xe3o.",photosUploadLimitWarning:function(n){
return "Voc\xea pode carregar "+n+" fotos por vez. ";
},photosUploadLimitCountdown:function(n){
switch(n){
case 0:
return "Voc\xea adicionou o n\xfamero m\xe1ximo de m\xfasicas. ";
case 1:
return "P\xe1gina de Coment\xe1rios (um coment\xe1rio)";
default:
return "P\xe1gina de Coment\xe1rios ("+n+" coment\xe1rios) Tem certeza de que deseja pesquisar mesmo assim?";
}
},photosIHaveTheRight:"Eu tenho o direito de carregar estas fotos conforme os <a href=\"/main/authorization/termsOfService\">Termos de Servi\xe7o</a>",videosUploadHeader:"V\xeddeos para carregar",videosDragInInstructions:"Arraste os v\xeddeos aqui",videosDragOutInstructions:"Arraste os v\xeddeos para remov\xea-los",videosSelectInstructions:"Selecione um v\xeddeo",videosFiles:"V\xeddeos",videosUploadingStatus:function(n,m){
return "Carregando v\xeddeo "+n+" de "+m;
},videosErrorTooManyTitle:"H\xe1 v\xeddeos demais",videosErrorTooManyDescription:function(n){
return "Desculpe, voc\xea pode carregar apenas "+n+" v\xeddeos por vez. ";
},videosErrorContentTypeNotAllowedDescription:"Desculpe, o recurso para carregar v\xeddeos est\xe1 desabilitado.",videosErrorUnsupportedFormatDescription:"Desculpe, voc\xea pode carregar v\xeddeos apenas nos formatos .avi, .mov, .mp4, .wmv ou .mpg.",videosErrorUnsupportedFileDescription:function(x){
return x+" n\xe3o \xe9 arquivo .avi, .mov, .mp4, .wmv or .mpg.";
},videosBatchEditorLabel:"Editar informa\xe7\xf5es para todos os v\xeddeos",videosApplyThisInfo:"Aplicar estas informa\xe7\xf5es aos v\xeddeos abaixo",videosErrorUploadUnexpectedDescription:function(_5f){
return _5f?("Parece haver um problema com o arquivo "+_5f+". Remova-o da lista antes de carregar o restante de seus v\xeddeos."):"Parece haver um problema com o v\xeddeo do in\xedcio da lista. Remova-o antes de carregar o restante de seus v\xeddeos.";
},videosUploadSuccessfulDescription:"Espere enquanto o levamos aos seus v\xeddeos...",videosUploadPendingDescription:"Seus v\xeddeos foram carregados com \xeaxito e est\xe3o aguardando aprova\xe7\xe3o.",videosUploadLimitWarning:function(n){
return "Voc\xea pode carregar "+n+" v\xeddeos por vez. ";
},videosUploadLimitCountdown:function(n){
switch(n){
case 0:
return "Voc\xea adicionou o n\xfamero m\xe1ximo de m\xfasicas. ";
case 1:
return "P\xe1gina de Coment\xe1rios (um coment\xe1rio)";
default:
return "P\xe1gina de Coment\xe1rios ("+n+" coment\xe1rios) Tem certeza de que deseja pesquisar mesmo assim?";
}
},videosIHaveTheRight:"Eu tenho o direito de carregar estes v\xeddeos conforme os <a href=\"/main/authorization/termsOfService\">Termos de Servi\xe7o</a>",musicUploadHeader:"M\xfasicas para carregar",musicTitleProperty:"T\xedtulo da m\xfasica",musicDragOutInstructions:"Arraste as m\xfasicas para remov\xea-las",musicDragInInstructions:"Arraste as m\xfasicas aqui",musicSelectInstructions:"Selecione uma m\xfasica",musicFiles:"M\xfasicas",musicUploadingStatus:function(n,m){
return "Carregando m\xfasicas "+n+" de "+m;
},musicErrorTooManyTitle:"H\xe1 m\xfasicas demais",musicErrorTooManyDescription:function(n){
return "Desculpe, voc\xea pode carregar apenas "+n+" m\xfasicas por vez. ";
},musicErrorContentTypeNotAllowedDescription:"Desculpe, o recurso para carregar m\xfasicas est\xe1 desabilitado.",musicErrorUnsupportedFormatDescription:"Desculpe, voc\xea pode carregar m\xfasicas apenas no formato .mp3.",musicErrorUnsupportedFileDescription:function(x){
return x+" n\xe3o \xe9 um arquivo .mp3.";
},musicBatchEditorLabel:"Editar informa\xe7\xf5es sobre todas as m\xfasicas",musicApplyThisInfo:"Aplicar estas informa\xe7\xf5es \xe0s m\xfasicas abaixo",musicErrorUploadUnexpectedDescription:function(_66){
return _66?("Parece haver um problema com o arquivo "+_66+". Remova-a da lista antes de carregar as m\xfasicas restantes."):"Parece haver um problema com a m\xfasica no topo da lista. Remova-a da lista antes de carregar as m\xfasicas restantes.";
},musicUploadSuccessfulDescription:"Espere enquanto o levamos \xe0s suas m\xfasicas...",musicUploadPendingDescription:"Suas m\xfasicas foram carregadas com \xeaxito e est\xe3o aguardando aprova\xe7\xe3o.",musicUploadLimitWarning:function(n){
return "Voc\xea pode carregar "+n+" m\xfasicas por vez. ";
},musicUploadLimitCountdown:function(n){
switch(n){
case 0:
return "Voc\xea adicionou o n\xfamero m\xe1ximo de m\xfasicas. ";
case 1:
return "P\xe1gina de Coment\xe1rios (um coment\xe1rio)";
default:
return "P\xe1gina de Coment\xe1rios ("+n+" coment\xe1rios) Tem certeza de que deseja pesquisar mesmo assim?";
}
},musicIHaveTheRight:"Eu tenho o direito de carregar estas m\xfasicas conforme os <a href=\"/main/authorization/termsOfService\">Termos de Servi\xe7o</a>"});
dojo.evalObjPath("xg.events.nls",true);
dojo.lang.mixin(xg.events.nls,xg.index.i18n,{pleaseEnterTitle:"Digite um t\xedtulo para o evento.",pleaseEnterDescription:"Digite uma descri\xe7\xe3o para o evento.",messageIsTooLong:function(n){
return "A mensagem est\xe1 muito longa. Use at\xe9 "+n+" caracteres.";
},pleaseEnterLocation:"Digite um local para o evento.",pleaseEnterType:"Digite pelo menos um tipo para o evento.",sendMessageToGuests:"Enviar mensagens aos convidados",sendMessageToGuestsThat:"Enviar mensagem aos convidados que",areAttending:"Comparecer\xe1",mightAttend:"Poder\xe1 comparecer",haveNotYetRsvped:"Ainda n\xe3o foi dado RSVP",areNotAttending:"N\xe3o comparecer\xe1",yourMessage:"Sua mensagem",send:"Enviar",sending:"Enviando...",yourMessageIsBeingSent:"Sua mensagem est\xe1 sendo enviada.",messageSent:"Mensagem Enviada",yourMessageHasBeenSent:"Sua mensagem foi enviada!",chooseRecipient:"Escolha um recipiente.",pleaseEnterAMessage:"Digite uma mensagem.",thereHasBeenAnError:"Erro",datePickerDateFormat:"mm/dd/yyyy",monday:"Segunda-feira",tuesday:"Ter\xe7a-feira",wednesday:"Quarta-feira",thursday:"Quinta-feira",friday:"Sexta-feira",saturday:"S\xe1bado",sunday:"Domingo",mondayAbbreviated:"Seg",tuesdayAbbreviated:"Ter",wednesdayAbbreviated:"Qua",thursdayAbbreviated:"Qui",fridayAbbreviated:"Sex",saturdayAbbreviated:"S\xe1b",sundayAbbreviated:"Dom",mondayShort:"S",tuesdayShort:"T",wednesdayShort:"Q",thursdayShort:"Q",fridayShort:"S",saturdayShort:"D",sundayShort:"D",januaryShort:"J",februaryShort:"F",marchShort:"M",aprilShort:"A",mayShort:"M",juneShort:"J",julyShort:"J",augustShort:"A",septemberShort:"S",octoberShort:"O",novemberShort:"N",decemberShort:"D",januaryAbbreviated:"Jan",februaryAbbreviated:"Fev",marchAbbreviated:"Mar",aprilAbbreviated:"Abr",mayAbbreviated:"Mai",juneAbbreviated:"Jun",julyAbbreviated:"Jul",augustAbbreviated:"Ago",septemberAbbreviated:"Set",octoberAbbreviated:"Out",novemberAbbreviated:"Nov",decemberAbbreviated:"Dez",january:"Janeiro",february:"Fevereiro",march:"Mar\xe7o",april:"Abril",may:"Maio",june:"Junho",july:"Julho",august:"Agosto",september:"Setembro",october:"Outubro",november:"Novembro",december:"Dezembro"});
dojo.evalObjPath("xg.notes.nls",true);
dojo.lang.mixin(xg.notes.nls,xg.index.i18n,{addNewNote:"Adicionar nova nota",pleaseEnterNoteTitle:"Digite um t\xedtulo para a nota!",noteTitleTooLong:"O t\xedtulo da nota \xe9 longo demais",pleaseEnterNoteEntry:"Digite uma nota."});
dojo.evalObjPath("xg.gifts.nls",true);
dojo.lang.mixin(xg.gifts.nls,xg.index.i18n,{thereHasBeenAnError:"Ocorreu um erro",pleaseSelectGift:"Selecione um presente.",buyCredits:"Comprar cr\xe9ditos",added:"Adicionado!",creditsRequired:"Cr\xe9ditos necess\xe1rios:",moreCreditsRequired:"Mais cr\xe9ditos necess\xe1rios",xCreditsForYUSD:"%1$s cr\xe9ditos  \u2013  $%2$s USD",purchaseCreditsToSend:"Compre alguns cr\xe9ditos para enviar este presente.",purchaseCredits:"Comprar cr\xe9ditos:",byMakingPurchase:"Ao fazer uma compra, voc\xea concorda com os <a %1$s>Termos dos presentes virtuais</a>.",payPalCheckout:"Sa\xedda do PayPal",close:"Fechar",removeCategory:"Remover categoria",removeGiftWarning:"Este \xe9 um presente do Ning. Remov\xea-lo far\xe1 com que ele seja removido da Loja de presentes, mas ele poder\xe1 ser adicionado novamente a partir do Cat\xe1logo de presentes do Ning.",removeGiftTitle:"Remover presente do Ning",removeGiftWarningCustom:"Este \xe9 um presente personalizado. Remov\xea-lo o excluir\xe1 completamente da Loja de presentes. Ele n\xe3o ficar\xe1 dispon\xedvel novamente.",removeGiftTitleCustom:"Remover presente personalizado",thisWillRemoveThisCategory:"Isso remover\xe1 esta categoria da Loja de presentes, assim como todos os presentes da categoria. Voc\xea pode adicionar esta categoria novamente a qualquer momento, e os presentes reaparecer\xe3o na Loja de presentes.",pleaseEnterMessage:"Digite uma mensagem.",unableToCompleteAction:"N\xe3o foi poss\xedvel concluir sua \xfaltima a\xe7\xe3o. Tente novamente mais tarde.",messageHasToBeShorter:"A mensagem deve ter no m\xe1ximo %1$s caracteres.",pleaseEnterAGiftName:"Digite um nome de presente.",pleaseEnterAGiftImage:"Selecione uma imagem de presente.",pleaseEnterName:"Digite seu nome.",pleaseEnterPhone:"Digite seu n\xfamero de telefone.",pleaseEnterPayPal:"Digite seu novo endere\xe7o de email do PayPal.",contactEmailInvalid:"O email de contato parece n\xe3o ser v\xe1lido.",pleaseEnterStreetAddress:"Digite seu endere\xe7o para correspond\xeancia.",pleaseEnterCity:"Digite sua cidade.",pleaseEnterStateOrProvince:"Digite seu estado ou sua prov\xedncia.",pleaseEnterPostalCode:"Digite seu c\xf3digo postal.",pleaseEnterDescription:"Digite uma descri\xe7\xe3o para sua Rede do Ning.",credits:"Cr\xe9ditos",xCredits:"%1$s cr\xe9ditos",free:"Gratuito",wereSorry:"Desculpe",giftSent:"Presente enviado!",feature:"Destacar",stopFeaturing:"N\xe3o destacar",yourGiftHasBeenSent:"Seu presente foi enviado para %1$s. Voc\xea agora tem %2$s cr\xe9ditos restantes.",yourGiftHasBeenSentModerate:"Seu presente foi enviado para %1$s, mas %1$s optou por moderar os presentes e ter\xe1 que aprovar o presente antes que ele seja exibido. Voc\xea agora tem %2$s cr\xe9ditos restantes.",cannotDeleteCategory:"Voc\xea n\xe3o pode remover esta categoria porque deve ter no m\xednimo %1$s categorias na Loja de presentes. Adicione outra categoria antes de remover esta.",cannotDeleteGiftItem:"<p>Voc\xea n\xe3o pode remover este presente porque deve haver no m\xednimo %1$s presentes na Loja de presentes. <a %2$s>Adicione outro presente</a> antes de remover este. Voc\xea tamb\xe9m pode <a %3$s>carregar um presente personalizado</a>.</p>",searchGifts:"Pesquisar presentes",removeACategory:"Remover uma categoria",clickToSelectTheCategoryYouWouldLikeToRemove:"Clique para selecionar uma categoria que gostaria de remover e, em seguida, clique no \xedcone do \"X\" \xe0 direita do nome da categoria. Voc\xea ser\xe1 solicitado a confirmar a remo\xe7\xe3o. Observe que n\xe3o \xe9 poss\xedvel remover as categorias Todos, Personalizado, Destacado ou Pr\xeamios.",renameACategory:"Renomear uma categoria",clickToSelectTheCategoryYouWouldLikeToRename:"Clique para selecionar uma categoria que voc\xea deseja renomear e, em seguida, clique no link \"Editar\" \xe0 direita do nome da categoria. Observe que n\xe3o \xe9 poss\xedvel renomear as categorias Todos, Personalizado, Destacado ou Pr\xeamios.",pleaseSelectARecipient:"Selecione um destinat\xe1rio",pleaseEnterKeywordToSearch:"Digite uma palavra-chave para a pesquisa",giftMessageHasHTMLConfirmTitle:"Verifique a mensagem que acompanha seu presente.",giftMessageHasHTMLConfirmBody:"O HTML ser\xe1 removido da sua mensagem. Deseja enviar o presente mesmo assim?",sendGift:"Enviar presente",editMessage:"Editar mensagem",imagesMustBeUnder:"Selecione uma imagem de presente com menos de 10 KB. A imagem selecionada \xe9 grande demais. <a href=\"http://help.ning.com/cgi-bin/ning.cfg/php/enduser/std_adp.php?p_faqid=3720\" target=\"_blank\">Precisa de ajuda?</a>",giftImageUnder:"Selecione uma imagem de presente com menos de 10 KB. A imagem selecionada \xe9 grande demais. <a %1$s>Clique aqui</a> para obter ajuda com a cria\xe7\xe3o de uma imagem de presente personalizado.",imageInInvalidFormat:"Selecione um tipo de imagem aceito (PNG, GIF ou JPEG).",enterAMessageFor:"Digite uma mensagem para %1$s",enterAMessage:"Digitar uma mensagem",waitWhileRedirect:"Aguarde enquanto n\xf3s o redirecionamos para o PayPal...",yourGiftHasBeenAddedToYourProfilePage:"Seu presente foi adicionado \xe0 sua p\xe1gina de perfil. Voc\xea agora tem %1$s cr\xe9ditos restantes.",ncOnly:"Apenas o Criador da rede",autoManageGiftStore:"Gerenciamento autom\xe1tico de presentes do Ning",autoManageGiftStoreExpl:"Escolha se a Loja de presentes dever\xe1 ser atualizada automaticamente.",autoManageGiftStoreOnExpl:"A Loja de presentes ser\xe1 atualizada automaticamente com presentes novos e tempor\xe1rios do Ning. ",oneCredit:"1 cr\xe9dito",autoManageGiftStoreOffExpl:"Todos os presentes do Ning ser\xe3o removidos da Loja de presentes. Voc\xea pode escolher quais presentes do Ning ser\xe3o exibidos na Loja de presentes em \"Adicionar presentes do Ning\".",offCap:"Desativar",unlimited:"Sem limita\xe7\xe3o",nLeft:"%1$s restante(s)",sellingOut:"Grandes sucessos",awards:"Pr\xeamios",yourGiftsHasBeenSentToXMembers:{"f1":"Seu presente foi enviado. Voc\xea agora tem %2$s cr\xe9ditos restantes.","f2":"Seus presentes foram enviados para %1$s membros. Voc\xea agora tem %2$s cr\xe9ditos restantes."},yourGiftsHasBeenSentToXMembersModerate:{"f1":"Seu presente foi enviado, mas o destinat\xe1rio optou por moderar os presentes e ter\xe1 que aprov\xe1-los antes que sejam exibidos. Voc\xea agora tem %2$s cr\xe9ditos restantes.","f2":"Seus presentes foram enviados para %1$s membros. Alguns destinat\xe1rios optaram por moderar os presentes e ter\xe3o que aprov\xe1-los antes que sejam exibidos. Voc\xea agora tem %2$s cr\xe9ditos restantes."},unableToSendGiftsMsg:"Houve um problema ao enviar seus presentes. Tente novamente.",totalCostXCredits:function(x){
if(x==1){
return "Custo total: 1 cr\xe9dito";
}else{
return "Custo total: "+x+" cr\xe9ditos";
}
},onCap:"Ativar",notEnoughGiftsLeft:"N\xe3o h\xe1 presentes suficientes restantes. Escolha menos destinat\xe1rios.",next:"Avan\xe7ar &gt;",previous:"&lt; Anterior",searchMembers:"Pesquisar membros",showFriendsOnly:"Mostrar apenas amigos",maxN:function(n){
return "m\xe1x. "+n;
},nSelected:function(_6c,n){
return "<span "+_6c+">"+n+"</span> selecionado(s)";
},addRecipients:"Adicionar destinat\xe1rios",xCreditsForYUSDBonus:"%1$s cr\xe9ditos \u2013 $%2$s USD, <span %4$s>%3$s% de b\xf4nus</span>"});
}
if(!dojo.hostenv.findModule("xg.shared.PostLink",false)){
dojo.provide("xg.shared.PostLink");
dojo.widget.defineWidget("xg.shared.PostLink",dojo.widget.HtmlWidget,{_url:"<required>",_confirmQuestion:"",_confirmTitle:"",_confirmOkButtonText:"",_reload:false,posting:false,_joinPromptText:"",_isPending:false,_doPromptJoin:1,fillInTemplate:function(_1,_2){
this._confirmOkButtonText=this._confirmOkButtonText||xg.index.nls.text("ok");
var a=this.getFragNodeRef(_2);
dojo.style.show(a);
dojo.event.connect(a,"onclick",dojo.lang.hitch(this,function(_4){
dojo.event.browser.stopEvent(_4);
if(this.posting){
return;
}
var f=dojo.lang.hitch(this,function(){
if(!this._confirmQuestion){
this.post();
}else{
xg.shared.util.confirm({title:this._confirmTitle,bodyHtml:"<p>"+dojo.string.escape("html",this._confirmQuestion)+"</p>",onOk:dojo.lang.hitch(this,this.post),okButtonText:this._confirmOkButtonText});
}
});
this._doPromptJoin?xg.shared.util.promptToJoin(this._joinPromptText,this._isPending,f):f();
}));
},post:function(){
this.posting=true;
if(this._reload!=false){
dojo.io.bind({url:this._url,method:"post",encoding:"utf-8",load:function(_6,_7,_8){
window.location.reload(true);
}});
}else{
xg.shared.util.postSynchronously(this._url);
}
}});
}
if(!dojo.hostenv.findModule("xg.shared.OptionBox",false)){
dojo.provide("xg.shared.OptionBox");
dojo.widget.defineWidget("xg.shared.OptionBox",dojo.widget.HtmlWidget,{fillInTemplate:function(_1,_2){
var _3=x$(this.getFragNodeRef(_2));
if(!_3.find("li")[0]){
return;
}
_3.addClass("optionbox");
_3.removeClass("adminbox").removeClass("adminbox-right").removeClass("actionpadding");
_3.find(".xg_module_head").remove();
var _4=_3.find(".xg_module");
if(_3.hasClass("xg_module")){
var _5=_3.find(".xg_module_body");
var _6=x$("<div class=\"xg_module xg_span-4\"></div>");
_3.removeClass("xg_module").removeClass("xg_span-4");
_3.append(_6);
_6.append(_5);
}else{
if(_4&&!_4[0]){
var _7=x$("<div class=\"xg_module xg_span-4\"><div class=\"xg_module_body\"></div></div>");
_3.append(_7);
_3.children().not(".xg_module").each(function(){
_7.find(".xg_module_body").append(this);
});
}
}
var _8=x$("ul.navigation").eq(0);
var _9=_8.find(".optionlink");
if(!_9[0]){
_9=x$("<a href=\"#\" id=\"xj_optionlink\" class=\"xg_sprite xg_sprite-setting optionlink\">"+xg.shared.nls.html("options")+"</a>");
var li=x$("<li class=\"right xg_lightborder navbutton\"></li>");
li.append(_9);
_8.append(li);
}
xg.shared.util.dropdownMenu({"srcNode":_9.parent(),"menuNode":_3,"showOnClick":true});
}});
}
if(!dojo.hostenv.findModule("xg.shared.FlagLink",false)){
dojo.provide("xg.shared.FlagLink");
dojo.widget.defineWidget("xg.shared.FlagLink",dojo.widget.HtmlWidget,{_url:"<required>",_action:"flag",_completeText:"",_completeTitle:"",_completeOkButtonText:"",_link:null,fillInTemplate:function(_1,_2){
this._completeOkButtonText=this._completeOkButtonText||xg.index.nls.text("ok");
xg.shared.FlagLink._type="unspecified";
var a=this.getFragNodeRef(_2);
dojo.style.show(a);
xg.shared.FlagLink._link=a;
dojo.event.connect(a,"onclick",dojo.lang.hitch(this,function(_4){
dojo.event.browser.stopEvent(_4);
if(this._action=="flag"){
xg.shared.FlagLink._type="inappropriate";
html="<p>";
html+="<table><tr><td valign=\"top\">"+xg.shared.nls.text("reasonColon")+" </td><td>";
html+="<input checked onclick=\"xg.shared.FlagLink._type=this.value\" type=\"radio\" id=\"a4\" name=\"abuseType\" value=\"inappropriate\"><label for=\"a4\"> "+xg.shared.nls.text("inappropriate")+"</label></input><br/>";
html+="<input onclick=\"xg.shared.FlagLink._type=this.value\" type=\"radio\" id=\"a1\" name=\"abuseType\" value=\"spam\"><label for=\"a1\"> "+xg.shared.nls.text("spam")+"</label></input><br/>";
html+="<input onclick=\"xg.shared.FlagLink._type=this.value\" type=\"radio\" id=\"a2\" name=\"abuseType\" value=\"porn\"><label for=\"a2\"> "+xg.shared.nls.text("porn")+"</label></input><br/>";
html+="<input onclick=\"xg.shared.FlagLink._type=this.value\" type=\"radio\" id=\"a3\" name=\"abuseType\" value=\"illegal\"><label for=\"a3\"> "+xg.shared.nls.text("illegal")+"</label></input>";
html+="</td></tr></table>";
html+="</p>";
xg.shared.util.confirm({title:xg.shared.nls.text("flag"),onOk:dojo.lang.hitch(this,this.post),bodyHtml:html});
}else{
xg.shared.FlagLink._type=null;
this.post();
}
}));
},post:function(){
url=this._url+((this._action=="flag")?"&flag="+xg.shared.FlagLink._type:"");
dojo.io.bind({url:url,method:"post",encoding:"utf-8",mimetype:"text/javascript",preventCache:true,load:dojo.lang.hitch(this,function(_5,_6,_7){
})});
x$(xg.shared.FlagLink._link).replaceWith((this._action=="flag")?xg.shared.nls.text("contentHasBeenFlagged"):xg.shared.nls.text("contentHasBeenUnFlagged"));
}});
}
if(!dojo.hostenv.findModule("xg.shared.PromptToJoinButton",false)){
dojo.provide("xg.shared.PromptToJoinButton");
dojo.widget.defineWidget("xg.shared.PromptToJoinButton",dojo.widget.HtmlWidget,{_joinPromptText:"",_url:"",_signInUrl:"",_isPending:false,fillInTemplate:function(_1,_2){
var _3=this.getFragNodeRef(_2);
dojo.event.connect(_3,"onclick",dojo.lang.hitch(this,function(_4){
dojo.event.browser.stopEvent(_4);
xg.shared.util.promptToJoin(this._joinPromptText,this._isPending,dojo.lang.hitch(this,function(){
window.location=this._url;
}),dojo.lang.hitch(this,function(){
window.location=this._signInUrl;
}));
}));
}});
}
if(!dojo.hostenv.findModule("xg.shared.PromptToJoinLink",false)){
dojo.provide("xg.shared.PromptToJoinLink");
dojo.widget.defineWidget("xg.shared.PromptToJoinLink",dojo.widget.HtmlWidget,{_joinPromptText:"",_signInUrl:"",_isPending:false,_extraButtonData:false,_signUpText:"signUp",fillInTemplate:function(_1,_2){
var a=this.getFragNodeRef(_2);
var _4=this._signInUrl;
dojo.event.connect(a,"onclick",dojo.lang.hitch(this,function(_5){
dojo.event.browser.stopEvent(_5);
xg.shared.util.promptToJoin(this._joinPromptText,this._isPending,function(){
window.location=a.href;
},function(){
window.location=_4;
},this._extraButtonData,this._signUpText);
}));
}});
}
if(!dojo.hostenv.findModule("xg.shared.frameBusting",false)){
dojo.provide("xg.shared.frameBusting");
dojo.widget.defineWidget("xg.shared.frameBusting",dojo.widget.HtmlWidget,{_isAdminOrNC:"",_appUrl:"",fillInTemplate:function(_1,_2){
if(self!=top){
if(this._isAdminOrNC=="1"){
this.showBanner();
}else{
top.location.replace(this._appUrl);
}
}
},showBanner:function(){
var _3="<div class=\"framebusting-banner\" id=\"frame_error_overlay_content\"> \t\t\t\t    \t<div style=\"margin: 0pt auto; padding: 1.5em 0pt; width: 440px;\"> \t\t\t\t        \t<h3><strong>"+xg.index.nls.text("frameBustingMsgTitle")+"</strong></h3> \t\t\t\t\t        <p>"+xg.index.nls.text("frameBustingMsg","target=\"_top\" href=\"http://help.ning.com\"","target=\"_blank\"  href=\"/\"")+"</p><br/> \t\t\t\t\t    </div> \t\t\t\t\t</div>";
x$("#xj_msg").html(_3);
x$("#xj_msg").show();
x$("#xg").css("padding-top","150px");
xg.shared.util.showOverlay();
}});
}
if(!dojo.hostenv.findModule("xg.shared.SpamWarning",false)){
dojo.provide("xg.shared.SpamWarning");
dojo.widget.defineWidget("xg.shared.SpamWarning",dojo.widget.HtmlWidget,{_messageParts:"",_attachTo:"",_url:"",fillInTemplate:function(_1,_2){
this._attachTo=dojo.json.evalJson(this._attachTo);
for(var i=0;i<this._attachTo.length;i++){
this.installHandler(this._attachTo[i]);
}
},installHandler:function(id){
var el=dojo.byId(id),_6=this;
if(el){
dojo.event.connect(el,"onsubmit",function(_7){
_6.doCheck(_7,el,function(){
xg.shared.util.hideOverlay();
el.submit();
},function(){
xg.shared.util.hideOverlay();
},function(){
});
});
}
},doCheck:function(_8,_9,_a,_b,_c){
if(_8){
dojo.event.browser.stopEvent(_8);
}
var ta=_9.getElementsByTagName("textarea"),_e,_f=[],_10=this;
for(var i=0;i<ta.length;i++){
if(ta[i].name.match(/message/i)){
_f.push(ta[i].value);
}
}
if(_f.length>1){
return alert("Assertion failed: SpamWarning form cannot contain more than 1 TEXTAREA with name ~ /message/");
}else{
if(_f.length){
_e=dojo.json.evalJson(this._messageParts);
_e[xg.shared.nls.text("yourMessage")]=_f[0];
_e=dojo.json.serialize(_e);
}else{
_e=this._messageParts;
}
}
dojo.io.bind({url:this._url,mimetype:"text/javascript",method:"post",content:{xn_out:"json",messageParts:_e},encoding:"utf-8",preventCache:true,load:function(_12,_13,_14){
switch(_13.status){
default:
case "ok":
_a();
break;
case "warning":
_10.showDialog(xg.shared.nls.text("updateMessageQ"),xg.shared.nls.text("warningMessage"),_13.messageParts,_a,_b,_c);
break;
case "error":
_10.showDialog(xg.shared.nls.text("updateMessage"),xg.shared.nls.text("errorMessage"),_13.messageParts,undefined,_b,_c);
break;
}
}});
},showDialog:function(_15,_16,_17,_18,_19,_1a){
var _1b="";
for(var i in _17){
if(!_17[i].length){
continue;
}
for(var j=0,lst=[];j<_17[i].length;j++){
lst[j]="\""+_17[i][j].replace(/<\/?[\w-]+[^>]*>/g,"")+"\"";
}
_1b+="<p><strong>"+i+"</strong><br/>"+lst.join(", ")+"</p>";
}
var _1f=dojo.html.createNodesFromText("<div class=\"xg_module xg_floating_module\">"+"<div style=\"background-image: none;\" class=\"xg_floating_container xg_lightborder xg_module\">"+"<div class=\"xg_module_head\"><h2>"+_15+"</h2></div>"+"<div class=\"xg_module_body\">"+"<p>"+_16+"</p>"+"<p>"+xg.shared.nls.text("removeWords")+"</p>"+_1b+"<p class=\"buttongroup\">"+"<input class=\"button action-primary\" type=\"button\" value=\""+xg.shared.nls.text("goBack")+"\"> "+(_18?"<input class=\"button\" type=\"button\" value=\""+xg.shared.nls.text("sendAnyway")+"\">":"")+"</p>"+"</div>"+"</div>"+"</div>")[0];
if(_1a){
_1a();
}
xg.shared.util.showOverlay();
xg.append(_1f);
dojo.event.connect(dojo.html.getElementsByClass("button",_1f)[0],"onclick",dojo.lang.hitch(this,function(_20){
dojo.event.browser.stopEvent(_20);
dojo.dom.removeNode(_1f);
_19();
}));
if(_18){
dojo.event.connect(dojo.html.getElementsByClass("button",_1f)[1],"onclick",dojo.lang.hitch(this,function(_21){
dojo.event.browser.stopEvent(_21);
dojo.dom.removeNode(_1f);
_18();
}));
}
}});
xg.shared.SpamWarning.checkForSpam=function(_22){
var sw=new xg.shared.SpamWarning;
sw._url=_22.url;
sw._messageParts=_22.messageParts;
sw.doCheck(null,_22.form,_22.onContinue,_22.onBack,_22.onWarning);
};
}
if(!dojo.hostenv.findModule("xg.shared.IframeUpload",false)){
dojo.provide("xg.shared.IframeUpload");
(function(){
var _1=function(_2,_3){
if(window[_2]){
return window[_2];
}
if(window.frames[_2]){
return window.frames[_2];
}
var _4=null;
if(dojo.render.html.ie){
_4=document.createElement("<iframe name=\""+_2+"\" src=\"about:blank\" onload=\""+_3+"\">");
}else{
_4=document.createElement("iframe");
_4.name=_2;
_4.id=_2;
_4.src="about:blank";
_4.onload=new Function(_3);
}
if(dojo.render.html.safari){
_4.style.position="absolute";
}
_4.style.left=_4.style.top=_4.style.height=_4.style.width="1px";
_4.style.visibility="hidden";
return xg.append(_4);
};
var _5=function(_6){
var _7=_6.contentDocument||(((_6.name)&&(_6.document)&&(document.getElementsByTagName("iframe")[_6.name].contentWindow)&&(document.getElementsByTagName("iframe")[_6.name].contentWindow.document)))||((_6.name)&&(document.frames[_6.name])&&(document.frames[_6.name].document))||null;
return _7;
};
var _8=undefined,_9="xg_shared_transport",_a=undefined,_b=undefined,_c=undefined,_d=undefined;
var _e=function(){
_a?_c.setAttribute("target",_a):_c.removeAttribute("target");
_c.setAttribute("action",_b);
_d=undefined;
};
xg.shared.IframeUpload={_onLoadTransport:function(){
if(_5(_8).location!="about:blank"&&_d){
var _f=undefined,_10=_d;
_e();
try{
_f=_5(_8).body.innerHTML;
}
catch(e){
_f=null;
}
if(_f.match(/^<pre[^>]*>([\s\S]*)<\/pre>/i)){
_f=RegExp.$1;
}
_f=_f.replace(/&quot;/gm,"\"").replace(/&#39;/gm,"'").replace(/&amp;/gm,"&").replace(/&lt;/gm,"<").replace(/&gt;/gm,">");
_10(_f);
}
},start:function(_11,_12,url,_14){
if(typeof _14!="undefined"&&_14==true){
_a=undefined;
_c=undefined;
_b=undefined;
_d=undefined;
}
if(!_8){
_8=_1(_9,"xg.shared.IframeUpload._onLoadTransport()");
}
if(_d){
}
_d=_12;
_c=_11;
_a=_11.getAttribute("target");
_b=_11.getAttribute("action");
_11.setAttribute("target",_9);
if(url){
_11.setAttribute("action",url);
}
_11.submit();
},stop:function(){
_e();
_8.src="about:blank";
}};
})();
}
if(!dojo.hostenv.findModule("xg.index.util.FormHelper",false)){
dojo.provide("xg.index.util.FormHelper");
xg.index.util.FormHelper={runValidation:function(_1,_2,_3,_4){
xg.index.util.FormHelper.hideErrorMessages(_1);
dojo.lang.forEach(dojo.html.getElementsByClass("success",dojo.byId("xg_body")),function(_5){
dojo.style.hide(_5);
});
xg.index.util.FormHelper.trimTextInputsAndTextAreas(_1);
var _6=_2(_1);
if(dojo.lang.isEmpty(_6)){
return true;
}
if(_4){
dojo.event.browser.stopEvent(_4);
}
xg.index.util.FormHelper.showErrorMessages(_1,_6,_3);
return false;
},configureValidation:function(_7,_8,_9){
var _a;
var _b;
if(_7.tagName=="FORM"){
_a="onsubmit";
_b=_7;
}else{
_a="onclick";
_b=dojo.dom.getFirstAncestorByTag(_7,"form");
}
dojo.event.connect(_b,_a,function(_c){
return xg.index.util.FormHelper.runValidation(_b,_8,_9,_c);
});
},validateAndProcess:function(_d,_e,_f,_10,_11){
var _12;
var _13;
if(_d.tagName=="FORM"){
_12="onsubmit";
_13=_d;
}else{
_12="onclick";
_13=dojo.dom.getFirstAncestorByTag(_d,"form");
}
dojo.event.connect(_d,_12,function(_14){
dojo.lang.forEach(dojo.html.getElementsByClass("error",_13),function(_15){
dojo.html.removeClass(_15,"error");
});
xg.index.util.FormHelper.trimTextInputsAndTextAreas(_13);
var _16=_e(_13);
xg.index.util.FormHelper.hideErrorMessages(_13);
dojo.event.browser.stopEvent(_14);
if(dojo.lang.isEmpty(_16)){
if(typeof (_11)!=="undefined"){
_11(_f,_13);
}else{
_f(_13);
}
}else{
xg.index.util.FormHelper.showErrorMessages(_13,_16,_10);
}
});
},validateAndSave:function(_17,_18,_19,_1a,_1b,_1c){
xg.index.util.FormHelper.validateAndProcess(_17,_18,function(_1d){
xg.index.util.FormHelper.save(_1d,_19,_1d.action,_1b);
},_1a,_1c);
},trimTextInputsAndTextAreas:function(_1e){
dojo.lang.forEach(_1e.getElementsByTagName("textarea"),function(_1f){
_1f.value=dojo.string.trim(_1f.value);
});
dojo.lang.forEach(_1e.getElementsByTagName("input"),function(_20){
if(_20.type=="text"){
_20.value=dojo.string.trim(_20.value);
}
});
},save:function(_21,_22,url,_24){
if(!xg.index.util.FormHelper.validateFileInputsSpeciallyForIE(_21)){
return;
}
var _25=function(_26){
if(_26[0]!="("){
_26="("+_26+")";
}
try{
_26=eval(_26);
if("errorMessages" in _26){
xg.index.util.FormHelper.showErrorMessages(_21,_26.errorMessages);
if(_24){
_24(_26);
}
return;
}
_22(_26);
}
catch(e){
xg.index.util.FormHelper.showErrorMessages(_21,{});
return;
}
};
var _27=xg.index.util.FormHelper.hasFileFields(_21);
if(_27){
xg.shared.IframeUpload.start(_21,_25,url);
}else{
dojo.io.bind({url:url,mimetype:"text/plain",formNode:_21,method:"post",encoding:"utf-8",preventCache:true,load:function(_28,_29,_2a){
_25(_29);
},error:function(_2b,_2c){
throw _2c.message;
}});
}
},hideErrorMessages:function(_2d){
var _2e=xg.index.util.FormHelper.notificationNode(_2d);
if(_2e){
_2e.innerHTML="";
dojo.html.hide(_2e);
}
dojo.lang.forEach(dojo.html.getElementsByClass("error",_2d),function(el){
dojo.html.removeClass(el,"error");
},true);
},showErrorMessages:function(_30,_31,_32){
var _33=xg.index.util.FormHelper.notificationNode(_30);
var _34="";
xg.index.util.FormHelper.hideErrorMessages(_30);
if(dojo.lang.isString(_31)){
var _35=null;
var _36=null;
var i=0;
while((_35==null)&&(_36=_30[i])){
if(_36.tagName!="FIELDSET"){
_35=_36.name;
}
i++;
}
if(_35){
var tmp={};
tmp[_35]=_31;
_31=tmp;
}
}
for(name in _31){
if(_30[name]){
var _39=(_30[name].tagName!="SELECT"&&_30[name].length)?_30[name][0]:_30[name];
xg.index.util.FormHelper.showErrorMessage(_39);
}
if(dojo.lang.isArray(_31[name])){
dojo.lang.forEach(_31[name],function(n){
_34+="<li>"+n+"</li>";
},true);
}else{
_34+="<li>"+_31[name]+"</li>";
}
}
if(_33&&_34.length&&_33.tagName=="DL"){
if(!(_32&&_32.length)){
_32=xg.index.nls.html("wereSorry");
}
if(x$(_33).attr("_fmt")=="std"){
_33.innerHTML="<h3>"+_32+"</h3><ul class=\"errors last-child\">"+_34+"</ul>";
}else{
_33.innerHTML="<dt>"+_32+"</dt><dd><ol>"+_34+"</ol></dd>";
dojo.html.setClass(_33,"errordesc msg clear");
}
}
if(_33&&_34.length&&_33.tagName=="DIV"&&!x$(_33).hasClass("dy-error-msg")){
if(!(_32&&_32.length)){
_32=xg.index.nls.html("wereSorry");
}
_33.innerHTML="<h3>"+_32+"</h3><ul class=\"errors last-child\">"+_34+"</ul>";
dojo.html.setClass(_33,"errordesc");
}
if(_33&&_34.length&&_33.tagName=="DIV"&&x$(_33).hasClass("dy-error-msg")){
if(!(_32&&_32.length)){
_32=xg.index.nls.html("wereSorry");
}
_33.innerHTML="<p>"+_32+"</p><ul class=\"errors last-child\">"+_34+"</ul>";
}
if(_33&&_34.length){
dojo.html.show(_33);
xg.index.util.FormHelper.scrollIntoView(_33);
}
},notificationNode:function(_3b){
var id;
if(dojo.byId("form_notify")!=null){
return dojo.byId("form_notify");
}
if(dojo.lang.isString(_3b)){
id=_3b+"_notify";
}else{
id=_3b.id+"_notify";
}
return dojo.byId(id);
},showErrorMessage:function(_3d){
if(_3d.getAttribute("dojotype")=="Editor"){
return false;
}
var _3e=_3d.parentNode;
if(_3e.tagName=="LABEL"){
_3e=_3e.parentNode;
}
if(_3e.tagName=="DIV"&&dojo.html.hasClass("texteditor",_3e)){
_3e=_3e.parentNode;
}
if(_3e.tagName=="LI"){
if(dojo.dom.getFirstAncestorByTag(_3e,"UL")){
_3e=dojo.dom.getFirstAncestorByTag(_3e,"UL").parentNode;
}else{
if(dojo.dom.getFirstAncestorByTag(_3e,"OL")){
_3e=dojo.dom.getFirstAncestorByTag(_3e,"OL").parentNode;
}
}
}
dojo.html.addClass(_3e,"error");
if(_3e.tagName=="DD"){
var _3f=dojo.dom.prevElement(_3e);
if(_3f.tagName=="DT"){
dojo.html.addClass(_3f,"error");
}
}
},showMessage:function(_40,_41,_42,_43){
dojo.html.setClass(_40,_41+" msg");
_43=dojo.string.trim(_43);
if(_43.length&&(_43.charAt(0)!="<")){
_43="<p>"+_43+"</p>";
}
_40.innerHTML="<dt>"+_42+"</td><dd>"+_43+"</dd>";
dojo.html.show(_40);
},hasFileFields:function(_44){
var _45=_44.getElementsByTagName("input");
for(var i=0;i<_45.length;i++){
if(_45[i].type&&_45[i].type.toLowerCase()=="file"){
return true;
}
}
return false;
},indexOf:function(_47,_48){
for(var i=0;i<_48.length;i++){
if(_48.options[i].value===_47){
return i;
}
}
return null;
},select:function(_4a,_4b){
var i=xg.index.util.FormHelper.indexOf(_4a,_4b);
if(i!=null){
_4b.selectedIndex=i;
}else{
return false;
}
return true;
},selectedOption:function(_4d){
return _4d[_4d.selectedIndex];
},radioValue:function(_4e){
for(var i=0;i<_4e.length;i++){
if(_4e[i].checked){
return _4e[i].value;
}
}
return null;
},showOrHide:function(_50,_51){
if(_51){
dojo.html.show(_50);
}else{
dojo.html.hide(_50);
}
},iframeTransportSupportsBrowser:function(){
return dojo.render.html.ie||dojo.render.html.mozilla;
},replaceHashAnchors:function(_52){
var _53=_52.getElementsByTagName("a");
for(var i=0;i<_53.length;i++){
if(_53[i].href.match(/#$/)){
_53[i].href="javascript:void(0)";
}
}
},scrollIntoView:function(_55){
var doc=document.body,_57=document.documentElement,_58={x:0,y:0},dim={x:_57.clientWidth||doc.clientWidth,y:document.clientHeight||_57.clientHeight||doc.clientHeight},_5a={x:window.pageXOffset||_57.scrollLeft||doc.scrollLeft,y:window.pageYOffset||_57.scrollTop||doc.scrollTop};
dim.y=Math.min(dim.y,doc.clientHeight);
for(var cur=_55;cur;cur=cur.offsetParent){
_58.x+=cur.offsetLeft||0;
_58.y+=cur.offsetTop||0;
if(cur.tagName=="BODY"){
break;
}
}
var l=_58.x-_5a.x,t=_58.y-_5a.y,r=_58.x+_55.offsetWidth-dim.x-_5a.x,b=_58.y+_55.offsetHeight-dim.y-_5a.y;
var dx=l<0?l:(r>0?Math.min(l,r):0),dy=t<0?t:(b>0?Math.min(t,b):0);
window.scrollBy(dx,dy);
},validateFileInputsSpeciallyForIE:function(_62){
if(!(dojo.render.html.ie50||dojo.render.html.ie55||dojo.render.html.ie60)){
return true;
}
var _63={};
var _64=_62.getElementsByTagName("input");
for(var i=0;i<_64.length;i++){
if(_64[i].tagName!="INPUT"||_64[i].type!="file"){
continue;
}
if(_64[i].value.length===0){
continue;
}
if(!_64[i].value.match(/^[A-Za-z]:\\/)){
_63[_64[i].name]=xg.index.nls.html("fileNotFound");
}
}
xg.index.util.FormHelper.showErrorMessages(_62,_63);
return dojo.lang.isEmpty(_63);
},validateRequired:function(_66,_67,_68,_69){
if(_67[_68]){
if(typeof (_67[_68].value)=="undefined"){
if(xg.index.util.FormHelper.checkedCount(_67[_68])==0){
_66=xg.index.util.FormHelper.addValidationError(_66,_68,_69);
}
}else{
if(!_67[_68].value.length){
_66=xg.index.util.FormHelper.addValidationError(_66,_68,_69);
}
}
}
return _66;
},parseDateFromForm:function(_6a,_6b){
var _6c=_6a[_6b+"_month"];
var _6d=_6a[_6b+"_day"];
var _6e=_6a[_6b+"_year"];
if(_6c&&_6d&&_6e){
var _6f=parseInt(_6c.value);
var day=(_6d.value=="dd")?0:parseInt(_6d.value.replace(/^0*/,""));
var _71=(_6e.value=="yyyy")?0:parseInt(_6e.value);
if((_6f==0)||(day==0)||(_71==0)){
return false;
}else{
return {"month":_6f,"day":day,"year":_71};
}
}else{
return null;
}
},isDateValid:function(_72,_73,day){
var d=new Date(_72,_73-1,day);
return ((d.getFullYear()==_72)&&(d.getMonth()==(_73-1))&&(d.getDate()==day));
},validateRequiredDate:function(_76,_77,_78,_79,_7a){
var res=xg.index.util.FormHelper.parseDateFromForm(_77,_78);
if(res===false){
_76=xg.index.util.FormHelper.addValidationError(_76,_78+"_month",_79);
}else{
if(res&&(!xg.index.util.FormHelper.isDateValid(res.year,res.month,res.day))){
_76=xg.index.util.FormHelper.addValidationError(_76,_78+"_month",_7a);
}
}
return _76;
},validateDate:function(_7c,_7d,_7e,_7f){
var res=xg.index.util.FormHelper.parseDateFromForm(_7d,_7e);
if(res&&(!xg.index.util.FormHelper.isDateValid(res.year,res.month,res.day))){
_7c=xg.index.util.FormHelper.addValidationError(_7c,_7e+"_month",_7f);
}
return _7c;
},validateChoice:function(_81,_82,_83,_84,_85){
var _86=xg.index.util.FormHelper.checkedCount(_82[_83]);
if(_82[_83]&&(_86>0)){
_85=xg.index.util.FormHelper.buildValidationLabel(_83,_85);
if(_86>1){
_81=xg.index.util.FormHelper.addValidationError(_81,_83,_85+" can only have one value ");
}
var _87=null;
if(typeof (_82[_83].length)!=="undefined"){
for(var i=0;i<_82[_83].length;i++){
if(_82[_83][i].checked===true){
_87=_82[_83][i].value;
}
}
}else{
_87=_82[_83].value;
}
if(!dojo.lang.inArray(_84,_87)){
_81=xg.index.util.FormHelper.addValidationError(_81,_83,_85+" has to be one of: "+_84.join(", "));
}
}
return _81;
},validateMultipleChoice:function(_89,_8a,_8b,_8c,_8d){
if(_8a[_8b]&&(xg.index.util.FormHelper.checkedCount(_8a[_8b])>0)){
_8d=xg.index.util.FormHelper.buildValidationLabel(_8b,_8d);
var _8e=[];
if(typeof (_8a[_8b].length)!=="undefined"){
for(var i in _8a[_8b]){
if(_8a[_8b][i].checked===true){
_8e.push(_8a[_8b][i].value);
}
}
}else{
_8e.push(_8a[_8b].value);
}
dojo.lang.forEach(_8e,function(_90){
if(!dojo.lang.inArray(_8c,_90)){
_89=xg.index.util.FormHelper.addValidationError(_89,_8b,_8d+" has to be some of: "+_8c.join(", "));
}
},true);
}
return _89;
},capitalize:function(str){
var _92=str.split(" ");
for(var i=0;i<_92.length;i++){
_92[i]=_92[i].charAt(0).toUpperCase()+_92[i].substring(1);
}
return _92.join(" ");
},buildValidationLabel:function(_94,_95){
if(!_95){
_95=xg.index.util.FormHelper.capitalize(_94.replace(/_/," "));
}
return _95;
},addValidationError:function(_96,_97,_98){
if(_96[_97]){
_96[_97].push(_98);
}else{
_96[_97]=_98;
}
return _96;
},checkedCount:function(_99){
var _9a=0;
if(_99&&(typeof (_99.length)!="undefined")){
for(var i=0;i<_99.length;i++){
if(_99[i].checked===true){
_9a++;
}
}
}
return _9a;
},fixPopupZIndexAfterShow:function(_9c){
if(!dojo.render.html.ie){
return;
}
dojo.lang.forEach(xg.index.util.FormHelper.popupAncestorsForZIndexFix(_9c),function(_9d){
_9d.style.zIndex=10;
});
},fixPopupZIndexBeforeHide:function(_9e){
if(!dojo.render.html.ie){
return;
}
dojo.lang.forEach(xg.index.util.FormHelper.popupAncestorsForZIndexFix(_9e),function(_9f){
_9f.style.zIndex=null;
});
},popupAncestorsForZIndexFix:function(_a0){
return dojo.dom.getAncestors(_a0,function(_a1){
return dojo.html.hasClass(_a1,"xg_module")||dojo.html.hasClass(_a1,"xg_module_body");
});
},setTokenData:function(_a2){
if(x$(".xj_stgnfst").length==0){
return;
}
var _a3=x$(".xj_gnfst");
var ts=x$(".xj_gnfstTs");
if(typeof _a2!="undefined"){
_a3=x$(_a2+" .xj_gnfst");
ts=x$(_a2+" .xj_gnfstTs");
}
var url=_a3.attr("_url");
xg.get(url,"",function(r,_a7){
if(typeof _a7!=="object"||_a7.part0===1){
return;
}
var _a8=_a7.part1;
var n=10;
var str=_a7.part1;
var _ab=str.replace(/[a-zA-Z]/g,function(c){
return String.fromCharCode((c<="Z"?90:122)>=(c=c.charCodeAt(0)+13)?c:c-26);
});
tp=_ab.substr(0,n);
tn=_ab.substr(n,_a8.length);
ts.val(tp);
_a3.val(tn);
});
}};
}
if(!dojo.hostenv.findModule("xg.shared.AddAsFriendLink",false)){
dojo.provide("xg.shared.AddAsFriendLink");
dojo.widget.defineWidget("xg.shared.AddAsFriendLink",dojo.widget.HtmlWidget,{_screenName:"",_name:"",_maxMessageLength:0,_requestSentClasses:"",_xgSourceParam:undefined,_friendLimitExceededMessage:"",_sentFriendRequestLimitExceededMessage:"",_sendMessageAttempt:false,_checkFriendStatusAndLimitsUrl:"",_sendMessageUrl:"",fillInTemplate:function(_1,_2){
this.a=this.getFragNodeRef(_2);
var _3=this;
x$(this.a).click(function(_4){
_4.preventDefault();
var _5=_3._checkFriendStatusAndLimitsUrl;
if("undefined"!=typeof this._xgSourceParam){
_5=_5+"&xg_source="+this._xgSourceParam;
}
xg.get(_5,null,function(r,_7){
if(_7.friendLimitExceeded){
xg.shared.util.alert({title:xg.shared.nls.text("friendLimitExceeded"),bodyHtml:dojo.string.escape("html",_3._friendLimitExceededMessage)});
return false;
}
if(_7.sentFriendRequestLimitExceeded){
xg.shared.util.alert({title:xg.shared.nls.text("requestLimitExceeded"),bodyHtml:dojo.string.escape("html",_3._sentFriendRequestLimitExceededMessage)});
return false;
}
if(_7.friendStatus!=undefined){
if(_7.friendStatus=="pending"){
xg.shared.util.alert({title:xg.index.nls.text("wereSorry"),bodyHtml:xg.index.nls.html("youCantSendMessageUntilFriend",_3._name)});
return false;
}else{
if(_7.friendStatus=="friend"){
document.location.href=_3._sendMessageUrl;
return false;
}
}
}
_3.showDialog(_3.a);
});
});
},toggleDescIcon:function(a,_9){
if(_9){
if(_9=="working"){
dojo.html.removeClass(a,"xg_sprite");
dojo.html.removeClass(a,"xg_sprite-add");
dojo.html.addClass(a,"desc");
dojo.html.addClass(a,"working");
}else{
dojo.html.removeClass(a,"working");
dojo.html.removeClass(a,"desc");
dojo.html.addClass(a,"xg_sprite");
dojo.html.addClass(a,"xg_sprite-add");
}
}
},showDialog:function(a){
var _b=xg.shared.nls.html("typePersonalMessage");
var _c=xg.shared.util.confirm({title:xg.shared.nls.text("addNameAsFriend",this._name),bodyHtml:"                 <dl class=\"errordesc msg clear\" style=\"display: none\"></dl>                 <p>"+(this._sendMessageAttempt?xg.shared.nls.html("nameMustBeFriendsToMessage",dojo.string.escape("html",this._name))+" "+xg.shared.nls.html("nameMustConfirmYourFriendship",dojo.string.escape("html",this._name)):xg.shared.nls.html("nameMustConfirmFriendship",dojo.string.escape("html",this._name)))+"</p>                 <p><a href=\"#\">"+xg.shared.nls.html(this._sendMessageAttempt?"includePersonalMessage":"addPersonalMessage")+"</a></p>                 <p style=\"display:none\"><textarea name=\"message\" cols=\"30\" rows=\"3\"></textarea></p>",okButtonText:xg.shared.nls.text(this._sendMessageAttempt?"addAsFriend":"send"),closeOnlyIfOnOk:true,onOk:dojo.lang.hitch(this,function(_d){
var _e=_d.getElementsByTagName("form")[0];
if(!this.validate(_e)){
return false;
}
xg.shared.SpamWarning.checkForSpam({url:"/main/invitation/checkMessageForSpam",messageParts:"{}",form:_e,onContinue:dojo.lang.hitch(this,function(){
dojo.style.hide(_d);
if(_e.message.value==_b){
_e.message.value="";
}
this.send(_d,_e,a);
}),onBack:function(){
dojo.style.show(_d);
},onWarning:function(){
dojo.style.hide(_d);
}});
})});
var _f=_c.getElementsByTagName("form")[0];
xg.shared.util.setAdvisableMaxLength(_f.message,this._maxMessageLength);
var _10=_f.getElementsByTagName("a")[0];
dojo.event.connect(_10,"onclick",dojo.lang.hitch(this,function(_11){
dojo.event.browser.stopEvent(_11);
x$(_10.parentNode).remove();
x$(_f.message.parentNode).show();
_f.message.value=_b;
_f.message.focus();
dojo.html.selectInputText(_f.message);
}));
},send:function(_12,_13,a){
dojo.style.hide(_12);
dojo.io.bind({url:"/profiles/friendrequest/create?xn_out=json&screenName="+this._screenName,mimetype:"text/javascript",formNode:_13,method:"post",encoding:"utf-8",preventCache:true,load:dojo.lang.hitch(this,function(_15,_16,_17){
if(!_16.success){
return;
}
xg.shared.util.alert({title:xg.shared.nls.text("friendRequestSent"),bodyHtml:xg.shared.nls.html("yourFriendRequestHasBeenSent"),autoCloseTime:2000});
var _18=x$("#add-as-friend-link")[0];
var _19=x$("#send-message-link")[0];
var _1a=dojo.html.createNodesFromText("<a class=\""+this._requestSentClasses+"\">"+xg.shared.nls.html("requestSent")+"</a>")[0];
if(this._sendMessageAttempt&&a!=_18){
_18.parentNode.replaceChild(_1a,_18);
a.parentNode.removeChild(a);
}else{
if(_19){
_19.parentNode.removeChild(_19);
}
a.parentNode.replaceChild(_1a,a);
}
})});
},validate:function(_1b){
var _1c=[];
dojo.lang.forEach(dojo.html.getElementsByClass("error",_1b),function(_1d){
dojo.html.removeClass(_1d,"error");
});
if(dojo.string.trim(_1b.message.value).length>this._maxMessageLength){
_1c.push(xg.shared.nls.html("yourMessageIsTooLong",this._maxMessageLength));
xg.index.util.FormHelper.showErrorMessage(_1b.message);
}
var _1e=_1b.getElementsByTagName("dl")[0];
_1e.innerHTML="<dt>"+xg.shared.nls.html("thereHasBeenAnError")+"</dt><dd><ol><li>"+_1c.join("</li><li>")+"</li></ol></dd>";
dojo.style.setShowing(_1e,_1c.length>0);
return _1c.length==0;
}});
}
if(!dojo.hostenv.findModule("xg.shared.ComscoreBeacon",false)){
dojo.provide("xg.shared.ComscoreBeacon");
xg.addOnRequire(function(){
try{
if(typeof ("COMSCORE")!=="undefined"&&COMSCORE){
COMSCORE.beacon({c1:2,c2:6770185,c4:window.location.href});
}
}
catch(e){
}
});
}
if(!dojo.hostenv.findModule("xg.shared.Pagination",false)){
dojo.provide("xg.shared.Pagination");
dojo.widget.defineWidget("xg.shared.Pagination",dojo.widget.HtmlWidget,{_gotoUrl:"",_maxPage:1,span:null,fillInTemplate:function(_1,_2){
this.span=x$(this.getFragNodeRef(_2));
this.span.show();
var _3=this.span.children(".goto_button:first");
if(_3){
_3.click(dojo.lang.hitch(this,function(_4){
dojo.event.browser.stopEvent(_4);
this.gotoUrl();
}));
}
},gotoUrl:function(){
var _5=this.span.children(".pagination_input:first");
if(_5){
var _6=new String(_5.val());
if(_6.search(/^[1-9][0-9]*$/)!=-1){
pageUrl=new String(this._gotoUrl).replace(/__PAGE___/,(_5.val()>this._maxPage)?this._maxPage:_5.val());
window.location.href=pageUrl;
}
}
}});
}
if(!dojo.hostenv.findModule("xg.shared.SubTabHover",false)){
dojo.provide("xg.shared.SubTabHover");
dojo.widget.defineWidget("xg.shared.SubTabHover",dojo.widget.HtmlWidget,{a:null,subTabDiv:null,li:null,showTimeoutHandle:null,hideTimeoutHandle:null,showSubTabTime:150,hideSubTabTime:150,fillInTemplate:function(_1,_2){
this.li=this.getFragNodeRef(_2);
this.a=dojo.dom.firstElement(this.li);
this.subTabDiv=dojo.dom.nextElement(this.a);
xg.listen(this.a,"onmouseover",this,function(_3){
clearTimeout(this.hideTimeoutHandle);
this.showTimeoutHandle=setTimeout(dojo.lang.hitch(this,"showSubTab"),this.showSubTabTime);
});
xg.listen(this.a,"onmouseout",this,function(_4){
clearTimeout(this.showTimeoutHandle);
this.hideTimeoutHandle=setTimeout(dojo.lang.hitch(this,"hideSubTab"),this.hideSubTabTime);
});
xg.listen(this.subTabDiv,"onmouseover",this,function(_5){
clearTimeout(this.hideTimeoutHandle);
});
xg.listen(this.subTabDiv,"onmouseout",this,function(_6){
this.hideTimeoutHandle=setTimeout(dojo.lang.hitch(this,"hideSubTab"),this.hideSubTabTime);
});
},showSubTab:function(){
clearTimeout(this.hideTimeoutHandle);
var o=xg.shared.util.getOffset(this.li,this.subTabDiv);
dojo.html.addClass(this.a,"hovered");
dojo.style.setStyleAttributes(this.subTabDiv,"z-index:100;position:absolute;display:block;left: "+(o.x)+"px; top:"+(o.y+parseInt(this.li.offsetHeight))+"px;");
},hideSubTab:function(){
clearTimeout(this.showTimeoutHandle);
dojo.style.hide(this.subTabDiv);
if(this.ieiframe){
this.ieiframe.style.display="none";
}
dojo.html.removeClass(this.a,"hovered");
}});
}
if(!dojo.hostenv.findModule("xg.index.panel",false)){
dojo.provide("xg.index.panel");
xg.addOnRequire(function(){
var _1=dojo.byId("xg_sitename");
if(_1){
var _2=_1.getElementsByTagName("img");
if(_2){
xg.shared.util.fixImagesInIE(_2,true);
}
}
});
}
if(!dojo.hostenv.findModule("xg.index.embed.search",false)){
dojo.provide("xg.index.embed.search");
xg.addOnRequire(function(){
xg.shared.util.addHints(x$(".xj_search_hint"),true);
});
}
if(!dojo.hostenv.findModule("xg.shared.CookieStore",false)){
dojo.provide("xg.shared.CookieStore");
xg.shared.CookieStore=(function(){
var _1={};
var _={};
var _3="xg_sc";
var _4="xg_pc";
var _5=366;
var _6={};
_.initialize=function(){
var _7=xg.shared.util.getCookie(_3);
if(_7){
try{
_6=x$.evalJSON(_7);
}
catch(e){
try{
_6=x$.evalJSON(decodeURIComponent(_7.replace(/\+/g," ")));
}
catch(e){
}
}
}
var _8=xg.shared.util.getCookie(_4);
if(_8){
try{
persistentCookieData=x$.evalJSON(_8);
}
catch(e){
try{
persistentCookieData=x$.evalJSON(decodeURIComponent(_8.replace(/\+/g," ")));
}
catch(e){
}
}
}
};
_1.setSessionCookieValue=function(_9,_a){
if(_a.length===0){
delete _6[_9];
}else{
_6[_9]=_a;
}
_.setCookieProper(_3,x$.toJSON(_6),0);
};
_1.getSessionCookieValue=function(_b){
return _6[_b];
};
_1.setPersistentCookieValue=function(_c,_d){
if(_d===null||_d.length===0){
delete persistentCookieData[_c];
}else{
persistentCookieData[_c]=_d;
}
_.setCookieProper(_4,x$.toJSON(persistentCookieData),_5);
};
_1.getPersistentCookieValue=function(_e){
return persistentCookieData[_e];
};
_.setCookieProper=function(_f,_10,_11){
xg.shared.util.setCookie(_f,_10,_11,"."+window.location.hostname);
};
xg.addOnRequire(function(){
_.initialize();
});
return _1;
})();
}
if(!dojo.hostenv.findModule("xg.index.embed.sidebarUserBox",false)){
dojo.provide("xg.index.embed.sidebarUserBox");
xg.index.embed.sidebarUserBox={isPopulated:function(_1){
return x$(_1).attr("_notCached")!="1";
},toggleFriendRequestCounts:function(_2){
var _3=new Array();
var _4="undefined"!=typeof _2||isNaN(_2);
_3["xj_no_friend_requests"]=!_4||_2<1;
_3["xj_multiple_friend_requests"]=_4&&_2>1;
_3["xj_one_friend_request"]=_4&&_2==1;
for(var _5 in _3){
if(_3[_5]){
x$("."+_5).show();
}else{
x$("."+_5).hide();
}
}
}};
xg.addOnRequire(function(){
var _6="auth-type";
var _7=xg.index.embed.sidebarUserBox;
var _8=x$(".xj_count_unreadMessages")[0];
var _9=x$(".xj_count_unreadAlerts")[0];
var _a=x$(".xj_count_friendRequestsReceived .xj_count")[0];
var _b=x$("#xj_approvalBox")[0];
var r={preventCache:true,getMessageCount:_7.isPopulated(_8)?0:1,getAlertCount:_7.isPopulated(_9)?0:1,getFriendRequestCount:_7.isPopulated(_a)?0:1,getApprovalLinks:_7.isPopulated(_b)?0:1};
if(r.getMessageCount||r.getAlertCount||r.getFriendRequestCount||r.getApprovalLinks){
xg.get("/main/embed/getSidebarCounts?xn_out=json",r,function(_d,_e){
if("undefined"==typeof _e){
return;
}
if(r.getMessageCount){
if(_e.messageCount>0){
x$(_8).html(_e.messageCount);
x$(".xj_messages_present").show();
}else{
x$(".xj_messages_present").hide();
}
}
if(r.getAlertCount){
if(_e.alertCount>0){
x$(_9).html(_e.alertCount);
x$(".xj_alerts_present").show();
}else{
x$(".xj_alerts_present").hide();
}
}
if(r.getFriendRequestCount){
if(_e.friendRequestCount>0){
x$(_a).html(_e.friendRequestCount);
}
_7.toggleFriendRequestCounts(_e.friendRequestCount);
}
if(r.getApprovalLinks&&_e.approvalLinksHtml){
x$(_b).html(_e.approvalLinksHtml).show();
}
});
}
});
}
if(!dojo.hostenv.findModule("xg.index.embed.footer",false)){
dojo.provide("xg.index.embed.footer");
xg.addOnRequire(function(){
try{
document.execCommand("BackgroundImageCache",false,true);
}
catch(e){
}
});
}
if(!dojo.hostenv.findModule("xg.index.embed.announcementBar",false)){
dojo.provide("xg.index.embed.announcementBar");
xg.addOnRequire(function(){
var _1=x$("#announcement_close_id");
if(_1.length>0){
_1.click(function(_2){
_2.preventDefault();
x$("#xj_announcement_bar").hide();
xg.get(x$(this).attr("_url"),{},function(_3,_4){
});
});
}
});
}
if(!dojo.hostenv.findModule("xg.index.quickadd.loader",false)){
dojo.provide("xg.index.quickadd.loader");
xg.index.quickadd._dialogs={};
xg.index.quickadd._stub=undefined;
xg.addOnRequire(function(){
var _1=0;
xg.index.quickadd.loadModule=function(_2,_3,js,_5){
if((_5===null)||("undefined"===typeof (_5))){
_5=false;
}
if(_1||xg.index.quickadd.activeDialog){
return;
}
if(!_3){
return;
}
_1=1;
xg.shared.util.showOverlay();
if(xg.index.quickadd._dialogs[_2]){
if(_5){
dojo.dom.removeNode(xg.index.quickadd._dialogs[_2]);
}else{
xg.shared.util.hideOverlay();
xg.index.quickadd.openDialog(_2);
_1=0;
return;
}
}
if(!_5&&xg.index.quickadd._stub){
dojo.html.show(xg.index.quickadd._stub);
}else{
xg.index.quickadd._stub=xg.append(xg.shared.util.createElement("<div class=\"xg_floating_module\">"+"<div class=\"xg_floating_container xg_lightborder xg_floating_container_wide xg_module\" style=\"top: -30px\">"+"<div class=\"xg_module_body\">"+"<img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/spinner.gif")+"\" height=\"16\" width=\"16\">"+"</div>"+"</div>"+"</div>"));
}
var _6,_7=function(){
_1=0;
var el=xg.append(xg.shared.util.createElement(_6));
dojo.html.hide(el);
xg.shared.util.parseWidgets(el);
xg.index.quickadd.fire(_2,"load");
xg.index.quickadd._dialogs[_2]=el;
xg.shared.util.hideOverlay();
xg.index.quickadd.openDialog(_2);
};
var _9=2,_a=function(){
if(0==--_9){
_7();
}
};
var _b=["dojo.lfx.html","xg.index.util.FormHelper","xg.index.quickadd.core"];
if(js){
_b.push(js);
}
xg.get(_3,{},function(r,_d){
_6=_d;
_a();
});
_b.push(_a);
ning.loader.require.apply(ning.loader,_b);
};
});
}
if(!dojo.hostenv.findModule("xg.index.quickadd.bar",false)){
dojo.provide("xg.index.quickadd.bar");
dojo.widget.defineWidget("xg.index.quickAddBar",dojo.widget.HtmlWidget,{fillInTemplate:function(_1,_2){
var s=this.getFragNodeRef(_2);
xg.listen(s,"onchange",function(){
var _4,_5,js,_7;
if(s.selectedIndex){
var _8=s.options[s.selectedIndex];
_4=s.value;
_7=_8.getAttribute("gotoPage");
_5=_8.getAttribute("url");
js=_8.getAttribute("js");
}
if(_7){
window.location.href=_5;
return false;
}
s.value="";
if(_4){
var _9=false;
if(_4=="photo"){
_9=true;
}
xg.index.quickadd.loadModule(_4,_5,js,_9);
}
});
s.disabled=false;
}});
}
if(!dojo.hostenv.findModule("xg.index.bulk",false)){
dojo.provide("xg.index.bulk");
dojo.provide("xg.index.BulkActionLink");
dojo.widget.defineWidget("xg.index.BulkActionLink",dojo.widget.HtmlWidget,{title:"<required>",_url:"<required>",_successUrl:"",_successCallback:"",_displaySuccesDialog:"true",_couldNotProcessSomeEntitiesMessage:"",_couldNotProcessEntities:[],_joinPromptText:"",_ensureCheckboxClicked:false,_formId:"",_checkboxSelectMessage:"",_verb:"",_confirmMessage:"",_progressTitle:"",_progressMessage:"",_successTitle:"",_successMessage:"",_failureTitle:"",_failureMessage:"",_showCheckbox:false,_checkboxUrl:"",_checkboxSuccessUrl:"",_checkboxMessage:"",_checkboxLabelStyle:"",_checkboxChecked:false,_showTextarea:false,_textareaTitle:"",_textareaName:"textarea",_textareaContent:"",_nonEmptyTextareaVerb:"",_textareaToggles:false,_textareaHidden:false,_textareaIsTextInput:false,maxMsgLength:2000,ensureSelection:function(){
if(this._ensureCheckboxClicked){
var _1=false;
var _2=dojo.byId(this._formId);
checkboxes=[];
var _3=_2.getElementsByTagName("input");
for(a=0;a<_3.length;a++){
if(_3[a].type=="checkbox"){
checkboxes.push(_3[a]);
}
}
if(checkboxes.length){
for(i=0;i<checkboxes.length;i++){
if(checkboxes[i].checked){
_1=true;
}
}
}
if(!_1){
xg.shared.util.alert(this._checkboxSelectMessage);
}
return _1;
}else{
return true;
}
},fillInTemplate:function(_4,_5){
this._verb=this._verb||xg.index.nls.text("ok"),this._confirmMessage=this._confirmMessage||xg.index.nls.text("areYouSureYouWant"),this._progressTitle=this._progressTitle||xg.index.nls.text("processing"),this._progressMessage=this._progressMessage||xg.index.nls.text("pleaseKeepWindowOpen"),this._successTitle=this._successTitle||xg.index.nls.text("complete"),this._successMessage=this._successMessage||xg.index.nls.text("processIsComplete"),this._failureTitle=this._failureTitle||xg.index.nls.text("error"),this._failureMessage=this._failureMessage||xg.index.nls.text("processingFailed"),this.a=this.getFragNodeRef(_5);
dojo.style.show(this.a);
this.initDialog();
dojo.event.connect(this.a,"onclick",dojo.lang.hitch(this,function(_6){
dojo.event.browser.stopEvent(_6);
xg.shared.util.promptToJoin(this._joinPromptText,dojo.lang.hitch(this,function(){
if(this._confirmMessage){
this.confirm();
}else{
this.execute();
}
}));
}));
},initDialog:function(){
if(this.dialog){
return;
}
var _7=dojo.html.createNodesFromText(dojo.string.trim("            <div style=\"display: none\" class=\"xg_floating_module\">                <div class=\"xg_floating_container xg_lightborder xg_floating_container_wide xg_module\">                    <div class=\"xg_module_head\">                        <h2>"+dojo.string.escape("html",this.title)+"</h2>                    </div>                    <div class=\"xg_module_body\">                    </div>                </div>            </div>"))[0];
this.dialog=xg.append(_7);
this.h2=this.dialog.getElementsByTagName("h2")[0];
this.body=dojo.html.getElementsByClass("xg_module_body",_7,"div")[0];
},confirm:function(){
if(this.ensureSelection()){
this.h2.innerHTML=this.title;
var _8="<p>"+dojo.string.escape("html",this._confirmMessage)+"</p>                 <fieldset class=\"nolegend\">";
if(this._showCheckbox){
_8+="                    <p>                         <label style=\""+this._checkboxLabelStyle+"\"><input type=\"checkbox\"                             class=\"checkbox\" id=\"dialog_additional_checkbox\""+(this._checkboxChecked?" checked=\"checked\"":"")+">"+this._checkboxMessage+"</label>                     </p>";
}
if(this._showTextarea){
_8+="                    <p>"+(this._textareaTitle?"<label for=\"body\" id=\"textareaLabel\">"+(this._textareaToggles?"<span id=\"textareaArrow\">"+(this._textareaHidden?"\u25ba":"\u25bc")+"</span> ":"")+xg.qh(this._textareaTitle)+"</label>":"")+(this._textareaIsTextInput?"<input type=\"text\" size=\"30\" name=\"body\" id=\"body\" maxlength=\""+this.maxMsgLength+"\""+((this._textareaToggles&&this._textareaHidden)?" style=\"display: none;\"":"")+"value=\""+xg.qh(this._textareaContent)+"\">":"<textarea rows=\"4\" cols=\"30\" name=\"body\" id=\"body\""+((this._textareaToggles&&this._textareaHidden)?" style=\"display: none;\"":"")+">"+xg.qh(this._textareaContent)+"</textarea>")+"</p>";
}
_8+="                <p class=\"buttongroup\">                     <a href=\"#\" class=\"button action-primary\">"+this._verb+"</a>                     <a href=\"#\" class=\"action-secondary\">"+xg.index.nls.html("cancel")+"</a>                 </p>             </fieldset>";
this.body.innerHTML=_8;
var _9=this.body.getElementsByTagName("a");
if(this._showTextarea){
var _a=x$("#body")[0];
if(this._textareaToggles){
var _b=x$("#textareaLabel",this.body)[0];
var _c=x$("#textareaArrow",_b);
dojo.event.connect(_b,"onclick",dojo.lang.hitch(this,function(_d){
x$(_a).toggle(200);
_c.html(_c.html().indexOf("\u25ba")>-1?"\u25bc":"\u25ba");
}));
}
if(this._nonEmptyTextareaVerb){
dojo.event.connect(_a,"onkeyup",dojo.lang.hitch(this,function(_e){
var _f=dojo.string.trim(_a.value);
if(_f&&_f.length>0){
_9[0].innerHTML=xg.qh(this._nonEmptyTextareaVerb);
}else{
_9[0].innerHTML=xg.qh(this._verb);
}
}));
}
}
dojo.event.connect(_9[0],"onclick",dojo.lang.hitch(this,function(evt){
dojo.event.browser.stopEvent(evt);
if(this._showCheckbox&&dojo.byId("dialog_additional_checkbox").checked){
this._url=this._checkboxUrl;
if(this._checkboxSuccessUrl.length>0){
this._successUrl=this._checkboxSuccessUrl;
}
}
if(this._showTextarea){
var _11=x$("#body")[0];
this.messageBody=dojo.string.trim(_11.value);
if(this.messageBody.length>this.maxMsgLength){
this.failure(xg.index.nls.html("messageIsTooLong",this.maxMsgLength));
return;
}
}
this.execute();
}));
dojo.event.connect(_9[1],"onclick",dojo.lang.hitch(this,function(evt){
dojo.event.browser.stopEvent(evt);
this.hide();
}));
this.showDialog();
}
},execute:function(){
this.h2.innerHTML=this._progressTitle;
this.body.innerHTML="<img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/spinner.gif")+"\" alt=\"\" class=\"left\" style=\"margin-right:5px\" width=\"20\" height=\"20\"/>             <p style=\"margin-left:25px\">"+this._progressMessage+"</p>";
this.showDialog();
this.doBulkAction(0);
},showDialog:function(){
xg.shared.util.showOverlay();
dojo.html.show(this.dialog);
window.scrollTo(0,0);
},doBulkAction:function(_13){
dojo.io.bind({url:this._url,method:"post",encoding:"utf-8",preventCache:true,content:dojo.lang.mixin({counter:_13},this.getPostContent(_13)),mimetype:"text/json",load:dojo.lang.hitch(this,function(t,_15,e){
if(!_15){
this.failure(this._failureMessage);
}else{
if("couldNotProcessEntities" in _15){
this._couldNotProcessEntities=this._couldNotProcessEntities.concat(_15.couldNotProcessEntities);
}
if(!("contentRemaining" in _15)){
if("errorMessage" in _15){
this.failure(_15.errorMessage);
}else{
this.failure(this._failureMessage);
}
}else{
if(this.isDone(_15.contentRemaining)){
this.success();
}else{
this.doBulkAction(_13+1);
}
}
}
})});
},getPostContent:function(_17){
var _18={};
if(this._showTextarea){
_18[this._textareaName]=this.messageBody;
}
return _18;
},isDone:function(_19){
return _19==0;
},success:function(){
if(this._successUrl.length&&this._couldNotProcessEntities.length==0){
window.location.replace(this._successUrl);
}else{
if(this._displaySuccesDialog=="true"||this._couldNotProcessEntities.length>0){
var _1a="";
if(this._couldNotProcessEntities.length>0){
this.h2.innerHTML=this.title;
_1a="<p>"+this._couldNotProcessSomeEntitiesMessage+"</p><ul>";
for(var i=0;i<this._couldNotProcessEntities.length;i++){
_1a+="<li>"+this._couldNotProcessEntities[i]+"</li>";
}
_1a+="</ul>";
}else{
this.h2.innerHTML=this._successTitle;
_1a="<p>"+this._successMessage+"</p>";
}
_1a+="<p class=\"buttongroup\"><a href=\"#\" class=\"button\">"+xg.index.nls.html("ok")+"</a></p>";
this.body.innerHTML=_1a;
var _1c=this.body.getElementsByTagName("a");
dojo.event.connect(this.body.getElementsByTagName("a")[_1c.length-1],"onclick",dojo.lang.hitch(this,function(evt){
dojo.event.browser.stopEvent(evt);
this.hide();
if(this._successUrl.length){
window.location.replace(this._successUrl);
}
}));
}else{
this.hide();
}
if(this._successCallback.length){
eval(this._successCallback+"(this.a)");
}
window.scrollTo(0,0);
}
},failure:function(_1e){
this.h2.innerHTML=this._failureTitle;
this.body.innerHTML="<p>"+_1e+"</p>                 <p class=\"buttongroup\">                     <a href=\"#\" class=\"button\">"+xg.index.nls.html("ok")+"</a>                 </p>";
var _1f=this.body.getElementsByTagName("a");
dojo.event.connect(this.body.getElementsByTagName("a")[_1f.length-1],"onclick",dojo.lang.hitch(this,function(evt){
dojo.event.browser.stopEvent(evt);
this.hide();
}));
dj_global.scrollTo(0,0);
},hide:function(){
x$(this.dialog).hide();
xg.shared.util.hideOverlay();
}});
dojo.widget.defineWidget("xg.index.BroadcastMessageLink",xg.index.BulkActionLink,{_spamUrl:"",_spamMessageParts:"",maxMsgLength:10000,confirm:function(){
this.h2.innerHTML=this.title;
this.body.innerHTML="<dl style=\"display: none\"></dl>                <fieldset>                 <p><label for=\"subject\">"+xg.index.nls.html("subject")+"</label><br /><input type=\"text\" class=\"textfield\" name=\"subject\" id=\"subject\" size=\"51\" /></p>                 <p><label for=\"body\">"+xg.index.nls.html("body")+"</label>("+xg.index.nls.html("htmlNotAllowed")+")<br /><textarea rows=\"6\" cols=\"20\" style=\"width:230px\" name=\"body\" id=\"body\"></textarea></p>                 <p class=\"buttongroup\">                     <a href=\"#\" class=\"button action-primary\">"+xg.index.nls.html("send")+"</a>                     <a href=\"#\" class=\"action-secondary\">"+xg.index.nls.html("cancel")+"</a>                 </p>             </fieldset>";
var _21=this.body.getElementsByTagName("a");
var _22=this.body.getElementsByTagName("input")[0];
var _23=this.body.getElementsByTagName("textarea")[0];
var _24=this.body.getElementsByTagName("dl")[0];
dojo.event.connect(_21[0],"onclick",dojo.lang.hitch(this,function(evt){
dojo.event.browser.stopEvent(evt);
var _26=[];
dojo.lang.forEach(dojo.html.getElementsByClass("error",this.body),function(el){
dojo.html.removeClass(el,"error");
},true);
this.messageSubject=dojo.string.trim(_22.value);
if(this.messageSubject.length==0){
_26.push(xg.index.nls.html("pleaseEnterASubject"));
xg.index.util.FormHelper.showErrorMessage(_22);
}else{
if(this.messageSubject.length>this.maxMsgLength){
_26.push(xg.index.nls.html("subjectIsTooLong",this.maxMsgLength));
xg.index.util.FormHelper.showErrorMessage(_22);
}
}
this.messageBody=dojo.string.trim(_23.value);
if(this.messageBody.length==0){
_26.push(xg.index.nls.html("pleaseEnterAMessage"));
xg.index.util.FormHelper.showErrorMessage(_23);
}else{
if(this.messageBody.length>this.maxMsgLength){
_26.push(xg.index.nls.html("messageIsTooLong",this.maxMsgLength));
xg.index.util.FormHelper.showErrorMessage(_23);
}
}
if(_26.length==0){
dojo.html.hide(_24);
this._executeProper(_22,_23);
}else{
dojo.html.setClass(_24,"errordesc msg clear");
_24.innerHTML="<dt>"+xg.index.nls.html("thereHasBeenAnError")+"</dt><dd><ol><li>"+_26.join("</li><li>")+"</li></ol></dd>";
dojo.html.show(_24);
}
}));
dojo.event.connect(_21[1],"onclick",dojo.lang.hitch(this,function(evt){
dojo.event.browser.stopEvent(evt);
this.hide();
}));
xg.shared.util.setAdvisableMaxLength(_23,this.maxMsgLength);
this.showDialog();
},_executeProper:function(_29,_2a){
var _2b=this;
this._spamMessageParts=dojo.json.evalJson(this._spamMessageParts);
this._spamMessageParts[xg.index.nls.text("yourSubject")]=_29.value;
this._spamMessageParts[xg.index.nls.text("yourMessage")]=_2a.value;
this._spamMessageParts=dojo.json.serialize(this._spamMessageParts);
xg.shared.SpamWarning.checkForSpam({url:this._spamUrl,messageParts:this._spamMessageParts,form:_2b.body,onContinue:function(){
dojo.style.show(_2b.dialog);
_2b.execute();
},onBack:function(){
dojo.style.show(_2b.dialog);
},onWarning:function(){
dojo.style.hide(_2b.dialog);
}});
},getPostContent:function(_2c){
return {subject:this.messageSubject,body:this.messageBody};
}});
}
if(!dojo.hostenv.findModule("xg.chat.Base",false)){
dojo.provide("xg.chat.Base");
(function(){
var _1=document,_2=function(){
return _1.innerHeight||(_1.documentElement?_1.documentElement.clientHeight:(_1.body?_1.body.clientHeight:0));
},_3=function(_4,_5,_6){
_1.cookie=_4+"="+encodeURIComponent(_5)+(_6?";Expires="+(new Date((new Date).getTime()+_6*1000)).toGMTString():"")+";Path=/;Domain="+window.location.host;
return true;
},_7=function(_8){
var _9=_1.cookie.split("; ");
for(var i=0;i<_9.length;i++){
var _b=_9[i].split("=",2);
if(_b[0]==_8){
return decodeURIComponent(_b[1]);
}
}
},_c=[],_d,_e,_f,_10,_11,_12,_13,_14,_15=0,_16=function(_17){
var ac=x$("#appletContainer");
if(_17){
_14.style.display="none";
xg.chat.Base.setChatExpandedMode(true);
xg.chat.Base.expandChatDiv();
}
if(_15>0){
return;
}
_15=1;
if(!_17){
ac.css("left","-10000px");
}
ac.css("display","").css("visibility","visible");
ac[0].innerHTML=_14.getAttribute("_chatEmbed");
},_19=undefined,_1a=function(url,_1c,_1d){
if(!x$.browser.mozilla){
return x$.getJSON(url,_1c,_1d);
}
if("undefined"==typeof _19){
_19="loading";
var _1e=document.createElement("iframe");
_1e.name="chatPoll";
_1e.id="chatPoll";
_1e.src="/xn_resources/widgets/chat/poll.html";
_1e.onload=function(){
_19=_1e;
_1a(url,_1c,_1d);
};
_1e.style.left=_1e.style.top=_1e.style.height=_1e.style.width="1px";
_1e.style.visibility="hidden";
xg.append(_1e);
}else{
if("string"==typeof _19){
}else{
var now=(new Date).getTime(),_20="jsonp"+parseInt(now*Math.random()),w=_19.contentWindow,_22=w.document.getElementsByTagName("head")[0],_23=w.document.createElement("script");
w[_20]=function(_24){
w[_20]=undefined;
try{
delete w[_20];
}
catch(e){
}
_22.removeChild(_23);
_1d(_24);
};
_1c._=now;
_1c=x$.param(_1c);
url+=(url.match(/\?/)?"&":"?")+_1c;
_23.src=url.replace(/\bc=\?/,"c="+_20);
_22.appendChild(_23);
}
}
},_25=function(_26){
if(_10=xg.chat.Base.getChatServer(true)){
_26();
}else{
x$.getJSON("http://"+_14.getAttribute("_chatServer")+"/xn/redirector/redirect?c=?",{a:_d},function(_27){
xg.chat.Base.setChatServer(_10=_27.domain);
_26();
});
}
},_28=function(_29){
x$(".xj_info",_14).html(_e+" Chat | "+_29+" Online");
},_2a,_2b=function(){
x$.getJSON("http://"+_10+"/xn/presence/count?c=?",{r:_13,t:_12,a:_d,i:_f},function(_2c){
_28(_2c.count);
if(_15==0){
_2a=setTimeout(_2b,30*1000);
}
});
},_2d=function(){
if(_2a){
clearTimeout(_2a);
_2a=undefined;
}
},_2e=0,_2f=function(){
_2e=1;
_1a("http://"+_10+"/xn/groupchat/poll?c=?",{r:_13,t:_12,a:_d,i:_f},function(_30){
if(_30.messages){
for(var i=0;i<_30.messages.length;i++){
if(_30.messages[i].type=="private"){
_c.push(_30.messages[i]);
}
}
if(_30.messages.length){
_16(false);
}
}
if(_15!=2){
_2f();
}
});
},_32=function(){
x$.getJSON(_14.getAttribute("_loginUrl"),{chatServerDomain:_10},function(_33){
if(_33.result!="ok"){
return;
}
_13=_33.roomId;
_12=_33.token;
_28(_33.count);
if(_15==0){
_2d();
_2a=setTimeout(_2b,30*1000);
if(!_2e){
setTimeout(_2f,50);
}
}
if(!_33.sessionTTL){
_33.sessionTTL=14400;
}
_34(_33.sessionTTL);
});
},_35,_36=function(){
if(_35){
clearTimeout(_35);
_35=undefined;
}
},_34=function(_37){
_36();
_35=setTimeout(_38,(_37-300)*1000);
},_38=function(){
x$.getJSON(_14.getAttribute("_loginUrl"),{chatServerDomain:_10},function(_39){
if(_39.result!="ok"){
return;
}
_12=_39.token;
_34(_39.sessionTTL);
});
};
xg.chat.Base={chatIsLoaded:function(){
_15=2;
_2d();
_36();
_14.style.display="none";
x$("#appletContainer").css("visibility","visible").css("left","");
},getOnlineStatus:function(){
var s=_7("xg_chatOnline");
return typeof s=="undefined"?true:(s=="1"?true:false);
},setOnlineStatus:function(_3b){
return _3("xg_chatOnline",_3b?"1":"0");
},getChatServer:function(_3c){
var s=_7("xg_chatServer");
if(_3c){
return s;
}
if(!_11){
_11=s.replace(/^(\w+)((\.[a-z][\w-]+){3})$/i,""+((new Date).getTime()&65535)+"$2");
}
return _11;
},setChatServer:function(_3e){
if(_3e!=_11){
_11=_3e;
return _3("xg_chatServer",_3e,3600);
}
return true;
},getChatExpandedMode:function(){
var s=_7("xg_chatExp");
return typeof s=="undefined"?false:(s=="1"?true:false);
},setChatExpandedMode:function(_40){
return _3("xg_chatExp",_40?"1":"0");
},getPendingPrivateMessages:function(){
return _c;
},expandChatDiv:function(){
setTimeout(function(){
var _41=_1.getElementById("appletContainer");
var _42=_2();
_41.style.height=(_42&&_42<=425)?(_42-20)+"px":"485px";
},50);
},contractChatDiv:function(){
setTimeout(function(){
var _43=_1.getElementById("appletContainer");
_43.style.height="22px";
},50);
},start:function(){
if(!(_14=_1.getElementById("xj_chatContainer"))){
return;
}
_d=ning.CurrentApp.id;
_e=ning.CurrentApp.name.length>40?ning.CurrentApp.name.substr(0,37)+"...":ning.CurrentApp.name;
_f=ning.CurrentProfile?ning.CurrentProfile.id:"";
var _44=function(){
_16(true);
return false;
};
if(xg.chat.Base.getChatExpandedMode()){
return _44();
}
x$(".xj_expand",_14).click(_44);
x$(".xj_info",_14).click(_44);
x$(".xj_window",_14).click(function(){
window.open("/chat/index/popOutWindow","chat"+_d,"height=485,width=480,toolbar=no,scrollbars=no,resizable=yes");
return false;
});
var _45=xg.chat.Base.getOnlineStatus(),_46=x$(".xj_status",_14);
var _47=function(){
_46.addClass("xg_status-offline");
x$(".xj_info",_14).html(_e+" Chat | Disconnected");
};
if(!_45){
_47();
}
_46.click(function(){
var _48=!xg.chat.Base.getOnlineStatus();
xg.chat.Base.setOnlineStatus(_48);
if(_48){
_46.removeClass("xg_status-offline");
_25(_32);
}else{
_2d();
_36();
_47();
}
return false;
});
if(_45){
_25(_32);
}
}};
})();
}
