import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:final_sheshu/tableview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';

@RoutePage()
class CsvUploader extends StatefulWidget {
  @override
  _CsvUploaderState createState() => _CsvUploaderState();
}

TextEditingController _responseController = TextEditingController();
String res = "";
Map<String, dynamic>? ans;
List<String> names = [];

class _CsvUploaderState extends State<CsvUploader> {
  html.File? _selectedFile;
  bool _isLoading = false;
  void _selectFile() {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.length == 1) {
        setState(() {
          _selectedFile = files[0];
          _uploadFile();
        });
      }
    });
  }

  Future<void> callQuestionCsvEndpoint() async {
    setState(() {
      _isLoading = true;
      _onButtonPressed();
    });

    // Define the URL for the FastAPI endpoint
    final url = 'http://127.0.0.1:8000/question_csv';

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

        Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          ans = responseData;
          _isLoading = false;
        });

        // Handle the response data (responseData) here
        // For example, print it
        print(responseData);
      } else {
        // Handle other status codes (e.g., display an error message)
        print(
            'Failed to call the question_csv endpoint. Status code: ${response.statusCode}');
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
      print('Error calling the question_csv endpoint: $e');
    }
    String firstNameKey = ans!.keys.first;
    print(ans);
    print(firstNameKey);
    setState(() {
      names = (ans![firstNameKey] as Map<String, dynamic>)
          .values
          .map((value) => value.toString())
          .toList();
    });

    _responseController.clear();
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      // Show error message or prompt the user to select a file
      return;
    }

    final reader = html.FileReader();

    reader.onLoadEnd.listen((event) async {
      final url = 'http://127.0.0.1:8000/upload_csv/';
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          reader.result as List<int>,
          filename: _selectedFile!.name,
        ));

      try {
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          // Update the text of the TextField
          setState(() {
            res = responseBody;
          });
        } else {
          // Handle failure
          print('Failed to upload file. Status code: ${response.statusCode}');
          // Display the failure message to the user
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(
                  'Failed to upload file. Status code: ${response.statusCode}. Please try again.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        print('Error uploading file: $e');
        // Display the error message to the user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(
                'An error occurred while uploading the file: $e. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

    reader.readAsArrayBuffer(_selectedFile!);
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
      callQuestionCsvEndpoint();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    //List<String> names = ans["First_Name"].values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CSV Uploader',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            left: width * 0.12,
            top: height * 0.08,
            child: Container(
              height: height * 0.28,
              width: width * 0.45,
              margin: EdgeInsets.only(left: 200),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Positioned(
                    top: height * 0.01,
                    left: width * 0.02,
                    child: const Text(
                      "Upload your CSV file",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Positioned(
                        top: height * 0.13,
                        left: width * 0.02,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: _selectFile,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: const Text(
                              "Upload File",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Positioned(
                        top: height * 0.14,
                        left: width * 0.5,
                        child: res != ""
                            ? Text("Selected File: ${_selectedFile!.name}")
                            : const Text("Select your file"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          res != ""
              ? Positioned(
                  top: height * 0.22,
                  left: width * 0.02,
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.45,
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
                          onPressed:
                              _isButtonDisabled ? null : _onButtonPressed,
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
                )
              : Positioned(
                  top: height * 0.5, left: width * 0.02, child: const Text("")),
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
              left: width * 0.68,
              width: width * 0.3,
              child: SizedBox(
                height: height * 0.5,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  softWrap: true,
                                  "Query:",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      backgroundColor: Colors.white),
                                  textAlign: TextAlign.left,
                                ),
                                DefaultTextStyle(
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  child: AnimatedTextKit(
                                      repeatForever: false,
                                      totalRepeatCount: 1,
                                      animatedTexts: [
                                        TypewriterAnimatedText('Generating....',
                                            speed: const Duration(
                                                microseconds: 500)),
                                        TypewriterAnimatedText(
                                            '${ans!["query"]}',
                                            speed: const Duration(
                                                microseconds: 400),
                                            cursor: '_'),
                                      ]),
                                ),
                              ],
                            ),
                            // child: SelectableText(
                            //   " Query generated \n\n ${ans!["query"]}",
                            //   style: const TextStyle(color: Colors.white),
                            // ),
                          ),
                        ),
                ),
              )),
          if (_isLoading)
            Positioned(
              top: height * 0.35,
              left: width * 0.02,
              width: width,
              child: SizedBox(
                height: height * 0.3,
                width: width * 0.1,
                child: const Center(
                  child: RiveAnimation.asset("assets/hexasphere_loading.riv"),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
