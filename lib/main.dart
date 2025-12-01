import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/profile_view.dart';
import 'package:myapp/register_view.dart';
import 'firebase_options.dart';
import 'views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/login': (context) => const LoginView(),
        '/profile': (context) => const ProfileView(),
        '/register': (context) => const RegisterView(),
      },
    ),
  );
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.greenAccent,
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading while checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final currentUser = FirebaseAuth.instance.currentUser;
          final isEmailVerified = currentUser?.emailVerified;

          final user = snapshot.data;

          return Center(
            child: user != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Logged in as ${user.email}'),
                      if (!(isEmailVerified ?? false)) ...[
                        const Text('Please verify your email address.'),
                        TextButton(
                          onPressed: () => verification(user.email),
                          child: Text('verify'),
                        ),
                      ] else ...[
                        const Text('Email verified.'),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/profile'),
                        child: const Text('Profile'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          // No need for setState - stream handles it!
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/register'),
                        child: const Text('Register'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text('Login'),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
  
  bool verification(String? email) {
    if (email != null) {
      FirebaseAuth.instance.currentUser?.sendEmailVerification();
      return true;
    }
    return false;
  }
}




    // var viewButton = ElevatedButton(
    //   onPressed: () => Navigator.pushNamed(context, '/login'),
    //   child: const Text('Login'),
    // );
    // if (FirebaseAuth.instance.currentUser != null) {
    //   viewButton = ElevatedButton(
    //     onPressed: () => Navigator.pushNamed(context, '/profile'),
    //     child: const Text('Profile'),
    //   );
    // } else {
    //   viewButton = ElevatedButton(
    //     onPressed: () => Navigator.pushNamed(context, '/login'),
    //     child: const Text('Login'),
    //   );
    // }