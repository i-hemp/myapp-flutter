import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/profile_view.dart';
import 'package:myapp/register_view.dart';
import 'package:myapp/views/verify_email_view.dart';
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



class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void updateUI() {
    setState(() {
      //You can also make changes to your state here.
      stateUser?.reload();
    });
  }

  User? stateUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading while checking auth statescs\sc
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final currentUser = FirebaseAuth.instance.currentUser;
          final isEmailVerified = currentUser?.emailVerified;
          final user = snapshot.data;
          user?.reload();
          stateUser?.reload();
          return Center(
            child: user != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Logged in as ${user.email}'),
                      if (!(isEmailVerified ?? false)) ...[
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VerifyEmailView(),
                            ),
                          ),
                          child: const Text('Verify'),
                        ),
                      ] else ...[
                        const Text('Email verified.'),
                      ],
                      ElevatedButton(
                        onPressed: () => setState(() {
                          Navigator.pushNamed(context, '/profile');
                        }),
                        child: const Text('Profile'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          // No need for setState - stream handles it!
                        },
                        child: const Text('Logout'),
                      ),
                      ElevatedButton(
                        onPressed: () => updateUI(),
                        child: Text("Update"),
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