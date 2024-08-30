import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat('dd MMM yyyy');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Date calculator'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DateEntryForm(),
          ],
        ),
      ),
    );
  }
}

class DateEntryForm extends StatefulWidget {
  const DateEntryForm({
    super.key,
  });

  @override
  State<DateEntryForm> createState() => _DateEntryFormState();
}

class _DateEntryFormState extends State<DateEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _offsetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDateController.text = dateFormat.format(DateTime.now());
    _startDateController.addListener(() {
      setState(() {});
    });

    _offsetController.text = '75';
    _offsetController.addListener(() {
      setState(() {});
    });

    setState(() {});
  }

  String compute() {
    final sd = dateFormat.tryParse(_startDateController.text);
    final off = int.tryParse(_offsetController.text);
    if (sd == null || off == null) {
      return '';
    }
    setState(() {});
    return dateFormat.format(sd.add(Duration(days: off)));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Wrap(
            children: [
              SizedBox(
                width: 128,
                child: TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                  ),
                  onFieldSubmitted: (_) => compute(),
                  controller: _startDateController,
                  onTap: () async {
                    final dt = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2050),
                    );
                    if (dt == null) return;
                    _startDateController.text = dateFormat.format(dt);
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                width: 96,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Offset days',
                  ),
                  onFieldSubmitted: (_) => compute(),
                  controller: _offsetController,
                  inputFormatters: [
                    TextInputFormatter.withFunction((before, after) {
                      return RegExp(r'^[+-]?\d*$').hasMatch(after.text)
                          ? after
                          : before;
                    })
                  ],
                ),
              ),
            ],
          ),
          Text(
            compute(),
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    );
  }
}
