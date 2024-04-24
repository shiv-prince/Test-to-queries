import 'dart:async';
import 'dart:convert';
import 'package:final_sheshu/pages/sql_queries.dart';
import 'package:final_sheshu/routes/routes_imports.gr.dart';
import 'package:http/http.dart' as http;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@RoutePage()
class SqlConncet extends StatefulWidget {
  const SqlConncet({super.key});

  @override
  State<SqlConncet> createState() => _SqlConncetState();
}

class _SqlConncetState extends State<SqlConncet> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    FutureOr<List<List<String>>> ans;
    var code;
    bool _isloading = false;
    TextEditingController _unameController = TextEditingController();
    TextEditingController _upassController = TextEditingController();
    TextEditingController _hostController = TextEditingController();
    TextEditingController _dbnameController = TextEditingController();

    Future<void> connection() async {
      _isloading = true;
      // Define the URL for the FastAPI endpoint
      final url = 'http://127.0.0.1:8000/connection/';

      // Define the data to send in the request body
      final Map<String, dynamic> requestData = {
        'user_name': _unameController.text,
        'user_pass': _upassController.text,
        'host_details': _hostController.text,
        'db_name': _dbnameController.text,
      };

      try {
        // Make the POST request
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(requestData),
        );

        // Check if the request was successful (status code 200)
        if (response.statusCode == 200) {
          // Parse the response JSON

          final responseData = jsonDecode(response.body);

          code = response.statusCode;

          print(responseData);
        } else {
          // If the request was not successful, throw an exception or return null
          throw Exception('Failed to make connection: ${response.statusCode}');
        }
      } catch (e) {
        // Handle any errors that occur during the request
        print('Error making connection: $e');
        // Re-throw the exception to be caught by the caller
        rethrow;
      }
      _isloading = false;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('SQl Connector')),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Row(
            children: [
              Container(
                height: height * 0.7,
                padding: EdgeInsets.all(30),
                width: width * 0.5,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextField(
                      controller: _unameController,
                      readOnly: false,
                      decoration: const InputDecoration(
                        labelText: 'user_name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      controller: _upassController,
                      readOnly: false,
                      decoration: const InputDecoration(
                        labelText: 'user_pass',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      controller: _hostController,
                      readOnly: false,
                      decoration: const InputDecoration(
                        labelText: 'host_details',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      controller: _dbnameController,
                      readOnly: false,
                      decoration: const InputDecoration(
                        labelText: 'db_name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async {
                        await connection().then((value) => null);

                        if (code == 200) {
                          AutoRouter.of(context).push(const SqlQueriesRoute());
                        }
                      },
                      child: _isloading
                          ? CircularProgressIndicator()
                          : Text(
                              "Connect",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
