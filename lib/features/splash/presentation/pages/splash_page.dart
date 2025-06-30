import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/app_context_extensions.dart';
import '../../../../main.dart'; // For HomePage navigation

/// SplashPage displays a Lottie animation and creator, then navigates to HomePage.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomePage after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor, // Use context extension
      body: SafeArea(
        child: Stack(
          children: [
            // Centered Lottie animation
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                padding: EdgeInsets.all(context.splashCirclePadding),
                child: Lottie.asset(
                  AppStrings.splashLottieAsset,
                  width: context.splashIconSize,
                  height: context.splashIconSize,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),
            // Creator text at the bottom
            Positioned(
              bottom: context.splashBottomSpacing,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    AppStrings.createdBy,
                    style: context.caption,
                  ),
                  SizedBox(height: context.splashTextSpacing),
                  Text(
                    AppStrings.creatorName,
                    style: context.headline.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
