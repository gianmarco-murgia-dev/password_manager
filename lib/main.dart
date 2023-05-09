import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _servizio = "";
  String _username = "";
  String _passwordIN = "";
  String _passwordOUT = "";

  List<String> caratteri = ['q', 'e', 'A', 't', '#', 'Q', '@', '8', 'u', 'N', '1', 'F', 'w', '7', 'E', 'r', 'R', 'y', '6', '!', 'M', 'D', '=', 'p', 'X', 'Z', 'L', 'P', '5', 'a', '2', 'z', 'C', '_', 's', '9', 'W', '+', '4', 'x', 'd', 'Y', 'V', 'B', '3', 'K', 'G', '%', 'c', 'S', 'U', 'f', 'v', 'g', 'b', 'n', 'J', 'm', 'T', 'H', 'h', 'j', 'k', '-' ];
  
  int _convertHexToInt(String hex){
    hex = hex.toLowerCase();
    switch (hex) {
      case 'a':
        return 10;
      case 'b':
        return 11;
      case 'c':
        return 12;
      case 'd':
        return 13;
      case 'e':
        return 14;
      case 'f':
        return 15;
      default:
        return int.parse(hex);
    }
  }

  //return a value between 0 and 63
  int setOfHexToInt(String hex){
    int sum = -1;
    for (int i = 0; i < hex.length; i++)
    {
      sum += _convertHexToInt(hex[i]);
    }
    return sum;
  }
  void _generaPassword() {
    String output = "G.";
    int numeroDiCaratteri = 16; // max 32
    int salt = 10;

    String s = _servizio.toLowerCase().trim(); 
    String u = _username.toLowerCase().trim(); 
    String p = _passwordIN.toLowerCase().trim();

    String hash = sha512.convert(utf8.encode(s+u+p)).toString();
    //esegui l'hash dell' hash altre 10 volte
    for (int i = 0; i < salt; i++)
    {
      hash = sha512.convert(utf8.encode(hash)).toString();
    }

    int index = 0;
    for (int i = 0; i < numeroDiCaratteri; i++)
    {
      index = setOfHexToInt(hash.substring((0 + i*4), ((4 + i*4)))); //(i*4, (i+1)*(4))
      output += caratteri[index];
    }


    setState(() {
      _passwordOUT = output;
    });
  }

  void _copia(){
    Clipboard.setData(new ClipboardData(text: _passwordOUT));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestore password')),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Servizio"),
                onChanged: (String? value) {
                  _servizio = value as String;
                  _generaPassword();
                },
              ),
                TextFormField(
                decoration: const InputDecoration(labelText: "Username"),
                onChanged: (String? value) {
                  _username = value as String;
                  _generaPassword();
                },
              ),
                TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                onChanged: (String? value) {
                  _passwordIN = value as String;
                  _generaPassword();
                },
              ),
              Text(
                _passwordOUT,
                style: Theme.of(context).textTheme.headline4,
              ),
              TextButton(onPressed: _copia, child: Text("Copia negli appunti")),
            ],
          ),
        ),
      ),
    );
  }
}
