import 'package:depi_final_project/features/authentication/presentation/screens/register_screen.dart';
import 'package:depi_final_project/features/home/presentation/screens/home_screen.dart';
import 'package:depi_final_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/Onboarding/Views/Screens/OnboardingScreen.dart';
import 'features/authentication/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Master',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Showcase(title: 'Quiz Master'),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => CreateAccountScreen(),
      
      },
    );
  }
}
