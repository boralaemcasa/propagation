<!--DOCUMENT CONTENT_TYPE="text/javascript"  -->
/* 
  Copyright 2004 - Certifica.com 
  $Id: certifica.js,v 1.15 2005/03/10 20:08:23 leus Exp $
*/

DEFAULT_PIVOT_NAME = 'cert_Pivot';
DEFAULT_REDIRECT_TIME = 3000;
DEFAULT_PERIODIC_REDIRECT_TIME = 60000;

function cert_normalizePath(sPath, sPrefix)
{
    var sProtocol = cert_getProtocol();
    var sRet = 'home/default';
    var regexSlashes = /\/\/+/g;
    var regexInvalid = /[^A-Z0-9_.\/]/gi;
    var aDefaultPages = [
		'index.htm', 'index.html', 'index.asp', 'index.php', 
		'index.cfm', 'index.shtml', 'index.jsp', 'default.asp', 
		'default.html', 'default.htm', 'default.jsp', 'default.php'
    ];

    sPath = unescape(sPath);
    if (sPath && sPath.length > 0 &&
        (sProtocol == 'http:' || sProtocol == 'https:')) { 
        sPath = sPath.replace(regexInvalid, '');
        // Si es un directorio, se agrega una pagina por defecto
        if (sPath.charAt(sPath.length - 1) == '/') {
            sPath += aDefaultPages[0];
        }
        sPath = sPath.replace(regexSlashes, '/');

        var aParts = sPath.split('/');
        var aElems = new Array();
        for (var i = 0; i < aParts.length; i++) {
            if (aParts[i] && aParts[i] != '') {
                aElems.push(aParts[i]);
            }
        }

        if (aElems.length == 0) {
            aElems.push('home');
            aElems.push('default');
        }

        if (aElems.length == 1) {
            aElems.unshift('home');
        }
        
        for (var i = 0; i < aDefaultPages.length; i++) {
            if (aElems[aElems.length - 1] == aDefaultPages[i]) {
                aElems[aElems.length - 1] = 'default';
                break;
            }
        }
        
        // Si viene el prefijo, lo uso.
        if (sPrefix) {
            sRet = sPrefix + '/' + aElems[aElems.length -1];
        } else {
            sRet = aElems.join('/');
        }
        
    }
    return sRet;
}

function cert_qVal(sValue) 
{
    var pos = String(document.location).indexOf('?');
    if (pos != -1) {
       var query = String(document.location).substring(pos+1);
       var vars = query.split("&");
       for (var i=0; i < vars.length; i++) {
          var pair = vars[i].split("=");
          if (pair[0] == sValue)
             return pair[1];
       }       
    }
    return null;  
}

function cert_getCookie(sName) {
  var dc = document.cookie;
  var prefix = sName + "=";
  var begin = dc.indexOf("; " + prefix);
  if (begin == -1) {
    begin = dc.indexOf(prefix);
    if (begin != 0) return null;
  } else
    begin += 2;
  var end = document.cookie.indexOf(";", begin);
  if (end == -1)
    end = dc.length;
  return unescape(dc.substring(begin + prefix.length, end));
}

function cert_setCookie(sName, sValue, dtExpires, sPath, sDomain, bSecure) {
  document.cookie = sName + "=" + escape(sValue) +
      ((dtExpires) ? "; expires=" + dtExpires.toGMTString() : "") +
      ((sPath) ? "; path=" + sPath : "") +
      ((sDomain) ? "; domain=" + sDomain : "") +
      ((bSecure) ? "; secure" : "");
}

function cert_getReferrer()
{
   var referrer = document.referrer;
   if (self.cert_getReferrer14)
      return cert_getReferrer14();
/*@cc_on
  @if(@_jscript_version >= 5 )
   try { 
      if ( self != top ) referrer = top.document.referrer;
   } catch(e) {};
  @end
  @*/
  return referrer;
}

/* Obtiene el tipo de protocolo del documento actual. */
function cert_getProtocol()
{
    if (window && window.location && window.location.protocol)
        return window.location.protocol;
    return null;
}
 
/* Crea la URL para obtener un pageview de Certifica. */
/* Sólo necesita los parámetros iSiteId y sPath       */
function cert_getURL(iSiteId, sPath, sAppend) 
{
    var size, colors, referrer, url;
    size = colors = referrer = 'otro';
    var o = cert_qVal('url_origen');
    var proto = cert_getProtocol();
    if (proto != 'https:')
        proto = 'http:';
    
    if (o != null && o != '')
       referrer = o;
    else 
       referrer = escape(cert_getReferrer());
    if ( window.screen.width ) size = window.screen.width;
    if ( window.screen.colorDepth ) colors = window.screen.colorDepth;
    else if ( window.screen.pixelDepth ) colors = window.screen.pixelDepth;
    url = 
       proto + '//hits.e.cl/cert/hit.dll?sitio_id=' + iSiteId + '&path=' + sPath +
       '&referer=' + referrer + '&size=' + size + '&colors=' + colors;
    url += '&java=' + navigator.javaEnabled();
    if (sAppend)
        url += sAppend;
    return url;    
}

/* Efectua un hit en certifica usando una imagen pivote. */
function cert_registerHit(iSiteId, sPath, sPivotName) 
{
   var sAppend = '&cert_cachebuster=' + (1 + Math.floor (Math.random() * 10000));
   if ( !sPivotName )
      sPivotName = DEFAULT_PIVOT_NAME;
   if ( document.images )
      if ( document.images[sPivotName] )
         document.images[sPivotName].src = cert_getURL(iSiteId, sPath, sAppend);
}

/* Efectúa una redirección marcando la ruta de salida */
function cert_registerHitAndRedirect( sURL, iSiteId, sPath, sPivotName ) 
{
   cert_registerHit( iSiteId, sPath, sPivotName );
   setTimeout( "location.href = '" + sURL + "'", DEFAULT_REDIRECT_TIME );
}

/* Abre una nueva ventana, marcando el hit */
function cert_registerHitAndOpenWindow( sURL, iSiteId, sPath, sPivotName, sName, sFeatures, bReplace )
{
   cert_registerHit( iSiteId, sPath, sPivotName );
   if (!sName)
      sName = 'Downloads';
   if (!sFeatures)
      sFeatures = 'toolbar=no,location=no,directories=no,status=yes,menubar=no, scrollbars=no,resizable=no,width=425,height=510,screenX=20,screenY=20';
   window.open( sURL, 
      sName, 
      sFeatures, 
      bReplace 
   );
   return false;
}

/* Marca el hit y reemplaza/abre una URL en el frame 'sName' */
function cert_registerHitAndReplaceOtherFrame( sURL, sName, iSiteId, sPath, sPivotName ) 
{
   cert_registerHitAndOpenWindow( sURL, iSiteId, sPath, sPivotName, sName, 0, true );
}

/* Marca el hit y reemplaza/abre una URL en el frame 'sName' */
function cert_registerHitAndReplaceThisFrame( sURL, iSiteId, sPath, sPivotName ) 
{
   cert_registerHitAndRedirect( sURL, iSiteId, sPath, sPivotName );
}

/* Marca el hit y baja un archivo */
function cert_registerHitAndDownloadFile( sURL, iSiteId, sPath, sPivotName ) 
{
   cert_registerHitAndRedirect( sURL, iSiteId, sPath, sPivotName );
}

/* Marca un hit en la página actual */
function tagCertifica(iSiteId, sPath, sDesc) 
{
    sPrefix = null;
    sAppend = null;
    if (sPath.toLowerCase() == 'url') { 
        sPath = location.pathname;
    } else {
        sPrefix = sPath
        sPath = location.pathname;
    }

    if (!sDesc) {
        sDesc = document.title;
    }

    if (sDesc) {
        sAppend = '&descr=' + escape(sDesc.substr(0, 50));
    }
    
    sPath = cert_normalizePath(sPath, sPrefix);
    sURL = cert_getURL(iSiteId, sPath, sAppend); 
    document.writeln('<img src="' + sURL
        + '" width="1" height="1" border="0" alt="Certifica.com">' );
}

/* Marca un registro cada iTime milisegundos.  */
function cert_registerPeriodicHit( iSiteId, sPath, sPivotName, iTime ) 
{
   if ( !sPivotName )
      sPivotName = DEFAULT_PIVOT_NAME;
   if ( !iTime )
      iTime = DEFAULT_PERIODIC_REDIRECT_TIME;

   cert_registerHit( iSiteId, sPath, sPivotName );
   setTimeout( 'cert_registerPeriodicHit( ' + iSiteId + ', "' + sPath + '", "' + sPivotName + '", ' + iTime + ')', iTime );
}

