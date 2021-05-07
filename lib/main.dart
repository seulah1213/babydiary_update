import 'package:babydiary_seulahpark/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Baby Diary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.grey[50],
          accentColor: Colors.red,
          fontFamily: 'NotoSansKR'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        // if it's a RTL language
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
        // include country code too
      ],
      home: CalendarScreen(),
      routes: {
        '/calendar': (context) => CalendarScreen(),
      },
    );
  }
}
