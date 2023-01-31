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

enum City {
  saoPaulo,
  curitiba,
  vitoria,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {
      City.curitiba: ' ⛅',
      City.saoPaulo: '⛈',
      City.vitoria: '🌤	',
    }[city]!,
  );
}

final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeatherEmoji = '🤷';

final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);

  if (city != null) {
    return getWeather(city);
  } else {
    return unknownWeatherEmoji;
  }
});

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(
      weatherProvider,
    );

    /*currentWeather.when(
      data: (weather) {
        ref.read(currentCityProvider).state = City.curitiba;
      },
      error: (error, stacktrace) {
        ref.read(currentCityProvider).state = City.saoPaulo;
      },
      loading: () {
        ref.read(currentCityProvider).state = City.vitoria;
      },
    );*/

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: currentWeather.when(
                  data: (data) => Text(
                        data,
                        style: const TextStyle(fontSize: 74),
                      ),
                  error: (_, __) => const Text('Error 🚀'),
                  loading: () => const Padding(
                        padding: EdgeInsets.all(50.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          backgroundColor: Colors.black12,
                        ),
                      )),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: City.values.length,
                  itemBuilder: (context, index) {
                    final city = City.values[index];
                    final isSelected = city == ref.watch(currentCityProvider);
                    return ListTile(
                        title: Text(city.toString()),
                        trailing: isSelected ? const Icon(Icons.check) : null,
                        onTap: () => ref
                            .read(currentCityProvider.notifier)
                            .state = city);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
