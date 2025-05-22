import 'dart:typed_data';

import 'package:alarm/alarm.dart';
import 'package:fitness_flow/l10n/l10n.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  checkAudioAsset();
  usePathUrlStrategy();

  final appState = FFAppState();
  await appState.initializePersistedState();

  final isRegistered = await checkIfRegistered();
  final initialLocation = isRegistered ? '/homePage' : '/welcomePage';

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(initialLocation: initialLocation),
  ));
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (context) => appState),
  //       ChangeNotifierProvider(
  //           create: (context) =>
  //               LanguageProvider()), // Tambahkan provider di sini
  //     ],
  //     child: MyApp(initialLocation: initialLocation),
  //   ),
  // );
}

void checkAudioAsset() async {
  try {
    ByteData data = await rootBundle.load('assets/audios/alarm.mp3');
    print("✅ File ditemukan, ukuran: ${data.lengthInBytes} bytes");
  } catch (e) {
    print("❌ File tidak ditemukan: $e");
  }
}

Future<bool> checkIfRegistered() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isRegistered = preferences.containsKey('username');
  print('Is Registered: $isRegistered'); // Debugging
  return isRegistered;
}

class MyApp extends StatefulWidget {
  final String initialLocation;

  const MyApp({Key? key, required this.initialLocation}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale locale = Locale('id');

  void setLocale(Locale newlocale) {
    setState(() {
      locale = newlocale;
    });
  }

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier, widget.initialLocation);

    Future.delayed(Duration(milliseconds: 1000),
        () => setState(() => _appStateNotifier.stopShowingSplashImage()));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onBackButtonPressed(context),
        child: MaterialApp.router(
          title: 'FitnessFlow',
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.all,
          locale: locale,
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: false,
          ),
          themeMode: _themeMode,
          routerConfig: _router,
        ));
  }

  // PopScope(
  //     canPop: false,
  //     onPopInvokedWithResult: (bool didPop, Object? result) async {
  //       final shouldClose = await _onBackButtonPressed(context);
  //       if (shouldClose) {
  //         Navigator.of(context).pop();
  //       }
  //     },
  //     child:

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Really"),
            content: const Text("Do you want to close the app??"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No ")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Yes "))
            ],
          );
        });
    return exitApp ?? false;
  }
}
