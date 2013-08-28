#include <pgf/pgf.h>
#include <gu/mem.h>
#include <gu/exn.h>
#include <alloca.h>
#include "org_grammaticalframework_pgf_PGF.h"

static jstring
gu2j_string(JNIEnv *env, GuString s) {
	GuWord w = s.w_;
	uint8_t buf[sizeof(GuWord)];

	uint8_t* utf8;
	size_t len;
	if (w & 1) {
		len = (w & 0xff) >> 1;
		gu_assert(len <= sizeof(GuWord));
		size_t i = len;
		while (i > 0) {
			w >>= 8;
			buf[--i] = w & 0xff;
		}
		utf8 = buf;
	} else {
		uint8_t* p = (void*) w;
		len = (p[0] == 0) ? ((size_t*) p)[-1] : p[0];
		utf8 = &p[1];
	}

	const uint8_t* src = utf8;

	jchar* utf16 = alloca(len*sizeof(jchar));
	jchar* dst   = utf16;
	while (src-utf8 < len) {
		GuUCS ucs = gu_utf8_decode(&src);
		
		if (ucs <= 0xFFFF) {
			*dst++ = ucs;
		} else {
			ucs -= 0x10000;
			*dst++ = 0xD800+(ucs >> 10) & 0x3FF;
			*dst++ = 0xDC00+ucs & 0x3FF;
		}
	}

	return (*env)->NewString(env, utf16, dst-utf16);
}

static GuString
j2gu_string(JNIEnv *env, jstring s, GuPool* pool) {
	const char *str = (*env)->GetStringUTFChars(env, s, 0);
	return gu_str_string(str, pool);
}

static void*
get_ref(JNIEnv *env, jobject self) {
	jfieldID refId = (*env)->GetFieldID(env, (*env)->GetObjectClass(env, self), "ref", "J");
	return (void*) (*env)->GetLongField(env, self, refId);
}

static void
throw_jstring_exception(JNIEnv *env, const char* class_name, jstring msg)
{
	jclass exception_class = (*env)->FindClass(env, class_name);
	if (!exception_class)
		return;
	jmethodID constrId = (*env)->GetMethodID(env, exception_class, "<init>", "(Ljava/lang/String;)V");
	if (!constrId)
		return;
	jobject exception = (*env)->NewObject(env, exception_class, constrId, msg);
	if (!exception)
		return;
	(*env)->Throw(env, exception);
}

static void
throw_string_exception(JNIEnv *env, const char* class_name, const char* msg)
{
	jstring jmsg = (*env)->NewStringUTF(env, msg);
	if (!jmsg)
		return;
	throw_jstring_exception(env, class_name, jmsg);
}

JNIEXPORT jobject JNICALL 
Java_org_grammaticalframework_pgf_PGF_readPGF(JNIEnv *env, jclass cls, jstring s)
{ 
	GuPool* pool = gu_new_pool();
	GuPool* tmp_pool = gu_local_pool();

	// Create an exception frame that catches all errors.
	GuExn* err = gu_new_exn(NULL, gu_kind(type), tmp_pool);

	const char *fpath = (*env)->GetStringUTFChars(env, s, 0); 

	// Read the PGF grammar.
	PgfPGF* pgf = pgf_read(fpath, pool, err);

	(*env)->ReleaseStringUTFChars(env, s, fpath);

	if (!gu_ok(err)) {
		if (gu_exn_caught(err) == gu_type(GuErrno)) {
			throw_jstring_exception(env, "java/io/FileNotFoundException", s);
		} else {
			throw_string_exception(env, "org/grammaticalframework/pgf/PGFError", "The grammar cannot be loaded");
		}
		gu_pool_free(pool);
		gu_pool_free(tmp_pool);
		return NULL;
	}

	gu_pool_free(tmp_pool);

	jmethodID constrId = (*env)->GetMethodID(env, cls, "<init>", "(JJ)V");
	return (*env)->NewObject(env, cls, constrId, (jlong) pool, (jlong) pgf);
}

JNIEXPORT jstring JNICALL 
Java_org_grammaticalframework_pgf_PGF_getAbstractName(JNIEnv* env, jobject self)
{
	return gu2j_string(env, pgf_abstract_name(get_ref(env, self)));
}

JNIEXPORT jstring JNICALL
Java_org_grammaticalframework_pgf_PGF_getStartCat(JNIEnv* env, jobject self)
{
	GuPool* tmp_pool = gu_local_pool();
	jstring jname = gu2j_string(env, pgf_start_cat(get_ref(env, self), tmp_pool));
	gu_pool_free(tmp_pool);
	return jname;
}

JNIEXPORT void JNICALL 
Java_org_grammaticalframework_pgf_PGF_free(JNIEnv* env, jclass cls, jlong pool)
{
	gu_pool_free((GuPool*) pool);
}

typedef struct {
	GuMapItor fn;
	JNIEnv *env;
	jobject grammar;
	jobject object;
} JPGFClosure;

static void
pgf_collect_langs(GuMapItor* fn, const void* key, void* value, GuExn* err)
{
	PgfCId name = *((PgfCId*) key);
    PgfConcr* concr = *((PgfConcr**) value);
    JPGFClosure* clo = (JPGFClosure*) fn;

	jstring jname = gu2j_string(clo->env, name);
	
	jclass map_class = (*clo->env)->GetObjectClass(clo->env, clo->object);
	jmethodID put_method = (*clo->env)->GetMethodID(clo->env, map_class, "put", "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;");

	jclass concr_class = (*clo->env)->FindClass(clo->env, "org/grammaticalframework/pgf/Concr");
	jmethodID constrId = (*clo->env)->GetMethodID(clo->env, concr_class, "<init>", "(Lorg/grammaticalframework/pgf/PGF;J)V");
	jobject jconcr = (*clo->env)->NewObject(clo->env, concr_class, constrId, clo->grammar, (jlong) concr);

	(*clo->env)->CallObjectMethod(clo->env, clo->object, put_method, jname, jconcr);
}

JNIEXPORT jobject JNICALL
Java_org_grammaticalframework_pgf_PGF_getLanguages(JNIEnv* env, jobject self)
{
	jclass map_class = (*env)->FindClass(env, "java/util/HashMap");
	if (!map_class)
		return NULL;
	jmethodID constrId = (*env)->GetMethodID(env, map_class, "<init>", "()V");
	if (!constrId)
		return NULL;
	jobject languages = (*env)->NewObject(env, map_class, constrId);
	if (!languages)
		return NULL;

	PgfPGF* pgf = get_ref(env, self);

	GuPool* tmp_pool = gu_local_pool();

	// Create an exception frame that catches all errors.
	GuExn* err = gu_new_exn(NULL, gu_kind(type), tmp_pool);

	JPGFClosure clo = { { pgf_collect_langs }, env, self, languages };
	pgf_iter_languages(pgf, &clo.fn, err);
	if (!gu_ok(err)) {
		gu_pool_free(tmp_pool);
		return NULL;
	}
	
	gu_pool_free(tmp_pool);

	return languages;
}

JNIEXPORT jstring JNICALL 
Java_org_grammaticalframework_pgf_Concr_getName(JNIEnv* env, jobject self)
{
	return gu2j_string(env, pgf_concrete_name(get_ref(env, self)));
}

JNIEXPORT jobject JNICALL 
Java_org_grammaticalframework_pgf_Parser_parse
  (JNIEnv* env, jclass self, jobject concr, jstring jstartCat, jstring js)
{
	GuPool* pool = gu_new_pool();
	GuPool* out_pool = gu_new_pool();

    GuString startCat = j2gu_string(env, jstartCat, pool);
    GuString s = j2gu_string(env, js, pool);

	GuReader* rdr = gu_string_reader(s, pool);
	PgfLexer *lexer = pgf_new_simple_lexer(rdr, pool);

	GuEnum* res =
		pgf_parse(get_ref(env, concr), startCat, lexer, pool, out_pool);

	if (res == NULL) {
		PgfToken tok =
			pgf_lexer_current_token(lexer);

		if (gu_string_eq(tok, gu_empty_string))
			throw_string_exception(env, "org/grammaticalframework/pgf/PGFError", "The sentence cannot be parsed");
		else
			throw_jstring_exception(env, "org/grammaticalframework/pgf/ParseError", gu2j_string(env, tok));

		gu_pool_free(pool);
		gu_pool_free(out_pool);
	}

	jclass expiter_class = (*env)->FindClass(env, "org/grammaticalframework/pgf/ExprIterator");
	jmethodID constrId = (*env)->GetMethodID(env, expiter_class, "<init>", "(Lorg/grammaticalframework/pgf/Concr;JJJ)V");
	jobject jexpiter = (*env)->NewObject(env, expiter_class, constrId, concr, (jlong) pool, (jlong) out_pool, (jlong) res);

	return jexpiter;
}

JNIEXPORT jobject JNICALL 
Java_org_grammaticalframework_pgf_ExprIterator_fetchExprProb
  (JNIEnv* env, jobject self, jlong enumRef, jobject out_pool)
{
	GuEnum* res = (GuEnum*) enumRef;

	PgfExprProb* ep = gu_next(res, PgfExprProb*, NULL);
	if (ep == NULL)
		return NULL;

	jclass expprob_class = (*env)->FindClass(env, "org/grammaticalframework/pgf/ExprProb");
	jmethodID methodId = (*env)->GetStaticMethodID(env, expprob_class, "mkExprProb", "(Lorg/grammaticalframework/pgf/Pool;JD)Lorg/grammaticalframework/pgf/ExprProb;");
	jobject jexpprob = (*env)->CallStaticObjectMethod(env, expprob_class, methodId, 
	                                  out_pool, (jlong) gu_variant_to_ptr(ep->expr), (double) ep->prob);

	return jexpprob;
}

JNIEXPORT jstring JNICALL
Java_org_grammaticalframework_pgf_Concr_linearize(JNIEnv* env, jobject self, jobject jexpr)
{
	GuPool* tmp_pool = gu_local_pool();
	GuExn* err = gu_new_exn(NULL, gu_kind(type), tmp_pool);
	GuStringBuf* sbuf = gu_string_buf(tmp_pool);
	GuWriter* wtr = gu_string_buf_writer(sbuf);
	
	pgf_linearize(get_ref(env, self), gu_variant_from_ptr((void*) get_ref(env, jexpr)), wtr, err);
	if (!gu_ok(err)) {
		//
		return NULL;
	}

	GuString str = gu_string_buf_freeze(sbuf, tmp_pool);
	jstring jstr = gu2j_string(env, str);

	gu_pool_free(tmp_pool);
	
	return jstr;
}

JNIEXPORT void JNICALL 
Java_org_grammaticalframework_pgf_Pool_free(JNIEnv* env, jobject self, jlong ref)
{
	gu_pool_free((GuPool*) ref);
}

JNIEXPORT jstring JNICALL
Java_org_grammaticalframework_pgf_Expr_showExpr(JNIEnv* env, jclass clazz, jlong ref)
{
	GuPool* tmp_pool = gu_local_pool();

	GuExn* err = gu_new_exn(NULL, gu_kind(type), tmp_pool);
	GuStringBuf* sbuf = gu_string_buf(tmp_pool);
	GuWriter* wtr = gu_string_buf_writer(sbuf);

	pgf_print_expr(gu_variant_from_ptr((void*)ref), NULL, 0, wtr, err);

	GuString str = gu_string_buf_freeze(sbuf, tmp_pool);
	jstring jstr = gu2j_string(env, str);

	gu_pool_free(tmp_pool);
	return jstr;
}
