import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/app_store.dart';
import '../data/classifier.dart';
import '../models/category.dart';
import '../models/service_request.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/category_tile.dart';
import 'matching_screen.dart';
import 'my_requests_screen.dart';

/// "What's going on?" — the requester's entry point (design.md §8).
/// Friction at the start: user describes the issue; tapping a category or
/// submitting text starts the match flow.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});

  final AppStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  ServiceCategory? _selected;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String text) {
    if (text.trim().isEmpty && _selected == null) return;
    final request = _selected == null
        ? Classifier.classify(text)
        : ServiceRequest(
            text: text.trim().isEmpty
                ? _selected!.label
                : '${_selected!.label}: ${text.trim()}',
            category: _selected!,
            urgency: Classifier.inferUrgency(text),
            mode: Classifier.inferMode(text),
          );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MatchingScreen(
          store: widget.store,
          request: request,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('requesT'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MyRequestsScreen(store: widget.store),
              ),
            ),
            icon: const Icon(Icons.history_rounded, size: 18),
            label: const Text('My requests'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            const SizedBox(height: 8),
            Text(
              "What's going on?",
              style: text.displaySmall?.copyWith(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              'Describe the problem in your own words — we\'ll match you '
              'with a nearby, verified shop that can actually fix it.',
              style: text.bodyMedium?.copyWith(color: AppColors.slate),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'e.g. leaking pipe under the kitchen sink',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _submit,
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => _submit(_controller.text),
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('Find help'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Text('Or pick a category', style: text.titleMedium),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() => _selected = null);
                    _controller.clear();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.slate,
                    textStyle: text.labelMedium,
                  ),
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.78,
              children: [
                for (final category in ServiceCategory.values)
                  CategoryTile(
                    category: category,
                    selected: _selected == category,
                    onTap: () {
                      setState(() => _selected = category);
                      _submit('');
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _PronunciationHint(text: text),
          ],
        ),
      ),
    );
  }
}

class _PronunciationHint extends StatelessWidget {
  const _PronunciationHint({required this.text});

  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mintWash,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      ),
      child: Row(
        children: [
          Text('request', style: text.bodyMedium),
          Text(
            ' → ',
            style: text.bodyMedium?.copyWith(color: AppColors.slate),
          ),
          Text(
            'requesT',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.deepTeal,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '· say it: "requestee"',
            style: text.labelMedium?.copyWith(color: AppColors.deepTeal),
          ),
        ],
      ),
    );
  }
}
