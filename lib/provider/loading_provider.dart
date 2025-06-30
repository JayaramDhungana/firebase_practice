import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingProvider extends ChangeNotifier {
  bool isLoading = false;

  void changeLoadingState( bool loadingState) {
    isLoading = loadingState;
    notifyListeners();
  }
}

final loadingProvider = ChangeNotifierProvider((ref) {
  return LoadingProvider();
});
