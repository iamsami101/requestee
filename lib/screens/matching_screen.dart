import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/app_store.dart';
import '../data/classifier.dart';
import '../data/matcher.dart';
import '../models/category.dart';
import '../models/service_request.dart';
import '../models/shop.dart';
import '../theme/adaptive_palette.dart';
import '../widgets/radar_pulse.dart';
import 'results_screen.dart';

/// Searching state (design.md §6): radar pulse centred on the user, then
/// results arrive. Matches by the Discovery agent (agents.md §3.3).
class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key, required this.store, required this.request});

  final AppStore store;
  final ServiceRequest request;

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  List<Shop>? _matches;

  @override
  void initState() {
    super.initState();
    _kickoff();
  }

  Future<void> _kickoff() async {
    await Future<void>.delayed(widget.store.matchingDelay);
    if (!mounted) return;
    final matches = Matcher.match(
      widget.request.category,
      onSiteOnly:
          widget.request.mode == FulfilmentMode.onSite &&
          _prefersOnSiteOnly(widget.request.category),
    );
    setState(() => _matches = matches);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          store: widget.store,
          request: widget.request,
          matches: matches,
        ),
      ),
    );
  }

  bool _prefersOnSiteOnly(ServiceCategory c) => c == ServiceCategory.plumbing;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final palette = context.palette;
    final inferred = Classifier.classify(widget.request.text);
    final hasMatches = _matches != null;

    return Scaffold(
      backgroundColor: palette.paper,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!hasMatches)
                const RadarPulse().animate().scale(
                  begin: const Offset(0.92, 0.92),
                  end: const Offset(1, 1),
                  duration: 1200.ms,
                  curve: Curves.easeOut,
                )
              else
                Icon(
                  Icons.check_circle_rounded,
                  color: palette.deepTeal,
                  size: 64,
                ).animate().scale(),
              const SizedBox(height: 40),
              AnimatedSwitcher(
                duration: 250.ms,
                child: hasMatches
                    ? Text(
                        'Matched ${_matches!.length} shops',
                        key: const ValueKey('found'),
                        style: text.titleLarge,
                      )
                    : Text(
                        'Searching nearby…',
                        key: const ValueKey('searching'),
                        style: text.titleLarge,
                      ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      widget.request.summary,
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(color: palette.slate),
                    ),
                    const SizedBox(height: 16),
                    Chip(
                      avatar: Icon(
                        Icons.category_rounded,
                        size: 16,
                        color: palette.deepTeal,
                      ),
                      label: Text(inferred.category.label),
                    ),
                    if (inferred.urgency != UrgencyTier.standard) ...[
                      const SizedBox(height: 8),
                      Chip(
                        avatar: Icon(
                          Icons.bolt_rounded,
                          size: 16,
                          color: palette.amber,
                        ),
                        label: Text(inferred.urgency.label),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
