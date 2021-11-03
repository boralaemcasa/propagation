/* Versão: 1.2 - Especial Veja Notitia */

abrSuite="abrildev" 
abrChannel="veja"
abrDoPlugins="abrVejaMetrics"

abrVejaMetrics = function () {

   if (typeof s.channel != 'undefined' )
	 return ; //Variáveis já estão preenchidas
    
   s.channel = abrChannel 

   var regExp = /\/\/+/g
	
   s.prop3 = document.title.substr(0,100) // Título da Página 
   
   var abrURL = abrGetUrl()


   abrURL = abrURL.replace(regExp, '/') //Remove as barras duplicadas
  
   abrURL = abrURL.toLowerCase() //Converte para caixa baixa
   
   abrURL = unescape(abrURL)   //Remove caracteres HTML

   //Separa os elementos da URL (0=Protocol, 1=Domain , [ 2..(n-1)=hierarquia ], n=File Name 
   var abrElems = abrURL.split('/') 

   var isHome = (abrElems.length == 3) 

   //Protocolo (http, https)
   var abrProt = abrElems[0];

   //Partner
   s.prop17 = "abril"
   if (abrElems[1].indexOf(".uol.") > -1) s.prop17 = "uol" ; else if (abrElems[1].indexOf(".ig.") > -1) s.prop17 = "ig"

   /* Nome do arquivo */
   var abrFileName = abrElems[abrElems.length - 1] ;

   abrFileName = abrFileName.substr( 0 , abrFileName.indexOf('.') ) ;

   if(abrFileName == "" || abrFileName.indexOf("index") > -1 || abrFileName.indexOf("default") > -1 ) abrFileName = "default" ;

   /* Trata a URL do Noticia */
   if ( abrURL.indexOf("textcode") > -1 ) {
        var auxTit = document.title ;
        auxTit = auxTit.toLowerCase() ;
        auxTit = auxTit.replace('veja.com: ', '') ;
        auxTit = auxTit.replace('<b>', '') ;
        auxTit = auxTit.replace('</b>', '') ;
        auxTit = auxTit.replace('<i>', '') ;
        auxTit = auxTit.replace('</i>', '') ;
		abrFileName = auxTit.substr(0,50)  ;
   }  else 
	  if ( abrURL.indexOf("newstorm.ns.presentation") > -1 ) 
         abrFileName = "default" ;


   abrElems[abrElems.length - 1] = abrFileName 

   
   //Tipo de página
	if (typeof abrPType != 'undefined' )
		s.prop5 = abrPType ;
	else 
		if (abrFileName=="default") 
			s.prop5 = (isHome) ? "home" : "subhome" ;
		 else 
			s.prop5="pagina" ;
    
   //Search
   if (abrURL.indexOf("qu=") > -1) s.prop1 = s.getQueryParam("qu");

   //Hierarquia do site 
   var abrAux = s.channel ;

   if (typeof abrHier != 'undefined' ) {
	   
	   if (abrHier.charAt(0)!='/') 
          abrHier = '/' + abrHier;
	   if (abrHier.charAt(abrHier.length-1)!='/') 
          abrHier = abrHier + '/' ;
	   
 	   abrAux =  abrAux + abrHier + abrElems[abrElems.length - 1] ;

   } else 
	   if (isHome) 
		   abrAux = abrAux + "/home/default" ;
	   else  
			for (var i = 2; i < abrElems.length; i++) {
				abrAux = abrAux + "/" + abrElems[i]
			}
	
   s.hier1 = abrAux.substr(0,abrAux.lastIndexOf('/'))

   var regExp = /\/+/g
   s.pageName = abrAux.replace(regExp, ':') 

   
   /* Propriedade */
   abrAux = s.hier1.substr(s.hier1.indexOf('/')+1)
   abrAux = abrAux.split('/');


    //Site Correlation
	switch (abrAux.length) { 
		case 0: 
			break 
		case 1: //site section 
			s.prop6=abrAux[0] 
			break 
		case 2: //sub section 
			s.prop6 = abrAux[0] 
			s.prop7 = abrAux[0] + ":" + abrAux[1]	  
			break 
		case 3: //sub section 2
			s.prop6 = abrAux[0] 
			s.prop7 = abrAux[0] + ":" + abrAux[1]	  
			s.prop8 = abrAux[0] + ":" + abrAux[1]	+ ":" + abrAux[2]					
			break 
		default: //sub section 3 ou Maior
			s.prop6 = abrAux[0] 
			s.prop7 = abrAux[0] + ":" + abrAux[1]	  
			s.prop8 = abrAux[0] + ":" + abrAux[1]	+ ":" + abrAux[2]					
			s.prop9 = abrAux[0] + ":" + abrAux[1]	+ ":" + abrAux[2] + ":" + abrAux[3]					
			break
	}

}