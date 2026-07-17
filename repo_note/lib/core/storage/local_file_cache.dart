import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Markdown 원문 파일 캐시.
/// 파일명 충돌 방지를 위해 vaultId + 경로를 해시한 내부 경로를 사용한다.
class LocalFileCache {
  Directory? _baseDir;

  Future<Directory> _base() async {
    if (_baseDir != null) return _baseDir!;
    final support = await getApplicationSupportDirectory();
    final dir = Directory(p.join(support.path, 'note_cache'));
    if (!await dir.exists()) await dir.create(recursive: true);
    _baseDir = dir;
    return dir;
  }

  String _hashedName(String vaultId, String path) =>
      sha1.convert(utf8.encode('$vaultId:$path')).toString();

  Future<File> _fileFor(String vaultId, String path) async {
    final base = await _base();
    final vaultDir = Directory(p.join(base.path, vaultId));
    if (!await vaultDir.exists()) await vaultDir.create(recursive: true);
    return File(p.join(vaultDir.path, '${_hashedName(vaultId, path)}.md'));
  }

  Future<String?> read(String vaultId, String path) async {
    final file = await _fileFor(vaultId, path);
    if (!await file.exists()) return null;
    return file.readAsString();
  }

  Future<String> write(String vaultId, String path, String content) async {
    final file = await _fileFor(vaultId, path);
    await file.writeAsString(content, flush: true);
    return file.path;
  }

  Future<void> delete(String vaultId, String path) async {
    final file = await _fileFor(vaultId, path);
    if (await file.exists()) await file.delete();
  }

  Future<void> clearVault(String vaultId) async {
    final base = await _base();
    final vaultDir = Directory(p.join(base.path, vaultId));
    if (await vaultDir.exists()) await vaultDir.delete(recursive: true);
  }

  Future<void> clearAll() async {
    final base = await _base();
    if (await base.exists()) await base.delete(recursive: true);
    _baseDir = null;
  }
}
