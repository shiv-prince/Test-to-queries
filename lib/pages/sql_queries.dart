import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../tableview.dart';

@RoutePage()
class SqlQueries extends StatefulWidget {
  const SqlQueries({super.key});

  @override
  State<SqlQueries> createState() => _SqlQueriesState();
}

class _SqlQueriesState extends State<SqlQueries> {
  bool _isLoading = false;
  Map<String, dynamic>? ans;
  TextEditingController _responseController = TextEditingController();

  Future<void> callQuestionExcelEndpoint() async {
    setState(() {
      _isLoading = true;
      _onButtonPressed();
    });

    // Define the URL for the FastAPI endpoint
    final url = 'http://127.0.0.1:8000/question_db';

    // Define the data to send in the request body
    Map<String, dynamic> requestData = {
      // Add any required data for the request
      "req": _responseController.text
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
        setState(() {
          ans = responseData;
          print(responseData);
          _isLoading = false;
        }); // Handle the response data (responseData) here        // For example, print it
        print(responseData);
      } else {
        // Handle other status codes (e.g., display an error message)
        print(
            'Failed to call the question_excel endpoint. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'An error occurred while fetching the data:Please try again.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
      setState(() {
        _isLoading = false;
      });
      print('Error calling the question_excel endpoint: $e');
    }

    _responseController.clear();
  }

  bool _isButtonDisabled = false;
  int _disabledSeconds = 30;
  late Timer _timer;

  void _onButtonPressed() {
    if (!_isButtonDisabled) {
      setState(() {
        _isButtonDisabled = true;
        _disabledSeconds = 30;
      });

      // Disable button for 30 seconds
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_disabledSeconds > 0) {
            _disabledSeconds--;
          } else {
            _timer.cancel();
            _isButtonDisabled = false;
          }
        });
      });

      // Perform your action here
      // For example:
      callQuestionExcelEndpoint();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: height * 0.22,
            left: width * 0.02,
            child: Row(
              children: [
                SizedBox(
                  width: width * 0.65,
                  child: TextField(
                    controller: _responseController,
                    readOnly: false,
                    decoration: const InputDecoration(
                      labelText: 'Queries',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  backgroundColor:
                      _isButtonDisabled ? Colors.grey : Colors.black,
                  child: IconButton(
                    onPressed: _isButtonDisabled ? null : _onButtonPressed,
                    icon: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.22,
                  left: width * 0.03,
                  child: _isButtonDisabled
                      ? Text(
                          '  Button disabled for $_disabledSeconds seconds',
                          style: const TextStyle(fontSize: 16),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          Positioned(
              top: height * 0.35,
              left: width * 0.02,
              width: width * 0.6,
              child: SizedBox(
                height: height * 0.45,
                width: width * 0.6,
                child: Visibility(
                  visible: !_isLoading,
                  child: ans == null
                      ? const Text("")
                      : DynamicTableWidget(data: ans!),
                ),
              )),
          Positioned(
              top: height * 0.35,
              left: width * 0.7,
              width: width * 0.3,
              child: SizedBox(
                height: height * 0.45,
                width: width * 0.5,
                child: Visibility(
                  visible: !_isLoading,
                  child: ans == null
                      ? const Text("")
                      : Container(
                          padding: const EdgeInsets.all(30),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: SelectableText(
                            " Query generated \n\n ${ans!["query"]}",
                            style: const TextStyle(color: Colors.white),
                          ))),
                ),
              )),
          if (_isLoading)
            Positioned(
              top: height * 0.35,
              left: width * 0.02,
              child: const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: RiveAnimation.asset("assets/hexasphere_loading.riv"),
                ),
                // child: CircularProgressIndicator(
                //   color: Colors.black,
                // ),
              ),
            ),
        ],
      ),
    );
  }
}
