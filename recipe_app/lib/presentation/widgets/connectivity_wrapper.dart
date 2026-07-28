import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/l10n/app_localizations.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOffline = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _checkInitialConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final offline =
          results.contains(ConnectivityResult.none) || results.isEmpty;
      if (offline != _isOffline) {
        setState(() {
          _isOffline = offline;
        });
      }
    });
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    final offline =
        results.contains(ConnectivityResult.none) || results.isEmpty;
    if (offline != _isOffline) {
      setState(() {
        _isOffline = offline;
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOffline) {
      return widget.child;
    }

    final l10n = AppLocalizations.of(context);
    final textString = l10n != null
        ? l10n.noInternet
        : "No internet connection currently";

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colorScheme.surface,
              context.colorScheme.surfaceContainerLow,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colorScheme.error.withValues(
                            alpha: 0.08,
                          ),
                          border: Border.all(
                            color: context.colorScheme.error.withValues(
                              alpha: 0.2 * _pulseController.value,
                            ),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.colorScheme.error.withValues(
                                alpha: 0.1 * _pulseController.value,
                              ),
                              blurRadius: 20 * _pulseController.value + 10,
                              spreadRadius: 4 * _pulseController.value,
                            ),
                          ],
                        ),
                        child: child,
                      );
                    },
                    child: Icon(
                      Icons.wifi_off_rounded,
                      size: 64,
                      color: context.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    textString,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 0.15,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n != null
                        ? "Please check your connection and try again"
                        : "Please check your connection and try again", // Fallback description
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Trigger another check
                      await _checkInitialConnectivity();
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: Text(
                      l10n?.retryBtn ?? "Retry",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.primary,
                      foregroundColor: context.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      elevation: 3,
                      shadowColor: context.colorScheme.primary.withValues(
                        alpha: 0.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
