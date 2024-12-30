class GlobalState {
  static final GlobalState _instance = GlobalState._internal();

  String? currentUserId;
  bool soundAllowed = true; // Tracks if sound is enabled or disabled

  factory GlobalState() {
    return _instance;
  }

  GlobalState._internal();
}
