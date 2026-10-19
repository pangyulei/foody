import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';

class LoadErrorView extends StatelessWidget {
  final String detail;
  final VoidCallback onRetry;

  const LoadErrorView({super.key, required this.detail, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final t = AppStrings.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 12),
          Text(t.loadFailed),
          const SizedBox(height: 4),
          Text(
            detail,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: Text(t.retry)),
        ],
      ),
    );
  }
}
