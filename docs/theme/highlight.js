/*!
  Highlight.js v11.9.0 (git: ca77d5b733)
  (c) 2006-2024 undefined and other contributors
  License: BSD-3-Clause
 */
var hljs=function(){"use strict";function e(n){
return n instanceof Map?n.clear=n.delete=n.set=()=>{
throw Error("map is read-only")}:n instanceof Set&&(n.add=n.clear=n.delete=()=>{
throw Error("set is read-only")
}),Object.freeze(n),Object.getOwnPropertyNames(n).forEach((t=>{
const a=n[t],s=typeof a;"object"!==s&&"function"!==s||Object.isFrozen(a)||e(a)
})),n}class n{constructor(e){
void 0===e.data&&(e.data={}),this.data=e.data,this.isMatchIgnored=!1}
ignoreMatch(){this.isMatchIgnored=!0}}function t(e){
return e.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").replace(/'/g,"&#x27;")
}function a(e,...n){const t=Object.create(null);for(const n in e)t[n]=e[n]
;return n.forEach((e=>{for(const n in e)t[n]=e[n]})),t}const s=e=>!!e.scope
;class i{constructor(e,n){
this.buffer="",this.classPrefix=n.classPrefix,e.walk(this)}addText(e){
this.buffer+=t(e)}openNode(e){if(!s(e))return;const n=((e,{prefix:n})=>{
if(e.startsWith("language:"))return e.replace("language:","language-")
;if(e.includes(".")){const t=e.split(".")
;return[`${n}${t.shift()}`,...t.map(((e,n)=>`${e}${"_".repeat(n+1)}`))].join(" ")
}return`${n}${e}`})(e.scope,{prefix:this.classPrefix});this.span(n)}
closeNode(e){s(e)&&(this.buffer+="</span>")}value(){return this.buffer}span(e){
this.buffer+=`<span class="${e}">`}}const r=(e={})=>{const n={children:[]}
;return Object.assign(n,e),n};class o{constructor(){
this.rootNode=r(),this.stack=[this.rootNode]}get top(){
return this.stack[this.stack.length-1]}get root(){return this.rootNode}add(e){
this.top.children.push(e)}openNode(e){const n=r({scope:e})
;this.add(n),this.stack.push(n)}closeNode(){
if(this.stack.length>1)return this.stack.pop()}closeAllNodes(){
for(;this.closeNode(););}toJSON(){return JSON.stringify(this.rootNode,null,4)}
walk(e){return this.constructor._walk(e,this.rootNode)}static _walk(e,n){
return"string"==typeof n?e.addText(n):n.children&&(e.openNode(n),
n.children.forEach((n=>this._walk(e,n))),e.closeNode(n)),e}static _collapse(e){
"string"!=typeof e&&e.children&&(e.children.every((e=>"string"==typeof e))?e.children=[e.children.join("")]:e.children.forEach((e=>{
o._collapse(e)})))}}class c extends o{constructor(e){super(),this.options=e}
addText(e){""!==e&&this.add(e)}startScope(e){this.openNode(e)}endScope(){
this.closeNode()}__addSublanguage(e,n){const t=e.root
;n&&(t.scope="language:"+n),this.add(t)}toHTML(){
return new i(this,this.options).value()}finalize(){
return this.closeAllNodes(),!0}}function l(e){
return e?"string"==typeof e?e:e.source:null}function g(e){return b("(?=",e,")")}
function d(e){return b("(?:",e,")*")}function u(e){return b("(?:",e,")?")}
function b(...e){return e.map((e=>l(e))).join("")}function h(...e){const n=(e=>{
const n=e[e.length-1]
;return"object"==typeof n&&n.constructor===Object?(e.splice(e.length-1,1),n):{}
})(e);return"("+(n.capture?"":"?:")+e.map((e=>l(e))).join("|")+")"}
function f(e){return RegExp(e.toString()+"|").exec("").length-1}
const p=/\[(?:[^\\\]]|\\.)*\]|\(\??|\\([1-9][0-9]*)|\\./
;function m(e,{joinWith:n}){let t=0;return e.map((e=>{t+=1;const n=t
;let a=l(e),s="";for(;a.length>0;){const e=p.exec(a);if(!e){s+=a;break}
s+=a.substring(0,e.index),
a=a.substring(e.index+e[0].length),"\\"===e[0][0]&&e[1]?s+="\\"+(Number(e[1])+n):(s+=e[0],
"("===e[0]&&t++)}return s})).map((e=>`(${e})`)).join(n)}
const _="[a-zA-Z]\\w*",E="[a-zA-Z_]\\w*",y="\\b\\d+(\\.\\d+)?",w="(-?)(\\b0[xX][a-fA-F0-9]+|(\\b\\d+(\\.\\d*)?|\\.\\d+)([eE][-+]?\\d+)?)",N="\\b(0b[01]+)",S={
begin:"\\\\[\\s\\S]",relevance:0},v={scope:"string",begin:"'",end:"'",
illegal:"\\n",contains:[S]},x={scope:"string",begin:'"',end:'"',illegal:"\\n",
contains:[S]},A=(e,n,t={})=>{const s=a({scope:"comment",begin:e,end:n,
contains:[]},t);s.contains.push({scope:"doctag",
begin:"[ ]*(?=(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):)",
end:/(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):/,excludeBegin:!0,relevance:0})
;const i=h("I","a","is","so","us","to","at","if","in","it","on",/[A-Za-z]+['](d|ve|re|ll|t|s|n)/,/[A-Za-z]+[-][a-z]+/,/[A-Za-z][a-z]{2,}/)
;return s.contains.push({begin:b(/[ ]+/,"(",i,/[.]?[:]?([.][ ]|[ ])/,"){3}")}),s
},O=A("//","$"),k=A("/\\*","\\*/"),R=A("#","$");var M=Object.freeze({
__proto__:null,APOS_STRING_MODE:v,BACKSLASH_ESCAPE:S,BINARY_NUMBER_MODE:{
scope:"number",begin:N,relevance:0},BINARY_NUMBER_RE:N,COMMENT:A,
C_BLOCK_COMMENT_MODE:k,C_LINE_COMMENT_MODE:O,C_NUMBER_MODE:{scope:"number",
begin:w,relevance:0},C_NUMBER_RE:w,END_SAME_AS_BEGIN:e=>Object.assign(e,{
"on:begin":(e,n)=>{n.data._beginMatch=e[1]},"on:end":(e,n)=>{
n.data._beginMatch!==e[1]&&n.ignoreMatch()}}),HASH_COMMENT_MODE:R,IDENT_RE:_,
MATCH_NOTHING_RE:/\b\B/,METHOD_GUARD:{begin:"\\.\\s*"+E,relevance:0},
NUMBER_MODE:{scope:"number",begin:y,relevance:0},NUMBER_RE:y,
PHRASAL_WORDS_MODE:{
begin:/\b(a|an|the|are|I'm|isn't|don't|doesn't|won't|but|just|should|pretty|simply|enough|gonna|going|wtf|so|such|will|you|your|they|like|more)\b/
},QUOTE_STRING_MODE:x,REGEXP_MODE:{scope:"regexp",begin:/\/(?=[^/\n]*\/)/,
end:/\/[gimuy]*/,contains:[S,{begin:/\[/,end:/\]/,relevance:0,contains:[S]}]},
RE_STARTERS_RE:"!|!=|!==|%|%=|&|&&|&=|\\*|\\*=|\\+|\\+=|,|-|-=|/=|/|:|;|<<|<<=|<=|<|===|==|=|>>>=|>>=|>=|>>>|>>|>|\\?|\\[|\\{|\\(|\\^|\\^=|\\||\\|=|\\|\\||~",
SHEBANG:(e={})=>{const n=/^#![ ]*\//
;return e.binary&&(e.begin=b(n,/.*\b/,e.binary,/\b.*/)),a({scope:"meta",begin:n,
end:/$/,relevance:0,"on:begin":(e,n)=>{0!==e.index&&n.ignoreMatch()}},e)},
TITLE_MODE:{scope:"title",begin:_,relevance:0},UNDERSCORE_IDENT_RE:E,
UNDERSCORE_TITLE_MODE:{scope:"title",begin:E,relevance:0}});function T(e,n){
"."===e.input[e.index-1]&&n.ignoreMatch()}function I(e,n){
void 0!==e.className&&(e.scope=e.className,delete e.className)}function B(e,n){
n&&e.beginKeywords&&(e.begin="\\b("+e.beginKeywords.split(" ").join("|")+")(?!\\.)(?=\\b|\\s)",
e.__beforeBegin=T,e.keywords=e.keywords||e.beginKeywords,delete e.beginKeywords,
void 0===e.relevance&&(e.relevance=0))}function C(e,n){
Array.isArray(e.illegal)&&(e.illegal=h(...e.illegal))}function L(e,n){
if(e.match){
if(e.begin||e.end)throw Error("begin & end are not supported with match")
;e.begin=e.match,delete e.match}}function $(e,n){
void 0===e.relevance&&(e.relevance=1)}const j=(e,n)=>{if(!e.beforeMatch)return
;if(e.starts)throw Error("beforeMatch cannot be used with starts")
;const t=Object.assign({},e);Object.keys(e).forEach((n=>{delete e[n]
})),e.keywords=t.keywords,e.begin=b(t.beforeMatch,g(t.begin)),e.starts={
relevance:0,contains:[Object.assign(t,{endsParent:!0})]
},e.relevance=0,delete t.beforeMatch
},D=["of","and","for","in","not","or","if","then","parent","list","value"],P="keyword"
;function H(e,n,t=P){const a=Object.create(null)
;return"string"==typeof e?s(t,e.split(" ")):Array.isArray(e)?s(t,e):Object.keys(e).forEach((t=>{
Object.assign(a,H(e[t],n,t))})),a;function s(e,t){
n&&(t=t.map((e=>e.toLowerCase()))),t.forEach((n=>{const t=n.split("|")
;a[t[0]]=[e,U(t[0],t[1])]}))}}function U(e,n){
return n?Number(n):(e=>D.includes(e.toLowerCase()))(e)?0:1}const z={},F=e=>{
console.error(e)},Z=(e,...n)=>{console.log("WARN: "+e,...n)},K=(e,n)=>{
z[`${e}/${n}`]||(console.log(`Deprecated as of ${e}. ${n}`),z[`${e}/${n}`]=!0)
},G=Error();function W(e,n,{key:t}){let a=0;const s=e[t],i={},r={}
;for(let e=1;e<=n.length;e++)r[e+a]=s[e],i[e+a]=!0,a+=f(n[e-1])
;e[t]=r,e[t]._emit=i,e[t]._multi=!0}function X(e){(e=>{
e.scope&&"object"==typeof e.scope&&null!==e.scope&&(e.beginScope=e.scope,
delete e.scope)})(e),"string"==typeof e.beginScope&&(e.beginScope={
_wrap:e.beginScope}),"string"==typeof e.endScope&&(e.endScope={_wrap:e.endScope
}),(e=>{if(Array.isArray(e.begin)){
if(e.skip||e.excludeBegin||e.returnBegin)throw F("skip, excludeBegin, returnBegin not compatible with beginScope: {}"),
G
;if("object"!=typeof e.beginScope||null===e.beginScope)throw F("beginScope must be object"),
G;W(e,e.begin,{key:"beginScope"}),e.begin=m(e.begin,{joinWith:""})}})(e),(e=>{
if(Array.isArray(e.end)){
if(e.skip||e.excludeEnd||e.returnEnd)throw F("skip, excludeEnd, returnEnd not compatible with endScope: {}"),
G
;if("object"!=typeof e.endScope||null===e.endScope)throw F("endScope must be object"),
G;W(e,e.end,{key:"endScope"}),e.end=m(e.end,{joinWith:""})}})(e)}function q(e){
function n(n,t){
return RegExp(l(n),"m"+(e.case_insensitive?"i":"")+(e.unicodeRegex?"u":"")+(t?"g":""))
}class t{constructor(){
this.matchIndexes={},this.regexes=[],this.matchAt=1,this.position=0}
addRule(e,n){
n.position=this.position++,this.matchIndexes[this.matchAt]=n,this.regexes.push([n,e]),
this.matchAt+=f(e)+1}compile(){0===this.regexes.length&&(this.exec=()=>null)
;const e=this.regexes.map((e=>e[1]));this.matcherRe=n(m(e,{joinWith:"|"
}),!0),this.lastIndex=0}exec(e){this.matcherRe.lastIndex=this.lastIndex
;const n=this.matcherRe.exec(e);if(!n)return null
;const t=n.findIndex(((e,n)=>n>0&&void 0!==e)),a=this.matchIndexes[t]
;return n.splice(0,t),Object.assign(n,a)}}class s{constructor(){
this.rules=[],this.multiRegexes=[],
this.count=0,this.lastIndex=0,this.regexIndex=0}getMatcher(e){
if(this.multiRegexes[e])return this.multiRegexes[e];const n=new t
;return this.rules.slice(e).forEach((([e,t])=>n.addRule(e,t))),
n.compile(),this.multiRegexes[e]=n,n}resumingScanAtSamePosition(){
return 0!==this.regexIndex}considerAll(){this.regexIndex=0}addRule(e,n){
this.rules.push([e,n]),"begin"===n.type&&this.count++}exec(e){
const n=this.getMatcher(this.regexIndex);n.lastIndex=this.lastIndex
;let t=n.exec(e)
;if(this.resumingScanAtSamePosition())if(t&&t.index===this.lastIndex);else{
const n=this.getMatcher(0);n.lastIndex=this.lastIndex+1,t=n.exec(e)}
return t&&(this.regexIndex+=t.position+1,
this.regexIndex===this.count&&this.considerAll()),t}}
if(e.compilerExtensions||(e.compilerExtensions=[]),
e.contains&&e.contains.includes("self"))throw Error("ERR: contains `self` is not supported at the top-level of a language.  See documentation.")
;return e.classNameAliases=a(e.classNameAliases||{}),function t(i,r){const o=i
;if(i.isCompiled)return o
;[I,L,X,j].forEach((e=>e(i,r))),e.compilerExtensions.forEach((e=>e(i,r))),
i.__beforeBegin=null,[B,C,$].forEach((e=>e(i,r))),i.isCompiled=!0;let c=null
;return"object"==typeof i.keywords&&i.keywords.$pattern&&(i.keywords=Object.assign({},i.keywords),
c=i.keywords.$pattern,
delete i.keywords.$pattern),c=c||/\w+/,i.keywords&&(i.keywords=H(i.keywords,e.case_insensitive)),
o.keywordPatternRe=n(c,!0),
r&&(i.begin||(i.begin=/\B|\b/),o.beginRe=n(o.begin),i.end||i.endsWithParent||(i.end=/\B|\b/),
i.end&&(o.endRe=n(o.end)),
o.terminatorEnd=l(o.end)||"",i.endsWithParent&&r.terminatorEnd&&(o.terminatorEnd+=(i.end?"|":"")+r.terminatorEnd)),
i.illegal&&(o.illegalRe=n(i.illegal)),
i.contains||(i.contains=[]),i.contains=[].concat(...i.contains.map((e=>(e=>(e.variants&&!e.cachedVariants&&(e.cachedVariants=e.variants.map((n=>a(e,{
variants:null},n)))),e.cachedVariants?e.cachedVariants:J(e)?a(e,{
starts:e.starts?a(e.starts):null
}):Object.isFrozen(e)?a(e):e))("self"===e?i:e)))),i.contains.forEach((e=>{t(e,o)
})),i.starts&&t(i.starts,r),o.matcher=(e=>{const n=new s
;return e.contains.forEach((e=>n.addRule(e.begin,{rule:e,type:"begin"
}))),e.terminatorEnd&&n.addRule(e.terminatorEnd,{type:"end"
}),e.illegal&&n.addRule(e.illegal,{type:"illegal"}),n})(o),o}(e)}function J(e){
return!!e&&(e.endsWithParent||J(e.starts))}class V extends Error{
constructor(e,n){super(e),this.name="HTMLInjectionError",this.html=n}}
const Q=t,Y=a,ee=Symbol("nomatch"),ne=t=>{
const a=Object.create(null),s=Object.create(null),i=[];let r=!0
;const o="Could not find the language '{}', did you forget to load/include a language module?",l={
disableAutodetect:!0,name:"Plain text",contains:[]};let f={
ignoreUnescapedHTML:!1,throwUnescapedHTML:!1,noHighlightRe:/^(no-?highlight)$/i,
languageDetectRe:/\blang(?:uage)?-([\w-]+)\b/i,classPrefix:"hljs-",
cssSelector:"pre code",languages:null,__emitter:c};function p(e){
return f.noHighlightRe.test(e)}function m(e,n,t){let a="",s=""
;"object"==typeof n?(a=e,
t=n.ignoreIllegals,s=n.language):(K("10.7.0","highlight(lang, code, ...args) has been deprecated."),
K("10.7.0","Please use highlight(code, options) instead.\nhttps://github.com/highlightjs/highlight.js/issues/2277"),
s=e,a=n),void 0===t&&(t=!0);const i={code:a,language:s};A("before:highlight",i)
;const r=i.result?i.result:_(i.language,i.code,t)
;return r.code=i.code,A("after:highlight",r),r}function _(e,t,s,i){
const c=Object.create(null);function l(){if(!A.keywords)return void k.addText(R)
;let e=0;A.keywordPatternRe.lastIndex=0;let n=A.keywordPatternRe.exec(R),t=""
;for(;n;){t+=R.substring(e,n.index)
;const s=N.case_insensitive?n[0].toLowerCase():n[0],i=(a=s,A.keywords[a]);if(i){
const[e,a]=i
;if(k.addText(t),t="",c[s]=(c[s]||0)+1,c[s]<=7&&(M+=a),e.startsWith("_"))t+=n[0];else{
const t=N.classNameAliases[e]||e;d(n[0],t)}}else t+=n[0]
;e=A.keywordPatternRe.lastIndex,n=A.keywordPatternRe.exec(R)}var a
;t+=R.substring(e),k.addText(t)}function g(){null!=A.subLanguage?(()=>{
if(""===R)return;let e=null;if("string"==typeof A.subLanguage){
if(!a[A.subLanguage])return void k.addText(R)
;e=_(A.subLanguage,R,!0,O[A.subLanguage]),O[A.subLanguage]=e._top
}else e=E(R,A.subLanguage.length?A.subLanguage:null)
;A.relevance>0&&(M+=e.relevance),k.__addSublanguage(e._emitter,e.language)
})():l(),R=""}function d(e,n){
""!==e&&(k.startScope(n),k.addText(e),k.endScope())}function u(e,n){let t=1
;const a=n.length-1;for(;t<=a;){if(!e._emit[t]){t++;continue}
const a=N.classNameAliases[e[t]]||e[t],s=n[t];a?d(s,a):(R=s,l(),R=""),t++}}
function b(e,n){
return e.scope&&"string"==typeof e.scope&&k.openNode(N.classNameAliases[e.scope]||e.scope),
e.beginScope&&(e.beginScope._wrap?(d(R,N.classNameAliases[e.beginScope._wrap]||e.beginScope._wrap),
R=""):e.beginScope._multi&&(u(e.beginScope,n),R="")),A=Object.create(e,{parent:{
value:A}}),A}function h(e,t,a){let s=((e,n)=>{const t=e&&e.exec(n)
;return t&&0===t.index})(e.endRe,a);if(s){if(e["on:end"]){const a=new n(e)
;e["on:end"](t,a),a.isMatchIgnored&&(s=!1)}if(s){
for(;e.endsParent&&e.parent;)e=e.parent;return e}}
if(e.endsWithParent)return h(e.parent,t,a)}function p(e){
return 0===A.matcher.regexIndex?(R+=e[0],1):(B=!0,0)}function m(e){
const n=e[0],a=t.substring(e.index),s=h(A,e,a);if(!s)return ee;const i=A
;A.endScope&&A.endScope._wrap?(g(),
d(n,A.endScope._wrap)):A.endScope&&A.endScope._multi?(g(),
u(A.endScope,e)):i.skip?R+=n:(i.returnEnd||i.excludeEnd||(R+=n),
g(),i.excludeEnd&&(R=n));do{
A.scope&&k.closeNode(),A.skip||A.subLanguage||(M+=A.relevance),A=A.parent
}while(A!==s.parent);return s.starts&&b(s.starts,e),i.returnEnd?0:n.length}
let y={};function w(a,i){const o=i&&i[0];if(R+=a,null==o)return g(),0
;if("begin"===y.type&&"end"===i.type&&y.index===i.index&&""===o){
if(R+=t.slice(i.index,i.index+1),!r){const n=Error(`0 width match regex (${e})`)
;throw n.languageName=e,n.badRule=y.rule,n}return 1}
if(y=i,"begin"===i.type)return(e=>{
const t=e[0],a=e.rule,s=new n(a),i=[a.__beforeBegin,a["on:begin"]]
;for(const n of i)if(n&&(n(e,s),s.isMatchIgnored))return p(t)
;return a.skip?R+=t:(a.excludeBegin&&(R+=t),
g(),a.returnBegin||a.excludeBegin||(R=t)),b(a,e),a.returnBegin?0:t.length})(i)
;if("illegal"===i.type&&!s){
const e=Error('Illegal lexeme "'+o+'" for mode "'+(A.scope||"<unnamed>")+'"')
;throw e.mode=A,e}if("end"===i.type){const e=m(i);if(e!==ee)return e}
if("illegal"===i.type&&""===o)return 1
;if(I>1e5&&I>3*i.index)throw Error("potential infinite loop, way more iterations than matches")
;return R+=o,o.length}const N=S(e)
;if(!N)throw F(o.replace("{}",e)),Error('Unknown language: "'+e+'"')
;const v=q(N);let x="",A=i||v;const O={},k=new f.__emitter(f);(()=>{const e=[]
;for(let n=A;n!==N;n=n.parent)n.scope&&e.unshift(n.scope)
;e.forEach((e=>k.openNode(e)))})();let R="",M=0,T=0,I=0,B=!1;try{
if(N.__emitTokens)N.__emitTokens(t,k);else{for(A.matcher.considerAll();;){
I++,B?B=!1:A.matcher.considerAll(),A.matcher.lastIndex=T
;const e=A.matcher.exec(t);if(!e)break;const n=w(t.substring(T,e.index),e)
;T=e.index+n}w(t.substring(T))}return k.finalize(),x=k.toHTML(),{language:e,
value:x,relevance:M,illegal:!1,_emitter:k,_top:A}}catch(n){
if(n.message&&n.message.includes("Illegal"))return{language:e,value:Q(t),
illegal:!0,relevance:0,_illegalBy:{message:n.message,index:T,
context:t.slice(T-100,T+100),mode:n.mode,resultSoFar:x},_emitter:k};if(r)return{
language:e,value:Q(t),illegal:!1,relevance:0,errorRaised:n,_emitter:k,_top:A}
;throw n}}function E(e,n){n=n||f.languages||Object.keys(a);const t=(e=>{
const n={value:Q(e),illegal:!1,relevance:0,_top:l,_emitter:new f.__emitter(f)}
;return n._emitter.addText(e),n})(e),s=n.filter(S).filter(x).map((n=>_(n,e,!1)))
;s.unshift(t);const i=s.sort(((e,n)=>{
if(e.relevance!==n.relevance)return n.relevance-e.relevance
;if(e.language&&n.language){if(S(e.language).supersetOf===n.language)return 1
;if(S(n.language).supersetOf===e.language)return-1}return 0})),[r,o]=i,c=r
;return c.secondBest=o,c}function y(e){let n=null;const t=(e=>{
let n=e.className+" ";n+=e.parentNode?e.parentNode.className:""
;const t=f.languageDetectRe.exec(n);if(t){const n=S(t[1])
;return n||(Z(o.replace("{}",t[1])),
Z("Falling back to no-highlight mode for this block.",e)),n?t[1]:"no-highlight"}
return n.split(/\s+/).find((e=>p(e)||S(e)))})(e);if(p(t))return
;if(A("before:highlightElement",{el:e,language:t
}),e.dataset.highlighted)return void console.log("Element previously highlighted. To highlight again, first unset `dataset.highlighted`.",e)
;if(e.children.length>0&&(f.ignoreUnescapedHTML||(console.warn("One of your code blocks includes unescaped HTML. This is a potentially serious security risk."),
console.warn("https://github.com/highlightjs/highlight.js/wiki/security"),
console.warn("The element with unescaped HTML:"),
console.warn(e)),f.throwUnescapedHTML))throw new V("One of your code blocks includes unescaped HTML.",e.innerHTML)
;n=e;const a=n.textContent,i=t?m(a,{language:t,ignoreIllegals:!0}):E(a)
;e.innerHTML=i.value,e.dataset.highlighted="yes",((e,n,t)=>{const a=n&&s[n]||t
;e.classList.add("hljs"),e.classList.add("language-"+a)
})(e,t,i.language),e.result={language:i.language,re:i.relevance,
relevance:i.relevance},i.secondBest&&(e.secondBest={
language:i.secondBest.language,relevance:i.secondBest.relevance
}),A("after:highlightElement",{el:e,result:i,text:a})}let w=!1;function N(){
"loading"!==document.readyState?document.querySelectorAll(f.cssSelector).forEach(y):w=!0
}function S(e){return e=(e||"").toLowerCase(),a[e]||a[s[e]]}
function v(e,{languageName:n}){"string"==typeof e&&(e=[e]),e.forEach((e=>{
s[e.toLowerCase()]=n}))}function x(e){const n=S(e)
;return n&&!n.disableAutodetect}function A(e,n){const t=e;i.forEach((e=>{
e[t]&&e[t](n)}))}
"undefined"!=typeof window&&window.addEventListener&&window.addEventListener("DOMContentLoaded",(()=>{
w&&N()}),!1),Object.assign(t,{highlight:m,highlightAuto:E,highlightAll:N,
highlightElement:y,
highlightBlock:e=>(K("10.7.0","highlightBlock will be removed entirely in v12.0"),
K("10.7.0","Please use highlightElement now."),y(e)),configure:e=>{f=Y(f,e)},
initHighlighting:()=>{
N(),K("10.6.0","initHighlighting() deprecated.  Use highlightAll() now.")},
initHighlightingOnLoad:()=>{
N(),K("10.6.0","initHighlightingOnLoad() deprecated.  Use highlightAll() now.")
},registerLanguage:(e,n)=>{let s=null;try{s=n(t)}catch(n){
if(F("Language definition for '{}' could not be registered.".replace("{}",e)),
!r)throw n;F(n),s=l}
s.name||(s.name=e),a[e]=s,s.rawDefinition=n.bind(null,t),s.aliases&&v(s.aliases,{
languageName:e})},unregisterLanguage:e=>{delete a[e]
;for(const n of Object.keys(s))s[n]===e&&delete s[n]},
listLanguages:()=>Object.keys(a),getLanguage:S,registerAliases:v,
autoDetection:x,inherit:Y,addPlugin:e=>{(e=>{
e["before:highlightBlock"]&&!e["before:highlightElement"]&&(e["before:highlightElement"]=n=>{
e["before:highlightBlock"](Object.assign({block:n.el},n))
}),e["after:highlightBlock"]&&!e["after:highlightElement"]&&(e["after:highlightElement"]=n=>{
e["after:highlightBlock"](Object.assign({block:n.el},n))})})(e),i.push(e)},
removePlugin:e=>{const n=i.indexOf(e);-1!==n&&i.splice(n,1)}}),t.debugMode=()=>{
r=!1},t.safeMode=()=>{r=!0},t.versionString="11.9.0",t.regex={concat:b,
lookahead:g,either:h,optional:u,anyNumberOfTimes:d}
;for(const n in M)"object"==typeof M[n]&&e(M[n]);return Object.assign(t,M),t
},te=ne({});te.newInstance=()=>ne({});var ae=te
;const se="[A-Za-z$_][0-9A-Za-z$_]*",ie=["as","in","of","if","for","while","finally","var","new","function","do","return","void","else","break","catch","instanceof","with","throw","case","default","try","switch","continue","typeof","delete","let","yield","const","class","debugger","async","await","static","import","from","export","extends"],re=["true","false","null","undefined","NaN","Infinity"],oe=["Object","Function","Boolean","Symbol","Math","Date","Number","BigInt","String","RegExp","Array","Float32Array","Float64Array","Int8Array","Uint8Array","Uint8ClampedArray","Int16Array","Int32Array","Uint16Array","Uint32Array","BigInt64Array","BigUint64Array","Set","Map","WeakSet","WeakMap","ArrayBuffer","SharedArrayBuffer","Atomics","DataView","JSON","Promise","Generator","GeneratorFunction","AsyncFunction","Reflect","Proxy","Intl","WebAssembly"],ce=["Error","EvalError","InternalError","RangeError","ReferenceError","SyntaxError","TypeError","URIError"],le=["setInterval","setTimeout","clearInterval","clearTimeout","require","exports","eval","isFinite","isNaN","parseFloat","parseInt","decodeURI","decodeURIComponent","encodeURI","encodeURIComponent","escape","unescape"],ge=["arguments","this","super","console","window","document","localStorage","sessionStorage","module","global"],de=[].concat(le,oe,ce)
;var ue=Object.freeze({__proto__:null,grmr_ini:e=>{const n=e.regex,t={
className:"number",relevance:0,variants:[{begin:/([+-]+)?[\d]+_[\d_]+/},{
begin:e.NUMBER_RE}]},a=e.COMMENT();a.variants=[{begin:/;/,end:/$/},{begin:/#/,
end:/$/}];const s={className:"variable",variants:[{begin:/\$[\w\d"][\w\d_]*/},{
begin:/\$\{(.*?)\}/}]},i={className:"literal",
begin:/\bon|off|true|false|yes|no\b/},r={className:"string",
contains:[e.BACKSLASH_ESCAPE],variants:[{begin:"'''",end:"'''",relevance:10},{
begin:'"""',end:'"""',relevance:10},{begin:'"',end:'"'},{begin:"'",end:"'"}]
},o={begin:/\[/,end:/\]/,contains:[a,i,s,r,t,"self"],relevance:0
},c=n.either(/[A-Za-z0-9_-]+/,/"(\\"|[^"])*"/,/'[^']*'/);return{
name:"TOML, also INI",aliases:["toml"],case_insensitive:!0,illegal:/\S/,
contains:[a,{className:"section",begin:/\[+/,end:/\]+/},{
begin:n.concat(c,"(\\s*\\.\\s*",c,")*",n.lookahead(/\s*=\s*[^#\s]/)),
className:"attr",starts:{end:/$/,contains:[a,o,i,s,r,t]}}]}},
grmr_javascript:e=>{const n=e.regex,t=se,a={begin:/<[A-Za-z0-9\\._:-]+/,
end:/\/[A-Za-z0-9\\._:-]+>|\/>/,isTrulyOpeningTag:(e,n)=>{
const t=e[0].length+e.index,a=e.input[t]
;if("<"===a||","===a)return void n.ignoreMatch();let s
;">"===a&&(((e,{after:n})=>{const t="</"+e[0].slice(1)
;return-1!==e.input.indexOf(t,n)})(e,{after:t})||n.ignoreMatch())
;const i=e.input.substring(t)
;((s=i.match(/^\s*=/))||(s=i.match(/^\s+extends\s+/))&&0===s.index)&&n.ignoreMatch()
}},s={$pattern:se,keyword:ie,literal:re,built_in:de,"variable.language":ge
},i="[0-9](_?[0-9])*",r=`\\.(${i})`,o="0|[1-9](_?[0-9])*|0[0-7]*[89][0-9]*",c={
className:"number",variants:[{
begin:`(\\b(${o})((${r})|\\.)?|(${r}))[eE][+-]?(${i})\\b`},{
begin:`\\b(${o})\\b((${r})\\b|\\.)?|(${r})\\b`},{
begin:"\\b(0|[1-9](_?[0-9])*)n\\b"},{
begin:"\\b0[xX][0-9a-fA-F](_?[0-9a-fA-F])*n?\\b"},{
begin:"\\b0[bB][0-1](_?[0-1])*n?\\b"},{begin:"\\b0[oO][0-7](_?[0-7])*n?\\b"},{
begin:"\\b0[0-7]+n?\\b"}],relevance:0},l={className:"subst",begin:"\\$\\{",
end:"\\}",keywords:s,contains:[]},g={begin:"html`",end:"",starts:{end:"`",
returnEnd:!1,contains:[e.BACKSLASH_ESCAPE,l],subLanguage:"xml"}},d={
begin:"css`",end:"",starts:{end:"`",returnEnd:!1,
contains:[e.BACKSLASH_ESCAPE,l],subLanguage:"css"}},u={begin:"gql`",end:"",
starts:{end:"`",returnEnd:!1,contains:[e.BACKSLASH_ESCAPE,l],
subLanguage:"graphql"}},b={className:"string",begin:"`",end:"`",
contains:[e.BACKSLASH_ESCAPE,l]},h={className:"comment",
variants:[e.COMMENT(/\/\*\*(?!\/)/,"\\*/",{relevance:0,contains:[{
begin:"(?=@[A-Za-z]+)",relevance:0,contains:[{className:"doctag",
begin:"@[A-Za-z]+"},{className:"type",begin:"\\{",end:"\\}",excludeEnd:!0,
excludeBegin:!0,relevance:0},{className:"variable",begin:t+"(?=\\s*(-)|$)",
endsParent:!0,relevance:0},{begin:/(?=[^\n])\s/,relevance:0}]}]
}),e.C_BLOCK_COMMENT_MODE,e.C_LINE_COMMENT_MODE]
},f=[e.APOS_STRING_MODE,e.QUOTE_STRING_MODE,g,d,u,b,{match:/\$\d+/},c]
;l.contains=f.concat({begin:/\{/,end:/\}/,keywords:s,contains:["self"].concat(f)
});const p=[].concat(h,l.contains),m=p.concat([{begin:/(\s*)\(/,end:/\)/,
keywords:s,contains:["self"].concat(p)}]),_={className:"params",begin:/(\s*)\(/,
end:/\)/,excludeBegin:!0,excludeEnd:!0,keywords:s,contains:m},E={variants:[{
match:[/class/,/\s+/,t,/\s+/,/extends/,/\s+/,n.concat(t,"(",n.concat(/\./,t),")*")],
scope:{1:"keyword",3:"title.class",5:"keyword",7:"title.class.inherited"}},{
match:[/class/,/\s+/,t],scope:{1:"keyword",3:"title.class"}}]},y={relevance:0,
match:n.either(/\bJSON/,/\b[A-Z][a-z]+([A-Z][a-z]*|\d)*/,/\b[A-Z]{2,}([A-Z][a-z]+|\d)+([A-Z][a-z]*)*/,/\b[A-Z]{2,}[a-z]+([A-Z][a-z]+|\d)*([A-Z][a-z]*)*/),
className:"title.class",keywords:{_:[...oe,...ce]}},w={variants:[{
match:[/function/,/\s+/,t,/(?=\s*\()/]},{match:[/function/,/\s*(?=\()/]}],
className:{1:"keyword",3:"title.function"},label:"func.def",contains:[_],
illegal:/%/},N={
match:n.concat(/\b/,(S=[...le,"super","import"].map((e=>e+"\\s*\\(")),
n.concat("(?!",S.join("|"),")")),t,n.lookahead(/\s*\(/)),
className:"title.function",relevance:0};var S;const v={
begin:n.concat(/\./,n.lookahead(n.concat(t,/(?![0-9A-Za-z$_(])/))),end:t,
excludeBegin:!0,keywords:"prototype",className:"property",relevance:0},x={
match:[/get|set/,/\s+/,t,/(?=\()/],className:{1:"keyword",3:"title.function"},
contains:[{begin:/\(\)/},_]
},A="(\\([^()]*(\\([^()]*(\\([^()]*\\)[^()]*)*\\)[^()]*)*\\)|"+e.UNDERSCORE_IDENT_RE+")\\s*=>",O={
match:[/const|var|let/,/\s+/,t,/\s*/,/=\s*/,/(async\s*)?/,n.lookahead(A)],
keywords:"async",className:{1:"keyword",3:"title.function"},contains:[_]}
;return{name:"JavaScript",aliases:["js","jsx","mjs","cjs"],keywords:s,exports:{
PARAMS_CONTAINS:m,CLASS_REFERENCE:y},illegal:/#(?![$_A-z])/,
contains:[e.SHEBANG({label:"shebang",binary:"node",relevance:5}),{
label:"use_strict",className:"meta",relevance:10,
begin:/^\s*['"]use (strict|asm)['"]/
},e.APOS_STRING_MODE,e.QUOTE_STRING_MODE,g,d,u,b,h,{match:/\$\d+/},c,y,{
className:"attr",begin:t+n.lookahead(":"),relevance:0},O,{
begin:"("+e.RE_STARTERS_RE+"|\\b(case|return|throw)\\b)\\s*",
keywords:"return throw case",relevance:0,contains:[h,e.REGEXP_MODE,{
className:"function",begin:A,returnBegin:!0,end:"\\s*=>",contains:[{
className:"params",variants:[{begin:e.UNDERSCORE_IDENT_RE,relevance:0},{
className:null,begin:/\(\s*\)/,skip:!0},{begin:/(\s*)\(/,end:/\)/,
excludeBegin:!0,excludeEnd:!0,keywords:s,contains:m}]}]},{begin:/,/,relevance:0
},{match:/\s+/,relevance:0},{variants:[{begin:"<>",end:"</>"},{
match:/<[A-Za-z0-9\\._:-]+\s*\/>/},{begin:a.begin,
"on:begin":a.isTrulyOpeningTag,end:a.end}],subLanguage:"xml",contains:[{
begin:a.begin,end:a.end,skip:!0,contains:["self"]}]}]},w,{
beginKeywords:"while if switch catch for"},{
begin:"\\b(?!function)"+e.UNDERSCORE_IDENT_RE+"\\([^()]*(\\([^()]*(\\([^()]*\\)[^()]*)*\\)[^()]*)*\\)\\s*\\{",
returnBegin:!0,label:"func.def",contains:[_,e.inherit(e.TITLE_MODE,{begin:t,
className:"title.function"})]},{match:/\.\.\./,relevance:0},v,{match:"\\$"+t,
relevance:0},{match:[/\bconstructor(?=\s*\()/],className:{1:"title.function"},
contains:[_]},N,{relevance:0,match:/\b[A-Z][A-Z_0-9]+\b/,
className:"variable.constant"},E,x,{match:/\$[(.]/}]}},grmr_makefile:e=>{
const n={className:"variable",variants:[{
begin:"\\$\\("+e.UNDERSCORE_IDENT_RE+"\\)",contains:[e.BACKSLASH_ESCAPE]},{
begin:/\$[@%<?\^\+\*]/}]},t={className:"string",begin:/"/,end:/"/,
contains:[e.BACKSLASH_ESCAPE,n]},a={className:"variable",begin:/\$\([\w-]+\s/,
end:/\)/,keywords:{
built_in:"subst patsubst strip findstring filter filter-out sort word wordlist firstword lastword dir notdir suffix basename addsuffix addprefix join wildcard realpath abspath error warning shell origin flavor foreach if or and call eval file value"
},contains:[n]},s={begin:"^"+e.UNDERSCORE_IDENT_RE+"\\s*(?=[:+?]?=)"},i={
className:"section",begin:/^[^\s]+:/,end:/$/,contains:[n]};return{
name:"Makefile",aliases:["mk","mak","make"],keywords:{$pattern:/[\w-]+/,
keyword:"define endef undefine ifdef ifndef ifeq ifneq else endif include -include sinclude override export unexport private vpath"
},contains:[e.HASH_COMMENT_MODE,n,t,a,s,{className:"meta",begin:/^\.PHONY:/,
end:/$/,keywords:{$pattern:/[\.\w]+/,keyword:".PHONY"}},i]}},grmr_nix:e=>{
const n={
keyword:["rec","with","let","in","inherit","assert","if","else","then"],
literal:["true","false","or","and","null"],
built_in:["import","abort","baseNameOf","dirOf","isNull","builtins","map","removeAttrs","throw","toString","derivation"]
},t={className:"subst",begin:/\$\{/,end:/\}/,keywords:n},a={className:"string",
contains:[{className:"char.escape",begin:/''\$/},t],variants:[{begin:"''",
end:"''"},{begin:'"',end:'"'}]
},s=[e.NUMBER_MODE,e.HASH_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE,a,{
begin:/[a-zA-Z0-9-_]+(\s*=)/,returnBegin:!0,relevance:0,contains:[{
className:"attr",begin:/\S+/,relevance:.2}]}];return t.contains=s,{name:"Nix",
aliases:["nixos"],keywords:n,contains:s}},grmr_python:e=>{
const n=e.regex,t=/[\p{XID_Start}_]\p{XID_Continue}*/u,a=["and","as","assert","async","await","break","case","class","continue","def","del","elif","else","except","finally","for","from","global","if","import","in","is","lambda","match","nonlocal|10","not","or","pass","raise","return","try","while","with","yield"],s={
$pattern:/[A-Za-z]\w+|__\w+__/,keyword:a,
built_in:["__import__","abs","all","any","ascii","bin","bool","breakpoint","bytearray","bytes","callable","chr","classmethod","compile","complex","delattr","dict","dir","divmod","enumerate","eval","exec","filter","float","format","frozenset","getattr","globals","hasattr","hash","help","hex","id","input","int","isinstance","issubclass","iter","len","list","locals","map","max","memoryview","min","next","object","oct","open","ord","pow","print","property","range","repr","reversed","round","set","setattr","slice","sorted","staticmethod","str","sum","super","tuple","type","vars","zip"],
literal:["__debug__","Ellipsis","False","None","NotImplemented","True"],
type:["Any","Callable","Coroutine","Dict","List","Literal","Generic","Optional","Sequence","Set","Tuple","Type","Union"]
},i={className:"meta",begin:/^(>>>|\.\.\.) /},r={className:"subst",begin:/\{/,
end:/\}/,keywords:s,illegal:/#/},o={begin:/\{\{/,relevance:0},c={
className:"string",contains:[e.BACKSLASH_ESCAPE],variants:[{
begin:/([uU]|[bB]|[rR]|[bB][rR]|[rR][bB])?'''/,end:/'''/,
contains:[e.BACKSLASH_ESCAPE,i],relevance:10},{
begin:/([uU]|[bB]|[rR]|[bB][rR]|[rR][bB])?"""/,end:/"""/,
contains:[e.BACKSLASH_ESCAPE,i],relevance:10},{
begin:/([fF][rR]|[rR][fF]|[fF])'''/,end:/'''/,
contains:[e.BACKSLASH_ESCAPE,i,o,r]},{begin:/([fF][rR]|[rR][fF]|[fF])"""/,
end:/"""/,contains:[e.BACKSLASH_ESCAPE,i,o,r]},{begin:/([uU]|[rR])'/,end:/'/,
relevance:10},{begin:/([uU]|[rR])"/,end:/"/,relevance:10},{
begin:/([bB]|[bB][rR]|[rR][bB])'/,end:/'/},{begin:/([bB]|[bB][rR]|[rR][bB])"/,
end:/"/},{begin:/([fF][rR]|[rR][fF]|[fF])'/,end:/'/,
contains:[e.BACKSLASH_ESCAPE,o,r]},{begin:/([fF][rR]|[rR][fF]|[fF])"/,end:/"/,
contains:[e.BACKSLASH_ESCAPE,o,r]},e.APOS_STRING_MODE,e.QUOTE_STRING_MODE]
},l="[0-9](_?[0-9])*",g=`(\\b(${l}))?\\.(${l})|\\b(${l})\\.`,d="\\b|"+a.join("|"),u={
className:"number",relevance:0,variants:[{
begin:`(\\b(${l})|(${g}))[eE][+-]?(${l})[jJ]?(?=${d})`},{begin:`(${g})[jJ]?`},{
begin:`\\b([1-9](_?[0-9])*|0+(_?0)*)[lLjJ]?(?=${d})`},{
begin:`\\b0[bB](_?[01])+[lL]?(?=${d})`},{begin:`\\b0[oO](_?[0-7])+[lL]?(?=${d})`
},{begin:`\\b0[xX](_?[0-9a-fA-F])+[lL]?(?=${d})`},{begin:`\\b(${l})[jJ](?=${d})`
}]},b={className:"comment",begin:n.lookahead(/# type:/),end:/$/,keywords:s,
contains:[{begin:/# type:/},{begin:/#/,end:/\b\B/,endsWithParent:!0}]},h={
className:"params",variants:[{className:"",begin:/\(\s*\)/,skip:!0},{begin:/\(/,
end:/\)/,excludeBegin:!0,excludeEnd:!0,keywords:s,
contains:["self",i,u,c,e.HASH_COMMENT_MODE]}]};return r.contains=[c,u,i],{
name:"Python",aliases:["py","gyp","ipython"],unicodeRegex:!0,keywords:s,
illegal:/(<\/|\?)|=>/,contains:[i,u,{begin:/\bself\b/},{beginKeywords:"if",
relevance:0},{match:/\bor\b/,scope:"keyword"},c,b,e.HASH_COMMENT_MODE,{
match:[/\bdef/,/\s+/,t],scope:{1:"keyword",3:"title.function"},contains:[h]},{
variants:[{match:[/\bclass/,/\s+/,t,/\s*/,/\(\s*/,t,/\s*\)/]},{
match:[/\bclass/,/\s+/,t]}],scope:{1:"keyword",3:"title.class",
6:"title.class.inherited"}},{className:"meta",begin:/^[\t ]*@/,end:/(?=#)|$/,
contains:[u,h,c]}]}},grmr_python_repl:e=>({aliases:["pycon"],contains:[{
className:"meta.prompt",starts:{end:/ |$/,starts:{end:"$",subLanguage:"python"}
},variants:[{begin:/^>>>(?=[ ]|$)/},{begin:/^\.\.\.(?=[ ]|$)/}]}]}),
grmr_rust:e=>{
const n=e.regex,t=/(r#)?/,a=n.concat(t,e.UNDERSCORE_IDENT_RE),s=n.concat(t,e.IDENT_RE),i={
className:"title.function.invoke",relevance:0,
begin:n.concat(/\b/,/(?!let|for|while|if|else|match\b)/,s,n.lookahead(/\s*\(/))
},r="([ui](8|16|32|64|128|size)|f(32|64))?",o=["drop ","Copy","Send","Sized","Sync","Drop","Fn","FnMut","FnOnce","ToOwned","Clone","Debug","PartialEq","PartialOrd","Eq","Ord","AsRef","AsMut","Into","From","Default","Iterator","Extend","IntoIterator","DoubleEndedIterator","ExactSizeIterator","SliceConcatExt","ToString","assert!","assert_eq!","bitflags!","bytes!","cfg!","col!","concat!","concat_idents!","debug_assert!","debug_assert_eq!","env!","eprintln!","panic!","file!","format!","format_args!","include_bytes!","include_str!","line!","local_data_key!","module_path!","option_env!","print!","println!","select!","stringify!","try!","unimplemented!","unreachable!","vec!","write!","writeln!","macro_rules!","assert_ne!","debug_assert_ne!"],c=["i8","i16","i32","i64","i128","isize","u8","u16","u32","u64","u128","usize","f32","f64","str","char","bool","Box","Option","Result","String","Vec"]
;return{name:"Rust",aliases:["rs"],keywords:{$pattern:e.IDENT_RE+"!?",type:c,
keyword:["abstract","as","async","await","become","box","break","const","continue","crate","do","dyn","else","enum","extern","false","final","fn","for","if","impl","in","let","loop","macro","match","mod","move","mut","override","priv","pub","ref","return","self","Self","static","struct","super","trait","true","try","type","typeof","union","unsafe","unsized","use","virtual","where","while","yield"],
literal:["true","false","Some","None","Ok","Err"],built_in:o},illegal:"</",
contains:[e.C_LINE_COMMENT_MODE,e.COMMENT("/\\*","\\*/",{contains:["self"]
}),e.inherit(e.QUOTE_STRING_MODE,{begin:/b?"/,illegal:null}),{
className:"string",variants:[{begin:/b?r(#*)"(.|\n)*?"\1(?!#)/},{
begin:/b?'\\?(x\w{2}|u\w{4}|U\w{8}|.)'/}]},{className:"symbol",
begin:/'[a-zA-Z_][a-zA-Z0-9_]*/},{className:"number",variants:[{
begin:"\\b0b([01_]+)"+r},{begin:"\\b0o([0-7_]+)"+r},{
begin:"\\b0x([A-Fa-f0-9_]+)"+r},{
begin:"\\b(\\d[\\d_]*(\\.[0-9_]+)?([eE][+-]?[0-9_]+)?)"+r}],relevance:0},{
begin:[/fn/,/\s+/,a],className:{1:"keyword",3:"title.function"}},{
className:"meta",begin:"#!?\\[",end:"\\]",contains:[{className:"string",
begin:/"/,end:/"/,contains:[e.BACKSLASH_ESCAPE]}]},{
begin:[/let/,/\s+/,/(?:mut\s+)?/,a],className:{1:"keyword",3:"keyword",
4:"variable"}},{begin:[/for/,/\s+/,a,/\s+/,/in/],className:{1:"keyword",
3:"variable",5:"keyword"}},{begin:[/type/,/\s+/,a],className:{1:"keyword",
3:"title.class"}},{begin:[/(?:trait|enum|struct|union|impl|for)/,/\s+/,a],
className:{1:"keyword",3:"title.class"}},{begin:e.IDENT_RE+"::",keywords:{
keyword:"Self",built_in:o,type:c}},{className:"punctuation",begin:"->"},i]}}})
;const be=ae;for(const e of Object.keys(ue)){
const n=e.replace("grmr_","").replace("_","-");be.registerLanguage(n,ue[e])}
return be}()
;"object"==typeof exports&&"undefined"!=typeof module&&(module.exports=hljs);
