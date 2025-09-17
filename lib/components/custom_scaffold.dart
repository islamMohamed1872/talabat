import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const CustomScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // White background
        Container(color: Colors.white),

        // Semi-transparent orange circle in top-left
        Positioned(
          top: -130,
          left: -130,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                color: Color(0x80FF7119), // #FF7119 at 50% opacity
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        // Actual Scaffold content
        AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFFFF7119), // your color
            statusBarIconBrightness: Brightness.light, // white icons
            statusBarBrightness: Brightness.dark, // for iOS
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appBar,
            body: body,
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
          ),
        ),
      ],
    );
  }
}
