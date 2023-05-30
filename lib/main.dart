import 'package:flutter/material.dart';
import 'package:app_wearable/pages/splash.dart';
import 'package:provider/provider.dart';
import 'package:app_wearable/utils/shared_preferences.dart';
import 'package:app_wearable/services/impact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // we use the Multiprovider to inject all the app-wide services to the whole app. This way we will always use the same instance of the services without the need to reauthenticate
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => Preferences()..init(),
          // This creates the preferences when the provider is creater. With lazy = true (default), the preferences would be initialized when first accessed, but we need them for the other services
          lazy: false,
        ),
        Provider(
            create: (context) => ImpactService(
                  // We pass the newly created preferences to the service
                  Provider.of<Preferences>(context, listen: false),
                )),
        
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Splash(),
      ),
    );
  }
}
