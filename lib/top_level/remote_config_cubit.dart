import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'remote_config_state.dart';

class RemoteConfigCubit extends Cubit<RemoteConfigState> {
  late StreamSubscription _subscription;
  late final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigCubit() : super(const RemoteConfigLoaded({})) {
    _remoteConfig = FirebaseRemoteConfig.instance;
    init(RemoteConfigItems.toMap());
  }

  Future<void> init(defaults) async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 15),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await _remoteConfig.ensureInitialized();
      await _remoteConfig.setDefaults(defaults);
      await _remoteConfig.fetchAndActivate();
      emit(RemoteConfigInitial(getConfig()));
    } catch (exception, st) {
      Logger().e(exception, stackTrace: st);
    }
  }

  Stream<RemoteConfigUpdate> getOnConfigUpdated() =>
      _remoteConfig.onConfigUpdated;

  Future<Map<String, RemoteConfigValue>> update() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (exception, s) {
      Logger().w(exception, stackTrace: s);
    }
    return getConfig();
  }

  Map<String, RemoteConfigValue> getConfig() {
    return _remoteConfig.getAll();
  }

  bool getBool(String key) {
    return _remoteConfig.getAll()[key]?.asBool() ?? false;
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
