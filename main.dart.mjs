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
  async instantiate(additionalImports, {loadDeferredWasm} = {}) {
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
      _192: x0 => x0.select(),
      _193: (x0,x1) => x0.append(x1),
      _194: x0 => x0.remove(),
      _197: x0 => x0.unlock(),
      _202: x0 => x0.getReader(),
      _211: x0 => new MutationObserver(x0),
      _222: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _223: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _226: x0 => new ResizeObserver(x0),
      _229: (x0,x1) => new Intl.Segmenter(x0,x1),
      _230: x0 => x0.next(),
      _231: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      _314: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._314(f,arguments.length,x0) }),
      _315: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._315(f,arguments.length,x0) }),
      _316: (x0,x1) => ({addView: x0,removeView: x1}),
      _317: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._317(f,arguments.length,x0) }),
      _318: f => finalizeWrapper(f, function() { return dartInstance.exports._318(f,arguments.length) }),
      _319: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      _320: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._320(f,arguments.length,x0) }),
      _321: x0 => ({runApp: x0}),
      _322: x0 => new Uint8Array(x0),
      _324: x0 => x0.preventDefault(),
      _325: x0 => x0.stopPropagation(),
      _326: (x0,x1) => x0.addListener(x1),
      _327: (x0,x1) => x0.removeListener(x1),
      _328: (x0,x1) => x0.prepend(x1),
      _329: x0 => x0.remove(),
      _330: x0 => x0.disconnect(),
      _331: (x0,x1) => x0.addListener(x1),
      _332: (x0,x1) => x0.removeListener(x1),
      _333: x0 => x0.blur(),
      _334: (x0,x1) => x0.append(x1),
      _335: x0 => x0.remove(),
      _336: x0 => x0.stopPropagation(),
      _340: x0 => x0.preventDefault(),
      _345: (x0,x1) => x0.removeChild(x1),
      _346: (x0,x1) => x0.appendChild(x1),
      _347: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _348: (x0,x1) => x0.appendChild(x1),
      _349: (x0,x1) => x0.transferFromImageBitmap(x1),
      _351: (x0,x1) => x0.append(x1),
      _352: (x0,x1) => x0.append(x1),
      _353: (x0,x1) => x0.append(x1),
      _354: x0 => x0.remove(),
      _355: x0 => x0.remove(),
      _356: x0 => x0.remove(),
      _357: (x0,x1) => x0.appendChild(x1),
      _358: (x0,x1) => x0.appendChild(x1),
      _359: x0 => x0.remove(),
      _360: (x0,x1) => x0.append(x1),
      _361: (x0,x1) => x0.append(x1),
      _362: x0 => x0.remove(),
      _363: (x0,x1) => x0.append(x1),
      _364: (x0,x1) => x0.append(x1),
      _365: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _366: (x0,x1) => x0.append(x1),
      _367: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _368: x0 => x0.remove(),
      _369: (x0,x1) => x0.append(x1),
      _370: x0 => x0.remove(),
      _371: (x0,x1) => x0.append(x1),
      _372: x0 => x0.remove(),
      _373: x0 => x0.remove(),
      _374: x0 => x0.getBoundingClientRect(),
      _375: x0 => x0.remove(),
      _388: (x0,x1) => x0.append(x1),
      _389: x0 => x0.remove(),
      _390: (x0,x1) => x0.append(x1),
      _391: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _392: x0 => x0.preventDefault(),
      _393: x0 => x0.preventDefault(),
      _394: x0 => x0.preventDefault(),
      _395: x0 => x0.preventDefault(),
      _396: (x0,x1) => x0.observe(x1),
      _397: x0 => x0.disconnect(),
      _398: (x0,x1) => x0.appendChild(x1),
      _399: (x0,x1) => x0.appendChild(x1),
      _400: (x0,x1) => x0.appendChild(x1),
      _401: (x0,x1) => x0.append(x1),
      _402: x0 => x0.remove(),
      _403: (x0,x1) => x0.append(x1),
      _405: (x0,x1) => x0.appendChild(x1),
      _406: (x0,x1) => x0.append(x1),
      _407: x0 => x0.remove(),
      _408: (x0,x1) => x0.append(x1),
      _409: x0 => x0.remove(),
      _413: (x0,x1) => x0.appendChild(x1),
      _414: x0 => x0.remove(),
      _417: x0 => x0.preventDefault(),
      _418: (x0,x1) => x0.append(x1),
      _419: x0 => x0.remove(),
      _978: () => globalThis.window.flutterConfiguration,
      _979: x0 => x0.assetBase,
      _985: x0 => x0.debugShowSemanticsNodes,
      _986: x0 => x0.hostElement,
      _987: x0 => x0.multiViewEnabled,
      _988: x0 => x0.nonce,
      _990: x0 => x0.fontFallbackBaseUrl,
      _996: x0 => x0.console,
      _997: x0 => x0.devicePixelRatio,
      _998: x0 => x0.document,
      _999: x0 => x0.history,
      _1000: x0 => x0.innerHeight,
      _1001: x0 => x0.innerWidth,
      _1002: x0 => x0.location,
      _1003: x0 => x0.navigator,
      _1004: x0 => x0.visualViewport,
      _1005: x0 => x0.performance,
      _1008: (x0,x1) => x0.dispatchEvent(x1),
      _1010: (x0,x1) => x0.matchMedia(x1),
      _1012: (x0,x1) => x0.getComputedStyle(x1),
      _1013: x0 => x0.screen,
      _1014: (x0,x1) => x0.requestAnimationFrame(x1),
      _1015: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1015(f,arguments.length,x0) }),
      _1020: (x0,x1) => x0.warn(x1),
      _1023: () => globalThis.window,
      _1024: () => globalThis.Intl,
      _1025: () => globalThis.Symbol,
      _1028: x0 => x0.clipboard,
      _1029: x0 => x0.maxTouchPoints,
      _1030: x0 => x0.vendor,
      _1031: x0 => x0.language,
      _1032: x0 => x0.platform,
      _1033: x0 => x0.userAgent,
      _1034: x0 => x0.languages,
      _1035: x0 => x0.documentElement,
      _1036: (x0,x1) => x0.querySelector(x1),
      _1039: (x0,x1) => x0.createElement(x1),
      _1040: (x0,x1) => x0.execCommand(x1),
      _1043: (x0,x1) => x0.createTextNode(x1),
      _1044: (x0,x1) => x0.createEvent(x1),
      _1048: x0 => x0.head,
      _1049: x0 => x0.body,
      _1050: (x0,x1) => x0.title = x1,
      _1053: x0 => x0.activeElement,
      _1055: x0 => x0.visibilityState,
      _1056: x0 => x0.hasFocus(),
      _1057: () => globalThis.document,
      _1058: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1059: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1062: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1062(f,arguments.length,x0) }),
      _1063: x0 => x0.target,
      _1065: x0 => x0.timeStamp,
      _1066: x0 => x0.type,
      _1068: x0 => x0.preventDefault(),
      _1070: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      _1077: x0 => x0.firstChild,
      _1082: x0 => x0.parentElement,
      _1084: x0 => x0.parentNode,
      _1087: (x0,x1) => x0.removeChild(x1),
      _1088: (x0,x1) => x0.removeChild(x1),
      _1089: x0 => x0.isConnected,
      _1090: (x0,x1) => x0.textContent = x1,
      _1093: (x0,x1) => x0.contains(x1),
      _1099: x0 => x0.firstElementChild,
      _1101: x0 => x0.nextElementSibling,
      _1102: x0 => x0.clientHeight,
      _1103: x0 => x0.clientWidth,
      _1104: x0 => x0.offsetHeight,
      _1105: x0 => x0.offsetWidth,
      _1106: x0 => x0.id,
      _1107: (x0,x1) => x0.id = x1,
      _1110: (x0,x1) => x0.spellcheck = x1,
      _1111: x0 => x0.tagName,
      _1112: x0 => x0.style,
      _1113: (x0,x1) => x0.append(x1),
      _1114: (x0,x1) => x0.getAttribute(x1),
      _1116: x0 => x0.getBoundingClientRect(),
      _1119: (x0,x1) => x0.closest(x1),
      _1123: (x0,x1) => x0.querySelectorAll(x1),
      _1124: x0 => x0.remove(),
      _1126: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1127: (x0,x1) => x0.removeAttribute(x1),
      _1128: (x0,x1) => x0.tabIndex = x1,
      _1130: (x0,x1) => x0.focus(x1),
      _1131: x0 => x0.scrollTop,
      _1132: (x0,x1) => x0.scrollTop = x1,
      _1133: x0 => x0.scrollLeft,
      _1134: (x0,x1) => x0.scrollLeft = x1,
      _1135: x0 => x0.classList,
      _1136: (x0,x1) => x0.className = x1,
      _1142: (x0,x1) => x0.getElementsByClassName(x1),
      _1144: x0 => x0.click(),
      _1146: (x0,x1) => x0.hasAttribute(x1),
      _1149: (x0,x1) => x0.attachShadow(x1),
      _1154: (x0,x1) => x0.getPropertyValue(x1),
      _1155: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      _1157: (x0,x1) => x0.removeProperty(x1),
      _1159: x0 => x0.offsetLeft,
      _1160: x0 => x0.offsetTop,
      _1161: x0 => x0.offsetParent,
      _1163: (x0,x1) => x0.name = x1,
      _1164: x0 => x0.content,
      _1165: (x0,x1) => x0.content = x1,
      _1183: (x0,x1) => x0.nonce = x1,
      _1188: x0 => x0.now(),
      _1190: (x0,x1) => x0.width = x1,
      _1192: (x0,x1) => x0.height = x1,
      _1196: (x0,x1) => x0.getContext(x1),
      _1275: (x0,x1) => x0.fetch(x1),
      _1276: x0 => x0.status,
      _1278: x0 => x0.body,
      _1280: x0 => x0.arrayBuffer(),
      _1285: x0 => x0.read(),
      _1286: x0 => x0.value,
      _1287: x0 => x0.done,
      _1290: x0 => x0.x,
      _1291: x0 => x0.y,
      _1294: x0 => x0.top,
      _1295: x0 => x0.right,
      _1296: x0 => x0.bottom,
      _1297: x0 => x0.left,
      _1306: x0 => x0.height,
      _1307: x0 => x0.width,
      _1308: (x0,x1) => x0.value = x1,
      _1310: (x0,x1) => x0.placeholder = x1,
      _1311: (x0,x1) => x0.name = x1,
      _1312: x0 => x0.selectionDirection,
      _1313: x0 => x0.selectionStart,
      _1314: x0 => x0.selectionEnd,
      _1317: x0 => x0.value,
      _1319: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1323: x0 => x0.readText(),
      _1324: (x0,x1) => x0.writeText(x1),
      _1325: x0 => x0.altKey,
      _1326: x0 => x0.code,
      _1327: x0 => x0.ctrlKey,
      _1328: x0 => x0.key,
      _1329: x0 => x0.keyCode,
      _1330: x0 => x0.location,
      _1331: x0 => x0.metaKey,
      _1332: x0 => x0.repeat,
      _1333: x0 => x0.shiftKey,
      _1334: x0 => x0.isComposing,
      _1335: (x0,x1) => x0.getModifierState(x1),
      _1337: x0 => x0.state,
      _1338: (x0,x1) => x0.go(x1),
      _1341: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      _1342: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      _1343: x0 => x0.pathname,
      _1344: x0 => x0.search,
      _1345: x0 => x0.hash,
      _1349: x0 => x0.state,
      _1356: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1356(f,arguments.length,x0,x1) }),
      _1358: (x0,x1,x2) => x0.observe(x1,x2),
      _1361: x0 => x0.attributeName,
      _1362: x0 => x0.type,
      _1363: x0 => x0.matches,
      _1368: x0 => x0.matches,
      _1370: x0 => x0.relatedTarget,
      _1371: x0 => x0.clientX,
      _1372: x0 => x0.clientY,
      _1373: x0 => x0.offsetX,
      _1374: x0 => x0.offsetY,
      _1377: x0 => x0.button,
      _1378: x0 => x0.buttons,
      _1379: x0 => x0.ctrlKey,
      _1381: (x0,x1) => x0.getModifierState(x1),
      _1384: x0 => x0.pointerId,
      _1385: x0 => x0.pointerType,
      _1386: x0 => x0.pressure,
      _1387: x0 => x0.tiltX,
      _1388: x0 => x0.tiltY,
      _1390: x0 => x0.getCoalescedEvents(),
      _1392: x0 => x0.deltaX,
      _1393: x0 => x0.deltaY,
      _1394: x0 => x0.wheelDeltaX,
      _1395: x0 => x0.wheelDeltaY,
      _1396: x0 => x0.deltaMode,
      _1402: x0 => x0.changedTouches,
      _1404: x0 => x0.clientX,
      _1405: x0 => x0.clientY,
      _1407: x0 => x0.data,
      _1410: (x0,x1) => x0.disabled = x1,
      _1411: (x0,x1) => x0.type = x1,
      _1412: (x0,x1) => x0.max = x1,
      _1413: (x0,x1) => x0.min = x1,
      _1414: (x0,x1) => x0.value = x1,
      _1415: x0 => x0.value,
      _1416: x0 => x0.disabled,
      _1417: (x0,x1) => x0.disabled = x1,
      _1418: (x0,x1) => x0.placeholder = x1,
      _1419: (x0,x1) => x0.name = x1,
      _1420: (x0,x1) => x0.autocomplete = x1,
      _1421: x0 => x0.selectionDirection,
      _1422: x0 => x0.selectionStart,
      _1423: x0 => x0.selectionEnd,
      _1427: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1432: (x0,x1) => x0.add(x1),
      _1436: (x0,x1) => x0.noValidate = x1,
      _1437: (x0,x1) => x0.method = x1,
      _1438: (x0,x1) => x0.action = x1,
      _1463: x0 => x0.orientation,
      _1464: x0 => x0.width,
      _1465: x0 => x0.height,
      _1467: (x0,x1) => x0.lock(x1),
      _1484: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1484(f,arguments.length,x0,x1) }),
      _1493: x0 => x0.length,
      _1494: (x0,x1) => x0.item(x1),
      _1495: x0 => x0.length,
      _1496: (x0,x1) => x0.item(x1),
      _1497: x0 => x0.iterator,
      _1498: x0 => x0.Segmenter,
      _1499: x0 => x0.v8BreakIterator,
      _1502: x0 => x0.done,
      _1503: x0 => x0.value,
      _1504: x0 => x0.index,
      _1508: (x0,x1) => x0.adoptText(x1),
      _1509: x0 => x0.first(),
      _1510: x0 => x0.next(),
      _1511: x0 => x0.current(),
      _1522: x0 => x0.hostElement,
      _1523: x0 => x0.viewConstraints,
      _1525: x0 => x0.maxHeight,
      _1526: x0 => x0.maxWidth,
      _1527: x0 => x0.minHeight,
      _1528: x0 => x0.minWidth,
      _1529: x0 => x0.loader,
      _1530: () => globalThis._flutter,
      _1532: (x0,x1) => x0.didCreateEngineInitializer(x1),
      _1533: (x0,x1,x2) => x0.call(x1,x2),
      _1534: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1534(f,arguments.length,x0,x1) }),
      _1535: x0 => new Promise(x0),
      _1539: x0 => x0.length,
      _1622: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1651: x0 => new Array(x0),
      _1653: x0 => x0.length,
      _1655: (x0,x1) => x0[x1],
      _1656: (x0,x1,x2) => x0[x1] = x2,
      _1659: (x0,x1,x2) => new DataView(x0,x1,x2),
      _1661: x0 => new Int8Array(x0),
      _1662: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _1663: x0 => new Uint8Array(x0),
      _1671: x0 => new Int32Array(x0),
      _1675: x0 => new Float32Array(x0),
      _1677: x0 => new Float64Array(x0),
      _1709: (decoder, codeUnits) => decoder.decode(codeUnits),
      _1710: () => new TextDecoder("utf-8", {fatal: true}),
      _1711: () => new TextDecoder("utf-8", {fatal: false}),
      _1712: x0 => new WeakRef(x0),
      _1713: x0 => x0.deref(),
      _1719: Date.now,
      _1721: s => new Date(s * 1000).getTimezoneOffset() * 60,
      _1722: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      _1723: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _1724: () => typeof dartUseDateNowForTicks !== "undefined",
      _1725: () => 1000 * performance.now(),
      _1726: () => Date.now(),
      _1729: () => new WeakMap(),
      _1730: (map, o) => map.get(o),
      _1731: (map, o, v) => map.set(o, v),
      _1732: () => globalThis.WeakRef,
      _1744: s => JSON.stringify(s),
      _1745: s => printToConsole(s),
      _1746: a => a.join(''),
      _1749: (s, t) => s.split(t),
      _1750: s => s.toLowerCase(),
      _1751: s => s.toUpperCase(),
      _1752: s => s.trim(),
      _1753: s => s.trimLeft(),
      _1754: s => s.trimRight(),
      _1756: (s, p, i) => s.indexOf(p, i),
      _1757: (s, p, i) => s.lastIndexOf(p, i),
      _1759: Object.is,
      _1760: s => s.toUpperCase(),
      _1761: s => s.toLowerCase(),
      _1762: (a, i) => a.push(i),
      _1766: a => a.pop(),
      _1767: (a, i) => a.splice(i, 1),
      _1769: (a, s) => a.join(s),
      _1770: (a, s, e) => a.slice(s, e),
      _1772: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      _1773: a => a.length,
      _1775: (a, i) => a[i],
      _1776: (a, i, v) => a[i] = v,
      _1778: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      _1779: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _1780: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _1781: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _1782: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _1783: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _1784: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _1785: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _1787: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      _1788: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _1789: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _1790: (t, s) => t.set(s),
      _1792: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _1794: o => o.buffer,
      _1795: o => o.byteOffset,
      _1796: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _1797: (b, o) => new DataView(b, o),
      _1798: (b, o, l) => new DataView(b, o, l),
      _1799: Function.prototype.call.bind(DataView.prototype.getUint8),
      _1800: Function.prototype.call.bind(DataView.prototype.setUint8),
      _1801: Function.prototype.call.bind(DataView.prototype.getInt8),
      _1802: Function.prototype.call.bind(DataView.prototype.setInt8),
      _1803: Function.prototype.call.bind(DataView.prototype.getUint16),
      _1804: Function.prototype.call.bind(DataView.prototype.setUint16),
      _1805: Function.prototype.call.bind(DataView.prototype.getInt16),
      _1806: Function.prototype.call.bind(DataView.prototype.setInt16),
      _1807: Function.prototype.call.bind(DataView.prototype.getUint32),
      _1808: Function.prototype.call.bind(DataView.prototype.setUint32),
      _1809: Function.prototype.call.bind(DataView.prototype.getInt32),
      _1810: Function.prototype.call.bind(DataView.prototype.setInt32),
      _1813: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      _1814: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      _1815: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _1816: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _1817: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _1818: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _1831: (o, t) => o instanceof t,
      _1833: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1833(f,arguments.length,x0) }),
      _1834: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1834(f,arguments.length,x0) }),
      _1835: o => Object.keys(o),
      _1836: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      _1837: (handle) => clearTimeout(handle),
      _1838: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      _1839: (handle) => clearInterval(handle),
      _1840: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _1841: () => Date.now(),
      _1872: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _1873: (x0,x1) => x0.exec(x1),
      _1874: (x0,x1) => x0.test(x1),
      _1875: (x0,x1) => x0.exec(x1),
      _1876: (x0,x1) => x0.exec(x1),
      _1877: x0 => x0.pop(),
      _1879: o => o === undefined,
      _1898: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _1900: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      _1901: o => o instanceof RegExp,
      _1902: (l, r) => l === r,
      _1903: o => o,
      _1904: o => o,
      _1905: o => o,
      _1906: b => !!b,
      _1907: o => o.length,
      _1910: (o, i) => o[i],
      _1911: f => f.dartFunction,
      _1912: l => arrayFromDartList(Int8Array, l),
      _1913: l => arrayFromDartList(Uint8Array, l),
      _1914: l => arrayFromDartList(Uint8ClampedArray, l),
      _1915: l => arrayFromDartList(Int16Array, l),
      _1916: l => arrayFromDartList(Uint16Array, l),
      _1917: l => arrayFromDartList(Int32Array, l),
      _1918: l => arrayFromDartList(Uint32Array, l),
      _1919: l => arrayFromDartList(Float32Array, l),
      _1920: l => arrayFromDartList(Float64Array, l),
      _1921: x0 => new ArrayBuffer(x0),
      _1922: (data, length) => {
        const getValue = dartInstance.exports.$byteDataGetUint8;
        const view = new DataView(new ArrayBuffer(length));
        for (let i = 0; i < length; i++) {
          view.setUint8(i, getValue(data, i));
        }
        return view;
      },
      _1923: l => arrayFromDartList(Array, l),
      _1924: () => ({}),
      _1925: () => [],
      _1926: l => new Array(l),
      _1927: () => globalThis,
      _1928: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      _1929: (o, p) => p in o,
      _1930: (o, p) => o[p],
      _1931: (o, p, v) => o[p] = v,
      _1932: (o, m, a) => o[m].apply(o, a),
      _1934: o => String(o),
      _1935: (p, s, f) => p.then(s, f),
      _1936: o => {
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
      _1937: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1938: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1941: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1942: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1943: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1944: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1945: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1946: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1947: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      _1950: x0 => x0.index,
      _1955: x0 => x0.flags,
      _1956: x0 => x0.multiline,
      _1957: x0 => x0.ignoreCase,
      _1958: x0 => x0.unicode,
      _1959: x0 => x0.dotAll,
      _1960: (x0,x1) => x0.lastIndex = x1,
      _1962: (o, p) => o[p],
      _1965: x0 => x0.random(),
      _1966: x0 => x0.random(),
      _1970: () => globalThis.Math,
      _1972: Function.prototype.call.bind(Number.prototype.toString),
      _1973: (d, digits) => d.toFixed(digits),
      _3847: () => globalThis.window,
      _3912: x0 => x0.navigator,
      _4303: x0 => x0.userAgent,

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


    const deferredLibraryHelper = {
      "loadModule": async (moduleName) => {
        if (!loadDeferredWasm) {
          throw "No implementation of loadDeferredWasm provided.";
        }
        const source = await Promise.resolve(loadDeferredWasm(moduleName));
        const module = await ((source instanceof Response)
            ? WebAssembly.compileStreaming(source, this.builtins)
            : WebAssembly.compile(source, this.builtins));
        return await WebAssembly.instantiate(module, {
          ...baseImports,
          ...additionalImports,
          "wasm:js-string": jsStringPolyfill,
          "module0": dartInstance.exports,
        });
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
