import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../account_profile.dart';

@lazySingleton
final class AccountRecoveryStore {
  AccountRecoveryStore() : this.inDirectory(getApplicationSupportDirectory);

  AccountRecoveryStore.inDirectory(this._findDirectory);

  final Future<Directory> Function() _findDirectory;
  Future<void> _operations = Future<void>.value();

  Future<AccountProfile?> read(String uid) => _serialize(() => _read(uid));

  Future<void> write(String uid, AccountProfile profile) => _serialize(
    () async {
      final file = await _file(uid);
      await file.parent.create(recursive: true);
      // Keep the previous weight intact until the replacement has been flushed.
      final temporary = File('${file.path}.tmp');
      await temporary.writeAsString('${profile.bodyWeightKg}', flush: true);
      await temporary.rename(file.path);
    },
  );

  Future<void> clearIfMatches(String uid, AccountProfile confirmed) =>
      _serialize(() async {
        if (await _read(uid) == confirmed) await (await _file(uid)).delete();
      });

  Future<AccountProfile?> _read(String uid) async {
    final file = await _file(uid);
    final String contents;
    try {
      contents = await file.readAsString();
    } on PathNotFoundException {
      return null;
    }
    final weight = double.tryParse(contents);
    if (weight == null || !AccountProfile.acceptsWeight(weight)) {
      throw const FormatException('Invalid stored account weight');
    }
    return AccountProfile(bodyWeightKg: weight);
  }

  Future<File> _file(String uid) async {
    final directory = await _findDirectory();
    final key = base64Url.encode(utf8.encode(uid));
    return File('${directory.path}/account_setup/$key.weight');
  }

  Future<T> _serialize<T>(Future<T> Function() operation) {
    final result = _operations.then((_) => operation());
    _operations = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return result;
  }
}
