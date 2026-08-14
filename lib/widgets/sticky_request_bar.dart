import 'package:flutter/material.dart';

import '../models/service_request.dart';
import '../theme/app_colors.dart';

/// Persistent compact summary of "what you asked for" shown while browsing
/// matches (design.md §7). Keeps the user anchored to their original issue.
class StickyRequestBar extends StatelessWidget {
  const StickyRequestBar({super.key, required this.request, this.onTap});

  final ServiceRequest request;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: AppColors.surface,
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.mist),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.signalCoral.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.edit_note_rounded,
                size: 20,
                color: AppColors.signalCoral,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.category.label,
                    style: text.labelSmall?.copyWith(
                      color: AppColors.slate,
                      fontSize: 11,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    request.summary,
                    style: text.titleMedium?.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.slate,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
