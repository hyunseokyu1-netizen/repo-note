import 'package:flutter/widgets.dart';

import '../../l10n/gen/app_localizations.dart';
import 'app_failure.dart';

/// AppFailure를 현재 언어의 사용자 메시지로 변환한다.
String failureMessage(BuildContext context, AppFailure failure) {
  final l10n = AppLocalizations.of(context);
  return switch (failure) {
    NetworkFailure() => l10n.errNetwork,
    UnauthorizedFailure() => l10n.errUnauthorized,
    PermissionDeniedFailure() => l10n.errPermission,
    RateLimitFailure() => l10n.errRateLimit,
    NotFoundFailure() => l10n.errNotFound,
    ConflictFailure() => l10n.errConflict,
    LocalStorageFailure() => l10n.errLocalStorage,
    ValidationFailure(:final kind) => validationMessage(context, kind),
    UnknownFailure() => l10n.errUnknown,
  };
}

String validationMessage(BuildContext context, ValidationErrorKind kind) {
  final l10n = AppLocalizations.of(context);
  return switch (kind) {
    ValidationErrorKind.emptyName => l10n.errNameEmpty,
    ValidationErrorKind.slashInName => l10n.errNameSlash,
    ValidationErrorKind.dotsInName => l10n.errNameDots,
    ValidationErrorKind.specialChars => l10n.errNameSpecial,
    ValidationErrorKind.duplicateName => l10n.errNameDuplicate,
    ValidationErrorKind.renamePartialFailure => l10n.errRenamePartial,
  };
}
