var wc={}
wc.f=document.forms[0]
wc.e=element("extra")
wc.p=element("pick")
wc.translate=function() {
    var f=wc.f, e=wc.e, p=wc.p
    f.translate.disabled=true
    f.output.value=""
    wc.r=[]
    wc.current=0
    clear(e)
    clear(p)

    function show_error(msg) {
	if(e) e.innerHTML=msg
	else f.output.value="["+msg+"]"
    }
    function show_pick(i) { return function() { show_trans(i); return false; } }
    function show_picks() {
	clear(p)
	for(var i=0;i<wc.r.length;i++) {
	    p.appendChild(text(" "))
	    var pick=text(i+1) // +"⃝"
	    if(i!=wc.current) {
		var pick=node("a",{href:"#"},[pick])
		pick.onclick=pick.onmouseover=show_pick(i)
	    }
	    p.appendChild(span_class("pick",pick))
	}
	p.appendChild(wrap_class("small","pick",
				 node("a",{href:wc.google_translate_url(),
					   target:"google_translate"},
				      [text("Google Translate")])))
    }
    function show_trans(i) {
	var r=wc.r[i]
	f.output.value=r.text
	if(e) e.innerHTML=r.prob+"<br>"+r.tree
	wc.current=i
	if(wc.p /*&& wc.r.length>1*/) show_picks()
	if(f.speak.checked) wc.speak(r.text,f.to.value)
    }

    function trans(text,i) {
	function showit(result) {
	    wc.r[i].text=result
	    if(wc.current==i) show_trans(i)
	    else show_picks()
	    f.translate.disabled=false
	    if(wc.p && i<9) trans(text,i+1)
	}
	function step3(trans) {
	    if(trans.length>=1) {
		if(trans[0].error) show_error(trans[0].error)
		else {
		    var r=wc.r[i]=trans[0]
		    if(e && wc.current==i) e.innerHTML=r.prob+"<br>"+r.tree
		    unlextext(r.linearizations[0].text,showit)
		}
	    }
	    else if(i==0) show_error("Unable to translate")
	}
	gftranslate.translate(text,f.from.value,f.to.value,i,1,step3)
    }
    function step2(text) { trans(text,0) }
    lextext(f.input.value,step2)
    return false;
}

wc.speak=function(text,lang) {
    if(wc.speech) {
	var u=new SpeechSynthesisUtterance(text)
	u.lang=add_country(alangcode(lang))
	speechSynthesis.cancel()
	speechSynthesis.speak(u)
    }
}

wc.swap=function() {
    var f=wc.f
    f.input.value=f.output.value;
    var from=f.from.value
    f.from.value=f.to.value
    f.to.value=from
    wc.translate()
}

wc.google_translate_url=function() {
    return "http://translate.google.com/"
	+"#"+alangcode(wc.f.from.value)
	+"/"+alangcode(wc.f.to.value)
	+"/"+encodeURIComponent(wc.f.input.value)
}
/*
wc.try_google=function() {
    var w=window.open(wc.google_translate_url(),
		      "google_translate")
    w.focus()
}
*/

function init_speech() {
    wc.speech=window.speechSynthesis && window.speechSynthesis.getVoices().length>0
    if(wc.speech) element("speak").style.display="inline"
}

init_speech()
setTimeout(init_speech,500) // A hack for Chrome.
