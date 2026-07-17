import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repo_note/features/auth/presentation/token_setup_page.dart';
import 'package:repo_note/l10n/gen/app_localizations.dart';

void main() {
  Widget wrap(Widget child, {Locale locale = const Locale('en')}) =>
      ProviderScope(
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      );

  group('TokenSetupPage (en)', () {
    testWidgets('Token 입력 필드와 연결 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(wrap(const TokenSetupPage()));
      expect(find.text('Connect GitHub'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Verify connection'), findsOneWidget);
    });

    testWidgets('빈 Token으로 연결 시 오류 메시지를 표시한다', (tester) async {
      await tester.pumpWidget(wrap(const TokenSetupPage()));
      await tester.tap(find.text('Verify connection'));
      await tester.pump();
      expect(find.text('Please enter a token.'), findsOneWidget);
    });

    testWidgets('표시/숨김 토글이 동작한다', (tester) async {
      await tester.pumpWidget(wrap(const TokenSetupPage()));
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });

  group('TokenSetupPage (ko)', () {
    testWidgets('한국어 로케일에서 한국어 문구가 표시된다', (tester) async {
      await tester.pumpWidget(
        wrap(const TokenSetupPage(), locale: const Locale('ko')),
      );
      expect(find.text('GitHub 연결'), findsOneWidget);
      expect(find.text('연결 확인'), findsOneWidget);
    });

    testWidgets('한국어 로케일에서 빈 Token 오류가 한국어로 표시된다', (tester) async {
      await tester.pumpWidget(
        wrap(const TokenSetupPage(), locale: const Locale('ko')),
      );
      await tester.tap(find.text('연결 확인'));
      await tester.pump();
      expect(find.text('Token을 입력해 주세요.'), findsOneWidget);
    });
  });
}
