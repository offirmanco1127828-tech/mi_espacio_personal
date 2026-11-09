import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
void main() {
  runApp(const MyApp());
}

// Configure the routes of the application.
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/age',
      builder: (context, state) => const AgePage(),
    ),
    GoRoute(
      path: '/bmi',
      builder: (context, state) => const BmiPage(),
    ),
    GoRoute(
      path: '/zodiac',
      builder: (context, state) => const ZodiacPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Mi Espacio Personal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

// Main screen with navigation options.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Personal Space'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => context.go('/age'),
              child: const Text('Calculate my age'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/bmi'),
              child: const Text('Calculate my BMI'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/zodiac'),
              child: const Text('Check my zodiac sign'),
            ),
          ],
        ),
      ),
    );
  }
}

 // Age screen with a date picker and age calculation.
class AgePage extends StatefulWidget {
  const AgePage({super.key});

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  DateTime? birthDate;
  int? age;

  // Open the date picker and calculate the user's age.
  Future<void> selectBirthDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      locale: const Locale('en', 'US'),
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      final today = DateTime.now();
      int calculatedAge = today.year - selectedDate.year;

      if (today.month < selectedDate.month ||
          (today.month == selectedDate.month &&
              today.day < selectedDate.day)) {
        calculatedAge--;
      }

      setState(() {
        birthDate = selectedDate;
        age = calculatedAge;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age Calculator')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cake,
              size: 70,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            const Text(
              'Select your birth date',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectBirthDate,
              child: const Text('Choose date'),
            ),
            const SizedBox(height: 20),
            if (birthDate != null)
              Text(
                'Birth date: ${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
                style: const TextStyle(fontSize: 18),
              ),
            if (age != null)
              Text(
                'Your age is $age years',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
 

 


 // BMI screen with a weight and height calculator.
class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  double? bmi;
  String result = '';

  // Calculate the Body Mass Index.
  void calculateBMI() {
    final weight = double.tryParse(weightController.text);
    final height = double.tryParse(heightController.text);

    if (weight == null ||
        height == null ||
        weight <= 0 ||
        height <= 0) {
      setState(() {
        bmi = null;
        result = 'Please enter valid weight and height.';
      });
      return;
    }

    final heightInMeters = height / 100;
    final calculatedBMI = weight / (heightInMeters * heightInMeters);

    String category;

    if (calculatedBMI < 18.5) {
      category = 'Underweight';
    } else if (calculatedBMI < 25) {
      category = 'Normal weight';
    } else if (calculatedBMI < 30) {
      category = 'Overweight';
    } else {
      category = 'Obesity';
    }

    setState(() {
      bmi = calculatedBMI;
      result = category;
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.monitor_weight,
                size: 70,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your information',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: heightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateBMI,
                child: const Text('Calculate BMI'),
              ),
              const SizedBox(height: 20),
              if (bmi != null)
                Text(
                  'Your BMI: ${bmi!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (result.isNotEmpty)
                Text(
                  result,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Zodiac screen with a birth date selector.
class ZodiacPage extends StatefulWidget {
  const ZodiacPage({super.key});

  @override
  State<ZodiacPage> createState() => _ZodiacPageState();
}

class _ZodiacPageState extends State<ZodiacPage> {
  DateTime? birthDate;
  String zodiacSign = '';

  Future<void> selectBirthDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null) return;

    final month = selectedDate.month;
    final day = selectedDate.day;
    String sign;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      sign = 'Aries ♈';
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      sign = 'Taurus ♉';
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      sign = 'Gemini ♊';
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      sign = 'Cancer ♋';
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      sign = 'Leo ♌';
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      sign = 'Virgo ♍';
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      sign = 'Libra ♎';
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      sign = 'Scorpio ♏';
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      sign = 'Sagittarius ♐';
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      sign = 'Capricorn ♑';
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      sign = 'Aquarius ♒';
    } else {
      sign = 'Pisces ♓';
    }

    setState(() {
      birthDate = selectedDate;
      zodiacSign = sign;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signo zodiacal')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                size: 70,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              const Text(
                'Select your birth date',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectBirthDate,
                child: const Text('Choose date'),
              ),
              const SizedBox(height: 20),
              if (birthDate != null)
                Text(
                  'Birth date: ${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
                  style: const TextStyle(fontSize: 18),
                ),
              if (zodiacSign.isNotEmpty)
                Text(
                  'Your zodiac sign is $zodiacSign',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}