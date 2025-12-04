import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_note_app/providers/note_viewmodel.dart';
import 'package:simple_note_app/screens/home_page.dart';
import 'package:simple_note_app/screens/note_new_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NoteViewmodel())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomePage(),
    '/notes': (context) => const HomePage(),
    '/newNote': (context) => const NoteNewScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Note App',
      theme: ThemeData(
        fontFamily: 'Jacklane',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}
