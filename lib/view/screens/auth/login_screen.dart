import 'package:flutter/material.dart';
import 'package:slic/utils/assets.dart';
import 'package:slic/view/screens/main_screen.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SLIC WBS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            Image.asset(
              AppAssets.logo, // Update this to your actual logo path
              height: 100, // Adjust height as needed
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Login ID',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            const TextFieldWidget(
              hintText: 'Enter your login ID',
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Password',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            TextFieldWidget(
              hintText: 'Enter your password',
              obscureText: _obscureText,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ),
                );
              },
              child: const Text("Log in"),
            ),
          ],
        ),
      ),
    );
  }
}
