import 'abdimas.dart';
import 'course.dart';
import 'penelitian.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const DashboardPage(kode: ''));
}

class DashboardPage extends StatelessWidget {
  final String kode;
  const DashboardPage({Key? key, required this.kode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecturo Homepage',
      theme: ThemeData(fontFamily: 'Outfit'),
      home: MyHomePage(title: 'Lecturo Homepage', kode: kode),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.kode})
      : super(key: key);
  final String title;
  final String kode;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selected = 0;
  PageController pc = PageController(initialPage: 0);
  String nama = '';
  String kode = '';
  final Dio _dio = Dio();
  String? errorMessage;
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    fetchKode();
  }

  Future<void> fetchKode() async {
    try {
      final response = await _dio.post(
        "http://10.0.2.2/lecturo/getDosen.php",
        data: {"kode": widget.kode},
      );

      final data = response.data;
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("kode", data["dosen"]["kode"]);
        await prefs.setString("nama", data["dosen"]["nama"]);

        if (!mounted) return;
        setState(() {
          nama = data["dosen"]["nama"];
          kode = data["dosen"]["kode"];
        });
      } else {
        if (!mounted) return;
        setState(() {
          errorMessage = data["message"];
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Kode atau password Anda salah!";
      });
    }
  }

  Future<void> sendMessage({
    required String message,
    required void Function(String botResponse) onResult,
    void Function(String error)? onError,
  }) async {
    try {
      final response = await _dio.post(
        "http://10.0.2.2:8000/api/send-message",
        data: {"message": message},
      );

      final data = response.data;

      if (data.containsKey("response") && data["response"] != null) {
        onResult(data["response"]);
      } else {
        onError?.call("Invalid response from server");
      }
    } catch (e) {
      onError?.call("Unable to send message (${e.toString()})");
    }
  }

  void showChatPopup(BuildContext context) {
    TextEditingController chatController = TextEditingController();
    List<Map<String, String>> localMessages = [
      {"sender": "bot", "text": "Halo! Ada yang bisa saya bantu?"},
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 400,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF004643),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lecturo AI',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: ListView.builder(
                          itemCount: localMessages.length,
                          itemBuilder: (context, index) {
                            final message = localMessages[index];
                            bool isBot = message['sender'] == 'bot';
                            return Align(
                              alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isBot ? Colors.grey[200] : Color(0xFFF9BC60),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  message['text']!,
                                  style: TextStyle(
                                    color: isBot ? Colors.black : Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: chatController,
                              decoration: InputDecoration(
                                hintText: 'Tulis pertanyaan...',
                                hintStyle: TextStyle(color: Colors.black45),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              String userInput = chatController.text.trim();
                              if (userInput.isNotEmpty) {
                                setState(() {
                                  localMessages.add({"sender": "user", "text": userInput});
                                  chatController.clear();
                                });

                                await sendMessage(
                                  message: userInput,
                                  onResult: (botReply) {
                                    setState(() {
                                      localMessages.add({"sender": "bot", "text": botReply});
                                    });
                                  },
                                  onError: (errorMsg) {
                                    setState(() {
                                      localMessages.add({"sender": "bot", "text": errorMsg});
                                    });
                                  },
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF9BC60),
                            ),
                            child: Text('Kirim', style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


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
              child: const Text('Tidak', style: TextStyle(color: Colors.white)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.circle, color: Color(0xFFF9BC60), size: 20),
                          const SizedBox(width: 8),
                          Text("Lecturo",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Good Morning",
                              style: TextStyle(color: Colors.white, fontSize: 12)),
                          Text(
                            nama.isNotEmpty ? nama : "Memuat..",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF9BC60)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFF9BC60), thickness: 1),
                  const SizedBox(height: 20),
                  const Text(
                    "Let's make today productive!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFF9BC60),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        MenuCard(
                          title: 'Pengabdian Masyarakat',
                          imagePath: 'assets/pengmas.png',
                          onTap: () => pc.jumpToPage(3),
                        ),
                        MenuCard(
                          title: 'Penelitian',
                          imagePath: 'assets/penelitian.png',
                          onTap: () => pc.jumpToPage(2),
                        ),
                        MenuCard(
                          title: 'Course',
                          imagePath: 'assets/course.png',
                          onTap: () => pc.jumpToPage(1),
                        ),
                      ],
                    ),
                  ),
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
            MyApp_course(kodePengampu: kode),
            MyApp_penelitian(kodeDosen: kode),
            MyApp_abdimas(kodeDosen: kode),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showChatPopup(context),
        child: Icon(Icons.chat),
        backgroundColor: Color(0xFFF9BC60),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFF9BC60),
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
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 28), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.book, size: 28), label: 'Mata Kuliah'),
          BottomNavigationBarItem(icon: Icon(Icons.article, size: 28), label: 'Penelitian'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt, size: 28), label: 'Pengmas'),
        ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF9BC60),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 70),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
