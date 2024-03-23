part of 'remote_config_cubit.dart';

abstract class RemoteConfigState extends Equatable {
  final Map<String, RemoteConfigValue> remoteConfig;

  const RemoteConfigState({required this.remoteConfig});

  @override
  List<Object?> get props => [remoteConfig];
}

class RemoteConfigInitial extends RemoteConfigState {
  const RemoteConfigInitial(Map<String, RemoteConfigValue> remoteConfig)
      : super(remoteConfig: remoteConfig);

  @override
  String toString() {
    return 'RemoteConfigInitial';
  }
}

class RemoteConfigLoaded extends RemoteConfigState {
  const RemoteConfigLoaded(Map<String, RemoteConfigValue> remoteConfig)
      : super(remoteConfig: remoteConfig);

  @override
  String toString() {
    return 'RemoteConfigLoaded';
  }
}

// REMOTE CONFIG ITEMS
enum RemoteConfigItems {
  bookPrice(8000),

  something(0.756);

  final dynamic defaultVale;

  static Map<String, dynamic> toMap() {
    return {
      for (final item in RemoteConfigItems.values) item.name: item.defaultVale
    };
  }

  const RemoteConfigItems(this.defaultVale);
}
