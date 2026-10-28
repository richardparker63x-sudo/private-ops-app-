import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

final InAppLocalhostServer server =
    InAppLocalhostServer(documentRoot: 'assets/app', port: 8765);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await server.start();
  runApp(const OpsApp());
}

class OpsApp extends StatelessWidget {
  const OpsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Private Ops',
        theme: ThemeData(colorSchemeSeed: const Color(0xFF2563EB), useMaterial3: true),
        home: const Home(),
      );
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  InAppWebViewController? ctl;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    final dark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
    ));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await ctl?.canGoBack() ?? false) {
          ctl!.goBack();
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: dark ? const Color(0xFF061226) : const Color(0xFFF0F6FF),
        body: SafeArea(
          child: Stack(children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri('http://localhost:8765/index.html')),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                supportZoom: false,
                transparentBackground: true,
              ),
              onWebViewCreated: (c) {
                ctl = c;
                c.addJavaScriptHandler(
                  handlerName: 'save',
                  callback: (a) async {
                    final dir = await getTemporaryDirectory();
                    final f = File('${dir.path}/${a[0]}');
                    await f.writeAsString(a[1] as String);
                    await Share.shareXFiles([XFile(f.path)]);
                  },
                );
                c.addJavaScriptHandler(
                  handlerName: 'share',
                  callback: (a) async => Share.share(a[0] as String),
                );
              },
              onLoadStop: (c, u) => setState(() => loading = false),
            ),
            if (loading) const Center(child: CircularProgressIndicator()),
          ]),
        ),
      ),
    );
  }
}
