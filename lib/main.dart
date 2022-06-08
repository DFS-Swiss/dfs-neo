import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DFS Neo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(248, 249, 251, 1),
        backgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          titleSmall: TextStyle(
            color: Color.fromRGBO(187, 187, 187, 1),
            fontFamily: "Urbanist",
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 14.4,
          ),
          bodySmall: TextStyle(
            color: Color.fromRGBO(144, 144, 144, 1),
            fontFamily: "Urbanist",
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 14.4,
          ),
          bodyMedium: TextStyle(
            color: Color.fromRGBO(32, 37, 50, 1),
            fontFamily: "Urbanist",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 19.2,
          ),
          headlineMedium: TextStyle(
            color: Color.fromRGBO(32, 37, 50, 1),
            fontFamily: "Urbanist",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 21.6,
          ),
          headlineLarge: TextStyle(
            color: Color.fromRGBO(32, 37, 50, 1),
            fontFamily: "Urbanist",
            fontSize: 22,
            fontWeight: FontWeight.w600,
            height: 30.8,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.helloWorld,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
