import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/debouncer.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/presentation/session_controller.dart';
import '../../file_browser/data/notes_repository.dart';

/// 파일명 + 로컬 캐시 본문 검색. 서버 검색 API를 사용하지 않는다.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _debouncer = Debouncer(const Duration(milliseconds: 300));
  List<SearchHit> _hits = [];
  bool _searched = false;

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debouncer.run(() async {
      final vault = ref.read(sessionControllerProvider).value?.vault;
      if (vault == null) return;
      final hits = await ref.read(notesRepositoryProvider).search(vault, query);
      if (mounted) {
        setState(() {
          _hits = hits;
          _searched = query.trim().isNotEmpty;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
          ),
          onChanged: _onQueryChanged,
        ),
      ),
      body: _hits.isEmpty
          ? Center(child: Text(_searched ? l10n.noResults : l10n.enterQuery))
          : ListView.builder(
              itemCount: _hits.length,
              itemBuilder: (context, index) {
                final hit = _hits[index];
                return ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(hit.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hit.path,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (hit.snippet != null)
                        Text(
                          hit.snippet!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  onTap: () => context.push('/editor?fileId=${hit.fileId}'),
                );
              },
            ),
    );
  }
}
