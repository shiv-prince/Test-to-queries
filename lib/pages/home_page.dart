import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:final_sheshu/routes/routes_imports.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final selectionkey1 = new GlobalKey();

class _HomePageState extends State<HomePage> {
  void scroll(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: height * 2,
          width: width,
          child: Stack(
            children: [
              Positioned(
                top: height * 0.02,
                child: const Text(
                  "Text To Queries",
                  style: TextStyle(fontSize: 35),
                ),
              ),
              Positioned(
                top: height * 0.3,
                left: width * 0.45,
                child: Row(
                  children: [
                    Container(
                      child: const Text(
                        "Make your text into",
                        style: TextStyle(fontSize: 35),
                      ),
                    ),
                    Container(
                      height: height * 0.1,
                      width: width * 0.12,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Horizon',
                        ),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            RotateAnimatedText('SQL queries'),
                            RotateAnimatedText('csv queries'),
                            RotateAnimatedText('excel queries'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: height * 0.55,
                  left: width * 0.45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      scroll(selectionkey1);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.1, right: width * 0.1),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  )),
              Positioned(
                  top: height * 0.15,
                  left: width * 0.09,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(scale: 1.3, "assets/main.png"),
                      SizedBox(
                        width: width * 0.5,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                              textAlign: TextAlign.center,
                              "Welcome to our cutting-edge text-to-SQL conversion service, where your unstructured text transforms into structured, actionable SQL queries seamlessly. Empower your business to leverage the full potential of your data without the hassle of manual query writing"),
                        ),
                      )
                    ],
                  )),
              Positioned(
                key: selectionkey1,
                width: width,
                top: height * 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Image.asset("assets/hero1.png"),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: width * 0.2,
                          child: const Text(
                              textAlign: TextAlign.center,
                              "Upload csv file and make your Queries on that Data"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            AutoRouter.of(context)
                                .push(const CsvUploaderRoute());
                          },
                          child: const Text(
                            "Upload File",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: width * 0.12,
                    ),
                    Column(
                      children: [
                        Image.asset("assets/hero2.png"),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: width * 0.2,
                          child: const Text(
                              textAlign: TextAlign.center,
                              "Connect with Sql Database and make your Queries on that Data"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            AutoRouter.of(context)
                                .push(const SqlConncetRoute());
                          },
                          child: const Text(
                            "Connect",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: width * 0.12,
                    ),
                    Column(
                      children: [
                        Image.asset("assets/hero3.png"),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: width * 0.2,
                          child: const Text(
                              textAlign: TextAlign.center,
                              "Upload excel file and make your Queries on that Data"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            AutoRouter.of(context)
                                .push(const ExcelUploaderRoute());
                          },
                          child: const Text(
                            "Upload File",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: height * 1.8,
                child: Container(
                  height: 200,
                  width: width,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Image.asset(
                                    "assets/github.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Image.asset(
                                    "assets/linkedin.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Image.asset(
                                    "assets/telegram.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Image.asset(
                                    "assets/instagram.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Copyright © 2024 - 2025 . All rights reserved - Final year Project ",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
