import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repo_note/core/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('연속 호출 시 마지막 콜백만 실행된다', () {
      fakeAsync((async) {
        final debouncer = Debouncer(const Duration(milliseconds: 500));
        var count = 0;
        debouncer.run(() => count++);
        async.elapse(const Duration(milliseconds: 200));
        debouncer.run(() => count++);
        async.elapse(const Duration(milliseconds: 200));
        debouncer.run(() => count++);
        async.elapse(const Duration(milliseconds: 500));
        expect(count, 1);
        debouncer.dispose();
      });
    });

    test('지연 시간 전에는 실행되지 않는다', () {
      fakeAsync((async) {
        final debouncer = Debouncer(const Duration(milliseconds: 500));
        var executed = false;
        debouncer.run(() => executed = true);
        async.elapse(const Duration(milliseconds: 499));
        expect(executed, isFalse);
        async.elapse(const Duration(milliseconds: 1));
        expect(executed, isTrue);
        debouncer.dispose();
      });
    });

    test('flush는 즉시 실행한다', () {
      fakeAsync((async) {
        final debouncer = Debouncer(const Duration(milliseconds: 500));
        var count = 0;
        debouncer.run(() => count++);
        debouncer.flush(() => count += 10);
        async.elapse(const Duration(seconds: 1));
        expect(count, 10);
        debouncer.dispose();
      });
    });

    test('cancel은 예약을 취소한다', () {
      fakeAsync((async) {
        final debouncer = Debouncer(const Duration(milliseconds: 500));
        var executed = false;
        debouncer.run(() => executed = true);
        debouncer.cancel();
        async.elapse(const Duration(seconds: 1));
        expect(executed, isFalse);
      });
    });
  });
}
