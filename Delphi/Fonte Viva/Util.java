package br.com.calcula.wiki;

import java.util.ArrayList;

public class Util {
	public static String delete(String s, int pos, int qtde) {
		String t = "";
		if (pos >= 1)
			t = s.substring(0, pos - 1);
		if (pos + qtde - 1 <= s.length())
			if (pos + qtde - 1 < 0)
				t = t + s;
			else t = t + s.substring(pos + qtde - 1, s.length());
		return t;
	}

	public static String insert(String sub, String s, int i) {
		if (i - 1 >= 0)
			return s.substring(0, i - 1) + sub + s.substring(i - 1, s.length());

		if (i < 1)
			i = 1;
		return sub + s.substring(i - 1, s.length());
	}

	public static String charLeftConcat(char c, String b) {
		b = "¨" + b;
		return b.replace('¨', c);
	}

	public static String char2String(char c) {
		String s = "¨";
		return s.replace('¨', c);
	}

	public static boolean charInSet(char ch, String s) {
		for (int i = 0; i < s.length(); i++)
			if (ch == s.charAt(i))
				return true;

		return false;
	}

	public static String toString2(ArrayList<String> memo) {
		String s = "";
		for (int i = 0; i < memo.size(); i++)
			s = s + memo.get(i);
		return s;
	}

	public static void processarBiba() {
		Util.processar("joão 1, 1", "in principio erat verbum");
	}

	public static void processar(String x, String y) {

	}
}
