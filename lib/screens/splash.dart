import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Image(
              image: AssetImage('assets/images/logo-2.png'),
              height: 45,
              width: 45,
              color: Colors.white,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'Ether Ease',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
