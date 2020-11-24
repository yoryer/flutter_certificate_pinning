import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_certificate_pinning/sni-cloudflaressl-com.pem.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Certificate pinning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _httpResult = 'Pulsa el botón para comenzar';

  void _goodRequest() async {
    setState(() {
      _httpResult = 'Cargando...';
    });

    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(certificate);

    HttpClient httpClient = HttpClient(context: securityContext);

    http.Client client = IOClient(httpClient);

    String result;

    try {
      http.Response response = await client.get(
        'https://pokeapi.co/api/v2/pokemon/pikachu',
      );
      result = response.body;
    } catch (exception) {
      result = exception.toString();
    }

    setState(() {
      _httpResult = result;
    });
  }

  void _badRequest() async {
    setState(() {
      _httpResult = 'Cargando...';
    });

    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(certificate);

    HttpClient httpClient = HttpClient(context: securityContext);

    http.Client client = IOClient(httpClient);

    String result;

    try {
      http.Response response = await client.get(
        'https://cat-fact.herokuapp.com/facts/random',
      );
      result = response.body;
    } catch (exception) {
      result = exception.toString();
    }

    setState(() {
      _httpResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate pinning'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Resultado petición HTTP:',
            ),
            SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '$_httpResult',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _goodRequest,
            tooltip: 'Good',
            child: Icon(Icons.check_box),
          ),
          SizedBox(width: 12),
          FloatingActionButton(
            onPressed: _badRequest,
            tooltip: 'Bad',
            child: Icon(Icons.warning),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
