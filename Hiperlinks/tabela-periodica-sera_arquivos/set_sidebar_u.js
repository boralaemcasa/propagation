if(!dojo.hostenv.findModule("xg.index.embed.badge",false)){
dojo.provide("xg.index.embed.badge");
xg.index.embed.badge={initialize:function(){
var _1=x$("div.xj_badge_body");
var _2=_1.attr("_embedCode");
_1.html(_2);
}};
xg.addOnRequire(function(){
xg.index.embed.badge.initialize();
});
}
if(!dojo.hostenv.findModule("xg.shared.EditUtil",false)){
dojo.provide("xg.shared.EditUtil");
xg.shared.EditUtil={showModuleForm:function(_1,_2,_3){
_1.style.height="0px";
dojo.html.show(_1);
dojo.lfx.html.wipeIn(_1,200).play();
},hideModuleForm:function(_4,_5,_6,_7){
dojo.html.removeClass(_6,"close");
dojo.lfx.html.wipeOut(_4,200,null,function(){
dojo.html.hide(_4);
if(_7){
_7();
}
}).play();
}};
}
if(!dojo.hostenv.findModule("xg.index.embed.BadgeModule",false)){
dojo.provide("xg.index.embed.BadgeModule");
dojo.widget.defineWidget("xg.index.embed.BadgeModule",dojo.widget.HtmlWidget,{_setValuesUrl:"",_badgeSizeSet:"",_badgeSizeOptionsJson:"",fillInTemplate:function(_1,_2){
this.module=this.getFragNodeRef(_2);
this.h2=this.module.getElementsByTagName("h2")[0];
dojo.dom.insertAfter(dojo.html.createNodesFromText("<p class=\"edit button\"><a class=\"button\" href=\"#\"><span>"+xg.index.nls.html("edit")+"</span></a></p>")[0],this.h2);
dojo.event.connect(this.module.getElementsByTagName("a")[0],"onclick",dojo.lang.hitch(this,function(_3){
dojo.event.browser.stopEvent(_3);
if((!this.form)||(this.form.style.height=="0px")){
this.showForm();
}else{
this.hideForm();
}
}));
},showForm:function(){
var _4=this.module.getElementsByTagName("a")[0];
var _5="";
dojo.lang.forEach(dj_eval(this._badgeSizeOptionsJson),function(_6){
_5+="<option value=\""+dojo.string.escape("html",_6.value)+"\">"+dojo.string.escape("html",_6.label)+"</option>";
});
if(!this.form){
this.form=xg.shared.util.createElement("                 <form class=\"xg_module_options\">                     <fieldset>                         <dl>                             <dt><label for=\""+this.widgetId+"_badgeSize\">"+xg.index.nls.html("size")+"</label></dt>                             <dd>                                 <select id=\""+this.widgetId+"_badgeSize\">                                     "+_5+"                                 </select>                              </dd>                         </dl>                         <p class=\"buttongroup\">                             <input type=\"submit\" value=\""+xg.index.nls.html("save")+"\" class=\"button action-primary submit\"/>                             <a class=\"action-secondary\"  id=\""+this.widgetId+"_cancelbtn\" href=\"#\">"+xg.index.nls.html("cancel")+"</a>                         </p>                     </fieldset>                 </form>                 ");
this.head=dojo.html.getElementsByClass("xg_module_head",this.module)[0];
dojo.dom.insertAfter(this.form,this.head);
this.formHeight=this.form.offsetHeight;
this.form.style.height="0px";
dojo.event.connect(this.form,"onsubmit",dojo.lang.hitch(this,function(_7){
this.save(_7);
}));
dojo.event.connect(dojo.byId(this.widgetId+"_cancelbtn"),"onclick",dojo.lang.hitch(this,function(_8){
dojo.event.browser.stopEvent(_8);
this.hideForm();
}));
}else{
dojo.html.removeClass(this.form,"collapsed");
}
this.form.style.height="0px";
xg.index.util.FormHelper.select(this._badgeSizeSet,dojo.byId(this.widgetId+"_badgeSize"));
xg.shared.EditUtil.showModuleForm(this.form,this.formHeight,_4);
},hideForm:function(){
var _9=this.module.getElementsByTagName("a")[0];
xg.shared.EditUtil.hideModuleForm(this.form,this.formHeight,_9);
},save:function(_a){
dojo.event.browser.stopEvent(_a);
this._badgeSizeSet=xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_badgeSize")).value;
this.hideForm();
dojo.io.bind({url:this._setValuesUrl,method:"post",content:{badgeSizeSet:this._badgeSizeSet},preventCache:true,mimetype:"text/javascript",encoding:"utf-8",load:dojo.lang.hitch(this,dojo.lang.hitch(this,function(_b,_c,_d){
dojo.lang.forEach(dojo.html.getElementsByClass("xg_module_body",this.module),function(_e){
dojo.dom.removeNode(_e);
});
x$(".xg_module_foot",this.module).before(dojo.html.createNodesFromText(_c.moduleBodyAndFooterHtml));
xg.shared.util.fixImagesInIE(this.module.getElementsByTagName("img"));
xg.shared.util.parseWidgets(dojo.html.getElementsByClass("xg_module_body",this.module)[0]);
if(!dojo.hostenv.findModule("xg.index.embed.badge",false)){
ning.loader.require("xg.index.embed.badge");
}else{
xg.index.embed.badge.initialize();
}
}))});
}});
}
if(!dojo.hostenv.findModule("xg.shared.editors.PlainEditor",false)){
dojo.provide("xg.shared.editors.PlainEditor");
xg.shared.editors.PlainEditor=function(_1){
var _2={};
var _={};
_2.setMaxLength=function(_4){
xg.shared.util.setAdvisableMaxLength(_1[0],_4);
};
_2.updateBackgroundColor=function(){
};
_2.val=function(){
if(arguments.length){
_1.val(arguments[0]);
return;
}
return _1.val();
};
_2.initializeAfterPageLoad=function(){
return _2;
};
_2.uninitialize=function(){
return _2;
};
_2.focus=function(){
_1[0].focus();
};
_2.moveCursorToStart=function(){
xg.shared.editors.Editor.moveCursorToStart(_1[0]);
};
_2.updateTextarea=function(){
};
_2.getTextarea=function(){
return _1;
};
return _2;
};
}
if(!dojo.hostenv.findModule("xg.shared.editors.Editor",false)){
dojo.provide("xg.shared.editors.Editor");
xg.shared.editors.Editor=(function($){
var _2={};
var _={};
var _4={};
var _5=1;
_.getID=function(_6){
var _7=$(_6);
if(!_7.data("xj_editor_id")){
_7.data("xj_editor_id",_5++);
}
return _7.data("xj_editor_id");
};
_2.get=function(_8){
var id=_.getID(_8);
if(!_4[id]){
var _a=$(_8);
if(_a.attr("_wysiwyg")){
_4[id]=xg.shared.editors.HtmlBoxEditor(_a);
}else{
if(_a.hasClass("wysiwyg-mce-editor")||_a.hasClass("deferred-wysiwyg-mce-editor")||_a.hasClass("html-mce-editor")||_a.hasClass("deferred-html-mce-editor")){
_4[id]=xg.shared.editors.TinyMCEEditor(_a);
}else{
if(_a.attr("dojoType")==="SimpleToolbar"||_a.attr("deferredDojoType")==="SimpleToolbar"){
_4[id]=xg.shared.editors.SimpleToolbarEditor(_a);
}else{
_4[id]=xg.shared.editors.PlainEditor(_a);
}
}
}
}
return _4[id];
};
_2.closest=function(_b,_c){
while(_b.length>=1){
if(_b.is(_c)){
return _b;
}
_b=_b.parent();
}
return _b;
};
_2.moveCursorToStart=function(_d){
if(_d.setSelectionRange){
_d.setSelectionRange(0,0);
}else{
if(_d.createTextRange){
var _e=_d.createTextRange();
_e.collapse(true);
_e.moveEnd("character",0);
_e.moveStart("character",0);
_e.select();
}
}
};
_2.warnOnLostChanges=function(_f,_10,_11){
var _12=_2.get(_f);
var _13=_12.val();
window.unloadaction=function(){
if(_11&&_11.isShowing()){
return;
}
if(_12.val().replace(/<.*?>|&nbsp;/g,"")!=_13.replace(/<.*?>|&nbsp;/g,"")){
return _10?_10:xg.shared.nls.text("unsavedChanges");
}
};
window.onbeforeunload=function(){
return window.unloadaction();
};
_2.closest($(_f),"form").submit(function(){
if(window.onbeforeunload){
window.onbeforeunload=null;
}
});
var _14=dojo.event.browser.stopEvent;
dojo.event.browser.stopEvent=function(_15){
_14(_15);
if(_15.type=="submit"||_15.type=="onsubmit"){
window.onbeforeunload=function(){
return window.unloadaction();
};
}
};
};
return _2;
})(x$);
}
if(!dojo.hostenv.findModule("xg.shared.UploadFileDialog",false)){
dojo.provide("xg.shared.UploadFileDialog");
xg.shared.UploadFileDialog={createLinkedFilename:function(_1){
var _2=_1.split("/");
var _3=decodeURIComponent(_2[_2.length-1]);
return "<a href=\""+_1+"\">"+_3+"</a>";
},showSpinner:function(){
dojo.html.hide("upload-form-container");
dojo.html.show("shared-upload-progress");
},uploadInsert:function(_4,_5){
_4.html=decodeURIComponent(_4.html);
if(_4.error){
dojo.html.hide("shared-upload-progress");
dojo.byId("shared-upload-error-message").innerHTML=_4.error;
dojo.html.show("shared-upload-error");
}else{
xg.shared.util.hideOverlay();
dojo.html.hide("shared-upload-progress");
dojo.html.hide("shared-upload-module");
dojo.html.hide("shared-upload-module-container");
dojo.dom.removeNode(dojo.byId("shared-upload-module"));
_5(_4.html);
}
},uploadValidate:function(_6){
var _7={};
_7=xg.index.util.FormHelper.validateRequired(_7,_6,"file",xg.shared.nls.html("pleaseSelectAFile"));
return _7;
},uploadOptionsDisable:function(){
dojo.byId("upload-file").value="";
dojo.byId("upload-thumb").disabled=true;
dojo.byId("upload-size").disabled=true;
dojo.byId("upload-popup").disabled=true;
},uploadOptionsEnable:function(){
dojo.byId("existing-image").value="http://";
dojo.byId("upload-thumb").disabled=false;
dojo.byId("upload-size").disabled=false;
dojo.byId("upload-popup").disabled=false;
},submitProcess:function(_8,_9){
if((dojo.byId("existing-file").value.length<8)||(dojo.byId("upload-file").value.length>0)){
dojo.lang.forEach(dojo.html.getElementsByClass("error",_8),function(_a){
dojo.html.removeClass(_a,"error");
});
xg.index.util.FormHelper.trimTextInputsAndTextAreas(_8);
errors=this.uploadValidate(_8);
xg.index.util.FormHelper.hideErrorMessages(_8);
if(dojo.lang.isEmpty(errors)){
this.showSpinner();
xg.index.util.FormHelper.save(_8,dojo.lang.hitch(this,function(_b){
this.uploadInsert(_b,_9);
}),_8.action);
}else{
xg.index.util.FormHelper.showErrorMessages(_8,errors,xg.shared.nls.html("pleaseCorrectErrors"));
}
}else{
var _c=this.createLinkedFilename(dojo.byId("existing-file").value);
dojo.html.hide("shared-upload-progress");
dojo.html.hide("shared-upload-module-container");
dojo.html.hide("shared-upload-module");
xg.shared.util.hideOverlay();
dojo.dom.removeNode(dojo.byId("shared-upload-module"));
_9(_c);
}
},showForm:function(_d){
var _e="";
if(ning.maxFileUploadSize!=undefined&&ning.maxFileUploadSize!=""){
_e="<p class=\"dy-small\">"+xg.shared.nls.html("fileSizeLimit",ning.maxFileUploadSize)+"</p>";
}
var _f=dojo.html.createNodesFromText(dojo.string.trim("        <div id=\"shared-upload-module\" class=\"xg_floating_module\">             <div id=\"shared-upload-module-container\" class=\"xg_floating_container xg_lightborder xg_module\">                 <div class=\"xg_module_head\">                     <h2 id=\"shared-upload-module-title\">"+xg.shared.nls.html("uploadAFile")+"</h2>                 </div>                 <div id=\"shared-upload-module-body\" class=\"xg_module_body\">                     <div id=\"upload-form-container\">                         <dl id=\"upload-form_notify\"></dl>                         <form id=\"upload-form\" method=\"post\" enctype=\"multipart/form-data\" action=\"/profiles/blog/upload/.txt?xn_out=json\">                             <input type=\"hidden\" name=\"image\" value=\"0\"/>                             <fieldset class=\"nolegend\">                                 <p>                                     <label for=\"upload-file\">"+xg.shared.nls.html("uploadAFile")+"</label><br />                                     <input id=\"upload-file\" name=\"file\" type=\"file\" class=\"file\" />                                 </p>                                 "+_e+"                             </fieldset>                             <fieldset class=\"nolegend\">                                 <p>                                     <label for=\"existing-file\">"+xg.shared.nls.html("addExistingFile")+"</label><br />                                     <input id=\"existing-file\" name=\"existing-file\" type=\"text\" class=\"textfield wide\" value=\"http://\" />                                 </p>                             </fieldset>                             <fieldset>                                 <p class=\"buttongroup\"> \t\t\t\t\t\t\t\t<input id=\"upload-submit\" type=\"submit\" class=\"button action-primary\" value=\""+xg.shared.nls.html("add")+"\" /> \t\t\t\t\t\t\t\t<a id=\"upload-cancel\" class=\"action-secondary\" href=\"#\">"+xg.shared.nls.html("cancel")+"</a>                                 </p>                             </fieldset>                         </form>                     </div>                     <div id=\"shared-upload-progress\" style=\"display:none\">                         <img class=\"left\" width=\"20\" height=\"20\" style=\"margin-right: 5px;\" alt=\"\" src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/spinner.gif")+"\"/>                         <p style=\"margin-left: 25px;\">"+xg.shared.nls.html("keepWindowOpen")+"</p>                         <p class=\"buttongroup\"><a class=\"action-secondary\" id=\"shared-upload-progress-button\" href=\"#\">"+xg.shared.nls.html("cancelUpload")+"</a></p>                     </div>                     <div id=\"shared-upload-error\" style=\"display: none\">                         <div class=\"dy-error-msg\"><p id=\"shared-upload-error-message\"></p></div>                         <p><input id=\"shared-upload-error-ok\" type=\"button\" class=\"right\" value=\""+xg.shared.nls.html("ok")+"\" /></p>                     </div>                 </div>             </div>         </div>"))[0];
xg.shared.util.showOverlay();
xg.append(_f);
if(xg.uploadsDisabled){
dojo.byId("upload-file").disabled=true;
}
dojo.byId("upload-form").appendChild(xg.shared.util.createCsrfTokenHiddenInput());
dojo.event.connect(dojo.byId("upload-cancel"),"onclick",dojo.lang.hitch(this,function(_10){
dojo.event.browser.stopEvent(_10);
xg.shared.util.hideOverlay();
dojo.dom.removeNode(dojo.byId("shared-upload-module"));
}));
dojo.event.connect(dojo.byId("upload-form"),"onsubmit",dojo.lang.hitch(this,function(_11){
dojo.event.browser.stopEvent(_11);
var _12=dojo.byId("upload-form");
this.submitProcess(_12,_d);
}));
dojo.event.connect(dojo.byId("shared-upload-error-ok"),"onclick",dojo.lang.hitch(this,function(_13){
dojo.event.browser.stopEvent(_13);
xg.shared.util.hideOverlay();
dojo.dom.removeNode(dojo.byId("shared-upload-module"));
}));
dojo.event.connect(dojo.byId("shared-upload-progress-button"),"onclick",dojo.lang.hitch(this,function(_14){
dojo.event.browser.stopEvent(_14);
xg.shared.IframeUpload.stop();
dojo.dom.removeNode(dojo.byId("shared-upload-module"));
xg.shared.util.hideOverlay();
}));
}};
}
if(!dojo.hostenv.findModule("xg.shared.AddImageDialog",false)){
dojo.provide("xg.shared.AddImageDialog");
xg.shared.AddImageDialog={promptForImage:function(_1,_2,_3,_4,_5,_6,_7,_8){
this.showForm(_1,_2,_3,_4,_5,_6,_7,_8);
},safariImage:function(_9){
var _a=prompt("Please enter an image address","http://");
var _b;
if(_a!=null){
_b="<img src=\""+_a+"\" />";
}else{
_b="";
}
_9(_b);
},showSpinner:function(){
dojo.html.hide("upload-form-container");
dojo.html.show("shared-upload-progress");
},uploadInsert:function(_c,_d){
_c.html=decodeURIComponent(_c.html);
if(_c.error){
dojo.html.hide("shared-upload-progress");
dojo.byId("shared-upload-error-message").innerHTML=_c.error;
dojo.html.show("shared-upload-error");
}else{
xg.shared.util.hideOverlay();
dojo.html.hide("shared-upload-progress");
dojo.html.hide("shared-upload-module");
dojo.html.hide("shared-upload-module-container");
dojo.dom.removeNode(dojo.byId("shared-upload-module"));
_d(_c.html);
}
},uploadValidate:function(_e){
var _f={};
_f=xg.index.util.FormHelper.validateRequired(_f,_e,"file",xg.shared.nls.html("pleaseSelectAFile"));
if(dojo.byId("upload-thumb").checked){
_f=xg.index.util.FormHelper.validateRequired(_f,_e,"thumb",xg.shared.nls.html("pleaseSpecifyAThumbnailSize"));
if(!_f["thumb"]){
var s=dojo.string.trim(dojo.byId("upload-size").value);
if(!s.match(/^\d+$/)){
_f["size"]=xg.shared.nls.html("thumbnailSizeMustBeNumber");
}
}
}
return _f;
},wrapOptionEnable:function(_11){
var _12=dojo.byId("upload-form");
if(!_11){
_12.wrap.checked=false;
}
_12.wrap.disabled=!(_11);
},uploadOptionsDisable:function(){
if(!dojo.byId("existing-image").value&&dojo.byId("existing-image").oldValue){
dojo.byId("existing-image").value=dojo.byId("existing-image").oldValue;
}
dojo.byId("upload-file").value="";
if(!this.isLocalImage()){
dojo.byId("upload-thumb").disabled=true;
dojo.byId("upload-size").disabled=true;
}else{
dojo.byId("upload-thumb").disabled=false;
dojo.byId("upload-size").disabled=false;
}
},uploadOptionsEnable:function(){
dojo.byId("existing-image").oldValue=dojo.byId("existing-image").value;
dojo.byId("existing-image").value="";
dojo.byId("upload-thumb").disabled=false;
dojo.byId("upload-size").disabled=false;
},isLocalImage:function(){
var url=dojo.byId("existing-image").value;
if(url.match(/^https?:\/\/api\.(\w+\.)?(ning.com|ningops.net)(:\d+)?\//i)){
return true;
}
return false;
},submitProcess:function(_14,_15){
if((dojo.byId("existing-image").value.length<8)||(dojo.byId("upload-file").value.length>0)){
dojo.lang.forEach(dojo.html.getElementsByClass("error",_14),function(_16){
dojo.html.removeClass(_16,"error");
});
xg.index.util.FormHelper.trimTextInputsAndTextAreas(_14);
errors=this.uploadValidate(_14);
xg.index.util.FormHelper.hideErrorMessages(_14);
if(dojo.lang.isEmpty(errors)){
this.showSpinner();
xg.index.util.FormHelper.save(_14,dojo.lang.hitch(this,function(_17){
this.uploadInsert(_17,_15);
}),_14.action);
}else{
xg.index.util.FormHelper.showErrorMessages(_14,errors,xg.shared.nls.html("pleaseCorrectErrors"));
}
}else{
var _18="left";
var _19=dojo.byId("existing-image").value;
var _1a=_19;
var _1b="";
var _1c=dojo.byId("text-wrap").checked;
if(this.isLocalImage()&&dojo.byId("upload-thumb").checked){
var _1d=parseInt(dojo.byId("upload-size").value);
if(!isNaN(_1d)&&_1d>0){
_19=_19+"?width="+_1d;
}
}
if(dojo.byId("center-align-radio").checked){
_18="center";
}else{
if(dojo.byId("right-align-radio").checked){
_18="right";
}
}
if(_1c&&_18!="center"){
_1b="<img style='float:"+_18+";' src='";
_1b+=_19+"' />";
}else{
_1b="<img src='"+_19+"' />";
}
if(dojo.byId("upload-popup").checked){
_1b="<a target=\"_blank\" class=\"noborder\" href=\""+_1a+"\">"+_1b+"</a>";
}
if(!_1c||_18=="center"){
_1b="<p style='text-align:"+_18+"'>"+_1b+"</p>";
}
dojo.html.hide("shared-upload-progress");
dojo.html.hide("shared-upload-module-container");
dojo.html.hide("shared-upload-module");
xg.shared.util.hideOverlay();
dojo.dom.removeNode(dojo.byId("shared-upload-module"));
_15(_1b);
}
},showForm:function(_1e,_1f,_20,_21,_22,_23,_24,_25){
var _26=dojo.html.createNodesFromText(dojo.string.trim("        <div id=\"shared-upload-module\" class=\"xg_floating_module\">             <div id=\"shared-upload-module-container\" class=\"xg_floating_container xg_lightborder xg_floating_container_wide xg_module\">                 <div class=\"xg_module_head\">                     <h2 id=\"shared-upload-module-title\">"+xg.shared.nls.html(_21?"editImage":"addAnImage")+"</h2>                 </div>                 <div id=\"shared-upload-module-body\" class=\"xg_module_body\">                     <div id=\"upload-form-container\">                         <dl id=\"upload-form_notify\"></dl>                         <form id=\"upload-form\" method=\"post\" enctype=\"multipart/form-data\" action=\"/profiles/blog/upload/.txt?xn_out=json\">                             <input type=\"hidden\" name=\"image\" value=\"1\"/>                             <fieldset class=\"nolegend\">                                 <p>                                     <label for=\"upload-file\">"+xg.shared.nls.html("uploadAnImage")+"</label><br />                                     <input id=\"upload-file\" name=\"file\" type=\"file\" class=\"file wide\" size=\"15\" />                                     "+((_20)?("<small class=\"xg_lightfont\">"+xg.shared.nls.html("gifJpgPngLimit",_20)+"</small>"):(""))+"                                 </p>                             </fieldset>                             <fieldset class=\"nolegend\">                                 <p>                                     <label for=\"existing-image\">"+xg.shared.nls.html(_21?"orUseExistingImage":"addExistingImage")+"</label><br />                                     <input id=\"existing-image\" name=\"existing-image\" type=\"text\" class=\"textfield wide\"  value=\""+(_21?_21:"http://")+"\" />                                 </p>                             </fieldset>                             <fieldset>                                 <legend class=\"toggle\""+(_1f?" style=\"display:none\"":"")+">                                     <a id=\"upload-form-options-toggle\" href=\"#\" ><span id=\"upload-form-options-arrow\">                                     <!--[if IE]>&#9658;<![endif]--><![if !IE]>&#9654;<![endif]></span>"+xg.shared.nls.html("options")+"</a>                                 </legend>                                 <div id=\"upload-form-options\" style=\"display:none\">                                     <p>                                         <strong>"+xg.shared.nls.html("alignImage")+"</strong><br />                                         <label style=\"margin:10px 0 5px 20px; font-weight:lighter\"><input name=\"align\"                                         type=\"radio\" class=\"radio\" value=\"left\" id=\"left-align-radio\" "+(!_23||_23=="left"?"checked=\"checked\"":"")+" />"+xg.shared.nls.html("left")+"</label><br />                                         <label style=\"margin:5px 0 5px 20px; font-weight:lighter\"><input name=\"align\" type=\"radio\" class=\"radio\"                                          "+((_23)&&_23=="center"?"checked=\"checked\"":"")+" value=\"center\" id=\"center-align-radio\" />"+xg.shared.nls.html("center")+"</label><br />                                         <label style=\"margin:5px 0 5px 20px; font-weight:lighter\"><input name=\"align\" type=\"radio\" class=\"radio\"                                          "+((_23)&&_23=="right"?"checked=\"checked\"":"")+" value=\"right\" id=\"right-align-radio\" />"+xg.shared.nls.html("right")+"</label>                                     </p>                                     <p>                                         <label><input name=\"wrap\" id=\"text-wrap\" type=\"checkbox\" class=\"checkbox\" "+((_22)&&_22!="center"?"checked=\"checked\"":"")+"\"                                         "+(_23=="center"?"disabled":"")+" value=\"yes\" /><strong>"+xg.shared.nls.html("wrapTextAroundImage")+"</strong></label>                                     </p>                                     <p>                                         <label><input id=\"upload-thumb\" name=\"thumb\" type=\"checkbox\" class=\"checkbox\" "+((_24)?"checked=\"checked\"":"")+"                                         value=\"yes\" /><strong>"+xg.shared.nls.html("resizeImage")+"</strong></label><br />                                         <label style=\"margin:10px 0 5px 20px; font-weight:lighter\"><input id=\"upload-size\" name=\"size\" type=\"text\"                                          class=\"textfield\" size=\"4\" value=\""+((_24)?_24:"300")+"\" /> "+xg.shared.nls.html("pixels")+"</label><br />                                         <small style=\"margin:5px 0 5px 20px; font-weight:lighter; line-height:1.4em;                                         display:block;\">"+xg.shared.nls.html("createSmallerVersionSetLongestDimension")+"</small>                                     </p>                                     <p>                                     <label><input name=\"popup\" type=\"checkbox\" class=\"checkbox\" value=\"yes\" id=\"upload-popup\" "+((_25)?"checked=\"checked\"":"")+" />                                     <strong>"+xg.shared.nls.html("linkToOriginal")+"</strong></label><br />                                         <small style=\"margin:0 0 5px 20px; font-weight:lighter; line-height:1.4em;                                         display:block;\">"+xg.shared.nls.html("linkToFullSize")+"</small>                                     </p>                                 </div>                                 <p class=\"buttongroup\">                                 <input id=\"upload-submit\" type=\"submit\" class=\"button action-primary\" value=\""+xg.shared.nls.html(_21?"update":"add")+"\" />&nbsp;\t\t\t\t\t\t\t\t<a id=\"upload-cancel\" class=\"action-secondary\" href=\"#\">"+xg.shared.nls.html("cancel")+"</a>                                 </p>                             </fieldset>                         </form>                     </div>                     <div id=\"shared-upload-progress\" style=\"display:none\">                         <img class=\"left\" width=\"20\" height=\"20\" style=\"margin-right: 5px;\" alt=\"\" src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/spinner.gif")+"\"/>                         <p style=\"margin-left: 25px;\">"+xg.shared.nls.html("keepWindowOpen")+"</p>                         <p class=\"buttongroup\"><a class=\"action-secondary\" id=\"shared-upload-progress-button\" href=\"#\">"+xg.shared.nls.html("cancelUpload")+"</a></p>                     </div>                     <div id=\"shared-upload-error\" style=\"display: none\">                         <div class=\"errordesc\"><p><big id=\"shared-upload-error-message\"></big></p></div>                         <p><input id=\"shared-upload-error-ok\" type=\"button\" class=\"right\" value=\""+xg.shared.nls.html("ok")+"\" /></p>                     </div>                 </div>             </div>         </div>"))[0];
xg.shared.util.showOverlay();
xg.append(_26);
if(xg.uploadsDisabled){
dojo.byId("upload-file").disabled=true;
}
dojo.byId("upload-form").appendChild(xg.shared.util.createCsrfTokenHiddenInput());
dojo.event.connect(dojo.byId("upload-cancel"),"onclick",dojo.lang.hitch(this,function(_27){
dojo.event.browser.stopEvent(_27);
xg.shared.util.hideOverlay();
dojo.dom.removeNode(dojo.byId("shared-upload-module"));
}));
dojo.event.connect(dojo.byId("upload-form"),"onsubmit",dojo.lang.hitch(this,function(_28){
dojo.event.browser.stopEvent(_28);
var _29=dojo.byId("upload-form");
this.submitProcess(_29,_1e);
}));
dojo.event.connect(dojo.byId("left-align-radio"),"onclick",dojo.lang.hitch(this,function(_2a){
return this.wrapOptionEnable(true);
}));
dojo.event.connect(dojo.byId("right-align-radio"),"onclick",dojo.lang.hitch(this,function(_2b){
return this.wrapOptionEnable(true);
}));
dojo.event.connect(dojo.byId("center-align-radio"),"onclick",dojo.lang.hitch(this,function(_2c){
return this.wrapOptionEnable(false);
}));
dojo.event.connect(dojo.byId("shared-upload-error-ok"),"onclick",dojo.lang.hitch(this,function(_2d){
dojo.event.browser.stopEvent(_2d);
xg.shared.util.hideOverlay();
dojo.dom.removeNode(dojo.byId("shared-upload-module"));
}));
dojo.event.connect(dojo.byId("shared-upload-progress-button"),"onclick",dojo.lang.hitch(this,function(_2e){
dojo.event.browser.stopEvent(_2e);
xg.shared.IframeUpload.stop();
dojo.dom.removeNode(dojo.byId("shared-upload-module"));
xg.shared.util.hideOverlay();
}));
dojo.event.connect(dojo.byId("existing-image"),"onchange",dojo.lang.hitch(this,function(_2f){
this.uploadOptionsDisable();
}));
var _30=false;
var _31=function(){
dojo.html.show("upload-form-options");
dojo.byId("upload-form-options-arrow").innerHTML="&#9660";
_30=true;
};
var _32=function(){
dojo.html.hide("upload-form-options");
if(dojo.render.html.ie){
dojo.byId("upload-form-options-arrow").innerHTML="&#9658;";
}else{
dojo.byId("upload-form-options-arrow").innerHTML="&#9654;";
}
_30=false;
};
dojo.event.connect(dojo.byId("upload-form-options-toggle"),"onclick",function(evt){
dojo.event.browser.stopEvent(evt);
_30?_32():_31();
});
if(!_1f&&_21){
_31();
}
dojo.event.connect(dojo.byId("upload-file"),"onfocus",dojo.lang.hitch(this,function(_34){
this.uploadOptionsEnable();
}));
dojo.event.connect(dojo.byId("existing-image"),"onfocus",dojo.lang.hitch(this,function(_35){
this.uploadOptionsDisable();
}));
}};
}
if(!dojo.hostenv.findModule("xg.shared.SimpleToolbar",false)){
dojo.provide("xg.shared.SimpleToolbar");
dojo.widget.defineWidget("xg.shared.SimpleToolbar",dojo.widget.HtmlWidget,{_id:false,_suppressFileUpload:false,_fileUploadLimit:undefined,_maxFileLimit:undefined,fillInTemplate:function(_1,_2){
if(this._id){
this.textArea=dojo.byId(this._id);
}else{
this.textArea=this.getFragNodeRef(_2);
}
var _3=dojo.html.createNodesFromText(dojo.string.trim("         <div class=\"texteditor\">         </div>"))[0];
this.toolbar=dojo.html.createNodesFromText(dojo.string.trim("         <p class=\"texteditor_toolbar\">             <a href=\"#\" tabindex=\"-1\" title=\""+xg.shared.nls.html("bold")+"\"><img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/icon/text_bold.gif")+"\" alt=\""+xg.shared.nls.html("bold")+"\" /></a>             <a href=\"#\" tabindex=\"-1\" title=\""+xg.shared.nls.html("italic")+"\"><img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/icon/text_italic.gif")+"\" alt=\""+xg.shared.nls.html("italic")+"\" /></a>             <a href=\"#\" tabindex=\"-1\" title=\""+xg.shared.nls.html("underline")+"\"><img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/icon/text_underline.gif")+"\" alt=\""+xg.shared.nls.html("underline")+"\" /></a>             <a href=\"#\" tabindex=\"-1\" title=\""+xg.shared.nls.html("strikethrough")+"\"><img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/icon/text_strikethrough.gif")+"\" alt=\""+xg.shared.nls.html("strikethrough")+"\" /></a>             <a href=\"#\" tabindex=\"-1\" title=\""+xg.shared.nls.html("addHyperink")+"\"><img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/icon/text_link.gif")+"\" alt=\""+xg.shared.nls.html("addHyperink")+"\" /></a>             <a href=\"#\" tabindex=\"-1\" class=\"image\" title=\""+xg.shared.nls.html("addAnImage")+"\"><img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/button/image.png")+"\" alt=\""+xg.shared.nls.html("addAnImage")+"\" /></a>             <a href=\"#\" tabindex=\"-1\" title=\""+xg.shared.nls.html("uploadAFile")+"\"><img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/button/file.gif")+"\" alt=\""+xg.shared.nls.html("uploadAFile")+"\" /></a>         </p>"))[0];
var _4=this.toolbar.getElementsByTagName("a");
dojo.event.connect(_4[0],"onclick",dojo.lang.hitch(this,function(_5){
dojo.event.browser.stopEvent(_5);
this.wrapText("<b>","</b>");
}));
dojo.event.connect(_4[1],"onclick",dojo.lang.hitch(this,function(_6){
dojo.event.browser.stopEvent(_6);
this.wrapText("<i>","</i>");
}));
dojo.event.connect(_4[2],"onclick",dojo.lang.hitch(this,function(_7){
dojo.event.browser.stopEvent(_7);
this.wrapText("<u>","</u>");
}));
dojo.event.connect(_4[3],"onclick",dojo.lang.hitch(this,function(_8){
dojo.event.browser.stopEvent(_8);
this.wrapText("<s>","</s>");
}));
dojo.event.connect(_4[4],"onclick",dojo.lang.hitch(this,function(_9){
dojo.event.browser.stopEvent(_9);
this.storeCaretPos();
this.addALink();
}));
dojo.event.connect(_4[5],"onclick",dojo.lang.hitch(this,function(_a){
dojo.event.browser.stopEvent(_a);
this.storeCaretPos();
xg.shared.AddImageDialog.promptForImage(dojo.lang.hitch(this,function(_b){
this.wrapText(_b,"");
this.checkFileLimit();
}),null,this._fileUploadLimit);
}));
if(this._suppressFileUpload){
dojo.style.hide(_4[6]);
}else{
dojo.event.connect(_4[6],"onclick",dojo.lang.hitch(this,function(_c){
dojo.event.browser.stopEvent(_c);
this.storeCaretPos();
xg.shared.UploadFileDialog.showForm(dojo.lang.hitch(this,function(_d){
this.wrapText(_d,"");
this.checkFileLimit();
}));
}));
}
if(xg.uploadsDisabled){
dojo.style.hide(_4[5]);
dojo.style.hide(_4[6]);
}
dojo.html.insertBefore(this.toolbar,this.textArea);
var _e=this;
this.fileLimitTimer=xg.shared.util.createQuiescenceTimer(500,function(){
_e.checkFileLimit();
});
dojo.event.connect(this.textArea,"onkeyup",dojo.lang.hitch(this,function(_f){
this.triggerLimitCheck();
}));
dojo.event.connect(this.textArea,"onkeypress",dojo.lang.hitch(this,function(_10){
this.triggerLimitCheck();
}));
dojo.event.connect(this.textArea,"onblur",dojo.lang.hitch(this,function(_11){
this.triggerLimitCheck();
}));
dojo.event.connect(this.textArea,"onchange",dojo.lang.hitch(this,function(_12){
this.triggerLimitCheck();
}));
this.checkFileLimit();
},triggerLimitCheck:function(){
this.fileLimitTimer.trigger();
},checkFileLimit:function(){
if(this._maxFileLimit==undefined||this._maxFileLimit==""){
return;
}
if(!this.textArea||!this.textArea.value){
return;
}
var _13=this.textArea.value.match(/https?:\/\/api\.(xn.\.ningops\.net|ning\.com)(:[0-9]+)?\//gi);
var _14=this.toolbar.getElementsByTagName("a");
if(_13&&_13.length>=this._maxFileLimit){
dojo.style.hide(_14[5]);
dojo.style.hide(_14[6]);
}else{
dojo.style.show(_14[5]);
dojo.style.show(_14[6]);
}
},saveSelection:function(){
if(document.selection){
this.textArea.focus();
this.storedSelectionBookmark=document.selection.createRange().getBookmark();
}
},isLocalUrl:function(_15){
var _16=_15.indexOf("/");
if(_16<0){
return true;
}
var _17=_15.indexOf("//");
if(_16==_17){
var _18=_15.indexOf("/",_17+2);
if(_18==0){
_18=_15.length+1;
}
var _19=_15.substring(_17+2,_18);
if(location.host!=_19){
return false;
}
}
return true;
},addProtocol:function(_1a){
var _1b=_1a;
var _1c=_1a.indexOf("/");
var _1d=_1a.indexOf(".");
if(_1d>0){
if(_1c<0||_1c>_1d){
_1b="http://"+_1a;
}
}
return _1b;
},storeCaretPos:function(){
if(document.selection){
this.textArea.focus();
this.textArea.caretPos=document.selection.createRange().duplicate();
}
},addALink:function(){
var _1e=xg.shared.nls.html("pleaseEnterAWebsite")+"<p><input type=\"text\" name=\"url\" size=\"40\" value=\"http://\"></p>";
var _1f=this;
var _20=xg.shared.util.confirm({title:xg.shared.nls.text("addHyperink"),bodyHtml:_1e,onOk:dojo.lang.hitch(this,function(_21){
var _22=_21.getElementsByTagName("form")[0];
var _23=_1f.addProtocol(_22.url.value);
var _24="<a>";
var _25="</a>";
if(_23!=null){
if(_1f.isLocalUrl(_23)){
_24="<a href=\""+_23+"\">";
}else{
_24="<a href=\""+_23+"\" target=\"_blank\">";
}
}else{
_24="";
_25="";
}
_1f.wrapText(_24,_25);
})});
},wrapText:function(_26,_27){
if(document.selection){
if(!this.textArea.caretPos){
this.storeCaretPos();
}
this.textArea.caretPos.text=_26+this.textArea.caretPos.text+_27;
this.textArea.caretPos=null;
this.textArea.focus();
}else{
if(this.textArea.selectionStart|this.textArea.selectionStart==0){
if(this.textArea.selectionEnd>this.textArea.value.length){
this.textArea.selectionEnd=this.textArea.value.length;
}
var _28=this.textArea.selectionStart;
var _29=this.textArea.selectionEnd+_26.length;
var _2a=this.textArea.scrollTop;
this.textArea.value=this.textArea.value.slice(0,_28)+_26+this.textArea.value.slice(_28);
this.textArea.value=this.textArea.value.slice(0,_29)+_27+this.textArea.value.slice(_29);
this.textArea.scrollTop=_2a;
this.textArea.selectionStart=_28+_26.length;
this.textArea.selectionEnd=_29;
this.textArea.focus();
}
}
}});
}
if(!dojo.hostenv.findModule("xg.html.embed.HtmlModule",false)){
dojo.provide("xg.html.embed.HtmlModule");
dojo.widget.defineWidget("xg.html.embed.HtmlModule",dojo.widget.HtmlWidget,{COMPACT_LAYOUT_MIN_WIDTH:474,url:"<required>",updateUrl:"<required>",_title:"",_maxLength:0,_maxEmbeds:-1,hasDefaultContent:false,spinner:null,recaptcha:null,editPanel:null,editor:null,fillInTemplate:function(_1,_2){
this.module=this.getFragNodeRef(_2);
var _3=x$(".xg_recaptcha_container",this.module)[0];
if(_3){
this.recaptcha=xg.shared.Recaptcha(_3);
this.recaptcha.setTrackingInfo("profile","embed");
}
this.head=dojo.html.getElementsByClass("xg_module_head",this.module)[0];
this.body=dojo.html.getElementsByClass("xg_module_body",this.module)[0];
this.editPanel=dojo.html.getElementsByClass("xj_edit_panel",this.module)[0];
this.foot=dojo.html.getElementsByClass("xg_module_foot",this.module)[0];
if(this.head.getElementsByTagName("a").length==0){
this.addEditLink();
this.html=dojo.string.trim(dojo.html.getElementsByClass("html_code",this.module)[0].value);
}
},addEditLink:function(){
var h2=this.head.getElementsByTagName("h2")[0];
var p=this.head.getElementsByTagName("p");
if(p.length<1){
dojo.dom.insertAfter(dojo.html.createNodesFromText("<p class=\"edit\"><a class=\"button\" href=\"#\"><span>"+xg.html.nls.html("edit")+"</span></a></p>")[0],h2);
dojo.event.connect(this.head.getElementsByTagName("a")[0],"onclick",dojo.lang.hitch(this,function(_6){
dojo.event.browser.stopEvent(_6);
this.showForm();
}));
if(this.foot){
dojo.event.connect(this.foot.getElementsByTagName("a")[0],"onclick",dojo.lang.hitch(this,function(_7){
dojo.event.browser.stopEvent(_7);
this.showForm();
}));
}
}
},generateMaxlengthError:function(_8){
return "<h3>"+xg.html.nls.html("wereSorry")+"</h3><p>"+xg.html.nls.html("contentsTooLong",_8-this._maxLength)+"</p>";
},generateMaxEmbedError:function(_9){
return "<h3>"+xg.html.nls.html("wereSorry")+"</h3><p>"+xg.html.nls.html("tooManyEmbeds",this._maxEmbeds,_9-this._maxEmbeds,"target=\"_blank\" href=\"http://help.ning.com/?faq=3718\"")+"</p>";
},showError:function(_a){
x$(".xj_html_module_error",this.module).html(_a).show();
return x$(".xj_html_module_error",this.module)[0];
},hideError:function(){
x$(".xj_html_module_error",this.module).hide();
},registerMaxLengthCounterOnTextInput:function(_b){
var _c=x$("#"+_b).attr("_limit");
if(_c){
var _d=x$("#"+_b)[0];
xg.shared.util.setAdvisableMaxLengthWithCountdown(_d,_c,x$(".xj_html_container",this.module).next()[0],true);
}
},showFormScripts4Ning:function(){
var _e=new Date();
this.taID="txt"+_e.getTime();
dojo.html.addClass(this.module,"editing_html_module");
this.head=dojo.html.getElementsByClass("xg_module_head",this.module)[0];
this.body=dojo.html.getElementsByClass("xg_module_body",this.module)[0];
this.foot=dojo.html.getElementsByClass("xg_module_foot",this.module)[0];
if(this.foot){
dojo.style.show(this.body);
dojo.style.hide(this.foot);
}
dojo.html.removeClass(this.body,"notification");
if(dojo.html.hasClass(this.module,"sortable")){
dojo.html.removeClass(this.head,"draggable");
dojo.html.removeClass(this.head.getElementsByTagName("h2")[0],"draggable");
}
this.head.innerHTML="<form><input type=\"text\" class=\"textfield\"/></form>";
this.body.innerHTML="                  <div class=\"errordesc xj_html_module_error\" style=\"display: none\"></div>                  <p></p><div class=\"texteditor xj_html_container\"><textarea id=\""+this.taID+"\" _limit=\""+this._maxLength+"\"></textarea></div><p></p>                  "+(this.addWidgetUrl&&!this.hasDefaultContent?"<span class=\"left\">"+xg.html.nls.html("addAWidget",dojo.string.escape("html",this.addWidgetUrl))+"</span>":"")+"                  <p class=\"buttongroup\">                      <img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/spinner.gif")+"\" alt=\"\" style=\"display: none; width:20px; height:20px; margin-right:3px; vertical-align:top;\" />                      <input type=\"button\" id=\"xj_submit_embed_html\" class=\"button submit\" value=\""+xg.html.nls.html("save")+"\" />                      <a class=\"cancellink action-secondary\" href=\"#\" >"+xg.html.nls.html("cancel")+"</a>                  </p>";
this.input=this.head.getElementsByTagName("input")[0];
this.textarea=this.body.getElementsByTagName("textarea")[0];
var _f=dojo.html.getElementsByClass("button",this.body)[0];
var _10=dojo.html.getElementsByClass("cancellink",this.body)[0];
this.spinner=dojo.dom.prevElement(_10,"img");
this.input.value=this._title;
var _11=this.html.replace(/(\r\n|\n|\r)/g,"\n");
this.textarea.value=this.hasDefaultContent?"":_11.replace(/<br[^>]*>\n?/ig,"\n").replace(/<\/p>\n?/ig,"</p>\n");
xg.index.util.FormHelper.scrollIntoView(this.module);
var _12=dojo.widget.createWidget("SimpleToolbar",{_id:this.taID,_fileUploadLimit:this._imageUploadLimit,_suppressFileUpload:this._suppressFileUpload,_maxFileLimit:this._maxFileLimit});
dojo.event.connect(_f,"onclick",dojo.lang.hitch(this,this.validateAndSave));
dojo.event.connect(_10,"onclick",dojo.lang.hitch(this,this.cancel));
dojo.event.connect(this.head.getElementsByTagName("form")[0],"onsubmit",dojo.lang.hitch(this,this.validateAndSave));
this.registerMaxLengthCounterOnTextInput(this.taID);
this.input.focus();
xg.index.util.FormHelper.setTokenData(".html_module");
this.editor=xg.shared.editors.Editor.get(this.textarea);
},showForm:function(){
if(this.url.match(/\/extensions\/mods\/textbox_update.php/)){
return this.showFormScripts4Ning();
}
dojo.html.addClass(this.module,"editing_html_module");
dojo.style.hide(this.body);
dojo.style.show(this.editPanel);
dojo.style.hide(this.foot);
var _13=x$(this.editPanel).find("textarea");
if(!this.editor){
this.editor=xg.shared.editors.Editor.get(_13);
this.editor.setMaxLength(_13.attr("_maxlength"));
}
if(_13.parent().hasClass("compact-editor")&&_13.width()<this.COMPACT_LAYOUT_MIN_WIDTH){
_13.parent().removeClass("compact-editor").addClass("ultracompact-editor");
}else{
if(_13.parent().hasClass("ultracompact-editor")&&_13.width()>=this.COMPACT_LAYOUT_MIN_WIDTH){
_13.parent().removeClass("ultracompact-editor").addClass("compact-editor");
}
}
this.editor.initializeAfterPageLoad();
if(dojo.html.hasClass(this.module,"sortable")){
dojo.html.removeClass(this.head,"draggable");
dojo.html.removeClass(this.head.getElementsByTagName("h2")[0],"draggable");
}
this.head.innerHTML="<form><input type=\"text\" class=\"textfield\"/></form>";
this.input=this.head.getElementsByTagName("input")[0];
var _14=dojo.html.getElementsByClass("button",this.editPanel)[0];
var _15=dojo.html.getElementsByClass("cancellink",this.editPanel)[0];
this.spinner=dojo.dom.prevElement(_15,"img");
this.input.value=this._title;
_13.val(this.html);
this.editor.val(this.html);
xg.index.util.FormHelper.scrollIntoView(this.module);
dojo.event.connect(_14,"onclick",dojo.lang.hitch(this,this.validateAndSave));
dojo.event.connect(_15,"onclick",dojo.lang.hitch(this,this.cancel));
dojo.event.connect(this.head.getElementsByTagName("form")[0],"onsubmit",dojo.lang.hitch(this,this.validateAndSave));
this.input.focus();
xg.index.util.FormHelper.setTokenData(".html_module");
},hideForm:function(){
dojo.html.removeClass(this.module,"editing_html_module");
this.head.innerHTML="<h2></h2>";
var h2=this.head.getElementsByTagName("h2")[0];
h2.innerHTML=this._title?dojo.string.escape("html",this._title):"&nbsp;";
if(dojo.html.hasClass(this.module,"sortable")){
dojo.html.addClass(this.head,"draggable");
dojo.html.addClass(h2,"draggable");
}
dojo.style.show(this.body);
dojo.style.hide(this.editPanel);
this.editor.uninitialize();
this.body.innerHTML=xg.html.nls.html("saving");
},updateEmbed:function(ui){
var _18=this.module.parentNode.getAttribute("_maxembedwidth");
dojo.io.bind({url:this.updateUrl,method:"post",content:{maxEmbedWidth:_18},preventCache:true,mimetype:"text/json",encoding:"utf-8",load:dojo.lang.hitch(this,function(_19,_1a,_1b){
this.hasDefaultContent=_1a.hasDefaultContent;
this.body.innerHTML=_1a.displayHtml;
this.html=_1a.sourceHtml;
this.addEditLink();
ui.item.css("visibility","");
var _1c=this.module.getElementsByTagName("div")[0];
if(dojo.html.hasClass(_1c,"xg_handle")){
dojo.style.hide(_1c);
}
})});
},validateForm:function(){
var _1d=this.editor.val();
if(this._maxLength>0){
if(_1d.length>this._maxLength){
var _1e=this.generateMaxlengthError(_1d.length);
var _1f=this.showError(_1e);
xg.index.util.FormHelper.scrollIntoView(_1f);
return;
}
}
if(this._maxEmbeds>-1){
var _20=_1d.match(/<\s*embed/gi);
if(_20&&_20.length>this._maxEmbeds){
var _1e=this.generateMaxEmbedError(_20.length);
var _1f=this.showError(_1e);
xg.index.util.FormHelper.scrollIntoView(_1f);
return;
}
}
return true;
},doesContainsLink:function(_21){
if(_21.match(/<a/i)||_21.match(/www\.\w+\.\w+/i)||_21.match(/(http|ftp|https):\/\//i)){
return true;
}
return false;
},validateAndSave:function(_22){
dojo.event.browser.stopEvent(_22);
if(this.recaptcha&&this.doesContainsLink(this.editor.val())){
this.recaptcha.showRecaptchaPopup(dojo.lang.hitch(this,this.save));
}else{
this.save();
}
},save:function(_23){
if(!_23&&!this.validateForm()){
return;
}
this.hideError();
if(!_23){
this._title=this.input.value;
this.html=this.editor.val();
}
var _24=this.module.parentNode.getAttribute("_maxembedwidth");
if(dojo.style.isShowing(this.spinner)){
return;
}
dojo.style.show(this.spinner);
var _25=dojo.byId("recaptcha_challenge_field")!==null?dojo.byId("recaptcha_challenge_field").value:"";
var _26=dojo.byId("recaptcha_response_field")!==null?dojo.byId("recaptcha_response_field").value:"";
var _27=x$("[name=xg_recaptcha_popup_attempt]",this.module).length?x$("[name=xg_recaptcha_popup_attempt]",this.module).val():"";
var _28=x$(".xj_gnfst").length>0?x$(".xj_gnfst").val():"";
var _29=x$(".xj_gnfstTs").length>0?x$(".xj_gnfstTs").val():"";
var _2a=x$(".xj_gnfstId").length>0?x$(".xj_gnfstId").val():"";
var _2b={title:this._title,html:this.html,maxEmbedWidth:_24,recaptcha_challenge_field:_25,recaptcha_response_field:_26,xg_recaptcha_popup_attempt:_27,gnfst:_28,gnfstTs:_29,gnfstId:_2a};
dojo.io.bind({url:this.url,method:"post",content:_2b,preventCache:true,mimetype:"text/javascript",encoding:"utf-8",load:dojo.lang.hitch(this,function(_2c,_2d,_2e){
dojo.style.hide(this.spinner);
if(typeof _2d.errorCode!=="undefined"){
this.showError(_2d.errorMessage);
xg.index.util.FormHelper.setTokenData(".html_module");
return;
}
this.hasDefaultContent=_2d.hasDefaultContent;
if(_2d.displayHtml.match(/<script/i)||(this.recaptcha&&_2d.displayHtml.match(/<a/i))){
window.location.reload(true);
}
this.hideForm();
if(("moduleHead" in _2d)&&(_2d.moduleHead.length>0)){
var _2f=dojo.html.createNodesFromText(_2d.moduleHead)[0];
var _30=_2f.getElementsByTagName("h2")[0];
var h2=this.head.getElementsByTagName("h2")[0];
h2.innerHTML=_30.innerHTML;
}
if(_2d.displayFoot){
this.foot.innerHTML=_2d.displayFoot;
dojo.style.show(this.foot);
dojo.style.hide(this.body);
}else{
this.body.innerHTML=_2d.displayHtml;
this.html=_2d.sourceHtml;
}
this.addEditLink();
})});
},cancel:function(_32){
dojo.event.browser.stopEvent(_32);
this.save(true);
}});
}
if(!dojo.hostenv.findModule("xg.feed.embed.FeedModule",false)){
dojo.provide("xg.feed.embed.FeedModule");
dojo.widget.defineWidget("xg.feed.embed.FeedModule",dojo.widget.HtmlWidget,{setValuesUrl:"",updateEmbedUrl:"",feedUrl:"",itemCount:"",showDescriptions:"",titleOptionHtml:"",detailOptionHtml:"",fillInTemplate:function(_1,_2){
this.module=this.getFragNodeRef(_2);
this.h2=this.module.getElementsByTagName("h2")[0];
dojo.dom.insertAfter(dojo.html.createNodesFromText("<p class=\"edit\"><a class=\"button\" href=\"#\"><span>"+xg.feed.nls.html("edit")+"</span></a></p>")[0],this.h2);
dojo.event.connect(this.module.getElementsByTagName("a")[0],"onclick",dojo.lang.hitch(this,function(_3){
dojo.event.browser.stopEvent(_3);
if((!this.form)||(this.form.style.height=="0px")){
this.showForm();
}else{
this.hideForm();
}
}));
this.hookFooterEvents();
this.titleOptionHtml="<option value=\"0\">0</option>                                     <option value=\"1\">1</option>                                     <option value=\"2\">2</option>                                     <option value=\"3\">3</option>                                     <option value=\"5\">5</option>                                     <option value=\"10\">10</option>                                     <option value=\"15\">15</option>                                     <option value=\"20\">20</option>";
this.detailOptionHtml="<option value=\"0\">0</option>                                     <option value=\"1\">1</option>                                     <option value=\"2\">2</option>                                     <option value=\"3\">3</option>                                     <option value=\"4\">4</option>                                     <option value=\"5\">5</option>";
dojo.html.addClass(this.module,"initialized_feed_module");
},hookFooterEvents:function(){
var _4=xg.$(".xg_module_foot",this.module);
if(_4&&xg.$(".xj_add_rss",_4)){
xg.listen(xg.$(".xj_add_rss",_4),"onclick",this,function(_5){
xg.stop(_5);
if((!this.form)||(this.form.style.height=="0px")){
this.showForm();
}
});
}
},showForm:function(){
var _6=this.module.getElementsByTagName("a")[0];
this.head=dojo.html.getElementsByClass("xg_module_head",this.module)[0];
if(!this.form){
this.form=dojo.html.createNodesFromText(dojo.string.trim("                 <form class=\"xg_module_options\" style=\"display:none\">                     <fieldset>                         <dl>                             <dt><label for=\""+this.widgetId+"_title\">"+xg.feed.nls.html("title")+"</label></dt>                             <dd><input id=\""+this.widgetId+"_title\" type=\"text\" class=\"textfield\" /></dd>                             <dt><label for=\""+this.widgetId+"_feed_url\">"+xg.feed.nls.html("feedUrl")+"</label></dt>                             <dd><input id=\""+this.widgetId+"_feed_url\" type=\"text\" class=\"textfield\" /></dd>                             <dt><label for=\""+this.widgetId+"_show_descriptions\">"+xg.feed.nls.html("display")+"</label></dt>                             <dd>                                <select id=\""+this.widgetId+"_show_descriptions\">                                     <option value=\"1\">"+xg.feed.nls.html("titlesAndDescriptions")+"</option>                                     <option value=\"0\">"+xg.feed.nls.html("titles")+"</option>                                 </select>                            </dd>                             <dt><label for=\""+this.widgetId+"_item_count\">"+xg.feed.nls.html("show")+"</label></dt>                             <dd>                                <select id=\""+this.widgetId+"_item_count\" class=\"short\">                                 </select> "+xg.feed.nls.html("items")+"                            </dd>                         </dl>                        <p class=\"buttongroup\">                             <input type=\"submit\" value=\""+xg.feed.nls.html("save")+"\" class=\"button submit\"/>                             <a class=\"action-secondary\"  id=\""+this.widgetId+"_cancelbtn\" href=\"#\" >"+xg.feed.nls.html("cancel")+"</a>                         </p>                     </fieldset>                 </form>             "))[0];
dojo.dom.insertAfter(this.form,this.head);
this.formHeight=this.form.offsetHeight;
this.form.style.height="0px";
dojo.event.connect(this.form,"onsubmit",dojo.lang.hitch(this,function(_7){
this.save(_7);
}));
dojo.event.connect(dojo.byId(this.widgetId+"_cancelbtn"),"onclick",dojo.lang.hitch(this,function(_8){
dojo.event.browser.stopEvent(_8);
this.hideForm();
}));
}else{
dojo.html.removeClass(this.form,"collapsed");
}
this.form.style.height="0px";
dojo.byId(this.widgetId+"_title").value=dojo.html.renderedTextContent(this.h2);
dojo.byId(this.widgetId+"_feed_url").value=this.feedUrl;
xg.index.util.FormHelper.select(this.showDescriptions,dojo.byId(this.widgetId+"_show_descriptions"));
this.updateFieldDisplay();
var _9=this;
x$("#"+this.widgetId+"_show_descriptions").change(function(){
_9.updateFieldDisplay(true);
});
xg.shared.EditUtil.showModuleForm(this.form,this.formHeight,_6);
},updateFieldDisplay:function(_a){
if(dojo.byId(this.widgetId+"_show_descriptions").value=="1"){
x$("#"+this.widgetId+"_item_count").html(this.detailOptionHtml);
if(_a||!xg.index.util.FormHelper.select(this.itemCount,dojo.byId(this.widgetId+"_item_count"))){
xg.index.util.FormHelper.select("3",dojo.byId(this.widgetId+"_item_count"));
}
}else{
x$("#"+this.widgetId+"_item_count").html(this.titleOptionHtml);
if(_a||!xg.index.util.FormHelper.select(this.itemCount,dojo.byId(this.widgetId+"_item_count"))){
xg.index.util.FormHelper.select("5",dojo.byId(this.widgetId+"_item_count"));
}
}
},hideForm:function(){
var _b=this.module.getElementsByTagName("a")[0];
xg.shared.EditUtil.hideModuleForm(this.form,this.formHeight,_b);
},updateEmbed:function(ui){
var _d=this.module.parentNode.getAttribute("_maxembedwidth");
dojo.io.bind({url:this.updateEmbedUrl,method:"post",content:{maxEmbedWidth:_d},preventCache:true,mimetype:"text/json",encoding:"utf-8",load:dojo.lang.hitch(this,function(_e,_f,_10){
if("error" in _f){
ui.item.css("visibility","");
xg.shared.util.alert(_f.error);
}else{
this.replaceBodyAndFooter(_f.moduleBodyAndFooterHtml);
ui.item.css("visibility","");
var _11=this.module.getElementsByTagName("div")[0];
if(dojo.html.hasClass(_11,"xg_handle")){
dojo.style.hide(_11);
}
}
})});
},save:function(_12){
dojo.event.browser.stopEvent(_12);
var _13=dojo.byId(this.widgetId+"_title").value;
this.h2.innerHTML=dojo.string.escape("html",_13);
this.feedUrl=dojo.byId(this.widgetId+"_feed_url").value;
this.itemCount=xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_item_count")).value;
this.showDescriptions=xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_show_descriptions")).value;
this.removeBodyAndFooter();
this.module.appendChild(dojo.html.createNodesFromText("<div class=\"xg_module_body\">"+xg.feed.nls.html("loading")+"</div>")[0]);
this.hideForm();
dojo.io.bind({url:this.setValuesUrl,method:"post",content:{title:_13,feedUrl:this.feedUrl,itemCount:this.itemCount,showDescriptions:this.showDescriptions},preventCache:true,mimetype:"text/javascript",encoding:"utf-8",load:dojo.lang.hitch(this,function(_14,_15,_16){
this.replaceBodyAndFooter(_15.moduleBodyAndFooterHtml);
})});
},replaceBodyAndFooter:function(_17){
this.removeBodyAndFooter();
dojo.lang.forEach(dojo.html.createNodesFromText(_17),dojo.lang.hitch(this,function(_18){
this.module.appendChild(_18);
}));
this.hookFooterEvents();
xg.shared.util.parseWidgets(this.module);
xg.shared.util.fixImagesInIE(this.module.getElementsByTagName("img"),false);
},removeBodyAndFooter:function(){
dojo.lang.forEach(dojo.html.getElementsByClass("xg_module_body",this.module),function(_19){
dojo.dom.removeNode(_19);
});
dojo.dom.removeNode(dojo.html.getElementsByClass("xg_module_foot",this.module)[0]);
}});
}
if(!dojo.hostenv.findModule("xg.events.Scroller",false)){
dojo.provide("xg.events.Scroller");
dojo.widget.defineWidget("xg.events.Scroller",dojo.widget.HtmlWidget,{_buttonContainer:"",_nextButton:"",_prevButton:"",_nextSeqId:"",_prevSeqId:"",_url:"",_scrollBy:1,_threshold:0,container:null,position:0,start:0,end:0,showItems:0,activeReq:[],fillInTemplate:function(_1,_2){
this.container=this.getFragNodeRef(_2);
var ch=this.container.childNodes;
for(var i=ch.length-1;i>=0;i--){
if(ch[i].nodeType==3){
this.container.removeChild(ch[i]);
}
}
this.position=0;
this.start=0;
this.end=ch.length;
this.showItems=ch.length;
dojo.event.connect(dojo.byId(this._prevButton),"onclick",dojo.lang.hitch(this,this.onPrev));
dojo.event.connect(dojo.byId(this._nextButton),"onclick",dojo.lang.hitch(this,this.onNext));
this.updateButtons();
},updateItems:function(_5){
var c=this.container.childNodes,_7=-this.start;
var i,j,_a=c.length;
for(i=0;i<this.showItems;i++){
j=i+this.position+_7;
if(j>=0&&j<_a){
this.hide(c[j]);
}
}
this.position+=_5;
for(i=0;i<this.showItems;i++){
j=i+this.position+_7;
if(j>=0&&j<_a){
this.show(c[j]);
}
}
this.updateButtons();
},scroll:function(_b,_c){
if(_c>=0){
this.updateItems((_b?1:-1)*this._scrollBy);
if(_c<this._threshold){
this.request(_b,0);
}
}else{
this.request(_b,1);
}
},updateButtons:function(){
var _d=false;
if(this.position>this.start||this._prevSeqId){
this.show(this._prevButton);
_d=true;
}else{
this.hide(this._prevButton);
}
if(this.position+this.showItems<this.end||this._nextSeqId){
this.show(this._nextButton);
_d=true;
}else{
this.hide(this._nextButton);
}
if(_d){
this.show(this._buttonContainer);
}else{
this.hide(this._buttonContainer);
}
},request:function(_e,_f){
if(this.activeReq[_e]){
return;
}
var _10=_e?{xn_out:"json",direction:"forward",current:this._nextSeqId}:{xn_out:"json",direction:"backward",current:this._prevSeqId};
if(!_10.current){
return;
}
this.activeReq[_e]=dojo.io.bind({url:this._url,method:"post",mimetype:"text/javascript",preventCache:true,encoding:"utf-8",content:_10,load:dojo.lang.hitch(this,function(_11,js,_13){
var c=this.container;
if(_e){
this._nextSeqId=js.more;
this.end+=js.data.length;
for(var i=0;i<js.data.length;i++){
c.appendChild(this.nodeFromText(js.data[i]));
}
}else{
this._prevSeqId=js.more;
this.start-=js.data.length;
for(var i=js.data.length-1;i>=0;i--){
c.insertBefore(this.nodeFromText(js.data[i]),c.firstChild);
}
}
this.activeReq[_e]=null;
if(_f){
_e?this.onNext():this.onPrev();
}
})});
},show:function(n){
dojo.byId(n).style.display="";
},hide:function(n){
dojo.byId(n).style.display="none";
},nodeFromText:function(_18){
var div=document.createElement("DIV");
div.innerHTML=_18;
var _1a=div.firstChild;
this.hide(_1a);
return _1a;
},onPrev:function(_1b){
if(_1b){
dojo.event.browser.stopEvent(_1b);
}
this.scroll(0,this.position-this._scrollBy-this.start);
},onNext:function(_1c){
if(_1c){
dojo.event.browser.stopEvent(_1c);
}
this.scroll(1,this.end-(this.position+this._scrollBy+this.showItems));
}});
}
if(!dojo.hostenv.findModule("xg.events.EventEmbedModule",false)){
dojo.provide("xg.events.EventEmbedModule");
dojo.widget.defineWidget("xg.events.EventEmbedModule",dojo.widget.HtmlWidget,{isContainer:true,_url:"",_updateEmbedUrl:"",_visible:0,_prefix:"",_numListOptionsJson:"",_numDetailOptionsJson:"",numListOptionsHtml:"",numDetailOptionsHtml:"",_itemCount:"",fillInTemplate:function(_1,_2){
this.module=this.getFragNodeRef(_2);
this.edit=this.module.getElementsByTagName("p")[0];
this.form=this.module.getElementsByTagName("form")[0];
this.cancelLink=x$(".cancellink",this.module)[0];
this.showCountSelect=x$("#"+this._prefix+"_count")[0];
this.showCountLabel=x$("label[for=\""+this._prefix+"_count\"]")[0];
this.eventDisplaySelect=x$("#"+this._prefix+"_display")[0];
var _3=dj_eval(this._numListOptionsJson);
var _4=dj_eval(this._numDetailOptionsJson);
var _5="";
dojo.lang.forEach(_3,function(_6){
_5+="<option value=\""+dojo.string.escape("html",_6.value)+"\">"+dojo.string.escape("html",_6.label)+"</option>";
});
var _7="";
dojo.lang.forEach(_4,function(_8){
_7+="<option value=\""+dojo.string.escape("html",_8.value)+"\">"+dojo.string.escape("html",_8.label)+"</option>";
});
this.numListOptionsHtml=_5;
this.numDetailOptionsHtml=_7;
dojo.html.show(this.edit);
dojo.event.connect(this.edit.firstChild,"onclick",dojo.lang.hitch(this,function(_9){
dojo.event.browser.stopEvent(_9);
this._visible?this.hideForm():this.showForm();
}));
dojo.html.show(this.form);
this.formHeight=this.form.offsetHeight;
this.form.style.height=0;
dojo.html.hide(this.form);
dojo.event.connect(this.form,"onsubmit",dojo.lang.hitch(this,this.save));
dojo.event.connect(this.form.save,"onclick",dojo.lang.hitch(this,this.save));
dojo.event.connect(this.cancelLink,"onclick",dojo.lang.hitch(this,this.cancel));
},showForm:function(){
this.updateFieldDisplay();
var _a=this;
x$(this.eventDisplaySelect).change(function(){
_a.updateFieldDisplay(true);
});
dojo.html.show(this.form);
this._visible=1;
xg.shared.EditUtil.showModuleForm(this.form,this.formHeight,this.edit.firstChild);
},hideForm:function(){
this._visible=0;
xg.shared.EditUtil.hideModuleForm(this.form,this.formHeight,this.edit.firstChild);
},updateFieldDisplay:function(_b){
if(x$(this.eventDisplaySelect).val()=="detail"){
this.showEventCountOptions();
x$(this.showCountSelect).html(this.numDetailOptionsHtml);
if(_b||!xg.index.util.FormHelper.select(this._itemCount,this.showCountSelect)){
xg.index.util.FormHelper.select("4",this.showCountSelect);
}
}else{
if(x$(this.eventDisplaySelect).val()=="list"){
this.showEventCountOptions();
x$(this.showCountSelect).html(this.numListOptionsHtml);
if(_b||!xg.index.util.FormHelper.select(this._itemCount,this.showCountSelect)){
xg.index.util.FormHelper.select("5",this.showCountSelect);
}
}else{
this.hideEventCountOptions();
}
}
},showEventCountOptions:function(){
x$(this.showCountSelect).parent().show();
x$(this.showCountLabel).parent().show();
},hideEventCountOptions:function(){
x$(this.showCountSelect).parent().hide();
x$(this.showCountLabel).parent().hide();
},updateEmbed:function(ui){
var _d=this.module.parentNode.getAttribute("_columncount");
var _e={columnCount:_d};
dojo.io.bind({url:this._updateEmbedUrl,method:"post",mimetype:"text/json",preventCache:true,encoding:"utf-8",content:_e,load:dojo.lang.hitch(this,function(_f,js,_11){
var ch=this.module.childNodes;
for(var i=ch.length-1;i>=0;i--){
if(ch[i].nodeType==1&&ch[i].tagName=="DIV"&&ch[i].className.match(/xg_module_body|xg_module_foot/)){
this.module.removeChild(ch[i]);
}
}
var div=document.createElement("DIV");
div.innerHTML=js.moduleBodyAndFooter;
var _15=dojo.html.getElementsByClass("xg_module_body",div)[0];
if(_15){
this.module.appendChild(_15);
xg.shared.util.parseWidgets(_15);
}
var _16=dojo.html.getElementsByClass("xg_module_foot",div)[0];
if(_16){
this.module.appendChild(_16);
}
ui.item.css("visibility","");
var _17=this.module.getElementsByTagName("div")[0];
if(dojo.html.hasClass(_17,"xg_handle")){
dojo.style.hide(_17);
}
})});
},save:function(_18){
dojo.event.browser.stopEvent(_18);
var _19={},el=this.form.elements;
for(var i=0;i<el.length;i++){
if(el[i].name){
_19[el[i].name]=el[i].value;
}
}
this._itemCount=x$(this.showCountSelect).val();
_19.columnCount=this.module.parentNode.getAttribute("_columncount");
dojo.io.bind({url:this._url,method:"post",mimetype:"text/json",preventCache:true,encoding:"utf-8",content:_19,load:dojo.lang.hitch(this,function(_1c,js,_1e){
var ch=this.module.childNodes;
for(var i=ch.length-1;i>=0;i--){
if(ch[i].nodeType==1&&ch[i].tagName=="DIV"&&ch[i].className.match(/xg_module_body|xg_module_foot/)){
this.module.removeChild(ch[i]);
}
}
var div=document.createElement("DIV");
div.innerHTML=js.moduleBodyAndFooter;
var _22=dojo.html.getElementsByClass("xg_module_body",div)[0];
if(_22){
this.module.appendChild(_22);
xg.shared.util.parseWidgets(_22);
}
var _23=dojo.html.getElementsByClass("xg_module_foot",div)[0];
if(_23){
this.module.appendChild(_23);
}
})});
this.hideForm();
},cancel:function(_24){
dojo.event.browser.stopEvent(_24);
this.hideForm();
}});
}
if(!dojo.hostenv.findModule("xg.music.embed.loader",false)){
dojo.provide("xg.music.embed.loader");
xg.music.embed.loader={initialize:function(){
var _1=x$("input.musicPlayerHtml");
if(_1.length>0){
for(var i=0;i<_1.length;i++){
var _3=_1[i].value;
var _4=x$(_1[i].parentNode);
var _5=x$("div.musicplayer_visible",_4);
_5.html("");
_4.addClass("nopad");
_5.html(_3);
}
}
}};
xg.addOnRequire(function(){
xg.music.embed.loader.initialize();
});
}
if(!dojo.hostenv.findModule("xg.music.embed.MusicModule",false)){
dojo.provide("xg.music.embed.MusicModule");
dojo.widget.defineWidget("xg.music.embed.MusicModule",dojo.widget.HtmlWidget,{_setValuesUrl:"",_playlistSet:"",_playlistUrl:"",_customizeUrl:"",_autoplay:"",_shuffle:"",_showplaylist:"",_columnCount:1,_playlistOptionsJson:"",fillInTemplate:function(_1,_2){
this.module=this.getFragNodeRef(_2);
this.h2=this.module.getElementsByTagName("h2")[0];
if(this.h2){
dojo.dom.insertAfter(dojo.html.createNodesFromText("<p class=\"edit\"><a class=\"button\" href=\"#\"><span>"+xg.music.nls.html("edit")+"</span></a></p>")[0],this.h2);
dojo.event.connect(this.module.getElementsByTagName("a")[0],"onclick",dojo.lang.hitch(this,function(_3){
dojo.event.browser.stopEvent(_3);
if((!this.form)||(this.form.style.height=="0px")){
this.showForm();
}else{
this.hideForm();
}
}));
}
x$(this.module).mouseover(function(e){
x$(this.module).find(".music-facebook-share").show();
});
x$(this.module).mouseout(function(e){
x$(this.module).find(".music-facebook-share").hide();
});
},showForm:function(){
var _6="";
var _7=this._customizeUrl;
dojo.lang.forEach(dj_eval(this._playlistOptionsJson),function(_8){
_6+="<option value=\""+dojo.string.escape("html",_8.value)+"\">"+dojo.string.escape("html",_8.label)+"</option>";
});
if(!this.form){
this.form=dojo.html.createNodesFromText(dojo.string.trim("             <form class=\"xg_module_options\">                 <fieldset>                     <dl>                         <dt><input type=\"checkbox\" class=\"checkbox\" id=\""+this.widgetId+"_autoplay\" "+((this._autoplay=="true")?"checked=\"true\"":"")+" /></dt>                         <dd><label for=\""+this.widgetId+"_autoplay\">"+xg.music.nls.html("autoplay")+"</label></dd>                         <dt><input type=\"checkbox\" class=\"checkbox\" id=\""+this.widgetId+"_showplaylist\" "+((this._showplaylist=="true")?"checked=\"true\"":"")+" /></dt>                         <dd><label for=\""+this.widgetId+"_showplaylist\">"+xg.music.nls.html("showPlaylist")+"</label></dd>                         <dt><input type=\"checkbox\" class=\"checkbox\" id=\""+this.widgetId+"_shuffle\" "+((this._shuffle=="true")?"checked=\"true\"":"")+" /></dt>                         <dd><label for=\""+this.widgetId+"_shuffle\">"+xg.music.nls.html("shufflePlaylist")+"</label></dd>                         <dt><label for=\""+this.widgetId+"_sourceoption\">"+xg.music.nls.html("playLabel")+"</label></dt>                         <dd>                             <select id=\""+this.widgetId+"_sourceoption\">                                 "+_6+"                             </select>                         </dd>                         <div id=\""+this.widgetId+"_urlfield\">                             <dt><label for=\""+this.widgetId+"_playlisturl\">"+xg.music.nls.html("url")+"</label></dt>                             <dd>                                 <input type=\"text\" class=\"textfield\" id=\""+this.widgetId+"_playlisturl\" value=\""+this._playlistUrl+"\"/><br/>                                 <small>"+xg.music.nls.html("rssXspfOrM3u")+"</small>                             </dd>                         </div>                     </dl>                    \t<dl "+(_7?"":"style=\"display:none\"")+" >                         <dd>                             <a href=\""+_7+"\">"+xg.music.nls.html("customizePlayerColors")+"</a>                         </dd>                     </dl>                     <p class=\"buttongroup\">                         <input type=\"submit\" value=\""+xg.music.nls.html("save")+"\" class=\"button action-primary\"/>                         <a class=\"action-secondary\"  id=\""+this.widgetId+"_cancelbtn\" href=\"#\">"+xg.music.nls.html("cancel")+"</a>                     </p>                 </fieldset>             </form>"))[0];
this.head=dojo.html.getElementsByClass("xg_module_head",this.module)[0];
dojo.dom.insertAfter(this.form,this.head);
this.formHeight=this.form.offsetHeight-55;
this.form.style.height="0px";
dojo.event.connect(dojo.byId(this.widgetId+"_sourceoption"),"onchange",dojo.lang.hitch(this,this.updateUrlField));
dojo.event.connect(this.form,"onsubmit",dojo.lang.hitch(this,function(_9){
this.save(_9);
}));
dojo.event.connect(dojo.byId(this.widgetId+"_cancelbtn"),"onclick",dojo.lang.hitch(this,function(_a){
dojo.event.browser.stopEvent(_a);
this.hideForm();
}));
}else{
dojo.html.removeClass(this.form,"collapsed");
}
this.form.style.height="0px";
xg.index.util.FormHelper.select(this._playlistSet,dojo.byId(this.widgetId+"_sourceoption"));
this.updateUrlField();
var _b=this.module.getElementsByTagName("a")[0];
xg.shared.EditUtil.showModuleForm(this.form,this.formHeight,_b);
},updateUrlField:function(){
if(xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_sourceoption")).value!="podcast"){
dojo.byId(this.widgetId+"_urlfield").style.display="none";
}else{
dojo.byId(this.widgetId+"_urlfield").style.display="block";
}
},hideForm:function(){
var _c=this.module.getElementsByTagName("a")[0];
xg.shared.EditUtil.hideModuleForm(this.form,this.formHeight,_c);
},save:function(_d){
dojo.event.browser.stopEvent(_d);
this._autoplay=dojo.byId(this.widgetId+"_autoplay").checked;
this._showplaylist=dojo.byId(this.widgetId+"_showplaylist").checked;
this._shuffle=dojo.byId(this.widgetId+"_shuffle").checked;
this._playlistSet=xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_sourceoption")).value;
this._playlistUrl=dojo.byId(this.widgetId+"_playlisturl").value;
this.hideForm();
dojo.io.bind({url:this._setValuesUrl,method:"post",preventCache:true,mimetype:"text/javascript",encoding:"utf-8",content:{autoplay:this._autoplay,shuffle:this._shuffle,columnCount:this._columnCount,showPlaylist:this._showplaylist,playlistSet:this._playlistSet,playlistUrl:this._playlistUrl},load:dojo.lang.hitch(this,function(_e,_f,_10){
dojo.lang.forEach(dojo.html.getElementsByClass("xg_module_body",this.module),function(nd){
dojo.dom.removeNode(nd);
});
var _12=dojo.html.getElementsByClass("xg_module_foot",this.module)[0];
if(_12){
dojo.dom.removeNode(_12);
}
var _13=dojo.html.getElementsByClass("container",this.module)[0];
if(_13){
dojo.dom.removeNode(_13);
}
_13=dojo.html.createNodesFromText("<div class=\"container\"></div>")[0];
this.module.appendChild(_13);
var _14=dojo.html.createNodesFromText(_f.moduleBodyAndFooterHtml);
var _15=_14.length;
for(var x=0;x<_15;x++){
if(x$("script",_14[x])){
var _17=x$("script",_14[x]);
var _18=_17.parent();
var _19=dojo.html.createNodesFromText("<div class=\"javascript\" style=\"display:none;\">"+_17.html()+"</div>")[0];
_17.remove();
_18.append(_19);
}
_13.appendChild(_14[x]);
}
if(x$(".javascript")){
x$(".javascript").each(function(){
eval(x$(this).html());
});
}
xg.music.embed.loader.initialize();
})});
},cancel:function(){
}});
}
if(!dojo.hostenv.findModule("xg.profiles.embed.MembersModule",false)){
dojo.provide("xg.profiles.embed.MembersModule");
dojo.widget.defineWidget("xg.profiles.embed.MembersModule",dojo.widget.HtmlWidget,{_setValuesUrl:"",_displaySet:"",_displayOptionsJson:"",_sortSet:"",_sortOptionsJson:"",_rowsSet:"",_rowsOptionsJson:"",isContainer:true,fillInTemplate:function(_1,_2){
this.module=this.getFragNodeRef(_2);
this.h2=this.module.getElementsByTagName("h2")[0];
dojo.dom.insertAfter(dojo.html.createNodesFromText("<p class=\"edit button\"><a class=\"button\" href=\"#\"><span>"+xg.profiles.nls.html("edit")+"</span></a></p>")[0],this.h2);
dojo.event.connect(this.module.getElementsByTagName("a")[0],"onclick",dojo.lang.hitch(this,function(_3){
dojo.event.browser.stopEvent(_3);
if((!this.form)||(this.form.style.height=="0px")){
this.showForm();
}else{
this.hideForm();
}
}));
},showForm:function(){
var _4=this.module.getElementsByTagName("a")[0];
var _5="";
dojo.lang.forEach(dj_eval(this._displayOptionsJson),function(_6){
_5+="<option value=\""+dojo.string.escape("html",_6.value)+"\">"+dojo.string.escape("html",_6.label)+"</option>";
});
var _7="";
dojo.lang.forEach(dj_eval(this._sortOptionsJson),function(_8){
_7+="<option value=\""+dojo.string.escape("html",_8.value)+"\">"+dojo.string.escape("html",_8.label)+"</option>";
});
var _9="";
dojo.lang.forEach(dj_eval(this._rowsOptionsJson),function(_a){
_9+="<option value=\""+dojo.string.escape("html",_a.value)+"\">"+dojo.string.escape("html",_a.label)+"</option>";
});
if(!this.form){
this.form=dojo.html.createNodesFromText(dojo.string.trim("                 <form class=\"xg_module_options\">                     <fieldset>                         <dl>                             <dt><label for=\""+this.widgetId+"_display\">"+xg.profiles.nls.html("display")+"</label></dt>                             <dd>                                 <select id=\""+this.widgetId+"_display\">                                     "+_5+"                                 </select>                             </dd>                             <dt><label for=\""+this.widgetId+"_sort\">"+xg.profiles.nls.html("from")+"</label></dt>                             <dd>                                 <select id=\""+this.widgetId+"_sort\">                                     "+_7+"                                 </select>                             </dd>                             <dt><label for=\""+this.widgetId+"_rows\">"+xg.profiles.nls.html("show")+"</label></dt>                             <dd>                                 <select id=\""+this.widgetId+"_rows\" class=\"short\">                                     "+_9+"                                 </select> "+xg.profiles.nls.html("rows")+"                            </dd>                         </dl>                         <p class=\"buttongroup\">                             <input type=\"submit\" value=\""+xg.profiles.nls.html("save")+"\" class=\"button action-primary submit\"/>                             <a class=\"action-secondary\"  id=\""+this.widgetId+"_cancelbtn\" href=\"#\">"+xg.profiles.nls.html("cancel")+"</a>                         </p>                     </fieldset>                 </form>                 "))[0];
this.head=dojo.html.getElementsByClass("xg_module_head",this.module)[0];
dojo.dom.insertAfter(this.form,this.head);
this.formHeight=this.form.offsetHeight;
this.form.style.height="0px";
dojo.event.connect(this.form,"onsubmit",dojo.lang.hitch(this,function(_b){
this.save(_b);
}));
dojo.event.connect(dojo.byId(this.widgetId+"_cancelbtn"),"onclick",dojo.lang.hitch(this,function(_c){
dojo.event.browser.stopEvent(_c);
this.hideForm();
}));
}else{
dojo.html.removeClass(this.form,"collapsed");
}
this.form.style.height="0px";
xg.index.util.FormHelper.select(this._displaySet,dojo.byId(this.widgetId+"_display"));
xg.index.util.FormHelper.select(this._sortSet,dojo.byId(this.widgetId+"_sort"));
xg.index.util.FormHelper.select(this._rowsSet,dojo.byId(this.widgetId+"_rows"));
xg.shared.EditUtil.showModuleForm(this.form,this.formHeight,_4);
},hideForm:function(){
var _d=this.module.getElementsByTagName("a")[0];
xg.shared.EditUtil.hideModuleForm(this.form,this.formHeight,_d);
},save:function(_e){
dojo.event.browser.stopEvent(_e);
this._displaySet=xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_display")).value;
this._sortSet=xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_sort")).value;
this._rowsSet=xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_rows")).value;
this.hideForm();
dojo.io.bind({url:this._setValuesUrl,method:"post",content:{displaySet:this._displaySet,sortSet:this._sortSet,rowsSet:this._rowsSet},preventCache:true,mimetype:"text/javascript",encoding:"utf-8",load:dojo.lang.hitch(this,dojo.lang.hitch(this,function(_f,_10,_11){
dojo.lang.forEach(dojo.html.getElementsByClass("xg_module_body",this.module),function(_12){
dojo.dom.removeNode(_12);
});
var _13=dojo.html.getElementsByClass("xg_module_foot",this.module)[0];
if(_13){
dojo.dom.removeNode(_13);
}
dojo.lang.forEach(dojo.html.createNodesFromText(_10.moduleBodyAndFooterHtml),dojo.lang.hitch(this,function(_14){
dojo.dom.insertAtPosition(_14,this.module,"last");
}));
xg.shared.util.fixImagesInIE(this.module.getElementsByTagName("img"));
xg.shared.util.parseWidgets(dojo.html.getElementsByClass("xg_module_body",this.module)[0]);
}))});
}});
}
if(!dojo.hostenv.findModule("xg.profiles.embed.blog",false)){
dojo.provide("xg.profiles.embed.blog");
dojo.provide("xg.profiles.embed.blog.BlogModule");
dojo.widget.defineWidget("xg.profiles.embed.blog.BlogModule",dojo.widget.HtmlWidget,{_url:"",_updateUrl:"",_layoutType:"<required>",_displaySet:"",_displayOptionsJson:"",_excerptLengthOptionsJson:"",_excerptLengthSet:"",_sortSet:"",_sortOptionsJson:"",_postsSet:"",_postsTitleOptionsJson:"",_postsDetailOptionsJson:"",postsTitleOptionsHtml:"",postsDetailOptionsHtml:"",fillInTemplate:function(_1,_2){
this.module=this.getFragNodeRef(_2);
this.h2=this.module.getElementsByTagName("h2")[0];
dojo.dom.insertAfter(dojo.html.createNodesFromText("<p class=\"edit\"><a class=\"button\" href=\"#\"><span>"+xg.profiles.nls.html("edit")+"</span></a></p>")[0],this.h2);
var _3=dj_eval(this._postsTitleOptionsJson);
var _4=dj_eval(this._postsDetailOptionsJson);
var _5="";
dojo.lang.forEach(_3,function(_6){
_5+="<option value=\""+dojo.string.escape("html",_6.value)+"\">"+dojo.string.escape("html",_6.label)+"</option>";
});
var _7="";
dojo.lang.forEach(_4,function(_8){
_7+="<option value=\""+dojo.string.escape("html",_8.value)+"\">"+dojo.string.escape("html",_8.label)+"</option>";
});
this.postsTitleOptionsHtml=_5;
this.postsDetailOptionsHtml=_7;
dojo.event.connect(this.module.getElementsByTagName("a")[0],"onclick",dojo.lang.hitch(this,function(_9){
dojo.event.browser.stopEvent(_9);
if((!this.form)||(this.form.style.height=="0px")){
this.showForm();
}else{
this.hideForm();
}
}));
},showForm:function(){
var _a=this.module.getElementsByTagName("a")[0];
this.head=dojo.html.getElementsByClass("xg_module_head",this.module)[0];
this.body=dojo.html.getElementsByClass("xg_module_body",this.module)[0];
this.foot=dojo.html.getElementsByClass("xg_module_foot",this.module)[0];
if(!this.form){
var _b="";
dojo.lang.forEach(dj_eval(this._displayOptionsJson),function(_c){
_b+="<option value=\""+dojo.string.escape("html",_c.value)+"\">"+dojo.string.escape("html",_c.label)+"</option>";
});
if(this._sortOptionsJson){
var _d="";
dojo.lang.forEach(dj_eval(this._sortOptionsJson),function(_e){
_d+="<option value=\""+dojo.string.escape("html",_e.value)+"\">"+dojo.string.escape("html",_e.label)+"</option>";
});
}
var _f="";
if(this._excerptLengthOptionsJson){
var _10=dj_eval(this._excerptLengthOptionsJson);
for(var _11=0;_11<_10.length;_11++){
_f+="<option value=\""+_10[_11]+"\">"+_10[_11]+"</option>";
}
}
this.form=dojo.html.createNodesFromText(dojo.string.trim("             <form class=\"xg_module_options\">                 <fieldset>                     <dl>                        <dt><label for=\""+this.widgetId+"_display\">"+xg.profiles.nls.html("display")+"</label></dt>                        <dd>                             <select id=\""+this.widgetId+"_display\">                                 "+_b+"                             </select>                         </dd>                         "+(this._sortOptionsJson?"                        <dt><label for=\""+this.widgetId+"_sort\">"+xg.profiles.nls.html("from")+"</label></dt>                        <dd>                             <select id=\""+this.widgetId+"_sort\">                                 "+_d+"                             </select>                         </dd>":"")+"                        <dt><label for=\""+this.widgetId+"_posts\">"+xg.profiles.nls.html("show")+"</label></dt>                         <dd>                             <select id=\""+this.widgetId+"_posts\" class=\"short\">                             </select> "+xg.profiles.nls.html("posts")+"                        </dd> \t\t\t<dt class=\"excerptItem\"><label for=\""+this.widgetId+"_excerptLength\">"+xg.profiles.nls.html("show")+"</label></dt> \t\t\t<dd class=\"excerptItem\">     \t\t\t    <select id=\""+this.widgetId+"_excerptLength\">  \t\t\t    "+_f+"   \t\t\t    </select>\t\t\t    "+xg.profiles.nls.html("htmlCharacters")+"\t\t\t</dd>                    </dl>                    <p class=\"buttongroup\">                         <input type=\"submit\" value=\""+xg.profiles.nls.html("save")+"\" class=\"button action-primary\" />                         <a class=\"action-secondary\"  id=\""+this.widgetId+"_cancelbtn\" href=\"#\">"+xg.profiles.nls.html("cancel")+"</a>                     </p>                 </fieldset>             </form>             "))[0];
dojo.dom.insertAfter(this.form,this.head);
this.formHeight=this.form.offsetHeight;
this.form.style.height="0px";
dojo.event.connect(this.form,"onsubmit",dojo.lang.hitch(this,function(_12){
this.save(_12);
}));
dojo.event.connect(dojo.byId(this.widgetId+"_cancelbtn"),"onclick",dojo.lang.hitch(this,function(_13){
dojo.event.browser.stopEvent(_13);
this.hideForm();
}));
}else{
dojo.html.removeClass(this.form,"collapsed");
}
this.form.style.height=0;
xg.index.util.FormHelper.select(this._displaySet,dojo.byId(this.widgetId+"_display"));
if(this._sortOptionsJson){
xg.index.util.FormHelper.select(this._sortSet,dojo.byId(this.widgetId+"_sort"));
}
xg.index.util.FormHelper.select(this._excerptLengthSet,dojo.byId(this.widgetId+"_excerptLength"));
this.updateFieldDisplay();
var _14=this;
x$("#"+this.widgetId+"_display").change(function(){
_14.updateFieldDisplay(true);
});
xg.shared.EditUtil.showModuleForm(this.form,this.formHeight,_a);
},updateFieldDisplay:function(_15){
if(dojo.byId(this.widgetId+"_display").value=="detail"){
x$("#"+this.widgetId+"_posts").html(this.postsDetailOptionsHtml);
if(_15||!xg.index.util.FormHelper.select(this._postsSet,dojo.byId(this.widgetId+"_posts"))){
xg.index.util.FormHelper.select("4",dojo.byId(this.widgetId+"_posts"));
}
x$(".excerptItem").show();
}else{
x$("#"+this.widgetId+"_posts").html(this.postsTitleOptionsHtml);
if(_15||!xg.index.util.FormHelper.select(this._postsSet,dojo.byId(this.widgetId+"_posts"))){
xg.index.util.FormHelper.select("5",dojo.byId(this.widgetId+"_posts"));
}
x$(".excerptItem").hide();
}
},hideForm:function(){
var _16=this.module.getElementsByTagName("a")[0];
xg.shared.EditUtil.hideModuleForm(this.form,this.formHeight,_16);
},updateEmbed:function(ui){
var _18=this.module.parentNode.getAttribute("_maxembedwidth");
dojo.io.bind({url:this._updateUrl,method:"post",encoding:"utf-8",mimetype:"text/json",preventCache:true,content:{maxEmbedWidth:_18},load:dojo.lang.hitch(this,function(_19,_1a,_1b){
this.module.getElementsByTagName("h2")[0].innerHTML=dojo.string.escape("html",_1a.embedTitle);
dojo.html.getElementsByClass("xg_module_body",this.module)[0].innerHTML=_1a.moduleBodyHtml;
ui.item.css("visibility","");
var _1c=this.module.getElementsByTagName("div")[0];
if(dojo.html.hasClass(_1c,"xg_handle")){
dojo.style.hide(_1c);
}
})});
},save:function(_1d){
dojo.event.browser.stopEvent(_1d);
var _1e=this.module.parentNode.getAttribute("_maxembedwidth");
this._displaySet=xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_display")).value;
if(this._sortOptionsJson){
this._sortSet=xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_sort")).value;
}
this._postsSet=xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_posts")).value;
if(this._excerptLengthOptionsJson){
this._excerptLengthSet=x$("#"+this.widgetId+"_excerptLength").val();
}
if("undefined"!=typeof this.body){
this.body.innerHTML=xg.profiles.nls.html("loading");
}else{
x$(this.foot).before("<div class=\"xg_module_body xj_loading_msg\">"+xg.profiles.nls.html("loading")+"</div>");
}
this.hideForm();
dojo.io.bind({url:this._url,method:"post",preventCache:true,encoding:"utf-8",mimetype:"text/javascript",content:{displaySet:this._displaySet,sortSet:this._sortSet,postsSet:this._postsSet,excerptLengthSet:this._excerptLengthSet,maxEmbedWidth:_1e},load:dojo.lang.hitch(this,function(_1f,_20,_21){
this.h2.innerHTML=dojo.string.escape("html",_20.embedTitle);
var _22="undefined"!=typeof this.body;
var _23=_22?x$(this.body).prev()[0]:x$(this.head).next()[0];
if(_22){
x$(this.body).remove();
}else{
x$(".xj_loading_msg").remove();
}
x$(this.foot).remove();
x$(_23).after(_20.moduleBodyHtml);
xg.shared.util.parseWidgets(x$(_23).next()[0]);
})});
}});
}
if(!dojo.hostenv.findModule("xg.profiles.embed.BirthdaysModule",false)){
dojo.provide("xg.profiles.embed.BirthdaysModule");
dojo.widget.defineWidget("xg.profiles.embed.BirthdaysModule",dojo.widget.HtmlWidget,{_setValuesUrl:"",_itemCountSet:"",_itemCountOptionsJson:"",fillInTemplate:function(_1,_2){
this.module=this.getFragNodeRef(_2);
this.h2=this.module.getElementsByTagName("h2")[0];
dojo.dom.insertAfter(dojo.html.createNodesFromText("<p class=\"edit button\"><a class=\"button\" href=\"#\"><span>"+xg.profiles.nls.html("edit")+"</span></a></p>")[0],this.h2);
dojo.event.connect(this.module.getElementsByTagName("a")[0],"onclick",dojo.lang.hitch(this,function(_3){
dojo.event.browser.stopEvent(_3);
if((!this.form)||(this.form.style.height=="0px")){
this.showForm();
}else{
this.hideForm();
}
}));
},showForm:function(){
var _4=this.module.getElementsByTagName("a")[0];
var _5="";
dojo.lang.forEach(dj_eval(this._itemCountOptionsJson),function(_6){
_5+="<option value=\""+dojo.string.escape("html",_6.value)+"\">"+dojo.string.escape("html",_6.label)+"</option>";
});
if(!this.form){
this.form=xg.shared.util.createElement("                 <form class=\"xg_module_options\">                     <fieldset>                         <dl>                             <dt><label for=\""+this.widgetId+"_itemCount\">"+xg.profiles.nls.html("show")+"</label></dt>                             <dd>                                 <select id=\""+this.widgetId+"_itemCount\">                                     "+_5+"                                 </select> "+xg.profiles.nls.html("birthdays")+"                             </dd>                         </dl>                         <p class=\"buttongroup\">                             <input type=\"submit\" value=\""+xg.profiles.nls.html("save")+"\" class=\"button action-primary submit\"/>                             <a class=\"action-secondary\"  id=\""+this.widgetId+"_cancelbtn\" href=\"#\">"+xg.profiles.nls.html("cancel")+"</a>                         </p>                     </fieldset>                 </form>                 ");
this.head=dojo.html.getElementsByClass("xg_module_head",this.module)[0];
dojo.dom.insertAfter(this.form,this.head);
this.formHeight=this.form.offsetHeight;
this.form.style.height="0px";
dojo.event.connect(this.form,"onsubmit",dojo.lang.hitch(this,function(_7){
this.save(_7);
}));
dojo.event.connect(dojo.byId(this.widgetId+"_cancelbtn"),"onclick",dojo.lang.hitch(this,function(_8){
dojo.event.browser.stopEvent(_8);
this.hideForm();
}));
}else{
dojo.html.removeClass(this.form,"collapsed");
}
this.form.style.height="0px";
xg.index.util.FormHelper.select(this._itemCountSet,dojo.byId(this.widgetId+"_itemCount"));
xg.shared.EditUtil.showModuleForm(this.form,this.formHeight,_4);
},hideForm:function(){
var _9=this.module.getElementsByTagName("a")[0];
xg.shared.EditUtil.hideModuleForm(this.form,this.formHeight,_9);
},save:function(_a){
dojo.event.browser.stopEvent(_a);
this._itemCountSet=xg.index.util.FormHelper.selectedOption(dojo.byId(this.widgetId+"_itemCount")).value;
this.hideForm();
dojo.io.bind({url:this._setValuesUrl,method:"post",content:{itemCountSet:this._itemCountSet},preventCache:true,mimetype:"text/javascript",encoding:"utf-8",load:dojo.lang.hitch(this,dojo.lang.hitch(this,function(_b,_c,_d){
dojo.lang.forEach(dojo.html.getElementsByClass("xg_module_body",this.module),function(_e){
dojo.dom.removeNode(_e);
});
dojo.lang.forEach(dojo.html.createNodesFromText(_c.moduleBodyAndFooterHtml),dojo.lang.hitch(this,function(_f){
dojo.dom.insertAtPosition(_f,this.module,"last");
}));
xg.shared.util.fixImagesInIE(this.module.getElementsByTagName("img"));
xg.shared.util.parseWidgets(dojo.html.getElementsByClass("xg_module_body",this.module)[0]);
}))});
}});
}
