import 'package:flutter/material.dart';
import 'package:asincronia/services/mockapi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MockApi mockApi = MockApi();
  Map<int, int> _counters = {};
  Map<int, bool> _loadings = {};

  Future<void> _incrementCounter(int buttonIndex) async {
    _startLoading(buttonIndex, () async {
      int newValue = await _fetchData(buttonIndex);
      setState(() {
        _counters[buttonIndex] = newValue;
      });
    });
  }

  Future<int> _fetchData(int buttonIndex) async {
    switch (buttonIndex) {
      case 1:
        return await mockApi.getFerrariInteger();
      case 2:
        return await mockApi.getHyundaiInteger();
      case 3:
        return await mockApi.getFisherPriceInteger();
      default:
        return 0;
    }
  }

  Future<void> _startLoading(int buttonIndex, Function() action) async {
    setState(() {
      _loadings[buttonIndex] = true;
    });

    await action();

    setState(() {
      _loadings[buttonIndex] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildCircularButton(1, Icons.thunderstorm, 'Button 1', Colors.green),
              Text('${_counters[1] ?? 0}', style: TextStyle(color: Colors.green, fontSize: 24)),
              _buildCircularButton(2, Icons.person, 'Button 2', Colors.orange),
              Text('${_counters[2] ?? 0}', style: TextStyle(color: Colors.orange, fontSize: 24)),
              _buildCircularButton(3, Icons.playlist_add_check, 'Button 3', Colors.red),
              Text('${_counters[3] ?? 0}', style: TextStyle(color: Colors.red, fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton(int buttonIndex, IconData icon, String label, Color color) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _loadings[buttonIndex] == true ? null : () => _incrementCounter(buttonIndex),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(20.0),
            primary: color,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, color: Colors.black, size: 36),
            ],
          ),
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: _loadings[buttonIndex] == true ? null : 0,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}
