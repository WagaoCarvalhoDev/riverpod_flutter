import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  increment() => state = state == null ? 1 : state + 1;

  int? get value => state;
}

final counterProvider =
StateNotifierProvider<Counter, int?>((ref) => Counter());

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer(
              builder: (context, ref, child) {
                final counter = ref.watch(counterProvider);
                final text =
                counter == null ? 'Press the button' : counter.toString();
                return Text(
                  text,
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
            ElevatedButton(
                onPressed: () => ref.read(counterProvider.notifier).increment(),
                child: const Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}