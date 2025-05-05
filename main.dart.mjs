// Compiles a dart2wasm-generated main module from `source` which can then
// instantiatable via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm modules from `bytes` which is then
// instantiatable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export async function instantiate(modulePromise, importObjectPromise) {
  var moduleOrCompiledApp = await modulePromise;
  if (!(moduleOrCompiledApp instanceof CompiledApp)) {
    moduleOrCompiledApp = new CompiledApp(moduleOrCompiledApp);
  }
  const instantiatedApp = await moduleOrCompiledApp.instantiate(await importObjectPromise);
  return instantiatedApp.instantiatedModule;
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export const invoke = (moduleInstance, ...args) => {
  moduleInstance.exports.$invokeMain(args);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredWasm` is a JS function that takes a module name matching a
  //   wasm file produced by the dart2wasm compiler and returns the bytes to
  //   load the module. These bytes can be in either a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  // `loadDynamicModule` is a JS function that takes two string names matching,
  //   in order, a wasm file produced by the dart2wasm compiler during dynamic
  //   module compilation and a corresponding js file produced by the same
  //   compilation. It should return a JS Array containing 2 elements. The first
  //   should be the bytes for the wasm module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The second
  //   should be the result of using the JS 'import' API on the js file path.
  async instantiate(additionalImports, {loadDeferredWasm, loadDynamicModule} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + js;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            _4: (o, c) => o instanceof c,
      _7: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._7(f,arguments.length,x0) }),
      _8: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._8(f,arguments.length,x0) }),
      _37: x0 => new Array(x0),
      _39: x0 => x0.length,
      _41: (x0,x1) => x0[x1],
      _42: (x0,x1,x2) => x0[x1] = x2,
      _43: x0 => new Promise(x0),
      _45: (x0,x1,x2) => new DataView(x0,x1,x2),
      _47: x0 => new Int8Array(x0),
      _48: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _49: x0 => new Uint8Array(x0),
      _51: x0 => new Uint8ClampedArray(x0),
      _53: x0 => new Int16Array(x0),
      _55: x0 => new Uint16Array(x0),
      _57: x0 => new Int32Array(x0),
      _59: x0 => new Uint32Array(x0),
      _61: x0 => new Float32Array(x0),
      _63: x0 => new Float64Array(x0),
      _65: (x0,x1,x2) => x0.call(x1,x2),
      _70: (decoder, codeUnits) => decoder.decode(codeUnits),
      _71: () => new TextDecoder("utf-8", {fatal: true}),
      _72: () => new TextDecoder("utf-8", {fatal: false}),
      _73: (s) => +s,
      _74: x0 => new Uint8Array(x0),
      _75: (x0,x1,x2) => x0.set(x1,x2),
      _76: (x0,x1) => x0.transferFromImageBitmap(x1),
      _78: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._78(f,arguments.length,x0) }),
      _79: x0 => new window.FinalizationRegistry(x0),
      _80: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      _81: (x0,x1) => x0.unregister(x1),
      _82: (x0,x1,x2) => x0.slice(x1,x2),
      _83: (x0,x1) => x0.decode(x1),
      _84: (x0,x1) => x0.segment(x1),
      _85: () => new TextDecoder(),
      _87: x0 => x0.buffer,
      _88: x0 => x0.wasmMemory,
      _89: () => globalThis.window._flutter_skwasmInstance,
      _90: x0 => x0.rasterStartMilliseconds,
      _91: x0 => x0.rasterEndMilliseconds,
      _92: x0 => x0.imageBitmaps,
      _119: x0 => x0.remove(),
      _120: (x0,x1) => x0.append(x1),
      _121: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _124: (x0,x1) => x0.removeChild(x1),
      _201: x0 => x0.stopPropagation(),
      _202: x0 => x0.preventDefault(),
      _204: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _248: x0 => x0.select(),
      _249: (x0,x1) => x0.execCommand(x1),
      _251: x0 => x0.unlock(),
      _252: x0 => x0.getReader(),
      _253: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _254: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _255: (x0,x1) => x0.item(x1),
      _256: x0 => x0.next(),
      _257: x0 => x0.now(),
      _258: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._258(f,arguments.length,x0) }),
      _259: (x0,x1) => x0.addListener(x1),
      _260: (x0,x1) => x0.removeListener(x1),
      _261: (x0,x1) => x0.matchMedia(x1),
      _268: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._268(f,arguments.length,x0) }),
      _269: (x0,x1) => x0.getModifierState(x1),
      _270: (x0,x1) => x0.removeProperty(x1),
      _271: (x0,x1) => x0.prepend(x1),
      _272: x0 => x0.disconnect(),
      _273: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._273(f,arguments.length,x0) }),
      _274: x0 => x0.blur(),
      _275: x0 => x0.hasFocus(),
      _276: (x0,x1) => x0.hasAttribute(x1),
      _277: (x0,x1) => x0.getModifierState(x1),
      _282: (x0,x1) => x0.appendChild(x1),
      _283: (x0,x1) => x0.createTextNode(x1),
      _284: (x0,x1) => x0.removeAttribute(x1),
      _285: x0 => x0.getBoundingClientRect(),
      _286: (x0,x1) => x0.contains(x1),
      _287: (x0,x1) => x0.observe(x1),
      _288: x0 => x0.disconnect(),
      _289: (x0,x1) => x0.closest(x1),
      _290: (x0,x1) => x0.getAttribute(x1),
      _700: () => globalThis.window.flutterConfiguration,
      _701: x0 => x0.assetBase,
      _707: x0 => x0.debugShowSemanticsNodes,
      _708: x0 => x0.hostElement,
      _709: x0 => x0.multiViewEnabled,
      _710: x0 => x0.nonce,
      _712: x0 => x0.fontFallbackBaseUrl,
      _716: x0 => x0.console,
      _717: x0 => x0.devicePixelRatio,
      _718: x0 => x0.document,
      _719: x0 => x0.history,
      _720: x0 => x0.innerHeight,
      _721: x0 => x0.innerWidth,
      _722: x0 => x0.location,
      _723: x0 => x0.navigator,
      _724: x0 => x0.visualViewport,
      _725: x0 => x0.performance,
      _729: (x0,x1) => x0.getComputedStyle(x1),
      _730: x0 => x0.screen,
      _731: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._731(f,arguments.length,x0) }),
      _732: (x0,x1) => x0.requestAnimationFrame(x1),
      _737: (x0,x1) => x0.warn(x1),
      _740: () => globalThis.window,
      _741: () => globalThis.Intl,
      _742: () => globalThis.Symbol,
      _745: x0 => x0.clipboard,
      _746: x0 => x0.maxTouchPoints,
      _747: x0 => x0.vendor,
      _748: x0 => x0.language,
      _749: x0 => x0.platform,
      _750: x0 => x0.userAgent,
      _751: x0 => x0.languages,
      _752: x0 => x0.documentElement,
      _753: (x0,x1) => x0.querySelector(x1),
      _756: (x0,x1) => x0.createElement(x1),
      _759: (x0,x1) => x0.createEvent(x1),
      _760: x0 => x0.activeElement,
      _763: x0 => x0.head,
      _764: x0 => x0.body,
      _765: (x0,x1) => x0.title = x1,
      _769: x0 => x0.visibilityState,
      _770: () => globalThis.document,
      _771: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._771(f,arguments.length,x0) }),
      _772: (x0,x1) => x0.dispatchEvent(x1),
      _780: x0 => x0.target,
      _782: x0 => x0.timeStamp,
      _783: x0 => x0.type,
      _785: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      _792: x0 => x0.firstChild,
      _796: x0 => x0.parentElement,
      _798: (x0,x1) => x0.textContent = x1,
      _799: x0 => x0.parentNode,
      _801: x0 => x0.isConnected,
      _805: x0 => x0.firstElementChild,
      _807: x0 => x0.nextElementSibling,
      _808: x0 => x0.clientHeight,
      _809: x0 => x0.clientWidth,
      _810: x0 => x0.offsetHeight,
      _811: x0 => x0.offsetWidth,
      _812: x0 => x0.id,
      _813: (x0,x1) => x0.id = x1,
      _816: (x0,x1) => x0.spellcheck = x1,
      _817: x0 => x0.tagName,
      _818: x0 => x0.style,
      _820: (x0,x1) => x0.querySelectorAll(x1),
      _821: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _823: (x0,x1) => x0.tabIndex = x1,
      _824: (x0,x1) => x0.focus(x1),
      _825: (x0,x1) => x0.scrollTop = x1,
      _826: x0 => x0.scrollTop,
      _827: x0 => x0.scrollLeft,
      _828: (x0,x1) => x0.scrollLeft = x1,
      _829: x0 => x0.classList,
      _831: (x0,x1) => x0.className = x1,
      _833: (x0,x1) => x0.getElementsByClassName(x1),
      _834: x0 => x0.click(),
      _835: (x0,x1) => x0.attachShadow(x1),
      _840: (x0,x1) => x0.getPropertyValue(x1),
      _841: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      _842: x0 => x0.offsetLeft,
      _843: x0 => x0.offsetTop,
      _844: x0 => x0.offsetParent,
      _845: (x0,x1) => x0.name = x1,
      _847: (x0,x1) => x0.content = x1,
      _848: x0 => x0.content,
      _866: (x0,x1) => x0.nonce = x1,
      _871: (x0,x1) => x0.width = x1,
      _873: (x0,x1) => x0.height = x1,
      _876: (x0,x1) => x0.getContext(x1),
      _935: (x0,x1) => x0.fetch(x1),
      _936: x0 => x0.status,
      _938: x0 => x0.body,
      _939: x0 => x0.arrayBuffer(),
      _942: x0 => x0.read(),
      _943: x0 => x0.value,
      _944: x0 => x0.done,
      _947: x0 => x0.x,
      _948: x0 => x0.y,
      _951: x0 => x0.top,
      _952: x0 => x0.right,
      _953: x0 => x0.bottom,
      _954: x0 => x0.left,
      _966: x0 => x0.height,
      _967: x0 => x0.width,
      _968: x0 => x0.scale,
      _969: (x0,x1) => x0.value = x1,
      _971: (x0,x1) => x0.placeholder = x1,
      _973: (x0,x1) => x0.name = x1,
      _974: x0 => x0.selectionDirection,
      _975: x0 => x0.selectionStart,
      _976: x0 => x0.selectionEnd,
      _979: x0 => x0.value,
      _981: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _982: x0 => x0.readText(),
      _983: (x0,x1) => x0.writeText(x1),
      _985: x0 => x0.altKey,
      _986: x0 => x0.code,
      _987: x0 => x0.ctrlKey,
      _988: x0 => x0.key,
      _989: x0 => x0.keyCode,
      _990: x0 => x0.location,
      _991: x0 => x0.metaKey,
      _992: x0 => x0.repeat,
      _993: x0 => x0.shiftKey,
      _994: x0 => x0.isComposing,
      _996: x0 => x0.state,
      _997: (x0,x1) => x0.go(x1),
      _999: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      _1000: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      _1001: x0 => x0.pathname,
      _1002: x0 => x0.search,
      _1003: x0 => x0.hash,
      _1007: x0 => x0.state,
      _1014: x0 => new MutationObserver(x0),
      _1015: (x0,x1,x2) => x0.observe(x1,x2),
      _1016: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1016(f,arguments.length,x0,x1) }),
      _1019: x0 => x0.attributeName,
      _1020: x0 => x0.type,
      _1021: x0 => x0.matches,
      _1022: x0 => x0.matches,
      _1026: x0 => x0.relatedTarget,
      _1028: x0 => x0.clientX,
      _1029: x0 => x0.clientY,
      _1030: x0 => x0.offsetX,
      _1031: x0 => x0.offsetY,
      _1034: x0 => x0.button,
      _1035: x0 => x0.buttons,
      _1036: x0 => x0.ctrlKey,
      _1040: x0 => x0.pointerId,
      _1041: x0 => x0.pointerType,
      _1042: x0 => x0.pressure,
      _1043: x0 => x0.tiltX,
      _1044: x0 => x0.tiltY,
      _1045: x0 => x0.getCoalescedEvents(),
      _1048: x0 => x0.deltaX,
      _1049: x0 => x0.deltaY,
      _1050: x0 => x0.wheelDeltaX,
      _1051: x0 => x0.wheelDeltaY,
      _1052: x0 => x0.deltaMode,
      _1059: x0 => x0.changedTouches,
      _1062: x0 => x0.clientX,
      _1063: x0 => x0.clientY,
      _1066: x0 => x0.data,
      _1069: (x0,x1) => x0.disabled = x1,
      _1071: (x0,x1) => x0.type = x1,
      _1072: (x0,x1) => x0.max = x1,
      _1073: (x0,x1) => x0.min = x1,
      _1074: x0 => x0.value,
      _1075: (x0,x1) => x0.value = x1,
      _1076: x0 => x0.disabled,
      _1077: (x0,x1) => x0.disabled = x1,
      _1079: (x0,x1) => x0.placeholder = x1,
      _1081: (x0,x1) => x0.name = x1,
      _1082: (x0,x1) => x0.autocomplete = x1,
      _1084: x0 => x0.selectionDirection,
      _1085: x0 => x0.selectionStart,
      _1087: x0 => x0.selectionEnd,
      _1090: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1091: (x0,x1) => x0.add(x1),
      _1094: (x0,x1) => x0.noValidate = x1,
      _1095: (x0,x1) => x0.method = x1,
      _1096: (x0,x1) => x0.action = x1,
      _1121: x0 => x0.orientation,
      _1122: x0 => x0.width,
      _1123: x0 => x0.height,
      _1124: (x0,x1) => x0.lock(x1),
      _1143: x0 => new ResizeObserver(x0),
      _1146: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1146(f,arguments.length,x0,x1) }),
      _1154: x0 => x0.length,
      _1155: x0 => x0.iterator,
      _1156: x0 => x0.Segmenter,
      _1157: x0 => x0.v8BreakIterator,
      _1158: (x0,x1) => new Intl.Segmenter(x0,x1),
      _1159: x0 => x0.done,
      _1160: x0 => x0.value,
      _1161: x0 => x0.index,
      _1165: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      _1166: (x0,x1) => x0.adoptText(x1),
      _1167: x0 => x0.first(),
      _1168: x0 => x0.next(),
      _1169: x0 => x0.current(),
      _1175: x0 => x0.hostElement,
      _1176: x0 => x0.viewConstraints,
      _1179: x0 => x0.maxHeight,
      _1180: x0 => x0.maxWidth,
      _1181: x0 => x0.minHeight,
      _1182: x0 => x0.minWidth,
      _1183: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1183(f,arguments.length,x0) }),
      _1184: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1184(f,arguments.length,x0) }),
      _1185: (x0,x1) => ({addView: x0,removeView: x1}),
      _1186: x0 => x0.loader,
      _1187: () => globalThis._flutter,
      _1188: (x0,x1) => x0.didCreateEngineInitializer(x1),
      _1189: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1189(f,arguments.length,x0) }),
      _1190: f => finalizeWrapper(f, function() { return dartInstance.exports._1190(f,arguments.length) }),
      _1191: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      _1192: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1192(f,arguments.length,x0) }),
      _1193: x0 => ({runApp: x0}),
      _1194: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1194(f,arguments.length,x0,x1) }),
      _1195: x0 => x0.length,
      _1267: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1286: Date.now,
      _1288: s => new Date(s * 1000).getTimezoneOffset() * 60,
      _1289: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      _1290: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _1291: () => typeof dartUseDateNowForTicks !== "undefined",
      _1292: () => 1000 * performance.now(),
      _1293: () => Date.now(),
      _1296: () => new WeakMap(),
      _1297: (map, o) => map.get(o),
      _1298: (map, o, v) => map.set(o, v),
      _1299: x0 => new WeakRef(x0),
      _1300: x0 => x0.deref(),
      _1306: () => globalThis.WeakRef,
      _1311: s => JSON.stringify(s),
      _1312: s => printToConsole(s),
      _1313: (o, p, r) => o.replaceAll(p, () => r),
      _1315: Function.prototype.call.bind(String.prototype.toLowerCase),
      _1316: s => s.toUpperCase(),
      _1317: s => s.trim(),
      _1318: s => s.trimLeft(),
      _1319: s => s.trimRight(),
      _1320: (string, times) => string.repeat(times),
      _1321: Function.prototype.call.bind(String.prototype.indexOf),
      _1322: (s, p, i) => s.lastIndexOf(p, i),
      _1323: (string, token) => string.split(token),
      _1324: Object.is,
      _1325: (a, i) => a.push(i),
      _1329: a => a.pop(),
      _1330: (a, i) => a.splice(i, 1),
      _1331: (a, s) => a.join(s),
      _1332: (a, s, e) => a.slice(s, e),
      _1334: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      _1335: a => a.length,
      _1337: (a, i) => a[i],
      _1338: (a, i, v) => a[i] = v,
      _1340: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      _1341: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _1342: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _1343: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _1344: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _1345: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _1346: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _1347: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _1349: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      _1350: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _1351: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _1352: (t, s) => t.set(s),
      _1354: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _1356: o => o.buffer,
      _1357: o => o.byteOffset,
      _1358: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _1359: (b, o) => new DataView(b, o),
      _1360: (b, o, l) => new DataView(b, o, l),
      _1361: Function.prototype.call.bind(DataView.prototype.getUint8),
      _1362: Function.prototype.call.bind(DataView.prototype.setUint8),
      _1363: Function.prototype.call.bind(DataView.prototype.getInt8),
      _1364: Function.prototype.call.bind(DataView.prototype.setInt8),
      _1365: Function.prototype.call.bind(DataView.prototype.getUint16),
      _1366: Function.prototype.call.bind(DataView.prototype.setUint16),
      _1367: Function.prototype.call.bind(DataView.prototype.getInt16),
      _1368: Function.prototype.call.bind(DataView.prototype.setInt16),
      _1369: Function.prototype.call.bind(DataView.prototype.getUint32),
      _1370: Function.prototype.call.bind(DataView.prototype.setUint32),
      _1371: Function.prototype.call.bind(DataView.prototype.getInt32),
      _1372: Function.prototype.call.bind(DataView.prototype.setInt32),
      _1375: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      _1376: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      _1377: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _1378: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _1379: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _1380: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _1393: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      _1394: (handle) => clearTimeout(handle),
      _1395: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      _1396: (handle) => clearInterval(handle),
      _1397: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _1398: () => Date.now(),
      _1403: o => Object.keys(o),
      _1430: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _1431: (x0,x1) => x0.exec(x1),
      _1432: (x0,x1) => x0.test(x1),
      _1433: x0 => x0.pop(),
      _1435: o => o === undefined,
      _1437: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _1439: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      _1440: o => o instanceof RegExp,
      _1441: (l, r) => l === r,
      _1442: o => o,
      _1443: o => o,
      _1444: o => o,
      _1445: b => !!b,
      _1446: o => o.length,
      _1448: (o, i) => o[i],
      _1449: f => f.dartFunction,
      _1450: () => ({}),
      _1451: () => [],
      _1453: () => globalThis,
      _1454: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      _1455: (o, p) => p in o,
      _1456: (o, p) => o[p],
      _1457: (o, p, v) => o[p] = v,
      _1458: (o, m, a) => o[m].apply(o, a),
      _1460: o => String(o),
      _1461: (p, s, f) => p.then(s, f),
      _1462: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        return 17;
      },
      _1463: o => [o],
      _1464: (o0, o1) => [o0, o1],
      _1465: (o0, o1, o2) => [o0, o1, o2],
      _1466: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      _1467: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1468: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1471: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1472: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1473: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1474: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1475: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1476: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1477: x0 => new ArrayBuffer(x0),
      _1478: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      _1480: x0 => x0.index,
      _1482: x0 => x0.flags,
      _1483: x0 => x0.multiline,
      _1484: x0 => x0.ignoreCase,
      _1485: x0 => x0.unicode,
      _1486: x0 => x0.dotAll,
      _1487: (x0,x1) => x0.lastIndex = x1,
      _1488: (o, p) => p in o,
      _1489: (o, p) => o[p],
      _1492: x0 => x0.random(),
      _1495: () => globalThis.Math,
      _1496: Function.prototype.call.bind(Number.prototype.toString),
      _1497: Function.prototype.call.bind(BigInt.prototype.toString),
      _1498: Function.prototype.call.bind(Number.prototype.toString),
      _1499: (d, digits) => d.toFixed(digits),
      _3335: () => globalThis.window,
      _3397: x0 => x0.navigator,
      _3786: x0 => x0.userAgent,

    };

    const baseImports = {
      dart2wasm: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      S: new Proxy({}, { get(_, prop) { return prop; } }),

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s == '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
