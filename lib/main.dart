import 'package:ether_ease/add_entry/bloc/add_entry_bloc.dart';
import 'package:ether_ease/services/add_entries_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'package:ether_ease/screens/home.dart';
import 'package:ether_ease/screens/splash.dart';
import 'package:ether_ease/screens/waiting_verification.dart';
import 'package:ether_ease/screens/auth_screen.dart';

var kTextTabBarHeight = 48.0;

Future<bool> checkEmailVerified(User user) async {
  await user.reload();
  return user.emailVerified;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddEntryBloc>(
      create: (context) => AddEntryBloc(AddEntriesService()),
      child: MaterialApp(
        title: 'EtherEase',
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 20, 2)),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (snapshot.hasData) {
              final user = snapshot.data as User;

              if (!user.emailVerified) {
                return FutureBuilder(
                  future: checkEmailVerified(user),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const WaitingVerificationScreen();
                    }

                    if (snapshot.data!) {
                      return const HomeScreen();
                    } else {
                      return const WaitingVerificationScreen();
                    }
                  },
                );
              }
              return const HomeScreen();
            }
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
