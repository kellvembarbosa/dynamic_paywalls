import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_paywalls/dynamic_paywalls.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

import 'controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.lazyPut(() => DesignController(), fenix: true);

  // Initialize Qonversion SDK
  await Paywalls.init(
    iOSRevenueCatApiKey: 'Agy3OwEMnl2dt7RENVHxsdaJcRVLuajZ',
    glassfyApiKey: "ad76a2f6ff6e4b9b802ab65a50f73234",
    enableSearchAds: true,
    isDesignMode: Platform.isAndroid || Platform.isIOS ? false : true,
    othersConfigs: () {
      // Add your configs here
      debugPrint("executou othersConfigs");
    },
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      tools: [
        SliverToBoxAdapter(
          // Envolve o Material em um SliverToBoxAdapter
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              height: 320,
              width: double.infinity,
              color: Colors.black,
            ),
          ),
        ),
        ...DevicePreview.defaultTools,
      ],
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
      home: const MyHomePage(title: 'Design Preview'),
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
  final controller = Get.find<DesignController>();

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
                        () => DefaultOnboarding(
                          currentStep: 0,
                          items: [
                            OnboardingItem(
                              title: "Online Shopping",
                              subtitle: "You can shopping anytime, \nanywhere",
                              child: Expanded(
                                child: Image.network(
                                  "https://source.unsplash.com/random/?pregrancy",
                                ),
                              ),
                            ),
                            const OnboardingItem(
                              title: "Detailed Recipes",
                              subtitle: "You can shopping anytime, \nanywhere",
                              image: "https://picsum.photos/seed/1/200/300",
                            ),
                          ],
                          btnTexts: const ["Pular", "Próximo"],
                          onDonePressed: () {
                            Get.off(
                              () => Paywalls.getPaywall(
                                isDesignMode: controller.isDesignMode,
                                data: controller.paywallLayout ?? loadingLayout,
                                onPaywallClose: () {
                                  Get.back();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      child: const Text("Default onboarding"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Get.to(
                        () => Paywalls.getPaywall(
                          isDesignMode: controller.isDesignMode,
                          data: controller.paywallLayout ?? loadingLayout,
                          onPaywallClose: () {
                            Get.back();
                          },
                        ),
                      ),
                      child: const Text("Get Paywall"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => controller.isDesignMode = !controller.isDesignMode,
                        child: Text(controller.isDesignMode ? "Sair do design mode" : "Entrar no design mode"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
