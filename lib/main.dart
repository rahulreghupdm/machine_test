import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_machine_test/controller/fetch_controller.dart';
import 'package:sample_machine_test/view/list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FetchController()),
      ],
      child: MaterialApp(
       debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ListPageView(),
      ),
    );
  }
}
