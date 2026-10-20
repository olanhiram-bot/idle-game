import 'package:web/web.dart' as web;

String sessionOwner() {
  const key = 'farol-tab-owner';
  final existing = web.window.sessionStorage.getItem(key);
  if (existing != null) return existing;
  final owner = web.window.crypto.randomUUID();
  web.window.sessionStorage.setItem(key, owner);
  return owner;
}
