package br.com.calcula.wiki;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.Authenticator;
import java.net.InetSocketAddress;
import java.net.MalformedURLException;
import java.net.PasswordAuthentication;
import java.net.Proxy;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;

public class Testar {

	private static String USERNAME = "";
	private static String PASSWORD = "";
	private static String PASTA = "";
	private static String ARQUIVO = "";

	public static String rodar() {
		PASTA = "V:\\java\\wiki_branch\\";
		ARQUIVO = "temp.tmp";
		System.out.println(title("https://www.youtube.com/watch?v=THEBLw7CQ6w", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=CC7aXxSU720", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=xOnzF-iIQPo", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=5AvjCrXd0qk", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=0gj9xa7rZBw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=1wNc0MccTc4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Qmdz_Qu3jV8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=CeNeaePbvYo", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=drqWE2PFnvo", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=-nWgSsuI5mA&feature=youtu.be", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=U-xpNalmfgY", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=8a-wfCBBPd8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=3ohu8ZSmat0", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=2gZ7WEC8F4s", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=k3_lU615ZiQ", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=4fh04V2YO3w", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=UceBV_G3dp8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=xsA3Y-kPpTM", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=-GqT79uk3cQ&feature=youtu.be", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=oFrMdRXTWCE", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=NNLHsKoyvZc", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=snf1sK_vd_Y", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=t8F7V4ywOZg", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=_wxRMAsHQCE", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=4LC-RnqAkBY", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=PqOmEJvk1JY", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=b9i86isSocw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=MZUs13LkZzI", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=1O0TMmA9QzE", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=beRCO6aScPs", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=glBSE7J_g9E", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=8jpwH7Zud2Q", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=iWZDetvrUy8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=oDfclV5GxsY", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=S1W837UmeZ0", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Pqe81a_sGqw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=GimjV6Cl82U", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=uUdmrHPggCA", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=EX021hmzO_4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=tCRBt4WI90c", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=_y4xd0f70jY", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=4cqN5Xt0Lw4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=yWzrgSkrKlw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=ORnacewqtVk", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=yJcG_YexKsk", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=qSf982abo5E", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=LspapXG_h7s", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=GunAYyFhqtc", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=3up5vuaTSg4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=gBiTRhjZO2I", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=SL9w31H9rzQ", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=R15HOBrxWO4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=oPUtaUe8VaU", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=nCRlGR-xrsY", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=-t1jjshEjFM&feature=youtu.be", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=uwoCjL8A5sQ", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=ypDOPtmbOXg", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=2plcnM-TCR0", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=a2XVrzgouA8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=QGBSPnKZUo8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=drwXa9lVrmg", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=OQdZYivyNOA", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=u6qitaV1X6A", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=1r7hMrheJtY", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=ASg7mMXB6Xs", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Po-UTXEusIQ", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=r6L4df4Zikw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=eOpsxqh-4bs", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=1_fSukOPDRA", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=ivBuwr-Z_mM", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=I4ApH9BKg-M", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=OtP3hRl4L3U", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=aGe6Osg0R_8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=BdPPIuZkfig", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=FT4salitZZo", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Ie2z8CNlXS8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=jqpqLDBqSXs", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=lLK8Y5jicCw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=pWnCXXmSGlo", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=phz_1W2FO9k", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=qmFzJpOOQU4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=tSSnfywHGX0", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=G4DPpWLmTcw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Ipadp2B2EIY", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=JU52wvXxdEE", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=QZCIxoAzE4c", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=SoCoRKGqU7E", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=iy6kCidqjh0", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=qTolZEkzUwc", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=1cu_tg8wuSk", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=5AzIFbSgVvI", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=93WsbBQxD5s", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=BQqTQD8mZ0A", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Gh7B6RdH-Ck", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=HLUD6-b5Vvk", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=P1R0CPziF6w", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=VaGNRK8M_V0", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=bWpa3MHlRP0", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=hlb2f_dirm8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=phO_PFslAow", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=yixbS6qMq5w", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=hH_FzwPMG2M", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Ayv2Soe2P3w", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=cPWkKbwheJo", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=mh6cPiol0kU", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=sGQPOsiLyQg", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=07amfkNQ1mI", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=472RBgxNRKE", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=8pbO1gS6Khc", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=LHqFhttPjC8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=QXX40ABqqkA", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=RIosu15pW2E", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=_kaE1bR-pV4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=cDr7JBi4zd8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=fHffJVGJ2Mo", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=lLsoWd6hLns", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=pXKYMyqRQds", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=vHq60yrSuAg", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=ri133wXkBj8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=5Ij0wPPkt7I", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=7-wPzeXfH_I", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Hr-wRn_pSiM", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=NXpb3rscdmQ", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=QE1CZg5NO4Y", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=UEjbLzr28BA", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=clD7Tg66ULc", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=reX745_fOhw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=vY_DMGjeO1c", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=1xFZo8I61r4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=6yiW8ytXgb4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=7zHdLZ94HvI", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=8wJILJeD8sY", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=9EmXw3qE4_Y", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=AR7BWVsdtHU", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=C-sGymzk39E", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=CIaGQePVVQw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=FwHyiikrjR8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=HIwzjfGUJjk", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=KEjccyqMRMk", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=KTG0CW8YJd4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=M12dHDJru2E", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=M1hDggVKFtA", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=PLIuttXtBqg", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=QLFboAJhrB4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=QOjfjoVh2pM", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Rw8QllhM1cA", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=So6hoVy8qSU", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=UjexsG2MFJA", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=UsLO5gUtWiw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=YZL3h71J6UQ", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=1xFZo8I61r4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=8wJILJeD8sY", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=9EmXw3qE4_Y", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=CIaGQePVVQw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=HIwzjfGUJjk", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=YZL3h71J6UQ", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=qtTiKL44z-U", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=tyeLHQSEQOo", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=zls7IiFtqPI", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=8Y96tq6_gGw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=H5jFpw1-CsU", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=SN50mnCgvFg", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=feBa1GAKLgc", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=pc19OOW9kuQ", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=H0aeDHxYnGs", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Yrk6qZ34Mtw", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Vh0yCPvcdrI", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=s4Xexej67k0", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=rzPxK56GCu8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=wio-6zjSsV4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Z3IXeWvEEa4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=tkgjHRfidw8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Anyjzpp9uwI", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=I-WQmzbslQc", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=JVKMdyvGbUQ", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=jH4QAWhqkDE", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=E4aBYhwbRHg", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=HuHuZYgcLOI", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=OUaltUyhTSM", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=kNnNXxNR3SE", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=_h26uIKyqco", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Dd4eHdms4ZU", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=154zJRr2kwo", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=zhrVnGItKOE", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=yyqd22qMJE4", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=wyQJ_9UaOzE", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=mmzqmIcX7xo", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=2Zmk61NvaoU", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=xlabDMqVODI", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=07oqRHg1oD8", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=TXpUrw3vr24", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=9Eck5B8b4GY", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=ndlB2HIYZ7o", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=0dgNbhgUZ9w", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=h7HI_yRvung", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=f4RlOhc1cXA", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=gyxnDmc1U_c", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=Mz9mvLLgcDU", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=gIKVXwuLuAg", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=ZkZQaSqqqq0", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=mScoQhy0Owg", "", 443));
		System.out.println(title("https://www.youtube.com/watch?v=UIrG07SE9LQ", "", 443));
		return "eee";
	}

	public static String rodar2() {
		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\trinity\\";
		Util.println(executeGet("https://claudino.webs.com/trinity/Exercicio1.txt", "", 443));
		Util.println(executeGet("https://claudino.webs.com/trinity/Exercicio222.txt", "", 443));
		Util.println(executeGet("https://claudino.webs.com/trinity/Exercicio228.txt", "", 443));
		Util.println(executeGet("https://claudino.webs.com/trinity/Exercicio242_222.txt", "", 443));
		Util.println(executeGet("https://claudino.webs.com/trinity/Exercicio242_228.txt", "", 443));
		Util.println(executeGet("https://claudino.webs.com/trinity/palestina.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/trinity/rgfs.gif", "", 443));

		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\super\\";
		Util.println(executeGet("https://claudino.webs.com/super/AEquipeGraffite.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/super/index.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/super/novoAnuncio.jpg", "", 443));

		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\summer013\\";
		Util.println(executeGet("https://claudino.webs.com/summer013/holograms.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/summer013/resumao.txt", "", 443));
		Util.println(executeGet("https://claudino.webs.com/summer013/tensores.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/summer013/variedade1.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/summer013/variedade2.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/summer013/variedade3.gif", "", 443));

		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\math\\";
		Util.println(executeGet("https://claudino.webs.com/math/1ijk_lemniscatas.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/4pontos.zip", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/A(t).gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/b_escalar_c.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/calendario_c0_raios_circulos.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/definicao_lie.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/desigualdadeSN.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/dimImAt.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/Dom_e_CoDom.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/elipse.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/example81.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/geraPrimosAFD.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/good_prime.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/H_Riemanniana.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/heptagrama_trim.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/hyperbola.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/hypercube.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/inequacao.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/intgabbay2.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/math.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/matrizesCubicas.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/ordene_r3.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/parab.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/parab1.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/parab2.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/pentagrama_trim.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/power5.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/rascunho.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/Resumao%20da%20IntroZeta.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/Resumao%20da%20IntroZeta.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/StokeNav.doc", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/StokeNav.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/topologia2015.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/triang_pascal01.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/triang_pascal02.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/triang_pascal03.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/triang_pascal04.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/triang_pascal05.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/triang_pascal06.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/trisection.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/Vinicius_Monografia.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/VinteQuatroDoisCuboTres.gif", "", 443));

		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\math\\arcos\\";
		Util.println(executeGet("https://claudino.webs.com/math/arcos/figura.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/arcos/index.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/arcos/s1.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/math/arcos/s2.gif", "", 443));

		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\info\\";
		Util.println(executeGet("https://claudino.webs.com/info/cubo.zip", "", 443));
		Util.println(executeGet("https://claudino.webs.com/info/cubo_chines.zip", "", 443));
		Util.println(executeGet("https://claudino.webs.com/info/display.zip", "", 443));
		Util.println(executeGet("https://claudino.webs.com/info/reltec.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/info/reltec.zip", "", 443));
		Util.println(executeGet("https://claudino.webs.com/info/SNum.h", "", 443));
		Util.println(executeGet("https://claudino.webs.com/info/SNum.txt", "", 443));

		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\google\\";
		Util.println(executeGet("https://claudino.webs.com/google/index.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/google/index2.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/google/pendulo.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/google/simpsons.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/google/StatLib.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/google/zeos.jpg", "", 443));

		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\gimg\\";
		Util.println(executeGet("https://claudino.webs.com/gimg/alargamento.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/apareceu.JPG", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/blue.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/chapolin.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/CrazyCatLady.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/dolores.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/ele.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/green.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/ilson.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/index.txt", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/lateral.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/pinky.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/realm.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/simbolico.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/stormie.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/trespass.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/vigarista.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/woody.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gimg/wuw.jpg", "", 443));

		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\gatherer\\";
		Util.println(executeGet("https://claudino.webs.com/gatherer/absolute_grace.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/absolute_law.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/air.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/artificial_ev.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/batelada.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/BlanketofNight.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/blood_martyr.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/bog.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/brainstorm.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/bribery.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/brine.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/carma.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/cataclysm.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/cinder.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/cleanse.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/cockroach.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/condemn.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/contemplation.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/corrupt.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/day_judgement.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/dedicated_martyr.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/deepfire.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/desecration.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/dreams.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/dust.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/east.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/echoing_truth.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/ev_vat.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/evangelize.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/false_prophet.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/fanatical_devotion.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/FerAvernal.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/flamecore.bmp", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/fog.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/genesis.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/halo.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/hellspark.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/hostility.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/illuminate.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/illumination.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/island_sanct.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/ivy.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/kiss.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/lavacore.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/lichenthrope.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/lobotomy.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/lys_alana_bowmaster.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/martyr_cause.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/martyrdom.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/meditate.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/mirror.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/nature.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/near_death_xperience.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/overwhelming_ins.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/plasma.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/predatory.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/primeval.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/purgatory.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/queen.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/raking_canopy.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/redeem.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/redeem_lost.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/renewed_faith.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/reparations.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/repercussion.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/retribution.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/rift.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/rockshard.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/rockslide.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/roil.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/rust.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/s_mirror.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/s_sanctuary.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/savage.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/scholars.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/second_chance.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/SerraEmbrace.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/solidarity.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/test_faith.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/testament_faith.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/torment.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/transcendence.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/unconscious.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/vicious.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/voice_truth.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/wake_destruction.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/warpath.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/waterspout.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/web.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/west.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/wheel_fate.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/wheel_fortune.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/wilderness.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/gatherer/words.jpg", "", 443));

		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\citacoes\\";
		Util.println(executeGet("https://claudino.webs.com/citacoes/acredito.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/chicoXavierColecaoCompleta.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/doze_oito.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/espiritismo2013.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/espiritismo2014.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/estendamos_o_bem.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/j_picotation.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/joanna.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/joanna2012.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/joanna2012.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/joanna_alegria.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/joanna_espera.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/joanna_humor.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/joanna_insidioso.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/joanna_massif.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/levitico.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/painosso%20dos%20catarrolicos.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/respostas.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/tese_ChicoXavier.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/tese_Pedagogia.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/citacoes/tese_Psiquiatria.htm", "", 443));

		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\aperfeicoamento\\";
		Util.println(executeGet("https://claudino.webs.com/aperfeicoamento/index.htm", "", 443));

		PASTA = "V:\\java\\wiki_branch\\propagation\\webs dot com\\";
		Util.println(executeGet("https://claudino.webs.com/2010.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/2011.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/2012b.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/2013.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/2013b.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/2014.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/20140830.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/2015.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/2015b.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/2016.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/2017.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/2018.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/7corpos.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/abaixo.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ag.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/agimg.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/AlphaOmega.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/apocalipse.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/apocalipseimg.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/aposentos.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/arc_cos.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/At.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/audiolivros.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/AwwalAkhir.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/azul.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/biblia.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/bipartition.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/bitcoin.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/blackCardinal.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/boleto.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/caminhoDoTempo.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/carta_scaneada.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/CauchySchwarz.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/cefet.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ceu.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/chaves%20ovni.mp3", "", 443));
		Util.println(executeGet("https://claudino.webs.com/chebyshev.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ciencia.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ClasseCongruencia.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ClasseTFA.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/coisas_estranhas.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/colacao.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/corrupcao.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Cristo2.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/cumprirDever.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/DefinicoesDiferenciais.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/desalinhou.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/differential%20oneil.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/differential%20oprea.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Dodecaedro.zip", "", 443));
		Util.println(executeGet("https://claudino.webs.com/esboco_transposta.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/espelhamento.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/EspelhoConcavo.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/espiritismo.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Esquema%20do%20Pai%20Nosso.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/EulerNdim.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/evandro2.txt", "", 443));
		Util.println(executeGet("https://claudino.webs.com/extended_abs.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/forcaDoTexto.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Formas%20Diferenciais.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/fragm.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/geracao.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/GMmx.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/GOX-5013.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/hamilton_complex.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/hiperbole_xyc.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Historico%20UFMG%20-%209%20semestres.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Hologram.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/HologramSpace.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/hypersphere.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/hypersphere_gama.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/hypervolume.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/iahweh_lucas.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/iahweh_lucas.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ilson.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/imovel.doc", "", 443));
		Util.println(executeGet("https://claudino.webs.com/impostor.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/inconscienteMath.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/index.html", "", 443));
		Util.println(executeGet("https://claudino.webs.com/InfinityPolar.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/integral_norm_2D_sphere.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/integral_norm_3D_sphere.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/integral_norma_1D.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/integral_norma_2D.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/integral_norma_3D.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/intimaveis.rar", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ipconfig.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/irrational.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Isomorficos.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/isoperimetrical.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/khgf.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/lattes.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/liv_esp.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/mathematical_doublestruck_capital_m.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/mathspirituality2.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/megassena.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/memorial.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/messias.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/mestrado.zip", "", 443));
		Util.println(executeGet("https://claudino.webs.com/mestrado2011.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/moebius.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/msg.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Navier%20Stokes%20Equations.pps", "", 443));
		Util.println(executeGet("https://claudino.webs.com/novaTurma.txt", "", 443));
		Util.println(executeGet("https://claudino.webs.com/old_fashion.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ori%202015%20pagina%201.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ori%202015%20pagina%202.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/orientacao_1_2015.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/output.csv", "", 443));
		Util.println(executeGet("https://claudino.webs.com/paralelecubo.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/perfection.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Pontos%20Importantes.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/pope.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ppn.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Q2HeQ3.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Q2zetaQ3.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/quadraticSeries.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/questoes.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/r-n1-n2-grama.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/REDS_1407214_2012.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/reflection.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/retreplica.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/satelite.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/sauron.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/self_adjoint.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/serie_sobre_S.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/SESPRE.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/stokes.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/sul21.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/super_cluster.rar", "", 443));
		Util.println(executeGet("https://claudino.webs.com/synergy.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/tjmg.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/trabalho_manual.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/transposta.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/transposta35_1.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/transposta35_2.png", "", 443));
		Util.println(executeGet("https://claudino.webs.com/trump.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/u2be.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ufmg.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ufmg.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/un-indulgente.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/unfiled.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/VariavelComplexa.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/variedades.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/vela.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/verao2011.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Vi.jpg", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Vi2.jpg", "", 443));
		Util.println(
				executeGet("https://claudino.webs.com/VINICIUS%20CLAUDINO%20FERRAZ%20CURRICULO%20VITAE.pdf", "", 443));
		Util.println(executeGet("https://claudino.webs.com/Vinicius_Matematica.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/voltaLula.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/xereca.htm", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ydy_dx.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/yinyang_cardiaco.gif", "", 443));
		Util.println(executeGet("https://claudino.webs.com/ZFC.gif", "", 443));

		return "eee";
	}

	// https://stackoverflow.com/questions/26393031/how-to-execute-a-https-get-request-from-java
	private static String executeGet(final String https_url, final String proxyName, final int port) {
		String nomearq = https_url;
		int i = nomearq.lastIndexOf("/");
		if (ARQUIVO.equals(""))
			nomearq = nomearq.substring(i + 1);
		else
			nomearq = ARQUIVO;

		URL url;
		try {

			HttpsURLConnection con;
			url = new URL(https_url);

			if (proxyName.isEmpty()) {
				con = (HttpsURLConnection) url.openConnection();
			} else {
				Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress(proxyName, port));
				con = (HttpsURLConnection) url.openConnection(proxy);
				Authenticator authenticator = new Authenticator() {
					public PasswordAuthentication getPasswordAuthentication() {
						return (new PasswordAuthentication(USERNAME, PASSWORD.toCharArray()));
					}
				};
				Authenticator.setDefault(authenticator);
			}

			InputStream fis = (InputStream) con.getInputStream();
			File f = new File(PASTA + nomearq);
			FileOutputStream out = new FileOutputStream(f);

			byte bbuf[] = new byte[10240];
			int s;
			while ((s = fis.read(bbuf, 0, 10240)) > 0) {
				out.write(bbuf, 0, s);
				// tl += s;
			}

			fis.close();
			out.close();

		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return nomearq;
	}

	private static String title(final String https_url, final String proxyName, final int port) {
		String nomearq = "temp.tmp";

		URL url;
		try {

			HttpsURLConnection con;
			url = new URL(https_url);

			if (proxyName.isEmpty()) {
				con = (HttpsURLConnection) url.openConnection();
			} else {
				Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress(proxyName, port));
				con = (HttpsURLConnection) url.openConnection(proxy);
				Authenticator authenticator = new Authenticator() {
					public PasswordAuthentication getPasswordAuthentication() {
						return (new PasswordAuthentication(USERNAME, PASSWORD.toCharArray()));
					}
				};
				Authenticator.setDefault(authenticator);
			}

			InputStream fis = (InputStream) con.getInputStream();
			ByteArrayOutputStream out = new ByteArrayOutputStream();

			byte bbuf[] = new byte[10240];
			int s;
			while ((s = fis.read(bbuf, 0, 10240)) > 0) {
				out.write(bbuf, 0, s);
				// tl += s;
			}

			nomearq = out.toString("UTF-8");
			int i = nomearq.indexOf("<title>");
			int j = nomearq.indexOf("</title>");
			nomearq = nomearq.substring(i + 7, j);

			// i = nomearq.indexOf(" - Google Drive");
			i = nomearq.indexOf(" - YouTube");
			if (i >= 0)
				nomearq = nomearq.substring(0, i);
			else
				nomearq = https_url;

			fis.close();
			out.close();

		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return nomearq;
	}

}
