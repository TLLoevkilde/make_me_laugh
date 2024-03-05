import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data_source.dart';
import 'joke_dto.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => DataSource(),
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const JokePage(),
    ),
    );
  }
}

class JokePage extends StatefulWidget {
  const JokePage({super.key});

  @override
  State<JokePage> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  JokeDto? joke;

  @override
  void initState() {
    super.initState();
    _loadJoke();
  }

  _loadJoke() async {
    setState(() {
      joke = null;
    });
    final newJoke = await context.read<DataSource>().getJoke();
    setState(() {
      joke = newJoke;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jokes")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (joke == null)
              const CircularProgressIndicator(),
            if (joke?.joke != null)
              Text(joke!.joke!, style: TextStyle(fontSize: 18)),
            if (joke?.setup != null)
              Text(joke!.setup!, style: TextStyle(fontSize: 16)),
            if (joke?.delivery != null)
              Text(joke!.delivery!, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadJoke,
              child: const Text("Show another"),
            ),
          ],
        ),
      ),
    );
  }
}
