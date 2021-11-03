if(!dojo.hostenv.findModule("xg.index.actionicons",false)){
dojo.provide("xg.index.actionicons");
dojo.provide("xg.index.actionicons.PromotionLink");
dojo.widget.defineWidget("xg.index.actionicons.PromotionLink",dojo.widget.HtmlWidget,{_action:"<required>",_id:"<required>",_dialogClass:"dialog",_type:"item",_afterAction:"",_url:"",_xgSourceParam:undefined,fillInTemplate:function(_1,_2){
this.link=this.getFragNodeRef(_2);
if(this.link.promotionlink){
return;
}
this.link.promotionlink=true;
dojo.event.connect(this.link,"onclick",dojo.lang.hitch(this,function(_3){
dojo.event.browser.stopEvent(_3);
this.link.className="desc working disabled";
if(this._url==""){
this.url=xg.global.requestBase+"/main/promotion/"+this._action+"?src=link&xn_out=json";
}else{
this.url=this._url+"/"+this._action+"/?xn_out=json";
}
if("undefined"!=typeof this._xgSourceParam){
this.url=this.url+"&xg_source="+this._xgSourceParam;
}
dojo.io.bind({"url":this.url,"method":"post","mimetype":"text/json","content":{"id":this._id,"type":this._type},preventCache:true,encoding:"utf-8","load":dojo.lang.hitch(this,function(_4,_5,_6){
dojo.lfx.html.highlight(this.link,"#ffee7d",1000,null,dojo.lang.hitch(this,function(){
this.link.style.backgroundImage=this.link.style.backgroundColor="";
})).play();
this._action=(this._action=="promote")?"remove":"promote";
if(_5.linkText&&_5.linkClass){
dojo.html.setClass(this.link,"xg_sprite "+_5.linkClass);
this.link.title=_5.linkText;
this.link.innerHTML=_5.linkText;
}
if(this._afterAction.length){
eval(this._afterAction);
}
})});
}));
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
if(!dojo.hostenv.findModule("xg.forum.topic.CommentEditor",false)){
dojo.provide("xg.forum.topic.CommentEditor");
xg.forum.topic.CommentEditor=function(_1){
var _2={};
var _={};
var _4=false;
var _5=x$("#link_"+_1.attr("id"));
var _6=_1.next("form");
var _7=_1.attr("_value");
var _8=true;
var _9;
_.initialize=function(){
_.setDisplayHtml(_7);
_5.click(function(_a){
_a.preventDefault();
_.showForm();
});
};
_.showForm=function(){
if(!_8){
return;
}
_5.hide();
_1.hide();
_6.show();
_.initializeIfNecessary();
_9.val(_7);
_9.focus();
xg.index.util.FormHelper.scrollIntoView(_6[0]);
};
_.hideForm=function(){
_6.hide();
_1.show();
_5.show();
};
_.initializeIfNecessary=function(){
if(_4){
return;
}
_4=true;
_6.find(".cancellink").click(function(_b){
_b.preventDefault();
_.setDisplayHtml(_7);
_.hideForm();
});
_9=xg.shared.editors.Editor.get(_6.find("textarea"));
_9.initializeAfterPageLoad();
_9.setMaxLength(_6.find("textarea").attr("_maxlength"));
_6.submit(function(_c){
_c.preventDefault();
if(!_8){
return;
}
_8=false;
_1.html("<span class=\"instruction\">"+xg.shared.nls.html("saving")+"</span>");
_.hideForm();
xg.post(_1.attr("_setValueUrl"),{value:_9.val()},function(_d,_e){
_e=dj_eval(_e);
_.setDisplayHtml(_e.html);
_8=true;
});
});
};
_.setDisplayHtml=function(_f){
_7=_f;
_f=x$.trim(_f);
_1.html(_f);
_1.find("a").click(function(_10){
_10.stopPropagation();
return true;
});
};
_.initialize();
return _2;
};
}
if(!dojo.hostenv.findModule("xg.shared.comment",false)){
dojo.provide("xg.shared.comment");
xg.shared.comment={numComments:null,commentContainer:null,initialize:function(){
var _1;
dojo.lang.forEach(xg.$$("div"),function(_2){
if(_2.id=="comments"){
_1=_2;
}
});
if(_1===undefined){
return;
}
this.initializeCommentEdit();
this.commentContainer=_1;
this.numComments=parseInt(this.commentContainer.getAttribute("_numComments"),10);
dojo.lang.forEach(dojo.html.getElementsByClass("comment",this.commentContainer,"dl"),dojo.lang.hitch(this,this.initializeDl));
var _3=this.commentContainer.getAttribute("_scrollTo");
if(_3){
var _4=document.getElementById(_3);
if(_4){
if(_4.scrollIntoView){
_4.scrollIntoView(true);
}else{
xg.index.util.FormHelper.scrollIntoView(_4);
}
}
}
},initializeCommentEdit:function(){
x$(".xj_comment_editor").each(function(i,_6){
var _7=x$(_6);
if(!_7.data("xj_initialized")){
xg.forum.topic.CommentEditor(_7);
_7.data("xj_initialized",true);
}
});
},initializeDl:function(dl){
dojo.lang.forEach(dojo.html.getElementsByClass("delete_link",dl,"a"),dojo.lang.hitch(this,function(_9){
var _a=false;
dojo.event.connect(_9,"onclick",dojo.lang.hitch(this,function(_b){
dojo.event.browser.stopEvent(_b);
if(_a){
return;
}
_a=true;
dojo.io.bind({url:_9.getAttribute("_url"),method:"post",mimetype:"text/javascript",preventCache:true,encoding:"utf-8",content:{"id":dl.getAttribute("_id")},load:dojo.lang.hitch(this,function(_c,_d,_e){
if(!_d.success){
return;
}
dojo.lfx.html.fadeOut(dl,500,null,dojo.lang.hitch(this,function(){
var _f=dojo.html.hasClass(dl,"last-child")?dojo.dom.prevElement(dl,"dl"):null;
dl.parentNode.removeChild(dl);
if(_f){
dojo.html.addClass(_f,"last-child");
}
if(this.commentContainer.getElementsByTagName("dl").length==0){
var url=window.location.href;
var _11=url.split("#",2);
var _12=_11[1]?"#"+_11[1]:"";
url=_11[0];
var _13="page";
var _14=xg.shared.util.getParameter(url,"page");
if(!_14){
_14=xg.shared.util.getParameter(url,"commentPage");
_13="commentPage";
}
if(_14&&(_14>0)){
_14=parseInt(_14)-1;
if(_14>=0){
url=xg.shared.util.removeParameter(url,_13);
url=xg.shared.util.addParameter(url,_13,_14);
url+=_12;
window.location.href=url;
}
}else{
window.location.reload();
}
}
})).play();
})});
}));
}));
dojo.lang.forEach(dojo.html.getElementsByClass("approve_link",dl,"a"),dojo.lang.hitch(this,function(_15){
var _16=false;
dojo.event.connect(_15,"onclick",dojo.lang.hitch(this,function(_17){
dojo.event.browser.stopEvent(_17);
if(_16){
return;
}
_16=true;
dojo.io.bind({url:_15.getAttribute("_url"),method:"post",mimetype:"text/javascript",preventCache:true,encoding:"utf-8",content:{"id":dl.getAttribute("_id")},load:dojo.lang.hitch(this,function(_18,_19,_1a){
if(!_19.success){
return;
}
var _1b=dojo.dom.getAncestorsByTag(_15,"div",true);
dojo.lfx.html.fadeOut(_1b,500,null,dojo.lang.hitch(this,function(){
_1b.parentNode.removeChild(_1b);
})).play();
})});
}));
}));
},addDl:function(dl,_1d){
dojo.style.setOpacity(dl,0);
dojo.html.show(this.commentContainer);
if(_1d){
x$(this.commentContainer).prepend(dl);
}else{
this.commentContainer.appendChild(dl);
}
this.initializeCommentEdit();
this.initializeDl(dl);
dojo.lfx.fadeIn(dl,500,dojo.lfx.easeIn).play();
dojo.style.show(dojo.html.getElementsByClass("xg_module_foot",this.commentContainer.parentNode,"div")[0]);
this.styleComments();
},styleComments:function(){
dojo.lang.forEach(this.commentContainer.getElementsByTagName("dl"),dojo.lang.hitch(this,function(_1e){
dojo.html.removeClass(_1e,"last-child");
}));
var _1f=x$("dl:last",this.commentContainer);
if(_1f){
dojo.html.addClass(_1f,"last-child");
}
}};
xg.addOnRequire(function(){
xg.shared.comment.initialize();
});
}
if(!dojo.hostenv.findModule("xg.shared.FollowLink",false)){
dojo.provide("xg.shared.FollowLink");
dojo.widget.defineWidget("xg.shared.FollowLink",dojo.widget.HtmlWidget,{_addUrl:"",_removeUrl:"",_addLinkText:"",_removeLinkText:"",_addDescription:"",_removeDescription:"",_isFollowed:"",_joinPromptText:"",_signUpUrl:"",_isPending:false,fillInTemplate:function(_1,_2){
this._addLinkText=this._addLinkText?this._addLinkText:xg.shared.nls.text("follow");
this._removeLinkText=this._removeLinkText?this._removeLinkText:xg.shared.nls.text("stopFollowing");
this.a=this.getFragNodeRef(_2);
this.span=document.createElement("span");
this.span.className="xj_follow_description";
dojo.dom.insertAfter(this.span,this.a);
this.updateText(this.a);
dojo.event.connect(this.a,"onclick",dojo.lang.hitch(this,function(_3){
dojo.event.browser.stopEvent(_3);
if(this._joinPromptText.length||this._isPending){
xg.shared.util.promptToJoin(this._joinPromptText,this._isPending,dojo.lang.hitch(this,function(){
window.location=this._signUpUrl;
}));
}else{
this.a.className="desc working disabled";
if(this.posting){
return;
}
this.post();
}
}));
},post:function(){
this.posting=true;
if(this._isFollowed==0){
url=this._addUrl;
}else{
url=this._removeUrl;
}
dojo.io.bind({url:url,method:"post",encoding:"utf-8",preventCache:true,load:dojo.lang.hitch(this,function(_4,_5,_6){
this._isFollowed=this._isFollowed==0?1:0;
this.updateText(this.a);
dojo.lfx.html.highlight(this.a,"#ffee7d",1000).play();
this.posting=false;
})});
},updateText:function(){
if(this._isFollowed==0){
this.a.className="xg_sprite xg_sprite-follow-add";
this.a.innerHTML=dojo.string.escape("html",this._addLinkText);
if(this._addDescription.length){
dojo.dom.nextElement(this.a,"span").innerHTML=" &ndash; "+dojo.string.escape("html",this._addDescription);
}
}else{
this.a.className="xg_sprite xg_sprite-follow-remove";
this.a.innerHTML=dojo.string.escape("html",this._removeLinkText);
if(this._removeDescription.length){
dojo.dom.nextElement(this.a,"span").innerHTML=" &ndash; "+dojo.string.escape("html",this._removeDescription);
}
}
},showFollowing:function(){
this._isFollowed=1;
this.updateText();
},showNotFollowing:function(){
this._isFollowed=0;
this.updateText();
}});
}
if(!dojo.hostenv.findModule("xg.shared.FavoriteLink",false)){
dojo.provide("xg.shared.FavoriteLink");
dojo.widget.defineWidget("xg.shared.FavoriteLink",dojo.widget.HtmlWidget,{_addurl:"",_removeUrl:"",_hasFavorite:"",fillInTemplate:function(_1,_2){
var a=this.getFragNodeRef(_2);
if(this._hasFavorite==0){
a.className="xg_sprite xg_sprite-favorite-add";
a.innerHTML=xg.shared.nls.text("addToFavorites");
}else{
a.className="xg_sprite xg_sprite-favorite-remove";
a.innerHTML=xg.shared.nls.text("removeFromFavorites");
}
dojo.event.connect(a,"onclick",dojo.lang.hitch(this,function(_4){
dojo.event.browser.stopEvent(_4);
a.className="desc working disabled";
if(this.posting){
return;
}
this.post(a);
}));
},post:function(a){
this.posting=true;
if(this._hasFavorite==0){
url=this._addurl;
}else{
url=this._removeUrl;
}
dojo.io.bind({url:url,method:"post",encoding:"utf-8",mimetype:"text/javascript",preventCache:true,load:dojo.lang.hitch(this,function(_6,_7,_8){
if(this._hasFavorite==0){
a.className="xg_sprite xg_sprite-favorite-remove";
a.innerHTML=xg.shared.nls.text("removeFromFavorites");
this._hasFavorite=1;
}else{
a.className="xg_sprite xg_sprite-favorite-add";
a.innerHTML=xg.shared.nls.text("addToFavorites");
this._hasFavorite=0;
}
dojo.lfx.html.highlight(a,"#ffee7d",1000).play();
this.posting=false;
})});
}});
}
if(!dojo.hostenv.findModule("xg.shared.TagLink",false)){
dojo.provide("xg.shared.TagLink");
dojo.widget.defineWidget("xg.shared.TagLink",dojo.widget.HtmlWidget,{_actionUrl:"<required>",_tags:"",_allowEmptySubmission:true,_emptySubmissionMessage:"",_maxlength:0,_updateId:"tagsList",_addKey:"addTags",_editKey:"editYourTags",_popOver:false,killTagBox:function(_1){
dojo.event.browser.stopEvent(_1);
dojo.html.hide(formblock);
},fillInTemplate:function(_2,_3){
var li=this.getFragNodeRef(_3);
var _5=this._maxlength?"maxlength=\""+this._maxlength+"\"":"";
var _6=dojo.html.createNodesFromText(dojo.string.trim("         <div class=\"desc\" style=\"display: none;\">             <form>                 <input class=\"textfield\" type=\"text\" style=\"width: 95%;\" "+_5+" />                 <div class=\"align-right pad5\">                     <input class=\"button small\" type=\"submit\" value=\""+xg.shared.nls.html("save")+"\"/>                     <a id=\"cancelTags\" class=\"action-secondary small\" href=\"#\" >"+xg.shared.nls.html("cancel")+"</a>                 </div>             </form>         </div>"))[0];
if(this._popOver){
var _6=dojo.html.createNodesFromText(dojo.string.trim("             <small class=\"showembed\" style=\"display:none;\">                 <form>                     <input class=\"textfield\" type=\"text\" style=\"width: 160px;\" "+_5+" />                     <div class=\"align-right pad5\">                         <input class=\"button small\" type=\"submit\" value=\""+xg.shared.nls.html("save")+"\"/>                         <a id=\"cancelTags\" class=\"action-secondary small\" href=\"#\" >"+xg.shared.nls.html("cancel")+"</a>                     </div>                 </form>             </small>"))[0];
}
dojo.html.insertAfter(_6,li);
var _7=li.getElementsByTagName("a")[0];
dojo.event.connect(_7,"onclick",dojo.lang.hitch(this,function(_8){
dojo.event.browser.stopEvent(_8);
if(dojo.style.isShowing(_6)){
dojo.html.hide(_6);
}else{
dojo.html.show(_6);
}
}));
x$("#cancelTags",_6).click(dojo.lang.hitch(this,function(_9){
dojo.event.browser.stopEvent(_9);
dojo.html.hide(_6);
}));
var _a=_6.getElementsByTagName("input");
var _b=_a[0];
_b.value=this._tags;
dojo.event.connect(_6.getElementsByTagName("form")[0],"onsubmit",dojo.lang.hitch(this,function(_c){
dojo.event.browser.stopEvent(_c);
if(this._allowEmptySubmission==false&&_b.value.length==0){
xg.shared.util.alert(this._emptySubmissionMessage);
}else{
_7.className="desc working";
dojo.io.bind({url:this._actionUrl,method:"post",content:{tags:_b.value},encoding:"utf-8",preventCache:true,mimetype:"text/javascript",load:dojo.lang.hitch(this,function(_d,_e,_f){
if(_b.value.length){
_7.className="xg_sprite xg_sprite-edit";
_7.innerHTML=xg.shared.nls.html(this._editKey);
dojo.html.hide(_6);
}else{
_7.className="xg_sprite xg_sprite-add";
_7.innerHTML=xg.shared.nls.html(this._addKey);
dojo.html.hide(_6);
}
if("undefined"!=typeof _e["html"]){
var _10=dojo.byId(this._updateId);
if(_10){
_10.innerHTML=_e.html;
if(_e.html&&(_e.html!="")){
x$(_10).show();
}else{
x$(_10).hide();
}
}
}
})});
}
}));
}});
}
if(!dojo.hostenv.findModule("xg.shared.StarRater",false)){
dojo.provide("xg.shared.StarRater");
dojo.widget.defineWidget("xg.shared.StarRater",dojo.widget.HtmlWidget,{_rating:0,_setRatingUrl:"",_isPending:false,_resultId:"",_setRatingId:"",fillInTemplate:function(_1,_2){
var ul=this.getFragNodeRef(_2);
dojo.lang.forEach(ul.getElementsByTagName("a"),dojo.lang.hitch(this,function(a){
dojo.event.connect(a,"onclick",dojo.lang.hitch(this,function(_5){
dojo.event.browser.stopEvent(_5);
if(this._isPending){
return xg.shared.util.promptIsPending();
}
this.updateRating(a,ul);
}));
}));
},updateRating:function(a,ul){
var _8=parseInt(a.className.charAt(5)),_9=this;
dojo.html.getElementsByClass("current",ul)[0].style.width=13*_8+"px";
if(this._setRatingUrl){
dojo.io.bind({url:this._setRatingUrl,method:"post",content:{rating:_8},preventCache:true,encoding:"utf-8",mimetype:"text/javascript",load:function(e,_b,_c){
if(_9._resultId&&("undefined"!=typeof _b["html"])){
var _d=dojo.byId(_9._resultId);
_d.innerHTML=_b.html;
dojo.style.setShowing(_d,_b.html);
xg.shared.util.fixImagesInIE(_d.getElementsByTagName("img"));
}
}});
}else{
if(dojo.byId(this._setRatingId)){
dojo.byId(this._setRatingId).value=_8;
}
}
},clearRating:function(){
var ul=this.domNode;
dojo.html.getElementsByClass("current",ul)[0].style.width="0px";
if(dojo.byId(this._setRatingId)){
dojo.byId(this._setRatingId).value=this._rating;
}
}});
}
if(!dojo.hostenv.findModule("xg.shared.MoreLink",false)){
dojo.provide("xg.shared.MoreLink");
dojo.widget.defineWidget("xg.shared.MoreLink",dojo.widget.HtmlWidget,{fillInTemplate:function(_1,_2){
var _3=this.getFragNodeRef(_2);
dojo.event.connect(_3,"onclick",dojo.lang.hitch(this,function(_4){
dojo.event.browser.stopEvent(_4);
dojo.style.show(dojo.dom.nextElement(_3));
dojo.style.hide(_3);
}));
}});
}
if(!dojo.hostenv.findModule("xg.shared.CommentForm",false)){
dojo.provide("xg.shared.CommentForm");
xg.shared.CommentForm={ajax:null,addAtTop:null,submitting:false,editor:null,initialize:function(){
var _1=dojo.byId("comment_form");
if(!_1){
return;
}
this.editor=xg.shared.editors.Editor.get(x$(_1.comment));
var _2=x$("input.xj_submit",_1);
if(_2.length<1){
return;
}
var _3=x$(".xg_recaptcha_container",_1)[0];
if(_3){
var _4=xg.shared.Recaptcha(_3);
_4.setTrackingInfo("blog","comment");
}else{
var _4=null;
}
this.ajax=_1.getAttribute("_ajax")=="true";
this.addAtTop=_1.getAttribute("_addAtTop")=="true";
this.submitting=false;
var _5=dojo.html.createNodesFromText("<img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/spinner.gif")+"\" alt=\"\" style=\"width:16px; height:16px; margin-right:3px; display: none;\" />")[0];
dojo.dom.insertBefore(_5,dojo.html.getElementsByClass("button",_1)[0]);
dojo.event.connect(_1,"onsubmit",dojo.lang.hitch(this,function(_6){
dojo.event.browser.stopEvent(_6);
if(this.submitting){
return;
}
if(!xg.index.util.FormHelper.runValidation(_1,dojo.lang.hitch(this,this.validate))){
return;
}
if(this.isBlockedFromCreatingComments()){
xg.index.util.FormHelper.showErrorMessages(_1,{error:xg.index.nls.html("softBlockMessagingForComments")});
xg.post("/main/index/logPostAttempt?xn_out=json",null,function(){
});
return;
}
if(_4){
_4.showRecaptchaPopup(this.onVerify);
}else{
this.onVerify();
}
}));
xg.index.util.FormHelper.setTokenData();
},onVerify:function(){
var _7=dojo.byId("comment_form");
if(!_7){
return;
}
this.ajax=_7.getAttribute("_ajax")=="true";
this.addAtTop=_7.getAttribute("_addAtTop")=="true";
this.submitting=false;
if(!this.ajax){
return _7.submit();
}
this.submitting=true;
var _8=dojo.html.createNodesFromText("<img src=\""+xg.shared.util.cdn("/xn_resources/widgets/index/gfx/spinner.gif")+"\" alt=\"\" style=\"width:16px; height:16px; margin-right:3px; display: none;\" />")[0];
dojo.style.show(_8);
dojo.dom.removeNode(dojo.html.getElementsByClass("notification",_7,"div")[0]);
var _9=dojo.byId("recaptcha_challenge_field")!==null?dojo.byId("recaptcha_challenge_field").value:"";
var _a=dojo.byId("recaptcha_response_field")!==null?dojo.byId("recaptcha_response_field").value:"";
var _b=x$("[name=xg_recaptcha_popup_attempt]",_7).length?x$("[name=xg_recaptcha_popup_attempt]",_7).val():"";
var _c=x$(".xj_gnfst").length>0?x$(".xj_gnfst").val():"";
var _d=x$(".xj_gnfstTs").length>0?x$(".xj_gnfstTs").val():"";
var _e=x$(".xj_gnfstId").length>0?x$(".xj_gnfstId").val():"";
var _f={comment:this.editor.val(),recaptcha_challenge_field:_9,recaptcha_response_field:_a,xg_recaptcha_popup_attempt:_b,gnfst:_c,gnfstTs:_d,gnfstId:_e};
dojo.io.bind({url:_7.action+"&xn_out=json",method:"post",preventCache:true,encoding:"utf-8",mimetype:"text/javascript",content:_f,load:dojo.lang.hitch(this,function(_10,_11,_12){
dojo.style.hide(_8);
this.submitting=false;
xg.shared.CommentForm.onSuccess(_11);
})});
},isBlockedFromCreatingComments:function(){
var _13=x$("input#xj_canCreateContent");
if(_13.length>0&&_13.val()!="1"){
return true;
}
return false;
},validate:function(_14){
var _15={};
if(x$.trim(this.editor.val()).length===0){
_15.comment=xg.shared.nls.html("pleaseEnterAComment");
}
return _15;
},onSuccess:function(_16){
if(_16.error==true||typeof _16.errorMessages!=="undefined"){
xg.index.util.FormHelper.showErrorMessages(dojo.byId("comment_form"),{error:_16.errorMessages});
return;
}
if(!_16.html){
return;
}
if(_16.userIsNowFollowing){
dojo.lang.forEach(dojo.widget.manager.getWidgetsByType("FollowLink"),function(_17){
_17.showFollowing();
});
}
var _18=document.createElement("div");
_18.innerHTML=_16.html;
var dl=dojo.dom.firstElement(_18);
var _1a=dojo.byId("comment_form");
this.editor.val("");
if(_16.approved===false){
var _1b=dojo.html.getElementsByClass("notification",_1a,"div")[0];
if(!_1b){
_1b=dojo.html.createNodesFromText("<div class=\"notification\" style=\"margin-bottom:1em\"><p class=\"last-child\">"+xg.shared.nls.html("yourCommentMustBeApproved")+"</p></div>")[0];
dojo.dom.insertAtPosition(_1b,_1a,"first");
}
xg.index.util.FormHelper.scrollIntoView(_1a);
return;
}
xg.shared.comment.addDl(dl,this.addAtTop);
dojo.style.show("xj_comments_footer");
}};
xg.addOnRequire(function(){
xg.shared.CommentForm.initialize();
});
}
if(!dojo.hostenv.findModule("xg.shared.InPlaceEditor",false)){
dojo.provide("xg.shared.InPlaceEditor");
dojo.widget.defineWidget("xg.shared.InPlaceEditor",dojo.widget.HtmlWidget,{_instruction:"<required>",_maxLength:"<required>",_setValueUrl:"<required>",_getValueUrl:"",_value:"",_controlAttributes:"",_endRegexToIgnore:"",_maxLength:"",_html:false,_joinPromptText:"",disabled:false,initialized:false,showForm:function(){
dojo.html.hide(this.displayNode);
dojo.html.removeClass(this.displayNode,"editable_hover");
dojo.html.show(this.form);
setTimeout(dojo.lang.hitch(this,function(){
this.textControl.value=this._value.replace(this.end,"").replace(/<span><\/span>/gi,"");
if(this.stripTags(this.textControl.value)==this.stripTags(this.instruction())){
this.textControl.value="";
}
if(!this._html){
this.textControl.value=this.stripTags(this.textControl.value);
}else{
this.textControl.value=this.textControl.value.replace(/<br ?.?>\r?\n/gi,"\n");
}
}),0);
this.textControl.focus();
xg.index.util.FormHelper.scrollIntoView(this.form);
},hideForm:function(){
dojo.html.hide(this.form);
dojo.html.show(this.displayNode);
if(this.editLink){
dojo.html.show(this.editLink);
}
},stripTags:function(x){
return dojo.html.renderedTextContent(dojo.html.createNodesFromText("<div>"+x+"</div>")[0]);
},fillInTemplate:function(_2,_3){
this.displayNode=this.getFragNodeRef(_3);
this.displayNode.title=xg.shared.nls.text("clickToEdit");
this.editLink=dojo.byId("link_"+this.displayNode.id);
this._value=dojo.string.trim(this._value?this._value:this.displayNode.innerHTML);
var _4=new RegExp(this._endRegexToIgnore,"i").exec(this._value);
this.end=_4?_4[0]:"";
this.setDisplayHtml(this._value,this._value.length>0);
dojo.event.connect(this.displayNode,"onmouseover",dojo.lang.hitch(this,function(){
dojo.html.addClass(this.displayNode,"editable_hover");
}));
dojo.event.connect(this.displayNode,"onmouseout",dojo.lang.hitch(this,function(){
dojo.html.removeClass(this.displayNode,"editable_hover");
}));
dojo.event.connect(this.displayNode,"onclick",dojo.lang.hitch(this,function(){
this.showEditor();
}));
if(this.editLink){
dojo.event.connect(this.editLink,"onclick",dojo.lang.hitch(this,function(_5){
dojo.event.browser.stopEvent(_5);
this.showEditor();
}));
}
},showEditor:function(){
xg.shared.util.promptToJoin(this._joinPromptText,dojo.lang.hitch(this,function(){
this.initializeIfNecessary();
if(this.editLink){
dojo.html.hide(this.editLink);
}
if(this.disabled){
return;
}
if(this._getValueUrl==""){
this.showForm();
}else{
this.disabled=true;
this.displayNode.innerHTML="<span class=\"instruction\">"+xg.shared.nls.html("loading")+"</span>";
dojo.io.bind({url:this._getValueUrl,preventCache:true,encoding:"utf-8",mimetype:"text/javascript",load:dojo.lang.hitch(this,function(_6,_7,_8){
this.setDisplayHtml(_7.html);
this.showForm();
this.disabled=false;
})});
}
}));
},initializeIfNecessary:function(){
if(this.initialized){
return;
}
this.initialized=true;
this.form=dojo.html.createNodesFromText(dojo.string.trim("                 <form class=\"inplace_edit\" style=\"display:none;\">                     <div class=\"texteditor\">                         <input type=\"text\" "+this._controlAttributes+" maxLength=\""+this._maxLength+"\" />                     </div>                     <p class=\"buttongroup\">                         <input type=\"submit\" class=\"button action-primary submit\" value=\""+xg.shared.nls.html("save")+"\" />                         <a class=\"cancellink action-secondary\" href=\"javascript:void(0)\">"+xg.shared.nls.html("cancel")+"</a>                     </p>                 </form>"))[0];
dojo.dom.insertAfter(this.form,this.displayNode);
this.textControl=this.form.getElementsByTagName("input")[0];
this.saveButton=this.form.getElementsByTagName("input")[0];
this.cancelButton=dojo.html.getElementsByClassName("cancellink")[0];
dojo.event.connect(this.cancelButton,"onclick",dojo.lang.hitch(this,function(_9){
dojo.event.browser.stopEvent(_9);
this.setDisplayHtml(this._value);
this.hideForm();
}));
dojo.event.connect(this.form,"onsubmit",dojo.lang.hitch(this,function(_a){
dojo.event.browser.stopEvent(_a);
if(this.disabled){
return;
}
this.disabled=true;
this.displayNode.innerHTML="<span class=\"instruction\">"+xg.shared.nls.html("saving")+"</a>";
this.hideForm();
var _b=xg.shared.util.parseUrlParameters(this._setValueUrl);
_b["value"]=this.textControl.value;
dojo.io.bind({url:this._setValueUrl,content:_b,method:"post",encoding:"utf-8",preventCache:true,mimetype:"text/javascript",encoding:"utf-8",load:dojo.lang.hitch(this,function(_c,_d,_e){
this.setDisplayHtml(_d.html);
this.disabled=false;
this._getValueUrl="";
})});
}));
},setDisplayHtml:function(_f,_10){
this._value=_f;
_f=dojo.string.trim(_f.replace(this.end,""));
if(_f.length==0){
_f=this.instruction();
}
if(!_10){
this.displayNode.innerHTML="<span></span>"+xg.shared.util.nl2br(_f)+this.end;
}
dojo.lang.forEach(this.displayNode.getElementsByTagName("a"),dojo.lang.hitch(this,function(a){
a.onclick=dojo.lang.hitch(this,function(){
this.disabled=true;
window.setTimeout(dojo.lang.hitch(this,function(){
this.disabled=false;
}),1000);
});
}));
},instruction:function(){
if(dojo.string.trim(this._instruction).length>0){
return "<span class=\"instruction\">["+dojo.string.escape("html",this._instruction)+"] </span>";
}else{
return "<span class=\"instruction\"></span>";
}
}});
}
