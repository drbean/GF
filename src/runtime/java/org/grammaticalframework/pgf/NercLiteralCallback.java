package org.grammaticalframework.pgf;

import java.util.Collections;
import java.util.Iterator;

public class NercLiteralCallback implements LiteralCallback {
	private PGF pgf;
	private Concr concr;

	public NercLiteralCallback(PGF pgf, Concr concr) {
		this.pgf   = pgf;
		this.concr = concr;
	}

	public CallbackResult match(int lin_idx, String sentence, int offset) {
		StringBuilder sbuilder = new StringBuilder();

		int i = 0;
		int end_offset = offset;
		while (offset < sentence.length() &&
			   Character.isUpperCase(sentence.charAt(offset))) {
			if (i > 0)
				sbuilder.append(' ');
			i++;

			while (offset < sentence.length() &&
			       !Character.isWhitespace(sentence.charAt(offset))) {
				sbuilder.append(sentence.charAt(offset));
				offset++;
			}

			end_offset = offset;
			while (offset < sentence.length() &&
			       Character.isWhitespace(sentence.charAt(offset))) {
				offset++;
			}
		}

		if (i > 0) {
			String name = sbuilder.toString();
			Expr expr = null;
			double prob = 0;
			for (MorphoAnalysis an : concr.lookupMorpho(name)) {
				String cat = pgf.getFunctionType(an.getLemma()).getCategory();
				if (prob < an.getProb()) {
					if ("PN".equals(cat)) {
						expr = new Expr(an.getLemma(), new Expr[0]);
						prob  = an.getProb();
					} else if ("Language".equals(cat)) {
						expr = new Expr(an.getLemma(), new Expr[0]);
						expr = new Expr("languagePN", expr);
					} else if ("Pron".equals(cat)) { // to capture I in English
						return null;
					}
				}
			}

			if (expr == null) {
				expr = new Expr(name);
				expr = new Expr("MkSymb", expr);
				expr = new Expr("SymbPN", expr);
			}

			return new CallbackResult(new ExprProb(expr, 0), end_offset);
		}

		return null;
	}
	
	public Iterator<TokenProb> predict(int lin_idx, String prefix) {
		return Collections.<TokenProb>emptyList().iterator();
	}
}
