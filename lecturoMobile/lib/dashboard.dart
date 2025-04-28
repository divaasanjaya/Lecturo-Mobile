import 'abdimas.dart';
import 'course.dart';
import 'penelitian.dart';
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

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFA6D6D6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Apakah Anda Yakin ?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004643),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Tidak',
                style: TextStyle(
                  color: Colors.white,
                ), // Font color set to white
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9BC60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Ya', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            color: Color(0xFFF9BC60),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Lecturo",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            "Good Morning",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            "Diva Sanjaya",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF9BC60),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFF9BC60), thickness: 1),
                  const SizedBox(height: 20),

                  // Motivational Text
                  const Text(
                    "Let's make today productive!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFF9BC60),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Grid Menu
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        MenuCard(
                          title: 'Pengabdian Masyarakat',
                          imagePath: 'assets/pengmas.png',
                          onTap: () {},
                        ),
                        MenuCard(
                          title: 'Penelitian',
                          imagePath: 'assets/penelitian.png',
                          onTap: () {},
                        ),
                        MenuCard(
                          title: 'Course',
                          imagePath: 'assets/course.png',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  // Tombol keluar di bawah
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: _showExitConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9BC60),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Keluar'),
                    ),
                  ),
                ],
              ),
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
                backgroundColor: Color(
                  0xFFF9BC60,
                ), // Supaya transparan, pakai warna Container
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

class MenuCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const MenuCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF004643),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
