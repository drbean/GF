package org.grammaticalframework.pgf;

import java.util.*;

public class Concr {

	public native String getName();

	public Iterable<ExprProb> parse(String startCat, String s) {
		return new Parser(this, startCat, s);
	}

	public Expr parseBest(String startCat, String s) {
		Iterator<ExprProb> iter = Parser.parse(this, startCat, s);
		if (iter.hasNext()) {
			return iter.next().getExpr();
		} else {
			return null;
		}
	}

	public native String linearize(Expr expr);

	//////////////////////////////////////////////////////////////////
	// private stuff
	
	private PGF gr;
	public long ref;

	private Concr(PGF gr, long ref) {
		this.gr  = gr;
		this.ref = ref;
	}
}
