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

    // Converts a Dart List to a JS array. Any Dart objects will be converted, but
    // this will be cheap for JSValues.
    function arrayFromDartList(constructor, list) {
      const exports = dartInstance.exports;
      const read = exports.$listRead;
      const length = exports.$listLength(list);
      const array = new constructor(length);
      for (let i = 0; i < length; i++) {
        array[i] = read(list, i);
      }
      return array;
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
            _1: (x0,x1,x2) => x0.set(x1,x2),
      _2: (x0,x1,x2) => x0.set(x1,x2),
      _6: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._6(f,arguments.length,x0) }),
      _7: x0 => new window.FinalizationRegistry(x0),
      _8: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      _9: (x0,x1) => x0.unregister(x1),
      _10: (x0,x1,x2) => x0.slice(x1,x2),
      _11: (x0,x1) => x0.decode(x1),
      _12: (x0,x1) => x0.segment(x1),
      _13: () => new TextDecoder(),
      _14: x0 => x0.buffer,
      _15: x0 => x0.wasmMemory,
      _16: () => globalThis.window._flutter_skwasmInstance,
      _17: x0 => x0.rasterStartMilliseconds,
      _18: x0 => x0.rasterEndMilliseconds,
      _19: x0 => x0.imageBitmaps,
      _161: x0 => x0.select(),
      _162: (x0,x1) => x0.append(x1),
      _163: x0 => x0.remove(),
      _166: x0 => x0.unlock(),
      _171: x0 => x0.getReader(),
      _180: x0 => new MutationObserver(x0),
      _191: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _192: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _195: x0 => new ResizeObserver(x0),
      _198: (x0,x1) => new Intl.Segmenter(x0,x1),
      _199: x0 => x0.next(),
      _200: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      _203: (x0,x1) => x0.addListener(x1),
      _204: (x0,x1) => x0.removeListener(x1),
      _217: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._217(f,arguments.length,x0) }),
      _218: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._218(f,arguments.length,x0) }),
      _219: (x0,x1) => ({addView: x0,removeView: x1}),
      _220: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._220(f,arguments.length,x0) }),
      _221: f => finalizeWrapper(f, function() { return dartInstance.exports._221(f,arguments.length) }),
      _222: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      _223: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._223(f,arguments.length,x0) }),
      _224: x0 => ({runApp: x0}),
      _225: x0 => new Uint8Array(x0),
      _227: x0 => x0.preventDefault(),
      _228: x0 => x0.stopPropagation(),
      _229: (x0,x1) => x0.prepend(x1),
      _230: x0 => x0.remove(),
      _231: x0 => x0.disconnect(),
      _232: (x0,x1) => x0.addListener(x1),
      _233: (x0,x1) => x0.removeListener(x1),
      _234: x0 => x0.blur(),
      _235: (x0,x1) => x0.append(x1),
      _236: x0 => x0.remove(),
      _237: x0 => x0.stopPropagation(),
      _241: x0 => x0.preventDefault(),
      _246: (x0,x1) => x0.removeChild(x1),
      _247: (x0,x1) => x0.appendChild(x1),
      _248: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _249: (x0,x1) => x0.appendChild(x1),
      _250: (x0,x1) => x0.transferFromImageBitmap(x1),
      _252: (x0,x1) => x0.append(x1),
      _253: (x0,x1) => x0.append(x1),
      _254: (x0,x1) => x0.append(x1),
      _255: x0 => x0.remove(),
      _256: x0 => x0.remove(),
      _257: x0 => x0.remove(),
      _258: (x0,x1) => x0.appendChild(x1),
      _259: (x0,x1) => x0.appendChild(x1),
      _260: x0 => x0.remove(),
      _261: (x0,x1) => x0.append(x1),
      _262: (x0,x1) => x0.append(x1),
      _263: x0 => x0.remove(),
      _264: (x0,x1) => x0.append(x1),
      _265: (x0,x1) => x0.append(x1),
      _266: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _267: (x0,x1) => x0.append(x1),
      _268: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _269: x0 => x0.remove(),
      _270: (x0,x1) => x0.append(x1),
      _271: x0 => x0.remove(),
      _272: (x0,x1) => x0.append(x1),
      _273: x0 => x0.remove(),
      _274: x0 => x0.remove(),
      _275: x0 => x0.getBoundingClientRect(),
      _276: x0 => x0.remove(),
      _277: (x0,x1) => x0.append(x1),
      _278: x0 => x0.remove(),
      _279: (x0,x1) => x0.append(x1),
      _280: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _281: x0 => x0.preventDefault(),
      _282: x0 => x0.preventDefault(),
      _283: x0 => x0.preventDefault(),
      _284: x0 => x0.preventDefault(),
      _285: (x0,x1) => x0.observe(x1),
      _286: x0 => x0.disconnect(),
      _287: (x0,x1) => x0.appendChild(x1),
      _288: (x0,x1) => x0.appendChild(x1),
      _289: (x0,x1) => x0.appendChild(x1),
      _290: (x0,x1) => x0.append(x1),
      _291: x0 => x0.remove(),
      _292: (x0,x1) => x0.append(x1),
      _294: (x0,x1) => x0.appendChild(x1),
      _295: (x0,x1) => x0.append(x1),
      _296: x0 => x0.remove(),
      _297: (x0,x1) => x0.append(x1),
      _298: x0 => x0.remove(),
      _302: (x0,x1) => x0.appendChild(x1),
      _303: x0 => x0.remove(),
      _304: x0 => x0.preventDefault(),
      _305: (x0,x1) => x0.append(x1),
      _306: x0 => x0.remove(),
      _869: () => globalThis.window.flutterConfiguration,
      _870: x0 => x0.assetBase,
      _876: x0 => x0.debugShowSemanticsNodes,
      _877: x0 => x0.hostElement,
      _878: x0 => x0.multiViewEnabled,
      _879: x0 => x0.nonce,
      _881: x0 => x0.fontFallbackBaseUrl,
      _886: x0 => x0.console,
      _887: x0 => x0.devicePixelRatio,
      _888: x0 => x0.document,
      _889: x0 => x0.history,
      _890: x0 => x0.innerHeight,
      _891: x0 => x0.innerWidth,
      _892: x0 => x0.location,
      _893: x0 => x0.navigator,
      _894: x0 => x0.visualViewport,
      _895: x0 => x0.performance,
      _898: (x0,x1) => x0.dispatchEvent(x1),
      _899: (x0,x1) => x0.matchMedia(x1),
      _901: (x0,x1) => x0.getComputedStyle(x1),
      _902: x0 => x0.screen,
      _903: (x0,x1) => x0.requestAnimationFrame(x1),
      _904: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._904(f,arguments.length,x0) }),
      _910: (x0,x1) => x0.warn(x1),
      _913: () => globalThis.window,
      _914: () => globalThis.Intl,
      _915: () => globalThis.Symbol,
      _918: x0 => x0.clipboard,
      _919: x0 => x0.maxTouchPoints,
      _920: x0 => x0.vendor,
      _921: x0 => x0.language,
      _922: x0 => x0.platform,
      _923: x0 => x0.userAgent,
      _924: x0 => x0.languages,
      _925: x0 => x0.documentElement,
      _926: (x0,x1) => x0.querySelector(x1),
      _929: (x0,x1) => x0.createElement(x1),
      _930: (x0,x1) => x0.execCommand(x1),
      _933: (x0,x1) => x0.createTextNode(x1),
      _934: (x0,x1) => x0.createEvent(x1),
      _938: x0 => x0.head,
      _939: x0 => x0.body,
      _940: (x0,x1) => x0.title = x1,
      _943: x0 => x0.activeElement,
      _945: x0 => x0.visibilityState,
      _947: x0 => x0.hasFocus(),
      _948: () => globalThis.document,
      _949: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _950: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _953: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._953(f,arguments.length,x0) }),
      _954: x0 => x0.target,
      _956: x0 => x0.timeStamp,
      _957: x0 => x0.type,
      _959: x0 => x0.preventDefault(),
      _961: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      _968: x0 => x0.firstChild,
      _974: x0 => x0.parentElement,
      _976: x0 => x0.parentNode,
      _979: (x0,x1) => x0.removeChild(x1),
      _980: (x0,x1) => x0.removeChild(x1),
      _981: x0 => x0.isConnected,
      _982: (x0,x1) => x0.textContent = x1,
      _984: (x0,x1) => x0.contains(x1),
      _989: x0 => x0.firstElementChild,
      _991: x0 => x0.nextElementSibling,
      _992: x0 => x0.clientHeight,
      _993: x0 => x0.clientWidth,
      _994: x0 => x0.offsetHeight,
      _995: x0 => x0.offsetWidth,
      _996: x0 => x0.id,
      _997: (x0,x1) => x0.id = x1,
      _1000: (x0,x1) => x0.spellcheck = x1,
      _1001: x0 => x0.tagName,
      _1002: x0 => x0.style,
      _1003: (x0,x1) => x0.append(x1),
      _1004: (x0,x1) => x0.getAttribute(x1),
      _1005: x0 => x0.getBoundingClientRect(),
      _1008: (x0,x1) => x0.closest(x1),
      _1011: (x0,x1) => x0.querySelectorAll(x1),
      _1013: x0 => x0.remove(),
      _1015: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1016: (x0,x1) => x0.removeAttribute(x1),
      _1017: (x0,x1) => x0.tabIndex = x1,
      _1019: (x0,x1) => x0.focus(x1),
      _1020: x0 => x0.scrollTop,
      _1021: (x0,x1) => x0.scrollTop = x1,
      _1022: x0 => x0.scrollLeft,
      _1023: (x0,x1) => x0.scrollLeft = x1,
      _1024: x0 => x0.classList,
      _1025: (x0,x1) => x0.className = x1,
      _1029: (x0,x1) => x0.getElementsByClassName(x1),
      _1030: x0 => x0.click(),
      _1031: (x0,x1) => x0.hasAttribute(x1),
      _1034: (x0,x1) => x0.attachShadow(x1),
      _1041: (x0,x1) => x0.getPropertyValue(x1),
      _1043: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      _1045: (x0,x1) => x0.removeProperty(x1),
      _1047: x0 => x0.offsetLeft,
      _1048: x0 => x0.offsetTop,
      _1049: x0 => x0.offsetParent,
      _1051: (x0,x1) => x0.name = x1,
      _1052: x0 => x0.content,
      _1053: (x0,x1) => x0.content = x1,
      _1071: (x0,x1) => x0.nonce = x1,
      _1077: x0 => x0.now(),
      _1079: (x0,x1) => x0.width = x1,
      _1081: (x0,x1) => x0.height = x1,
      _1085: (x0,x1) => x0.getContext(x1),
      _1158: (x0,x1) => x0.fetch(x1),
      _1159: x0 => x0.status,
      _1161: x0 => x0.body,
      _1162: x0 => x0.arrayBuffer(),
      _1168: x0 => x0.read(),
      _1169: x0 => x0.value,
      _1170: x0 => x0.done,
      _1173: x0 => x0.x,
      _1174: x0 => x0.y,
      _1177: x0 => x0.top,
      _1178: x0 => x0.right,
      _1179: x0 => x0.bottom,
      _1180: x0 => x0.left,
      _1189: x0 => x0.height,
      _1190: x0 => x0.width,
      _1191: x0 => x0.scale,
      _1192: (x0,x1) => x0.value = x1,
      _1194: (x0,x1) => x0.placeholder = x1,
      _1195: (x0,x1) => x0.name = x1,
      _1196: x0 => x0.selectionDirection,
      _1197: x0 => x0.selectionStart,
      _1198: x0 => x0.selectionEnd,
      _1201: x0 => x0.value,
      _1203: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1206: x0 => x0.readText(),
      _1207: (x0,x1) => x0.writeText(x1),
      _1208: x0 => x0.altKey,
      _1209: x0 => x0.code,
      _1210: x0 => x0.ctrlKey,
      _1211: x0 => x0.key,
      _1212: x0 => x0.keyCode,
      _1213: x0 => x0.location,
      _1214: x0 => x0.metaKey,
      _1215: x0 => x0.repeat,
      _1216: x0 => x0.shiftKey,
      _1217: x0 => x0.isComposing,
      _1218: (x0,x1) => x0.getModifierState(x1),
      _1220: x0 => x0.state,
      _1221: (x0,x1) => x0.go(x1),
      _1223: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      _1224: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      _1225: x0 => x0.pathname,
      _1226: x0 => x0.search,
      _1227: x0 => x0.hash,
      _1231: x0 => x0.state,
      _1238: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1238(f,arguments.length,x0,x1) }),
      _1240: (x0,x1,x2) => x0.observe(x1,x2),
      _1243: x0 => x0.attributeName,
      _1244: x0 => x0.type,
      _1245: x0 => x0.matches,
      _1249: x0 => x0.matches,
      _1251: x0 => x0.relatedTarget,
      _1252: x0 => x0.clientX,
      _1253: x0 => x0.clientY,
      _1254: x0 => x0.offsetX,
      _1255: x0 => x0.offsetY,
      _1258: x0 => x0.button,
      _1259: x0 => x0.buttons,
      _1260: x0 => x0.ctrlKey,
      _1261: (x0,x1) => x0.getModifierState(x1),
      _1264: x0 => x0.pointerId,
      _1265: x0 => x0.pointerType,
      _1266: x0 => x0.pressure,
      _1267: x0 => x0.tiltX,
      _1268: x0 => x0.tiltY,
      _1270: x0 => x0.getCoalescedEvents(),
      _1272: x0 => x0.deltaX,
      _1273: x0 => x0.deltaY,
      _1274: x0 => x0.wheelDeltaX,
      _1275: x0 => x0.wheelDeltaY,
      _1276: x0 => x0.deltaMode,
      _1282: x0 => x0.changedTouches,
      _1284: x0 => x0.clientX,
      _1285: x0 => x0.clientY,
      _1287: x0 => x0.data,
      _1290: (x0,x1) => x0.disabled = x1,
      _1291: (x0,x1) => x0.type = x1,
      _1292: (x0,x1) => x0.max = x1,
      _1293: (x0,x1) => x0.min = x1,
      _1294: (x0,x1) => x0.value = x1,
      _1295: x0 => x0.value,
      _1296: x0 => x0.disabled,
      _1297: (x0,x1) => x0.disabled = x1,
      _1298: (x0,x1) => x0.placeholder = x1,
      _1299: (x0,x1) => x0.name = x1,
      _1300: (x0,x1) => x0.autocomplete = x1,
      _1301: x0 => x0.selectionDirection,
      _1302: x0 => x0.selectionStart,
      _1303: x0 => x0.selectionEnd,
      _1307: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1312: (x0,x1) => x0.add(x1),
      _1316: (x0,x1) => x0.noValidate = x1,
      _1317: (x0,x1) => x0.method = x1,
      _1318: (x0,x1) => x0.action = x1,
      _1343: x0 => x0.orientation,
      _1344: x0 => x0.width,
      _1345: x0 => x0.height,
      _1346: (x0,x1) => x0.lock(x1),
      _1363: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1363(f,arguments.length,x0,x1) }),
      _1372: x0 => x0.length,
      _1373: (x0,x1) => x0.item(x1),
      _1374: x0 => x0.length,
      _1375: (x0,x1) => x0.item(x1),
      _1376: x0 => x0.iterator,
      _1377: x0 => x0.Segmenter,
      _1378: x0 => x0.v8BreakIterator,
      _1381: x0 => x0.done,
      _1382: x0 => x0.value,
      _1383: x0 => x0.index,
      _1387: (x0,x1) => x0.adoptText(x1),
      _1388: x0 => x0.first(),
      _1390: x0 => x0.next(),
      _1391: x0 => x0.current(),
      _1403: x0 => x0.hostElement,
      _1404: x0 => x0.viewConstraints,
      _1406: x0 => x0.maxHeight,
      _1407: x0 => x0.maxWidth,
      _1408: x0 => x0.minHeight,
      _1409: x0 => x0.minWidth,
      _1410: x0 => x0.loader,
      _1411: () => globalThis._flutter,
      _1413: (x0,x1) => x0.didCreateEngineInitializer(x1),
      _1414: (x0,x1,x2) => x0.call(x1,x2),
      _1415: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1415(f,arguments.length,x0,x1) }),
      _1416: x0 => new Promise(x0),
      _1419: x0 => x0.length,
      _1500: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1529: x0 => new Array(x0),
      _1531: x0 => x0.length,
      _1533: (x0,x1) => x0[x1],
      _1534: (x0,x1,x2) => x0[x1] = x2,
      _1537: (x0,x1,x2) => new DataView(x0,x1,x2),
      _1539: x0 => new Int8Array(x0),
      _1540: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _1541: x0 => new Uint8Array(x0),
      _1549: x0 => new Int32Array(x0),
      _1553: x0 => new Float32Array(x0),
      _1555: x0 => new Float64Array(x0),
      _1587: (decoder, codeUnits) => decoder.decode(codeUnits),
      _1588: () => new TextDecoder("utf-8", {fatal: true}),
      _1589: () => new TextDecoder("utf-8", {fatal: false}),
      _1590: (s) => parseFloat(s),
      _1591: x0 => new WeakRef(x0),
      _1592: x0 => x0.deref(),
      _1598: Date.now,
      _1600: s => new Date(s * 1000).getTimezoneOffset() * 60,
      _1601: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      _1602: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _1603: () => typeof dartUseDateNowForTicks !== "undefined",
      _1604: () => 1000 * performance.now(),
      _1605: () => Date.now(),
      _1608: () => new WeakMap(),
      _1609: (map, o) => map.get(o),
      _1610: (map, o, v) => map.set(o, v),
      _1611: () => globalThis.WeakRef,
      _1622: s => JSON.stringify(s),
      _1624: s => printToConsole(s),
      _1625: a => a.join(''),
      _1628: (s, t) => s.split(t),
      _1629: s => s.toLowerCase(),
      _1630: s => s.toUpperCase(),
      _1631: s => s.trim(),
      _1632: s => s.trimLeft(),
      _1633: s => s.trimRight(),
      _1635: (s, p, i) => s.indexOf(p, i),
      _1636: (s, p, i) => s.lastIndexOf(p, i),
      _1638: Object.is,
      _1639: s => s.toUpperCase(),
      _1640: s => s.toLowerCase(),
      _1641: (a, i) => a.push(i),
      _1645: a => a.pop(),
      _1646: (a, i) => a.splice(i, 1),
      _1648: (a, s) => a.join(s),
      _1649: (a, s, e) => a.slice(s, e),
      _1651: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      _1652: a => a.length,
      _1654: (a, i) => a[i],
      _1655: (a, i, v) => a[i] = v,
      _1657: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      _1658: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _1659: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _1660: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _1661: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _1662: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _1663: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _1664: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _1666: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      _1667: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _1668: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _1669: (t, s) => t.set(s),
      _1671: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _1673: o => o.buffer,
      _1674: o => o.byteOffset,
      _1675: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _1676: (b, o) => new DataView(b, o),
      _1677: (b, o, l) => new DataView(b, o, l),
      _1678: Function.prototype.call.bind(DataView.prototype.getUint8),
      _1679: Function.prototype.call.bind(DataView.prototype.setUint8),
      _1680: Function.prototype.call.bind(DataView.prototype.getInt8),
      _1681: Function.prototype.call.bind(DataView.prototype.setInt8),
      _1682: Function.prototype.call.bind(DataView.prototype.getUint16),
      _1683: Function.prototype.call.bind(DataView.prototype.setUint16),
      _1684: Function.prototype.call.bind(DataView.prototype.getInt16),
      _1685: Function.prototype.call.bind(DataView.prototype.setInt16),
      _1686: Function.prototype.call.bind(DataView.prototype.getUint32),
      _1687: Function.prototype.call.bind(DataView.prototype.setUint32),
      _1688: Function.prototype.call.bind(DataView.prototype.getInt32),
      _1689: Function.prototype.call.bind(DataView.prototype.setInt32),
      _1692: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      _1693: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      _1694: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _1695: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _1696: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _1697: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _1710: (o, t) => o instanceof t,
      _1712: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1712(f,arguments.length,x0) }),
      _1713: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1713(f,arguments.length,x0) }),
      _1714: o => Object.keys(o),
      _1715: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      _1716: (handle) => clearTimeout(handle),
      _1717: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      _1718: (handle) => clearInterval(handle),
      _1719: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _1720: () => Date.now(),
      _1751: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _1752: (x0,x1) => x0.exec(x1),
      _1753: (x0,x1) => x0.test(x1),
      _1754: (x0,x1) => x0.exec(x1),
      _1755: (x0,x1) => x0.exec(x1),
      _1756: x0 => x0.pop(),
      _1758: o => o === undefined,
      _1777: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _1779: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      _1780: o => o instanceof RegExp,
      _1781: (l, r) => l === r,
      _1782: o => o,
      _1783: o => o,
      _1784: o => o,
      _1785: b => !!b,
      _1786: o => o.length,
      _1789: (o, i) => o[i],
      _1790: f => f.dartFunction,
      _1791: l => arrayFromDartList(Int8Array, l),
      _1792: l => arrayFromDartList(Uint8Array, l),
      _1793: l => arrayFromDartList(Uint8ClampedArray, l),
      _1794: l => arrayFromDartList(Int16Array, l),
      _1795: l => arrayFromDartList(Uint16Array, l),
      _1796: l => arrayFromDartList(Int32Array, l),
      _1797: l => arrayFromDartList(Uint32Array, l),
      _1798: l => arrayFromDartList(Float32Array, l),
      _1799: l => arrayFromDartList(Float64Array, l),
      _1800: x0 => new ArrayBuffer(x0),
      _1801: (data, length) => {
        const getValue = dartInstance.exports.$byteDataGetUint8;
        const view = new DataView(new ArrayBuffer(length));
        for (let i = 0; i < length; i++) {
          view.setUint8(i, getValue(data, i));
        }
        return view;
      },
      _1802: l => arrayFromDartList(Array, l),
      _1803: () => ({}),
      _1804: () => [],
      _1805: l => new Array(l),
      _1806: () => globalThis,
      _1807: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      _1808: (o, p) => p in o,
      _1809: (o, p) => o[p],
      _1810: (o, p, v) => o[p] = v,
      _1811: (o, m, a) => o[m].apply(o, a),
      _1813: o => String(o),
      _1814: (p, s, f) => p.then(s, f),
      _1815: o => {
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
      _1816: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1817: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1820: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1821: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1822: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1823: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1824: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1825: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1826: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      _1829: x0 => x0.index,
      _1834: x0 => x0.flags,
      _1835: x0 => x0.multiline,
      _1836: x0 => x0.ignoreCase,
      _1837: x0 => x0.unicode,
      _1838: x0 => x0.dotAll,
      _1839: (x0,x1) => x0.lastIndex = x1,
      _1841: (o, p) => o[p],
      _1844: x0 => x0.random(),
      _1845: x0 => x0.random(),
      _1849: () => globalThis.Math,
      _1851: Function.prototype.call.bind(Number.prototype.toString),
      _1852: (d, digits) => d.toFixed(digits),
      _3726: () => globalThis.window,
      _3791: x0 => x0.navigator,
      _4182: x0 => x0.userAgent,

    };

    const baseImports = {
      dart2wasm: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      
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
    };


    const loadModuleFromBytes = async (bytes) => {
        const module = await WebAssembly.compile(bytes, this.builtins);
        return await WebAssembly.instantiate(module, {
          ...baseImports,
          ...additionalImports,
          "wasm:js-string": jsStringPolyfill,
          "module0": dartInstance.exports,
        });
    }

    const loadModule = async (loader, loaderArgument) => {
        const source = await Promise.resolve(loader(loaderArgument));
        const module = await ((source instanceof Response)
            ? WebAssembly.compileStreaming(source, this.builtins)
            : WebAssembly.compile(source, this.builtins));
        return await WebAssembly.instantiate(module, {
          ...baseImports,
          ...additionalImports,
          "wasm:js-string": jsStringPolyfill,
          "module0": dartInstance.exports,
        });
    }

    const deferredLibraryHelper = {
      "loadModule": async (moduleName) => {
        if (!loadDeferredWasm) {
          throw "No implementation of loadDeferredWasm provided.";
        }
        return await loadModule(loadDeferredWasm, moduleName);
      },
      "loadDynamicModuleFromUri": async (uri) => {
        if (!loadDynamicModule) {
          throw "No implementation of loadDynamicModule provided.";
        }
        const loadedModule = await loadModule(loadDynamicModule, uri);
        return loadedModule.exports.$invokeEntryPoint;
      },
      "loadDynamicModuleFromBytes": async (bytes) => {
        const loadedModule = await loadModuleFromBytes(loadDynamicModule, uri);
        return loadedModule.exports.$invokeEntryPoint;
      },
    };

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      "deferredLibraryHelper": deferredLibraryHelper,
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
