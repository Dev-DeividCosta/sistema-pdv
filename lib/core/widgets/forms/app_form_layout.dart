import 'package:flutter/material.dart';
import '../navigation/app_app_bar.dart';
import '../navigation/app_navigation_bar.dart';

class AppFormLayout extends StatelessWidget {
  final String title;
  final Color appBarColor;
  final Widget child;

  const AppFormLayout({
    super.key,
    required this.title,
    required this.appBarColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF2C2C2C),
      appBar: AppAppBar(
        title: title,
        backgroundColor: appBarColor,
      ),
      bottomNavigationBar: isKeyboardOpen ? null : const AppNavigationBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 110.0),
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}