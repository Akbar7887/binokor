import 'package:binokor/domain/Constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with TickerProviderStateMixin {
  double opacityLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHomePage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data as Widget;
        } else {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.webp',
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      Constans.namecompany,
                      style: TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w200),
                    )
                  ],
                ),
              ));
        }
      },
    );
  }

  // AnimatedOpacity(
  // opacity: opacityLevel,
  // duration: Duration(seconds: 2),
  // child: Column(
  // mainAxisAlignment: MainAxisAlignment.center,
  // children: [
  // Image.asset(
  // 'assets/logo.webp',
  // width: 120,
  // height: 120,
  // ),
  // SizedBox(
  // height: 20,
  // ),
  // Text(
  // Constans.namecompany,
  // style: TextStyle(
  // fontFamily: 'Times New Roman',
  // color: Colors.white,
  // fontSize: 40,
  // fontWeight: FontWeight.w200),
  // )
  // ],
  // ),
  // )

  // AnimatedSize(
  // vsync: this,
  // duration: Duration(seconds: 1),
  // child: Container(
  // height: double.infinity,
  // child: Image.asset(
  // 'assets/logo.webp',
  // width: 120,
  // height: 120,
  // fit: BoxFit.cover,
  // ),
  // ),
  // )
  //
  void _changeOpacity() {
    setState(() {
      opacityLevel = opacityLevel == 0 ? 1.0 : 0.0;
    });
  }

  Future<Widget> getHomePage() async {
    _changeOpacity();
    return await Future.delayed(Duration(seconds: 3), () {})
        .then((value) => Home());
  }
}
