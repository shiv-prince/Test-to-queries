import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:final_sheshu/tableview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class ExcelUploader extends StatefulWidget {
  const ExcelUploader({super.key});

  @override
  _ExcelUploaderState createState() => _ExcelUploaderState();
}

class _ExcelUploaderState extends State<ExcelUploader> {
  html.File? _selectedFile;
  bool _isLoading = false;
  TextEditingController _responseController = TextEditingController();
  String res = "";
  Map<String, dynamic>? ans;
  List<String> names = [];
  String? firstNameKey;
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

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      // Show error message or prompt the user to select a file
      return;
    }

    final reader = html.FileReader();

    reader.onLoadEnd.listen((event) async {
      final url = 'http://127.0.0.1:8000/upload_excell_file/';
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
            content: const Text(
                'An error occurred while uploading the file:Please try again.'),
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

  Future<void> callQuestionExcelEndpoint() async {
    setState(() {
      _isLoading = true;
      _onButtonPressed();
    });

    // Define the URL for the FastAPI endpoint
    final url = 'http://127.0.0.1:8000/question_excell';

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
    firstNameKey = ans!.keys.first;
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
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Uploader'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: height * 0.01,
            left: width * 0.02,
            child: const Text(
              "Upload your files",
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.w300),
            ),
          ),
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
              child: const Text(
                "Upload File",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Positioned(
            top: height * 0.14,
            left: width * 0.2,
            child: res != ""
                ? Text("Selected File: ${_selectedFile!.name}")
                : const Text("Select your file"),
          ),
          res != ""
              ? Positioned(
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
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
