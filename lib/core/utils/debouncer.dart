import 'dart:async';

/// 입력 debounce 유틸. 마지막 호출 후 [delay]가 지나면 콜백을 실행한다.
class Debouncer {
  Debouncer(this.delay);

  final Duration delay;
  Timer? _timer;

  bool get isActive => _timer?.isActive ?? false;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// 예약된 콜백을 취소하고 즉시 실행한다.
  void flush(void Function() action) {
    _timer?.cancel();
    action();
  }

  void cancel() => _timer?.cancel();

  void dispose() => _timer?.cancel();
}
