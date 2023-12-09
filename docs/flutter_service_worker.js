'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"manifest.json": "8ddc7178275d6520cec4e8c638980e9a",
"favicon.png": "ca8da297174aeee31b7885737db9fad8",
"index.html": "aec013722344dfc30a7af71ae9721996",
"/": "aec013722344dfc30a7af71ae9721996",
"main.dart.js": "44a3842dbda17d89ee342a9b2ff042ce",
"assets/FontManifest.json": "f28e381a20a4266c6868013164e190af",
"assets/AssetManifest.json": "4d1d7504157617a6c7f6623f0e08817c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/AssetManifest.bin": "1f203590fd6016aa504cb1b92a93c355",
"assets/assets/images/blue.png": "22136e67d24fcc380f23a80d4e541085",
"assets/assets/images/pause_icon.png": "2d9349d505924405f05bc36022a216b4",
"assets/assets/fonts/iconfont.ttf": "8df62a40f3c69fc5c78cbd0057749c59",
"assets/assets/audio/glass_001.ogg": "a2dd3e42c9d9643eac6ffb2299fbc71a",
"assets/assets/audio/pepSound2.mp3": "ff0bd0374c71b30e5ff7dfe106ff261c",
"assets/assets/audio/drop_003.ogg": "a7fbcb59b45db1d2b998ea416bf52c62",
"assets/assets/audio/merge.ogg": "d155c407d48937ff851b7d13583c347c",
"assets/assets/audio/hurt.ogg": "a2dd3e42c9d9643eac6ffb2299fbc71a",
"assets/assets/audio/drop_002.ogg": "c93648d84483c6ba9c375ba570ab1648",
"assets/assets/audio/energy.ogg": "486b022fdb020e14c527b3da772aac8a",
"assets/assets/audio/threeTone2.ogg": "71b860f69c9d6553dbcfca30e9471363",
"assets/assets/audio/dead.ogg": "d6a1eb6941239dc7efa8902088684086",
"assets/assets/audio/pepSound3.ogg": "2938b7b0af3bbeb42a1014e090ef248b",
"assets/assets/audio/drop_001.ogg": "fdb7c6bd1abf0e06c75f5ef3ee29d5a2",
"assets/assets/audio/click.ogg": "c78792d47b805c726b2fb1ad5f03c81d",
"assets/assets/audio/drop_002.mp3": "5cbacf3b6fae9dafa2b192c4678cc4f9",
"assets/assets/audio/back_002.ogg": "24369863311bc19adbdc989a182b6e21",
"assets/assets/audio/drop_004.ogg": "486b022fdb020e14c527b3da772aac8a",
"assets/assets/audio/move.mp3": "5cbacf3b6fae9dafa2b192c4678cc4f9",
"assets/assets/audio/pepSound2.ogg": "c58684c8a867770ec74cfd9d626452d6",
"assets/assets/audio/shoot.ogg": "f1ceb52ee4db5efd8099e7145d6ab983",
"assets/assets/audio/powerUp9.ogg": "29cbb5cc540ef46b057f61160d11d8b3",
"assets/assets/audio/bong_001.ogg": "c78792d47b805c726b2fb1ad5f03c81d",
"assets/assets/audio/laser5.ogg": "f1ceb52ee4db5efd8099e7145d6ab983",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/fonts/MaterialIcons-Regular.otf": "32fce58e2acb9c420eab0fe7b828b761",
"assets/NOTICES": "01baea5f3b758214d27488fa95f74b16",
"assets/AssetManifest.bin.json": "69cc6eb4e223a46ead9022f477f53016",
"version.json": "f01e52768cf8c246fb8cc93ebcebda12",
"canvaskit/canvaskit.wasm": "64edb91684bdb3b879812ba2e48dd487",
"canvaskit/skwasm.wasm": "4124c42a73efa7eb886d3400a1ed7a06",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/chromium/canvaskit.wasm": "f87e541501c96012c252942b6b75d1ea",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"icons/Icon-512.png": "4ac3c540d35742510514fb0242407f69",
"icons/Icon-maskable-512.png": "4ac3c540d35742510514fb0242407f69",
"icons/Icon-192.png": "27d9acad39cbbbff7186d84f803974ac",
"icons/Icon-maskable-192.png": "27d9acad39cbbbff7186d84f803974ac",
"flutter.js": "7d69e653079438abfbb24b82a655b0a4"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
