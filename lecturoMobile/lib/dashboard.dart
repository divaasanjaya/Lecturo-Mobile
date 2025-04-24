import 'package:app_lecturo/abdimas.dart';
import 'package:app_lecturo/course.dart';
import 'package:app_lecturo/penelitian.dart';
import 'package:flutter/material.dart';
import 'main.dart';

void main() {
  runApp(const DashboardPage());
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecturo Homepage',
      theme: ThemeData(fontFamily: 'Outfit'),
      home: MyHomePage(title: 'Lecturo Homepage'),
      debugShowCheckedModeBanner: false,
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
  int selected = 0;
  PageController pc = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF004643),
      body: SafeArea(
        child: PageView(
          controller: pc,
          onPageChanged: (index) {
            setState(() {
              selected = index;
            });
          },
          children: [
            Center(
              child: InkWell(
                child: Text('Logout', style: TextStyle(fontSize: 30)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MyApp()
                  ));
                },
              )
            ),
            MyApp_course(),
            MyApp_penelitian(),
            MyApp_abdimas(),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 10,
        color: Colors.transparent, // supaya tidak nutupi Container
        child: Container(
          height: 111,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFF2A2A2A),
                blurRadius: 10,
                offset: Offset(1, -4), // Arahkan ke atas
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: 111,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Color(0xFFF9BC60), // Supaya transparan, pakai warna Container
                selectedItemColor: Colors.white,
                unselectedItemColor: Color(0xFF004643),
                currentIndex: selected,
                onTap: (index) {
                  setState(() {
                    selected = index;
                  });
                  pc.animateToPage(
                    index,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled, size: 37),
                    label: 'Homepage',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book, size: 37),
                    label: 'Mata Kuliah',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.article, size: 37),
                    label: 'Penelitian',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people, size: 37),
                    label: 'Pengabdian\nMasyarakat',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

