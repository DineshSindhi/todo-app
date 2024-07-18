import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/presentation/screens/splash_screen/splash_page.dart';

import 'domain/app_theme/theme.dart';
import 'domain/app_theme/theme_provider.dart';
import 'firebase_options.dart';

 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      //ChangeNotifierProvider(create: (context) => TodoProvider()),
  ],child:MyApp() ,));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    var Dark=context.watch<ThemeProvider>().Theme;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Dark ? darkTheme:lightTheme,
      home:SplashPage(),
    );
  }
}

