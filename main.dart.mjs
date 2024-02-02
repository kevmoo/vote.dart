  let buildArgsList;

// `modulePromise` is a promise to the `WebAssembly.module` object to be
//   instantiated.
// `importObjectPromise` is a promise to an object that contains any additional
//   imports needed by the module that aren't provided by the standard runtime.
//   The fields on this object will be merged into the importObject with which
//   the module will be instantiated.
// This function returns a promise to the instantiated module.
export const instantiate = async (modulePromise, importObjectPromise) => {
    let dartInstance;

      function stringFromDartString(string) {
        const totalLength = dartInstance.exports.$stringLength(string);
        let result = '';
        let index = 0;
        while (index < totalLength) {
          let chunkLength = Math.min(totalLength - index, 0xFFFF);
          const array = new Array(chunkLength);
          for (let i = 0; i < chunkLength; i++) {
              array[i] = dartInstance.exports.$stringRead(string, index++);
          }
          result += String.fromCharCode(...array);
        }
        return result;
    }

    function stringToDartString(string) {
        const length = string.length;
        let range = 0;
        for (let i = 0; i < length; i++) {
            range |= string.codePointAt(i);
        }
        if (range < 256) {
            const dartString = dartInstance.exports.$stringAllocate1(length);
            for (let i = 0; i < length; i++) {
                dartInstance.exports.$stringWrite1(dartString, i, string.codePointAt(i));
            }
            return dartString;
        } else {
            const dartString = dartInstance.exports.$stringAllocate2(length);
            for (let i = 0; i < length; i++) {
                dartInstance.exports.$stringWrite2(dartString, i, string.charCodeAt(i));
            }
            return dartString;
        }
    }

      // Prints to the console
    function printToConsole(value) {
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
        const length = dartInstance.exports.$listLength(list);
        const array = new constructor(length);
        for (let i = 0; i < length; i++) {
            array[i] = dartInstance.exports.$listRead(list, i);
        }
        return array;
    }

    buildArgsList = function(list) {
        const dartList = dartInstance.exports.$makeStringList();
        for (let i = 0; i < list.length; i++) {
            dartInstance.exports.$listAdd(dartList, stringToDartString(list[i]));
        }
        return dartList;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
        wrapped.dartFunction = dartFunction;
        wrapped[jsWrappedDartFunctionSymbol] = true;
        return wrapped;
    }

    if (WebAssembly.String === undefined) {
        printToConsole("WebAssembly.String is undefined, adding polyfill");
        WebAssembly.String = {
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
        };
    }

    // Imports
    const dart2wasm = {

  _1576: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
_1594: (x0,x1) => x0.matchMedia(x1),
_19922: () => globalThis.window,
_19942: x0 => x0.matches,
_19946: x0 => x0.platform,
_19951: x0 => x0.navigator,
_3891: () => globalThis.window,
_3983: x0 => x0.navigator,
_4475: x0 => x0.userAgent,
_1666: s => stringToDartString(JSON.stringify(stringFromDartString(s))),
_1667: s => printToConsole(stringFromDartString(s)),
_1799: o => o === undefined,
_1800: o => typeof o === 'boolean',
_1801: o => typeof o === 'number',
_1803: o => typeof o === 'string',
_1806: o => o instanceof Int8Array,
_1807: o => o instanceof Uint8Array,
_1808: o => o instanceof Uint8ClampedArray,
_1809: o => o instanceof Int16Array,
_1810: o => o instanceof Uint16Array,
_1811: o => o instanceof Int32Array,
_1812: o => o instanceof Uint32Array,
_1813: o => o instanceof Float32Array,
_1814: o => o instanceof Float64Array,
_1815: o => o instanceof ArrayBuffer,
_1816: o => o instanceof DataView,
_1817: o => o instanceof Array,
_1818: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
_1820: o => {
            const proto = Object.getPrototypeOf(o);
            return proto === Object.prototype || proto === null;
          },
_1821: o => o instanceof RegExp,
_1822: (l, r) => l === r,
_1823: o => o,
_1824: o => o,
_1825: o => o,
_1826: b => !!b,
_1827: o => o.length,
_1830: (o, i) => o[i],
_1831: f => f.dartFunction,
_1832: l => arrayFromDartList(Int8Array, l),
_1833: l => arrayFromDartList(Uint8Array, l),
_1834: l => arrayFromDartList(Uint8ClampedArray, l),
_1835: l => arrayFromDartList(Int16Array, l),
_1836: l => arrayFromDartList(Uint16Array, l),
_1837: l => arrayFromDartList(Int32Array, l),
_1838: l => arrayFromDartList(Uint32Array, l),
_1839: l => arrayFromDartList(Float32Array, l),
_1840: l => arrayFromDartList(Float64Array, l),
_1841: (data, length) => {
          const view = new DataView(new ArrayBuffer(length));
          for (let i = 0; i < length; i++) {
              view.setUint8(i, dartInstance.exports.$byteDataGetUint8(data, i));
          }
          return view;
        },
_1842: l => arrayFromDartList(Array, l),
_1843: stringFromDartString,
_1844: stringToDartString,
_1845: () => ({}),
_1846: () => [],
_1848: () => globalThis,
_1849: (constructor, args) => {
      const factoryFunction = constructor.bind.apply(
          constructor, [null, ...args]);
      return new factoryFunction();
    },
_1850: (o, p) => p in o,
_1851: (o, p) => o[p],
_1852: (o, p, v) => o[p] = v,
_1853: (o, m, a) => o[m].apply(o, a),
_1856: (p, s, f) => p.then(s, f),
_1857: s => {
      let jsString = stringFromDartString(s);
      if (/[[\]{}()*+?.\\^$|]/.test(jsString)) {
          jsString = jsString.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
      }
      return stringToDartString(jsString);
    },
_1788: (s, m) => {
          try {
            return new RegExp(s, m);
          } catch (e) {
            return String(e);
          }
        },
_1789: (x0,x1) => x0.exec(x1),
_1790: (x0,x1) => x0.test(x1),
_1791: (x0,x1) => x0.exec(x1),
_1792: (x0,x1) => x0.exec(x1),
_1793: x0 => x0.pop(),
_1797: (x0,x1,x2) => x0[x1] = x2,
_1847: l => new Array(l),
_1855: o => String(o),
_1860: x0 => x0.index,
_1862: x0 => x0.length,
_1864: (x0,x1) => x0[x1],
_1868: x0 => x0.flags,
_1869: x0 => x0.multiline,
_1870: x0 => x0.ignoreCase,
_1871: x0 => x0.unicode,
_1872: x0 => x0.dotAll,
_1873: (x0,x1) => x0.lastIndex = x1,
_1748: Object.is,
_1750: WebAssembly.String.concat,
_1756: (t, s) => t.set(s),
_1758: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
_1760: o => o.buffer,
_1708: (a, i) => a.push(i),
_1712: a => a.pop(),
_1713: (a, i) => a.splice(i, 1),
_1715: (a, s) => a.join(s),
_1716: (a, s, e) => a.slice(s, e),
_1718: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
_1719: a => a.length,
_1721: (a, i) => a[i],
_1722: (a, i, v) => a[i] = v,
_1724: a => a.join(''),
_1727: (s, t) => s.split(t),
_1728: s => s.toLowerCase(),
_1729: s => s.toUpperCase(),
_1730: s => s.trim(),
_1731: s => s.trimLeft(),
_1732: s => s.trimRight(),
_1734: (s, p, i) => s.indexOf(p, i),
_1735: (s, p, i) => s.lastIndexOf(p, i),
_1736: (o, offsetInBytes, lengthInBytes) => {
      var dst = new ArrayBuffer(lengthInBytes);
      new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
      return new DataView(dst);
    },
_1737: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
_1738: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
_1739: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
_1740: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
_1741: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
_1742: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
_1743: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
_1745: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
_1746: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
_1747: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
_1749: WebAssembly.String.charCodeAt,
_1751: WebAssembly.String.substring,
_1752: WebAssembly.String.length,
_1753: WebAssembly.String.equals,
_1754: WebAssembly.String.compare,
_1755: WebAssembly.String.fromCharCode,
_1761: o => o.byteOffset,
_1762: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
_1763: (b, o) => new DataView(b, o),
_1764: (b, o, l) => new DataView(b, o, l),
_1765: Function.prototype.call.bind(DataView.prototype.getUint8),
_1766: Function.prototype.call.bind(DataView.prototype.setUint8),
_1767: Function.prototype.call.bind(DataView.prototype.getInt8),
_1768: Function.prototype.call.bind(DataView.prototype.setInt8),
_1769: Function.prototype.call.bind(DataView.prototype.getUint16),
_1770: Function.prototype.call.bind(DataView.prototype.setUint16),
_1771: Function.prototype.call.bind(DataView.prototype.getInt16),
_1772: Function.prototype.call.bind(DataView.prototype.setInt16),
_1773: Function.prototype.call.bind(DataView.prototype.getUint32),
_1774: Function.prototype.call.bind(DataView.prototype.setUint32),
_1775: Function.prototype.call.bind(DataView.prototype.getInt32),
_1776: Function.prototype.call.bind(DataView.prototype.setInt32),
_1779: Function.prototype.call.bind(DataView.prototype.getBigInt64),
_1780: Function.prototype.call.bind(DataView.prototype.setBigInt64),
_1781: Function.prototype.call.bind(DataView.prototype.getFloat32),
_1782: Function.prototype.call.bind(DataView.prototype.setFloat32),
_1783: Function.prototype.call.bind(DataView.prototype.getFloat64),
_1784: Function.prototype.call.bind(DataView.prototype.setFloat64),
_1673: (ms, c) =>
              setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
_1674: (handle) => clearTimeout(handle),
_1675: (ms, c) =>
          setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
_1676: (handle) => clearInterval(handle),
_1678: () => Date.now(),
_1677: (c) =>
              queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
_1605: x0 => new Array(x0),
_1668: (o, t) => o instanceof t,
_1670: f => finalizeWrapper(f,x0 => dartInstance.exports._1670(f,x0)),
_1671: f => finalizeWrapper(f,x0 => dartInstance.exports._1671(f,x0)),
_1672: o => Object.keys(o),
_1785: s => stringToDartString(stringFromDartString(s).toUpperCase()),
_1786: s => stringToDartString(stringFromDartString(s).toLowerCase()),
_1642: v => stringToDartString(v.toString()),
_1643: (d, digits) => stringToDartString(d.toFixed(digits)),
_1646: (d, precision) => stringToDartString(d.toPrecision(precision)),
_1647: o => new WeakRef(o),
_1648: r => r.deref(),
_1653: Date.now,
_1655: s => new Date(s * 1000).getTimezoneOffset() * 60 ,
_1656: s => {
      const jsSource = stringFromDartString(s);
      if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(jsSource)) {
        return NaN;
      }
      return parseFloat(jsSource);
    },
_1657: () => {
          let stackString = new Error().stack.toString();
          let frames = stackString.split('\n');
          let drop = 2;
          if (frames[0] === 'Error') {
              drop += 1;
          }
          return frames.slice(drop).join('\n');
        },
_1658: () => typeof dartUseDateNowForTicks !== "undefined",
_1659: () => 1000 * performance.now(),
_1660: () => Date.now(),
_1663: () => new WeakMap(),
_1664: (map, o) => map.get(o),
_1665: (map, o, v) => map.set(o, v),
_162: x0 => x0.focus(),
_163: x0 => x0.select(),
_164: (x0,x1) => x0.append(x1),
_165: x0 => x0.remove(),
_168: x0 => x0.unlock(),
_173: x0 => x0.getReader(),
_183: x0 => new MutationObserver(x0),
_202: (x0,x1,x2) => x0.addEventListener(x1,x2),
_203: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_206: x0 => new ResizeObserver(x0),
_209: (x0,x1) => new Intl.Segmenter(x0,x1),
_210: x0 => x0.next(),
_211: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
_294: f => finalizeWrapper(f,x0 => dartInstance.exports._294(f,x0)),
_295: f => finalizeWrapper(f,x0 => dartInstance.exports._295(f,x0)),
_296: (x0,x1) => ({addView: x0,removeView: x1}),
_297: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._297(f,arguments.length,x0) }),
_298: f => finalizeWrapper(f,() => dartInstance.exports._298(f)),
_299: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
_300: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._300(f,arguments.length,x0) }),
_301: x0 => ({runApp: x0}),
_302: x0 => new Uint8Array(x0),
_304: x0 => x0.preventDefault(),
_305: x0 => x0.stopPropagation(),
_306: (x0,x1) => x0.addListener(x1),
_307: (x0,x1) => x0.removeListener(x1),
_308: x0 => x0.disconnect(),
_309: (x0,x1) => x0.addListener(x1),
_310: (x0,x1) => x0.removeListener(x1),
_311: (x0,x1) => x0.append(x1),
_312: x0 => x0.remove(),
_313: x0 => x0.stopPropagation(),
_317: x0 => x0.preventDefault(),
_318: (x0,x1) => x0.append(x1),
_319: x0 => x0.remove(),
_324: (x0,x1) => x0.appendChild(x1),
_325: (x0,x1,x2) => x0.insertBefore(x1,x2),
_326: (x0,x1) => x0.removeChild(x1),
_327: (x0,x1) => x0.appendChild(x1),
_328: (x0,x1) => x0.transferFromImageBitmap(x1),
_329: (x0,x1) => x0.append(x1),
_330: (x0,x1) => x0.append(x1),
_331: (x0,x1) => x0.append(x1),
_332: x0 => x0.remove(),
_333: x0 => x0.focus(),
_334: x0 => x0.focus(),
_335: x0 => x0.remove(),
_336: x0 => x0.focus(),
_337: x0 => x0.remove(),
_338: (x0,x1) => x0.append(x1),
_339: x0 => x0.focus(),
_340: (x0,x1) => x0.append(x1),
_341: x0 => x0.remove(),
_342: (x0,x1) => x0.append(x1),
_343: (x0,x1) => x0.append(x1),
_344: (x0,x1,x2) => x0.insertBefore(x1,x2),
_345: (x0,x1) => x0.append(x1),
_346: (x0,x1,x2) => x0.insertBefore(x1,x2),
_347: x0 => x0.remove(),
_348: x0 => x0.remove(),
_349: x0 => x0.remove(),
_350: (x0,x1) => x0.append(x1),
_351: x0 => x0.remove(),
_352: x0 => x0.remove(),
_353: x0 => x0.getBoundingClientRect(),
_354: x0 => x0.remove(),
_355: x0 => x0.blur(),
_357: x0 => x0.focus(),
_358: x0 => x0.focus(),
_359: x0 => x0.remove(),
_360: x0 => x0.focus(),
_361: x0 => x0.focus(),
_362: x0 => x0.blur(),
_363: x0 => x0.remove(),
_376: (x0,x1) => x0.append(x1),
_377: x0 => x0.remove(),
_378: (x0,x1) => x0.append(x1),
_379: (x0,x1,x2) => x0.insertBefore(x1,x2),
_380: (x0,x1) => x0.append(x1),
_381: x0 => x0.focus(),
_382: x0 => x0.focus(),
_383: x0 => x0.focus(),
_384: x0 => x0.focus(),
_385: x0 => x0.focus(),
_386: (x0,x1) => x0.append(x1),
_387: x0 => x0.focus(),
_388: x0 => x0.blur(),
_389: x0 => x0.remove(),
_391: x0 => x0.preventDefault(),
_392: x0 => x0.focus(),
_393: x0 => x0.preventDefault(),
_394: x0 => x0.preventDefault(),
_395: x0 => x0.preventDefault(),
_396: x0 => x0.focus(),
_397: x0 => x0.focus(),
_398: (x0,x1) => x0.append(x1),
_399: x0 => x0.focus(),
_400: x0 => x0.focus(),
_401: x0 => x0.focus(),
_402: x0 => x0.focus(),
_403: (x0,x1) => x0.observe(x1),
_404: x0 => x0.disconnect(),
_405: (x0,x1) => x0.appendChild(x1),
_406: (x0,x1) => x0.appendChild(x1),
_407: (x0,x1) => x0.appendChild(x1),
_408: (x0,x1) => x0.append(x1),
_409: (x0,x1) => x0.append(x1),
_410: (x0,x1) => x0.append(x1),
_411: x0 => x0.remove(),
_412: (x0,x1) => x0.append(x1),
_414: (x0,x1) => x0.appendChild(x1),
_415: (x0,x1) => x0.append(x1),
_416: x0 => x0.remove(),
_417: (x0,x1) => x0.append(x1),
_421: (x0,x1) => x0.appendChild(x1),
_422: x0 => x0.remove(),
_975: () => globalThis.window.flutterConfiguration,
_976: x0 => x0.assetBase,
_980: x0 => x0.debugShowSemanticsNodes,
_981: x0 => x0.hostElement,
_982: x0 => x0.multiViewEnabled,
_983: x0 => x0.nonce,
_985: x0 => x0.useColorEmoji,
_989: x0 => x0.console,
_990: x0 => x0.devicePixelRatio,
_991: x0 => x0.document,
_992: x0 => x0.history,
_993: x0 => x0.innerHeight,
_994: x0 => x0.innerWidth,
_995: x0 => x0.location,
_996: x0 => x0.navigator,
_997: x0 => x0.visualViewport,
_998: x0 => x0.performance,
_999: (x0,x1) => x0.fetch(x1),
_1002: (x0,x1) => x0.dispatchEvent(x1),
_1003: (x0,x1) => x0.matchMedia(x1),
_1004: (x0,x1) => x0.getComputedStyle(x1),
_1006: x0 => x0.screen,
_1007: (x0,x1) => x0.requestAnimationFrame(x1),
_1008: f => finalizeWrapper(f,x0 => dartInstance.exports._1008(f,x0)),
_1013: (x0,x1) => x0.warn(x1),
_1015: (x0,x1) => x0.debug(x1),
_1016: () => globalThis.window,
_1017: () => globalThis.Intl,
_1018: () => globalThis.Symbol,
_1021: x0 => x0.clipboard,
_1022: x0 => x0.maxTouchPoints,
_1023: x0 => x0.vendor,
_1024: x0 => x0.language,
_1025: x0 => x0.platform,
_1026: x0 => x0.userAgent,
_1027: x0 => x0.languages,
_1028: x0 => x0.documentElement,
_1029: (x0,x1) => x0.querySelector(x1),
_1032: (x0,x1) => x0.createElement(x1),
_1034: (x0,x1) => x0.execCommand(x1),
_1037: (x0,x1) => x0.createTextNode(x1),
_1038: (x0,x1) => x0.createEvent(x1),
_1043: x0 => x0.head,
_1044: x0 => x0.body,
_1045: (x0,x1) => x0.title = x1,
_1048: x0 => x0.activeElement,
_1050: x0 => x0.visibilityState,
_1051: () => globalThis.document,
_1052: (x0,x1,x2) => x0.addEventListener(x1,x2),
_1053: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1055: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1056: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_1059: f => finalizeWrapper(f,x0 => dartInstance.exports._1059(f,x0)),
_1060: x0 => x0.target,
_1062: x0 => x0.timeStamp,
_1063: x0 => x0.type,
_1064: x0 => x0.preventDefault(),
_1068: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
_1073: x0 => x0.firstChild,
_1079: x0 => x0.parentElement,
_1085: (x0,x1) => x0.removeChild(x1),
_1087: (x0,x1) => x0.textContent = x1,
_1089: (x0,x1) => x0.contains(x1),
_1094: x0 => x0.firstElementChild,
_1096: x0 => x0.nextElementSibling,
_1097: x0 => x0.clientHeight,
_1098: x0 => x0.clientWidth,
_1099: x0 => x0.id,
_1100: (x0,x1) => x0.id = x1,
_1103: (x0,x1) => x0.spellcheck = x1,
_1104: x0 => x0.tagName,
_1105: x0 => x0.style,
_1107: (x0,x1) => x0.append(x1),
_1111: x0 => x0.getBoundingClientRect(),
_1117: (x0,x1) => x0.querySelectorAll(x1),
_1118: x0 => x0.remove(),
_1119: (x0,x1,x2) => x0.setAttribute(x1,x2),
_1120: (x0,x1) => x0.removeAttribute(x1),
_1121: (x0,x1) => x0.tabIndex = x1,
_1125: x0 => x0.scrollTop,
_1126: (x0,x1) => x0.scrollTop = x1,
_1127: x0 => x0.scrollLeft,
_1128: (x0,x1) => x0.scrollLeft = x1,
_1129: x0 => x0.classList,
_1130: (x0,x1) => x0.className = x1,
_1134: (x0,x1) => x0.getElementsByClassName(x1),
_1135: x0 => x0.click(),
_1136: (x0,x1) => x0.hasAttribute(x1),
_1139: (x0,x1) => x0.attachShadow(x1),
_1142: (x0,x1) => x0.getPropertyValue(x1),
_1144: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
_1146: (x0,x1) => x0.removeProperty(x1),
_1148: x0 => x0.offsetLeft,
_1149: x0 => x0.offsetTop,
_1150: x0 => x0.offsetParent,
_1152: (x0,x1) => x0.name = x1,
_1153: x0 => x0.content,
_1154: (x0,x1) => x0.content = x1,
_1167: (x0,x1) => x0.nonce = x1,
_1172: x0 => x0.now(),
_1174: (x0,x1) => x0.width = x1,
_1176: (x0,x1) => x0.height = x1,
_1180: (x0,x1) => x0.getContext(x1),
_1258: x0 => x0.status,
_1260: x0 => x0.body,
_1261: x0 => x0.arrayBuffer(),
_1266: x0 => x0.read(),
_1267: x0 => x0.value,
_1268: x0 => x0.done,
_1271: x0 => x0.x,
_1272: x0 => x0.y,
_1273: x0 => x0.width,
_1274: x0 => x0.height,
_1275: x0 => x0.top,
_1276: x0 => x0.right,
_1277: x0 => x0.bottom,
_1278: x0 => x0.left,
_1288: x0 => x0.height,
_1289: x0 => x0.width,
_1290: (x0,x1) => x0.value = x1,
_1293: (x0,x1) => x0.placeholder = x1,
_1294: (x0,x1) => x0.name = x1,
_1295: x0 => x0.selectionDirection,
_1296: x0 => x0.selectionStart,
_1297: x0 => x0.selectionEnd,
_1300: x0 => x0.value,
_1301: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1305: x0 => x0.readText(),
_1306: (x0,x1) => x0.writeText(x1),
_1307: x0 => x0.altKey,
_1308: x0 => x0.code,
_1309: x0 => x0.ctrlKey,
_1310: x0 => x0.key,
_1311: x0 => x0.keyCode,
_1312: x0 => x0.location,
_1313: x0 => x0.metaKey,
_1314: x0 => x0.repeat,
_1315: x0 => x0.shiftKey,
_1316: x0 => x0.isComposing,
_1317: (x0,x1) => x0.getModifierState(x1),
_1318: x0 => x0.state,
_1320: (x0,x1) => x0.go(x1),
_1322: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
_1323: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
_1324: x0 => x0.pathname,
_1325: x0 => x0.search,
_1326: x0 => x0.hash,
_1329: x0 => x0.state,
_1333: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1333(f,x0,x1)),
_1336: (x0,x1,x2) => x0.observe(x1,x2),
_1339: x0 => x0.attributeName,
_1340: x0 => x0.type,
_1341: x0 => x0.matches,
_1344: x0 => x0.matches,
_1345: x0 => x0.clientX,
_1346: x0 => x0.clientY,
_1347: x0 => x0.offsetX,
_1348: x0 => x0.offsetY,
_1351: x0 => x0.button,
_1352: x0 => x0.buttons,
_1353: x0 => x0.ctrlKey,
_1354: (x0,x1) => x0.getModifierState(x1),
_1355: x0 => x0.pointerId,
_1356: x0 => x0.pointerType,
_1357: x0 => x0.pressure,
_1358: x0 => x0.tiltX,
_1359: x0 => x0.tiltY,
_1360: x0 => x0.getCoalescedEvents(),
_1361: x0 => x0.deltaX,
_1362: x0 => x0.deltaY,
_1363: x0 => x0.wheelDeltaX,
_1364: x0 => x0.wheelDeltaY,
_1365: x0 => x0.deltaMode,
_1370: x0 => x0.changedTouches,
_1372: x0 => x0.clientX,
_1373: x0 => x0.clientY,
_1374: x0 => x0.data,
_1375: (x0,x1) => x0.type = x1,
_1376: (x0,x1) => x0.max = x1,
_1377: (x0,x1) => x0.min = x1,
_1378: (x0,x1) => x0.value = x1,
_1379: x0 => x0.value,
_1380: x0 => x0.disabled,
_1381: (x0,x1) => x0.disabled = x1,
_1382: (x0,x1) => x0.placeholder = x1,
_1383: (x0,x1) => x0.name = x1,
_1384: (x0,x1) => x0.autocomplete = x1,
_1385: x0 => x0.selectionDirection,
_1386: x0 => x0.selectionStart,
_1387: x0 => x0.selectionEnd,
_1390: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1396: (x0,x1) => x0.add(x1),
_1400: (x0,x1) => x0.noValidate = x1,
_1401: (x0,x1) => x0.method = x1,
_1402: (x0,x1) => x0.action = x1,
_1431: x0 => x0.orientation,
_1432: x0 => x0.width,
_1433: x0 => x0.height,
_1434: (x0,x1) => x0.lock(x1),
_1450: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1450(f,x0,x1)),
_1454: x0 => x0.contentRect,
_1459: x0 => x0.length,
_1460: (x0,x1) => x0.item(x1),
_1461: x0 => x0.length,
_1462: (x0,x1) => x0.item(x1),
_1463: x0 => x0.iterator,
_1464: x0 => x0.Segmenter,
_1465: x0 => x0.v8BreakIterator,
_1469: x0 => x0.done,
_1470: x0 => x0.value,
_1471: x0 => x0.index,
_1475: (x0,x1) => x0.adoptText(x1),
_1476: x0 => x0.first(),
_1477: x0 => x0.next(),
_1478: x0 => x0.current(),
_1482: () => globalThis.window.FinalizationRegistry,
_1484: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
_1485: (x0,x1) => x0.unregister(x1),
_1491: x0 => x0.hostElement,
_1493: x0 => x0.loader,
_1494: () => globalThis._flutter,
_1495: (x0,x1) => x0.didCreateEngineInitializer(x1),
_1497: (x0,x1,x2) => x0.call(x1,x2),
_1498: () => globalThis.Promise,
_1499: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1499(f,x0,x1)),
_1502: x0 => x0.length,
_1: (x0,x1,x2) => x0.set(x1,x2),
_2: (x0,x1,x2) => x0.set(x1,x2),
_5: f => finalizeWrapper(f,x0 => dartInstance.exports._5(f,x0)),
_6: (x0,x1,x2) => x0.slice(x1,x2),
_7: (x0,x1) => x0.decode(x1),
_8: (x0,x1) => x0.segment(x1),
_9: () => new TextDecoder(),
_10: x0 => x0.buffer,
_11: x0 => x0.wasmMemory,
_12: () => globalThis.window._flutter_skwasmInstance,
_1639: (decoder, codeUnits) => decoder.decode(codeUnits),
_1640: () => new TextDecoder("utf-8", {fatal: true}),
_1641: () => new TextDecoder("utf-8", {fatal: false})
      };

    const baseImports = {
        dart2wasm: dart2wasm,

  
          Math: Math,
        Date: Date,
        Object: Object,
        Array: Array,
        Reflect: Reflect,
    };
    dartInstance = await WebAssembly.instantiate(await modulePromise, {
        ...baseImports,
        ...(await importObjectPromise),
    });

    return dartInstance;
}

// Call the main function for the instantiated module
// `moduleInstance` is the instantiated dart2wasm module
// `args` are any arguments that should be passed into the main function.
export const invoke = (moduleInstance, ...args) => {
    const dartMain = moduleInstance.exports.$getMain();
    const dartArgs = buildArgsList(args);
    moduleInstance.exports.$invokeMain(dartMain, dartArgs);
}

