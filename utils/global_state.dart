class GlobalState {
  static final GlobalState _instance = GlobalState._internal();

  String? currentUserId;

  factory GlobalState() {
    return _instance;
  }

  GlobalState._internal();
}
