var wc={}
wc.cnl="Phrasebook" // try this controlled natural language first
wc.f=document.forms[0]
wc.o=element("output")
wc.e=element("extra")
wc.p=element("pick")
wc.serial=0
wc.os=[] // output segment list
wc.local=appLocalStorage("gf.wc.")

wc.delayed_translate=function() {
    function restart(){ if(wc.f.input.value!=wc.translating) wc.translate() }
    if(wc.timer) clearTimeout(wc.timer);
    wc.timer=setTimeout(restart,500)
    var h=wc.f.input.scrollHeight,bh=document.body.clientHeight
    if(h>bh) h=bh
    if(wc.f.input.clientHeight<h) wc.f.input.style.height=h+15+"px"
}

wc.clear=function() {
    wc.f.input.value=""
    wc.f.input.style.height=""
    clear(wc.o)
    wc.delayed_translate()
}

wc.save=function() {
    var f=wc.f
    wc.local.put("from",f.from.value)
    wc.local.put("to",f.to.value)
    wc.local.put("input",f.input.value)
    wc.local.put("colors",f.colors.checked)
}

wc.load=function() {
    var f=wc.f
    f.input.value=wc.local.get("input",f.input.value)
    f.from.value=wc.local.get("from",f.from.value)
    f.to.value=wc.local.get("to",f.to.value)
    f.colors.checked=wc.local.get("colors",f.colors.checked)
    wc.colors()
    wc.delayed_translate()
}

wc.translate=function() {
    var current= ++wc.serial
    var f=wc.f, e=wc.e, p=wc.p
    var selected= -1

    /*
    function disable(yes) {
	f.translate.disabled=yes
	f.to.disabled=yes
	if(f.swap) f.swap.disabled=yes
    }
    */

    function split_punct(s) {
	return s.split(/([.!?]+[ \t\n]+|\n\n+|[ \t\n]*[-•*+#]+[ \t\n]+)/)
    }

    function translate_segment(si) { // si = segment index
	var rs=[] // list of alternative translations for this segment
	var current_pick=0 // index of currently selected alternative
	var get_more // if defined, a function that will fetch more alternatives
	var output=wc.os[si].target // the element where this segment is shown

	function show_error(msg) {
	    //if(e) e.innerHTML="<span class=low_quality>Translation problem: "+msg+"</span>"
	    //else
	    {
		replaceChildren(output,text("["+msg+"]"))
		output.className="error"
	    }
	    //disable(false)
	}
	function show_pick(i) { return function() { show_trans(i); return false; } }
	function show_picks() {
	    clear(p)
	    for(var i=0;i<rs.length;i++) {
		p.appendChild(text(" "))
		var pick=text(i+1) // +"⃝"
		if(i!=current_pick) {
		    var pick=node("a",{href:"#"},[pick])
		    pick.onclick=pick.onmouseover=show_pick(i)
		}
		var q=rs[i].t.quality
		p.appendChild(span_class("pick "+q,pick))
	    }
	    /*
	    p.appendChild(wrap_class("small","pick",
				     node("a",{href:wc.google_translate_url(),
					       target:"google_translate"},
					  [text("Google Translate")])))
	    */
	}
	function show_more() {
	    selected=si
	    var r=rs[current_pick]
	    if(e) e.innerHTML=(r.prob||"")+"<br>"+r.tree
	    if(wc.p /*&& rs.length>1*/) show_picks()
	    //if(f.speak.checked) wc.speak(t.text,f.to.value)
	    if(get_more) {
		var f=get_more
		get_more=null
		f()
	    }
	}
	output.onclick=show_more

	function show_trans(i) {
	    var r=rs[i]
	    replaceChildren(output,text(r.text))
	    wc.os[si].text=r.text
	    output.className=r.t.quality
	    current_pick=i
	    if(selected==si) show_more()
	}

	function showit(r) {
	    r.t=trans_quality(r)
	    //r.t.text=r.t.text.trimRight()
	    r.text=r.t.text
	    rs.push(r)
	    var j=rs.length-1
	    if(current_pick==j) show_trans(j)
	    else if(selected==si) show_picks()
	    //disable(false)
	}
	function trans(text,i,count) {
	    function step3(tra) {
		if(wc.serial==current) {
		    if(tra.length>=1) {
			var r=tra[0]
			if(r.error!=undefined) {
			    if(i==0 && rs.length==0) show_error(tra[0].error)
			}
			else {
			    for(var ti=0;ti<tra.length;ti++) {
				var r=tra[ti]
				if(r.linearizations) showit(r)
				//else show_error("no linearizations")
			    }
			    /*
			    if(wc.p && i==0 && count==1) {
				if(si==selected) trans(text,1,9)
				else get_more=function() { trans(text,1,9) }
			    }
			    */
			}
		    }
		    else if(i==0 && rs.length==0)
			show_error("Unable to translate")
		}
	    }
	    gftranslate.translate(text,f.from.value,f.to.value,i,count,step3)
	}
	function step2(text) { trans(text,0,10) }
	function step2cnl(text) {
	    function step3cnl(results) {
		var trans=results[0].translations
		if(trans && trans.length>=1) {
		    var r=trans[0]
		    r.prob=0
		    showit(r)
		}
		step2(text)
	    }
	    wc.pgf_online.translate({from:wc.cnl+f.from.value,
				     to:wc.cnl+f.to.value,
				     lexer:"text",unlexer:"text",input:text},
				    step3cnl,
				    function(){step2(text)})
	}
	if(wc.cnl) step2cnl(is[si])
	else step2(is[si])
    }

    //disable(true)
    clear(wc.o)
    clear(e)
    clear(p)


    var old={}
    for(var i=0;i<wc.os.length;i++) old[wc.os[i].input]=wc.os[i] 
       // could also keep all copies if the same text occurs more than once...
    wc.os=[]

    wc.translating=f.input.value
    var is=split_punct(wc.translating+"\n")

    for(var i=0;i<is.length;i++) {
	var same=old[is[i]]
	if(same && same.to==f.to.value) { // reuse unchanged segment?
	    wc.os[i]=same
	    wc.o.appendChild(same.target)
	    delete old[is[i]] // can't use the same node twice
	}
	else {
	    wc.os[i]={input:is[i],text:is[i],to:f.to.value}
	    if(i&1) { // punctuation
		var o=wc.os[i].target=span_class("punct",text(is[i]))
		wc.o.appendChild(o)
	    }
	    else { // text segment to be translated
		var o=wc.os[i].target=span_class("placeholder",text(is[i]))
		wc.o.appendChild(o)
		translate_segment(i)
	    }
	}
    }
    wc.save()
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

wc.colors=function() {
  document.body.className=wc.f.colors.checked ? "colors" : ""
  wc.local.put("colors",wc.f.colors.checked)
}

wc.swap=function() {
    var f=wc.f
    function txt(r) { return r.text }
    f.input.value=wc.os.map(txt).join("").trimRight()
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

wc.try_google=function() {
    var w=window.open(wc.google_translate_url(),
		      "google_translate")
    w.focus()
}


// Update language selection menus with the languages supported by the grammar
function init_languages() {
    function init2(langs) {
	var langset=toSet(langs)
	function update_menu(m) {
	    var l=m.value
	    clear(m)
	    for(var i=0;i<langs.length;i++)
		m.appendChild(option(concname(langs[i]),langs[i]))
	    if(langset[l]) m.value=l
	}
	update_menu(wc.f.from)
	update_menu(wc.f.to)
    }
    gftranslate.get_languages(init2)
}

function init_speech() {
    var speak=element("speak")
    if(speak) {
	wc.speech=window.speechSynthesis && window.speechSynthesis.getVoices().length>0
	if(wc.speech) speak.style.display="inline"
    }
}

init_languages()
init_speech()
setTimeout(init_speech,500) // A hack for Chrome.
if(wc.cnl) {
    wc.pgf_online=pgf_online({});
    wc.pgf_online.switch_grammar(wc.cnl+".pgf")
}
wc.load()
wc.f.input.focus()
