import 'package:binokor/pages/HistoryImagePage.dart';
import 'package:binokor/pages/PhotoPickPage.dart';
import 'package:binokor/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/Constants.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  int bottomindex = 1;
  PageController pageController = PageController();
  FlutterSecureStorage storage = FlutterSecureStorage();

  List<Widget> _pageBottom = <Widget>[
    Home(),
    PhotoPickPage(),
    HistoryImagePage(),
  ];

  //
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constans().backroundcolors,
        title: Text(
          "DSK BINOKOR",
          style: TextStyle(fontFamily: Constans().font, color: Colors.yellow),
        ),
      ),
      body: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: pageController,
          onPageChanged: (int i) {
            setState(() {
              bottomindex = i;
            });
          },
          itemCount: _pageBottom.length,
          itemBuilder: (context, idx) {
            return _pageBottom[bottomindex];
          }),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(()  {
            if (index == 0) {
               storage.delete(key: "token");
              Navigator.pop(
                  context, MaterialPageRoute(builder: (context) => Home()));
            } else {
              bottomindex = index;
            }
          });
        },
        currentIndex: bottomindex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главное"),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: "Фото"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "История")
        ],
      ),
    );
  }
}

class ImageCard {
  late String name;
  late String image;

  ImageCard(this.name, this.image);
}
