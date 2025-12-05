import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/routes.dart';
import 'package:myapp/views/profile_view.dart';
import 'package:myapp/views/register_view.dart';
import 'package:myapp/views/notes_view.dart';
import 'package:myapp/views/verify_email_view.dart';
import 'firebase_options.dart';
import 'views/login_view.dart';

// import 'dart:developer' as devtools show log;
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
      home: const HomeView(),
      routes: {
        loginRoute: (context) => const LoginView(),
        profileRoute: (context) => const ProfileView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
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
          // Show loading while checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final currentUser = FirebaseAuth.instance.currentUser;
          final isEmailVerified = currentUser?.emailVerified;
          final user = snapshot.data;
          user?.reload();
          stateUser?.reload();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              backgroundColor: Colors.green,
              actions: [
                
              ],
            ),
            body: Center(
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
                          ElevatedButton(
                            onPressed: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NotesView(),
                                ),
                              ),
                            },
                            child: const Text("Go to notes"),
                          ),
                        ],

                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            updateUI();
                          },
                          child: const Text('Logout'),
                        ),
                        ElevatedButton(
                          onPressed: () => updateUI(),
                          child: Text("Update UI"),
                        ),
                      ],
                    )
                  : Material(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, registerRoute),
                            child: const Text('Register'),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, loginRoute),
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ),
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