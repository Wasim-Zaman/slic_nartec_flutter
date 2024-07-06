import 'package:flutter/material.dart';
import 'package:slic/utils/assets.dart';
import 'package:slic/view/screens/auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            Image.asset(AppAssets.wearhouseBanner),
            const SizedBox(height: 16.0),
            const Text(
              "Select Company",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButtonHideUnderline(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Select Company'),
                  items: <String>['Company A', 'Company B'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Select Location",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButtonHideUnderline(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Select Location'),
                  items:
                      <String>['Location A', 'Location B'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text("Proceed")),
            const SizedBox(height: 16.0),
            ElevatedButton(onPressed: () {}, child: const Text("Close")),
          ],
        ),
      ),
    );
  }
}
