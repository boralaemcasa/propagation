<!--DOCUMENT CONTENT_TYPE="text/javascript"  -->
/* 
  Copyright 2004 - Certifica.com 
  $Id: certifica-js14.js,v 1.4 2004/10/27 20:12:21 leus Exp $
*/
function cert_getReferrer14()
{
   var referrer = document.referrer;
   try { 
      if ( self != top ) 
         referrer = top.document.referrer;
   } catch(e) {
      referrer = document.referrer;
   }
   return referrer;
}
