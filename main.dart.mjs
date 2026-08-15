// Compiles a dart2wasm-generated main module from `source` which can then
// be instantiated via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm module from `bytes` which is then
// instantiable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string'], importedStringConstants: ''};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredModules` is a JS function that takes an array of module names
  //   matching wasm files produced by the dart2wasm compiler. It also takes a
  //   callback that should be invoked for each loaded module with 2 arguments:
  //   (1) the module name, (2) the loaded module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The callback
  //   returns a Promise that resolves when the module is instantiated.
  //   loadDeferredModules should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  // `loadDeferredId` is a JS function that takes load ID produced by the
  //   compiler when the `use-load-ids` option is passed. Each load ID maps to
  //   one or more wasm files as specified in the emitted JSON file. It also
  //   takes a callback that should be invoked for each loaded module with 2
  //   arguments: (1) the module name, (2) the loaded module in a format
  //   supported by `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  //   The callback returns a Promise that resolves when the module is
  //   instantiated.
  //   loadDeferredId should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  async instantiate(additionalImports, {loadDeferredModules, loadDeferredId} = {}) {
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

      throw "Unable to print message: " + value;
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
            AB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      AC: (t, s) => t.set(s),
      AD: (x0,x1) => x0.go(x1),
      AE: () => globalThis.window.flutterConfiguration,
      AF: (x0,x1) => { x0.method = x1 },
      AG: x0 => x0.offsetX,
      AH: x0 => x0.width,
      AI: x0 => x0.disabled,
      B: s => printToConsole(s),
      BB: Function.prototype.call.bind(String.prototype.toLowerCase),
      BC: Function.prototype.call.bind(DataView.prototype.setFloat32),
      BD: (x0,x1) => x0.append(x1),
      BE: (x0,x1) => x0.attachShadow(x1),
      BF: (x0,x1) => { x0.noValidate = x1 },
      BG: x0 => x0.type,
      BH: x0 => x0.clientWidth,
      BI: (x0,x1) => { x0.min = x1 },
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: (o, p, r) => o.replaceAll(p, () => r),
      CC: Function.prototype.call.bind(DataView.prototype.getFloat32),
      CD: (x0,x1) => { x0.textContent = x1 },
      CE: x0 => x0.preventDefault(),
      CF: x0 => x0.isConnected,
      CG: x0 => x0.shiftKey,
      CH: (x0,x1) => x0.removeChild(x1),
      CI: (x0,x1) => { x0.max = x1 },
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: (x0,x1) => x0[x1],
      DC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      DD: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      DE: (x0,x1) => x0.contains(x1),
      DF: x0 => x0.click(),
      DG: x0 => x0.disconnect(),
      DH: x0 => x0.firstChild,
      DI: (x0,x1) => { x0.disabled = x1 },
      E: (exn) => {
        let stackString = exn.toString();
        let frames = stackString.split('\n');
        let drop = 4;
        if (frames[0].startsWith('Error')) {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      EB: x0 => x0.length,
      EC: Function.prototype.call.bind(DataView.prototype.getUint32),
      ED: x0 => x0.parentElement,
      EE: (x0,x1) => x0.focus(x1),
      EF: (x0,x1) => x0.getElementsByClassName(x1),
      EG: x0 => new Intl.Locale(x0),
      EH: x0 => x0.viewConstraints,
      EI: (x0,x1) => { x0.scrollLeft = x1 },
      F: () => new Error().stack,
      FB: o => o,
      FC: Function.prototype.call.bind(DataView.prototype.setUint32),
      FD: (x0,x1) => x0.querySelectorAll(x1),
      FE: (x0,x1) => x0.closest(x1),
      FF: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      FG: x0 => x0.region,
      FH: x0 => x0.hostElement,
      FI: (x0,x1) => { x0.spellcheck = x1 },
      G: s => JSON.stringify(s),
      GB: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'number') return 1;
        return 2;
      },
      GC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      GD: x0 => x0.length,
      GE: (x0,x1) => x0.getAttribute(x1),
      GF: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      GG: x0 => x0.script,
      GH: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      GI: (x0,x1) => { x0.disabled = x1 },
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: (x0,x1) => x0.exec(x1),
      HC: Function.prototype.call.bind(DataView.prototype.getInt32),
      HD: (x0,x1) => x0.item(x1),
      HE: x0 => x0.activeElement,
      HF: (x0,x1) => x0.contains(x1),
      HG: x0 => x0.language,
      HH: x0 => ({runApp: x0}),
      HI: (x0,x1) => x0.transferFromImageBitmap(x1),
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: x0 => x0.flags,
      IC: Function.prototype.call.bind(DataView.prototype.setInt32),
      ID: x0 => x0.userAgent,
      IE: (x0,x1) => x0.add(x1),
      IF: (s) => +s,
      IG: x0 => x0.languages,
      IH: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      II: (x0,x1) => x0.getContext(x1),
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      JC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      JD: x0 => x0.maxTouchPoints,
      JE: x0 => x0.classList,
      JF: x0 => x0.target,
      JG: (x0,x1) => x0.observe(x1),
      JH: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      JI: (x0,x1) => { x0.height = x1 },
      K: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      KB: o => o instanceof RegExp,
      KC: o => o instanceof Uint16Array,
      KD: x0 => x0.platform,
      KE: x0 => x0.data,
      KF: (x0,x1) => x0.dispatchEvent(x1),
      KG: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      KH: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      KI: (x0,x1) => { x0.width = x1 },
      L: o => o === undefined,
      LB: s => s.trim(),
      LC: Function.prototype.call.bind(DataView.prototype.getUint16),
      LD: x0 => x0.navigator,
      LE: x0 => x0.scrollTop,
      LF: (x0,x1) => x0.createEvent(x1),
      LG: x0 => new ResizeObserver(x0),
      LH: () => typeof dartUseDateNowForTicks !== "undefined",
      LI: x0 => x0.height,
      M: o => String(o),
      MB: (a, s) => a.join(s),
      MC: Function.prototype.call.bind(DataView.prototype.setUint16),
      MD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      ME: (handle) => clearTimeout(handle),
      MF: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      MG: x0 => globalThis.parseFloat(x0),
      MH: () => Date.now(),
      MI: x0 => x0.width,
      N: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      NB: x0 => x0.random(),
      NC: o => o instanceof Int16Array,
      ND: Date.now,
      NE: (x0,x1) => x0.removeAttribute(x1),
      NF: x0 => x0.readText(),
      NG: (x0,x1) => x0.getComputedStyle(x1),
      NH: () => 1000 * performance.now(),
      NI: x0 => x0.rasterEndMilliseconds,
      O: (x0,x1) => x0.didCreateEngineInitializer(x1),
      OB: () => globalThis.Math,
      OC: Function.prototype.call.bind(DataView.prototype.getInt16),
      OD: (x0,x1,x2) => x0.setAttribute(x1,x2),
      OE: (x0,x1) => { x0.value = x1 },
      OF: x0 => x0.clipboard,
      OG: x0 => x0.documentElement,
      OH: x0 => new Uint8Array(x0),
      OI: x0 => x0.rasterStartMilliseconds,
      P: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PB: (x0,x1) => x0.error(x1),
      PC: Function.prototype.call.bind(DataView.prototype.setInt16),
      PD: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      PE: (x0,x1) => { x0.value = x1 },
      PF: (x0,x1) => x0.writeText(x1),
      PG: x0 => x0.computedStyleMap(),
      PH: (x0,x1,x2) => x0.slice(x1,x2),
      PI: x0 => x0.imageBitmaps,
      Q: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      QB: () => globalThis.console,
      QC: o => o instanceof Uint8ClampedArray,
      QD: x0 => x0.style,
      QE: x0 => x0.value,
      QF: x0 => x0.unlock(),
      QG: (x0,x1) => x0.get(x1),
      QH: (x0,x1) => x0.decode(x1),
      QI: x0 => x0.canvasKitMaximumSurfaces,
      R: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      RB: s => s.trimRight(),
      RC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      RD: (x0,x1) => x0.createElement(x1),
      RE: x0 => x0.selectionDirection,
      RF: (x0,x1) => x0.lock(x1),
      RG: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      RH: (x0,x1) => x0.adoptText(x1),
      RI: (a, i) => a.splice(i, 1),
      S: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SB: (a, i) => a.push(i),
      SC: Function.prototype.call.bind(DataView.prototype.setInt8),
      SD: x0 => x0.body,
      SE: x0 => x0.selectionStart,
      SF: x0 => x0.orientation,
      SG: x0 => x0.matches,
      SH: x0 => x0.first(),
      SI: a => a.pop(),
      T: x0 => new Promise(x0),
      TB: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      TC: Function.prototype.call.bind(DataView.prototype.getInt8),
      TD: x0 => x0.remove(),
      TE: x0 => x0.selectionEnd,
      TF: (x0,x1) => x0.querySelector(x1),
      TG: (x0,x1) => x0.matchMedia(x1),
      TH: x0 => x0.next(),
      TI: x0 => new WeakRef(x0),
      U: (x0,x1,x2) => x0.call(x1,x2),
      UB: () => ({}),
      UC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      UD: (x0,x1) => x0.getPropertyValue(x1),
      UE: x0 => x0.value,
      UF: (x0,x1) => { x0.content = x1 },
      UG: x0 => x0.matches,
      UH: x0 => x0.current(),
      UI: x0 => x0.deref(),
      V: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      VB: (o, p, v) => o[p] = v,
      VC: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      VD: (x0,x1) => x0.warn(x1),
      VE: x0 => x0.selectionDirection,
      VF: x0 => x0.head,
      VG: x0 => x0.timeStamp,
      VH: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      VI: () => globalThis.WeakRef,
      W: x0 => new Array(x0),
      WB: () => [],
      WC: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      WD: x0 => x0.console,
      WE: x0 => x0.selectionStart,
      WF: (x0,x1) => { x0.name = x1 },
      WG: (x0,x1) => x0.hasAttribute(x1),
      WH: x0 => x0.v8BreakIterator,
      WI: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      X: o => [o],
      XB: b => !!b,
      XC: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      XD: (x0,x1) => { x0.id = x1 },
      XE: x0 => x0.selectionEnd,
      XF: (x0,x1) => { x0.title = x1 },
      XG: x0 => x0.buttons,
      XH: () => globalThis.Intl,
      XI: (a, s, e) => a.slice(s, e),
      Y: (o0, o1) => [o0, o1],
      YB: x0 => new Int8Array(x0),
      YC: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      YD: (x0,x1) => x0.requestAnimationFrame(x1),
      YE: (x0,x1) => { x0.name = x1 },
      YF: () => globalThis.document,
      YG: x0 => x0.ctrlKey,
      YH: (x0,x1) => x0.segment(x1),
      YI: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      Z: (o0, o1, o2) => [o0, o1, o2],
      ZB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      ZC: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      ZD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      ZE: (x0,x1) => { x0.placeholder = x1 },
      ZF: (x0,x1) => x0.vibrate(x1),
      ZG: x0 => x0.y,
      ZH: x0 => x0.index,
      ZI: x0 => x0.hostElement,
      a: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      aB: x0 => new Uint8Array(x0),
      aC: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      aD: x0 => x0.now(),
      aE: (x0,x1) => { x0.autocomplete = x1 },
      aF: (o, p) => p in o,
      aG: x0 => x0.x,
      aH: x0 => x0.next(),
      aI: x0 => x0.location,
      b: (x0,x1,x2) => { x0[x1] = x2 },
      bB: x0 => new Uint8ClampedArray(x0),
      bC: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      bD: x0 => x0.performance,
      bE: (x0,x1) => { x0.type = x1 },
      bF: x0 => x0.arrayBuffer(),
      bG: x0 => x0.offsetTop,
      bH: x0 => x0.value,
      bI: (x0,x1) => x0.getModifierState(x1),
      c: o => o,
      cB: x0 => new Int16Array(x0),
      cC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      cD: (x0,x1) => x0.unregister(x1),
      cE: (x0,x1) => { x0.name = x1 },
      cF: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      cG: x0 => x0.scrollLeft,
      cH: x0 => x0.done,
      cI: x0 => x0.metaKey,
      d: (o, p) => o[p],
      dB: x0 => new Uint16Array(x0),
      dC: x0 => x0.history,
      dD: () => globalThis.window.FinalizationRegistry,
      dE: (x0,x1) => { x0.placeholder = x1 },
      dF: x0 => x0.status,
      dG: x0 => x0.offsetLeft,
      dH: (o, m, a) => o[m].apply(o, a),
      dI: x0 => x0.altKey,
      e: () => globalThis,
      eB: x0 => new Int32Array(x0),
      eC: () => globalThis.window,
      eD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      eE: (x0,x1) => { x0.scrollTop = x1 },
      eF: (x0,x1) => x0.fetch(x1),
      eG: x0 => x0.offsetParent,
      eH: x0 => x0.iterator,
      eI: x0 => x0.ctrlKey,
      f: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      fC: x0 => x0.search,
      fD: x0 => new window.FinalizationRegistry(x0),
      fE: x0 => x0.tagName,
      fF: x0 => x0.content,
      fG: x0 => x0.deltaMode,
      fH: () => globalThis.Symbol,
      fI: x0 => x0.isComposing,
      g: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gB: x0 => new Uint32Array(x0),
      gC: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      gD: x0 => x0.scale,
      gE: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      gF: x0 => x0.document,
      gG: x0 => x0.deltaY,
      gH: (x0,x1) => new Intl.Segmenter(x0,x1),
      gI: x0 => x0.code,
      h: (x0,x1) => ({addView: x0,removeView: x1}),
      hB: x0 => new Float32Array(x0),
      hC: x0 => x0.location,
      hD: x0 => x0.visualViewport,
      hE: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      hF: x0 => x0.language,
      hG: x0 => x0.deltaX,
      hH: x0 => x0.Segmenter,
      hI: x0 => x0.repeat,
      i: (l, r) => l === r,
      iB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      iC: x0 => x0.pathname,
      iD: x0 => x0.devicePixelRatio,
      iE: x0 => x0.visibilityState,
      iF: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      iG: x0 => x0.wheelDeltaY,
      iH: x0 => x0.buffer,
      iI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      j: (string, token) => string.split(token),
      jB: x0 => new Float64Array(x0),
      jC: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      jD: (d, digits) => d.toFixed(digits),
      jE: x0 => x0.hasFocus(),
      jF: (x0,x1) => x0.prepend(x1),
      jG: x0 => x0.wheelDeltaX,
      jH: x0 => x0.wasmMemory,
      jI: x0 => x0.userAgent,
      k: o => o instanceof Array,
      kB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      kC: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      kD: x0 => x0.maxHeight,
      kE: x0 => x0.relatedTarget,
      kF: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      kG: x0 => x0.key,
      kH: () => globalThis.window._flutter_skwasmInstance,
      kI: x0 => x0.navigator,
      l: (a, i) => a[i],
      lB: x0 => new ArrayBuffer(x0),
      lC: o => Object.keys(o),
      lD: x0 => x0.maxWidth,
      lE: x0 => x0.index,
      lF: (x0,x1) => x0.querySelector(x1),
      lG: x0 => x0.identifier,
      lH: () => new TextDecoder(),
      lI: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      m: a => a.length,
      mB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      mC: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      mD: x0 => x0.minHeight,
      mE: x0 => x0.unicode,
      mF: (x0,x1) => x0.querySelectorAll(x1),
      mG: x0 => x0.touches,
      mH: (map, o, v) => map.set(o, v),
      mI: () => globalThis.window,
      n: (string, times) => string.repeat(times),
      nB: (x0,x1,x2) => new DataView(x0,x1,x2),
      nC: f => f.dartFunction,
      nD: x0 => x0.minWidth,
      nE: (x0,x1) => { x0.lastIndex = x1 },
      nF: x0 => x0.tabIndex,
      nG: x0 => x0.pressure,
      nH: (map, o) => map.get(o),
      nI: x0 => x0.length,
      o: (decoder, codeUnits) => decoder.decode(codeUnits),
      oB: (o, p) => o[p],
      oC: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      oD: x0 => x0.height,
      oE: x0 => x0.dotAll,
      oF: x0 => x0.parentNode,
      oG: x0 => x0.tiltY,
      oH: () => new WeakMap(),
      oI: x0 => x0.getReader(),
      p: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      pB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      pC: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      pD: x0 => x0.width,
      pE: x0 => x0.ignoreCase,
      pF: x0 => x0.clientY,
      pG: x0 => x0.tiltX,
      pH: (handle) => clearInterval(handle),
      pI: x0 => x0.value,
      q: () => new TextDecoder("utf-8", {fatal: true}),
      qB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      qC: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      qD: x0 => x0.screen,
      qE: x0 => x0.multiline,
      qF: x0 => x0.clientX,
      qG: x0 => x0.pointerType,
      qH: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      qI: x0 => x0.done,
      r: () => new TextDecoder("utf-8", {fatal: false}),
      rB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      rC: (o, i) => o[i],
      rD: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      rE: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      rF: x0 => x0.getBoundingClientRect(),
      rG: x0 => x0.pointerId,
      rH: () => Date.now(),
      rI: x0 => x0.read(),
      s: s => s.trimLeft(),
      sB: o => o.byteOffset,
      sC: o => o.length,
      sD: (x0,x1) => x0.removeProperty(x1),
      sE: x0 => x0.keyCode,
      sF: x0 => x0.bottom,
      sG: x0 => x0.getCoalescedEvents(),
      sH: x0 => x0.debugSkipFontRetryDelay,
      sI: x0 => x0.body,
      t: (a, i, v) => a[i] = v,
      tB: o => o.buffer,
      tC: o => {
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
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        if (o instanceof Promise) return 18;
        return 19;
      },
      tD: (x0,x1) => x0.appendChild(x1),
      tE: (x0,x1) => x0.scrollIntoView(x1),
      tF: x0 => x0.top,
      tG: (x0,x1) => x0.getModifierState(x1),
      tH: (x0,x1,x2) => x0.set(x1,x2),
      tI: (x0,x1) => new OffscreenCanvas(x0,x1),
      u: s => s.toUpperCase(),
      uB: (b, o) => new DataView(b, o),
      uC: x0 => x0.state,
      uD: x0 => x0.debugShowSemanticsNodes,
      uE: x0 => x0.multiViewEnabled,
      uF: x0 => x0.right,
      uG: x0 => x0.blur(),
      uH: x0 => x0.fontFallbackBaseUrl,
      uI: x0 => x0.assetBase,
      v: Object.is,
      vB: (b, o, l) => new DataView(b, o, l),
      vC: x0 => x0.hash,
      vD: (o, c) => o instanceof c,
      vE: x0 => x0.parent,
      vF: x0 => x0.left,
      vG: x0 => x0.button,
      vH: (x0,x1,x2) => x0.insertBefore(x1,x2),
      vI: x0 => x0.loader,
      w: (x0,x1) => x0.test(x1),
      wB: Function.prototype.call.bind(DataView.prototype.getUint8),
      wC: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      wD: x0 => x0.vendor,
      wE: (x0,x1) => x0.replaceWith(x1),
      wF: x0 => x0.clientY,
      wG: x0 => x0.innerHeight,
      wH: x0 => x0.id,
      wI: () => globalThis._flutter,
      x: o => o,
      xB: Function.prototype.call.bind(DataView.prototype.setUint8),
      xC: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      xD: (x0,x1) => x0.createTextNode(x1),
      xE: (x0,x1) => { x0.className = x1 },
      xF: x0 => x0.clientX,
      xG: x0 => x0.height,
      xH: x0 => x0.offsetHeight,
      y: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      yB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      yC: x0 => x0.state,
      yD: (x0,x1) => { x0.nonce = x1 },
      yE: (x0,x1) => { x0.tabIndex = x1 },
      yF: x0 => x0.changedTouches,
      yG: x0 => x0.clientHeight,
      yH: x0 => x0.offsetWidth,
      z: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      zB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      zC: (x0,x1,x2) => x0.addEventListener(x1,x2),
      zD: x0 => x0.nonce,
      zE: (x0,x1) => { x0.action = x1 },
      zF: x0 => x0.offsetY,
      zG: x0 => x0.innerWidth,
      zH: x0 => x0.stopPropagation(),

    };

    const baseImports = {
      _: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      WebAssembly: {
        JSTag: WebAssembly.JSTag,
      },
      "": new Proxy({}, { get(_, prop) { return prop; } }),

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
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
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
