package br.com.calcula.wiki;

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

	public static String rodar() {
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
		nomearq = nomearq.substring(i + 1);

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

}
