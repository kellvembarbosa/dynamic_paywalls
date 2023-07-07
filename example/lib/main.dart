import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_paywalls/dynamic_paywalls.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Qonversion SDK
  await Paywalls.init(
    projectKey: 'Agy3OwEMnl2dt7RENVHxsdaJcRVLuajZ',
    paywallUrl: 'https://dash.newipe.com/assets/038e9263-5990-4e21-bf49-21fd8c705d61',
    paywallFallback: {
      "type": "scaffold",
      "args": {
        "body": {
          "type": "center",
          "child": {"type": "circular_progress_indicator"}
        }
      }
    },
    launchMode: QLaunchMode.subscriptionManagement,
    enableSearchAds: true,
    environment: QEnvironment.sandbox,
    isDesignMode: Platform.isAndroid || Platform.isIOS ? false : true,
    othersConfigs: () {
      // Add your configs here
      debugPrint("executou othersConfigs");
    },
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDesignMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Este user é premium? ${Paywalls.paywallService.isPremiumUser ? "Premium User" : "Free User"}',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Get.to(
                        Paywalls.getPaywall(
                          isDesignMode: isDesignMode,
                          data: {
                            "type": "scaffold",
                            "args": {
                              "body": {
                                "type": "center",
                                "child": {
                                  "type": "text",
                                  "args": {
                                    "data": "Hello World",
                                    "style": {
                                      "type": "text_style",
                                      "args": {"color": "#000000", "font_size": 24.0, "font_weight": "bold"}
                                    }
                                  }
                                }
                              }
                            }
                          },
                        ),
                      ),
                      child: const Text("Get Paywall"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => isDesignMode = !isDesignMode),
                      child: Text(isDesignMode ? "Sair do design mode" : "Entrar no design mode"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
