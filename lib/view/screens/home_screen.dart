import 'package:flutter/material.dart';
import 'package:slic/utils/assets.dart';
import 'package:slic/utils/navigation.dart'; // Ensure this is your custom navigation with the right path
import 'package:slic/view/screens/auth/login_screen.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/dropdown/dropdown_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WBS PRO 2.0'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Image.asset(AppAssets.wearhouseBanner),
              ),
            ),
            const SizedBox(height: 16.0),
            buildAnimatedText("Select Company"),
            const DropdownWidget(
              items: <String>['Company A', 'Company B'],
              hint: "Company",
            ),
            const SizedBox(height: 8.0),
            buildAnimatedText("Select Location"),
            const DropdownWidget(
              items: <String>['Location A', 'Location B'],
              hint: "Location",
            ),
            const SizedBox(height: 16.0),
            FadeTransition(
              opacity: _fadeAnimation,
              child: AppButton(
                  text: "Proceed",
                  onPressed: () {
                    Navigation.push(context, const LoginScreen());
                  }),
            ),
            const SizedBox(height: 16.0),
            FadeTransition(
              opacity: _fadeAnimation,
              child: AppButton(
                  text: "Close",
                  onPressed: () {
                    Navigation.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedText(String text) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
