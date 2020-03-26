'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "997d42482a332cfee068da0327f6b6c5",
"CNAME": "ac4e7539e555d65d75d7ab6fdb594c57",
"main.dart.js": "e1ae3dae40e89949548e8a24644c5fb8",
"assets/LICENSE": "344a7d6d5d4c4759c44ce422fd99f052",
"assets/AssetManifest.json": "8f761014e51230aa2d057b1160574051",
"assets/FontManifest.json": "0fcebabcb068b3fbddc62deb53890e93",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/assets/fonts/RobotoMono-Regular.ttf": "b4618f1f7f4cee0ac09873fcc5a966f9"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
