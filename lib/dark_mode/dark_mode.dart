import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeDataProvider extends ChangeNotifier {
  ThemeMode mode = ThemeMode.light;

  void switchMode() {
    mode = (mode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyDartModeApp extends StatelessWidget {
  MyDartModeApp({Key? key}) : super(key: key);

  final _themeNotifier = ThemeDataProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _themeNotifier,
      builder: (context, child) {
        return Consumer(
          builder: (context, ThemeDataProvider provider, child) {
            return MaterialApp(
              theme: ThemeData(
                  useMaterial3: true,
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: const Color(0xffe35b34))),
              darkTheme: ThemeData.dark(useMaterial3: true),
              themeMode: provider.mode,
              home: const MyWidget(),
            );
          },
        );
      },
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeDataProvider provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('testing dark mode'),
            actions: [
              IconButton(
                onPressed: () {
                  provider.switchMode();
                  print(provider.mode);
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: Text(provider.mode.toString()),
          floatingActionButton: FloatingActionButton(onPressed: () {}),
        );
      },
    );
  }
}
