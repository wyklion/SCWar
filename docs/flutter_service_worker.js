'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"manifest.json": "b9cdb14b7fb731dbb54a144847b5744f",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"version.json": "f01e52768cf8c246fb8cc93ebcebda12",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"index.html": "5bdc053ba7dce45b7bbedebf050cc2d9",
"/": "5bdc053ba7dce45b7bbedebf050cc2d9",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/NOTICES": "4c38ba870902110e8aa8eec9e7b13a28",
"assets/AssetManifest.json": "c43f8529f0c277f672ef7a39c8c6282e",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/assets/audio/click.ogg": "c78792d47b805c726b2fb1ad5f03c81d",
"assets/assets/audio/move.mp3": "5cbacf3b6fae9dafa2b192c4678cc4f9",
"assets/assets/audio/energy.ogg": "486b022fdb020e14c527b3da772aac8a",
"assets/assets/audio/drop_004.ogg": "486b022fdb020e14c527b3da772aac8a",
"assets/assets/audio/powerUp9.ogg": "29cbb5cc540ef46b057f61160d11d8b3",
"assets/assets/audio/bong_001.ogg": "c78792d47b805c726b2fb1ad5f03c81d",
"assets/assets/audio/shoot.ogg": "f1ceb52ee4db5efd8099e7145d6ab983",
"assets/assets/audio/pepSound2.ogg": "c58684c8a867770ec74cfd9d626452d6",
"assets/assets/audio/drop_002.ogg": "c93648d84483c6ba9c375ba570ab1648",
"assets/assets/audio/drop_001.ogg": "fdb7c6bd1abf0e06c75f5ef3ee29d5a2",
"assets/assets/audio/pepSound3.ogg": "2938b7b0af3bbeb42a1014e090ef248b",
"assets/assets/audio/pepSound2.mp3": "ff0bd0374c71b30e5ff7dfe106ff261c",
"assets/assets/audio/threeTone2.ogg": "71b860f69c9d6553dbcfca30e9471363",
"assets/assets/audio/laser5.ogg": "f1ceb52ee4db5efd8099e7145d6ab983",
"assets/assets/audio/drop_003.ogg": "a7fbcb59b45db1d2b998ea416bf52c62",
"assets/assets/audio/hurt.ogg": "a2dd3e42c9d9643eac6ffb2299fbc71a",
"assets/assets/audio/back_002.ogg": "24369863311bc19adbdc989a182b6e21",
"assets/assets/audio/dead.ogg": "d6a1eb6941239dc7efa8902088684086",
"assets/assets/audio/drop_002.mp3": "5cbacf3b6fae9dafa2b192c4678cc4f9",
"assets/assets/audio/glass_001.ogg": "a2dd3e42c9d9643eac6ffb2299fbc71a",
"assets/assets/audio/merge.ogg": "d155c407d48937ff851b7d13583c347c",
"assets/assets/images/pause_icon.png": "2d9349d505924405f05bc36022a216b4",
"assets/assets/images/blue.png": "22136e67d24fcc380f23a80d4e541085",
"assets/AssetManifest.bin": "4b4fd189bc28d3269e82d106c4b0f9fd",
"assets/fonts/MaterialIcons-Regular.otf": "32fce58e2acb9c420eab0fe7b828b761",
"canvaskit/skwasm.wasm": "1a074e8452fe5e0d02b112e22cdcf455",
"canvaskit/canvaskit.js": "bbf39143dfd758d8d847453b120c8ebb",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/canvaskit.wasm": "42df12e09ecc0d5a4a34a69d7ee44314",
"canvaskit/chromium/canvaskit.js": "96ae916cd2d1b7320fff853ee22aebb0",
"canvaskit/chromium/canvaskit.wasm": "be0e3b33510f5b7b0cc76cc4d3e50048",
"main.dart.js": "8e36c4eb64f61d547b14fcbf0dfaa45c"};
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
