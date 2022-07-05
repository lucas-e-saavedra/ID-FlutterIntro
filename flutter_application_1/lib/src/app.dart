import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view_home.dart';
import 'view_login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _username;

  @override
  void initState() {
    super.initState();
    readSavedInfo();
  }

  void readSavedInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
    });
  }

  void logInCallback(String user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', user);
    setState(() {
      _username = user;
    });
  }

  void logOutCallback() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    setState(() {
      _username = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter',
        theme: ThemeData(primarySwatch: Colors.green),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [Locale('en', ''), Locale('es', '')],
        home: getMainWidget());
  }

  Widget getMainWidget() {
    if (_username != null) {
      return MyHomePage(
        title: "Home",
        callback: logOutCallback,
      );
    } else {
      return LoginPage(
        title: "Log In",
        callback: logInCallback,
      );
    }
  }
}
