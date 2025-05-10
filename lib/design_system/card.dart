import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, this.onTap, required this.child});

  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Stack(
        children: [
          child,
          if (onTap != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: onTap),
              ),
            ),
        ],
      ),
    );
  }
}
