import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(fontFamily: 'Outfit'),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio();
  String? errorMessage;

  Future<void> login() async {
    try {
      final response = await _dio.post(
        "http://10.0.2.2/lecturo/login.php",
        data: {
          "kode": _kodeController.text,
          "password": _passwordController.text,
        },
      );

      final data = response.data;
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("kode", data["dosen"]["kode"]);
        await prefs.setString("nama", data["dosen"]["nama"]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        setState(() {
          errorMessage = data["message"];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Kode atau password Anda salah!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFABD1C6),
      body: Stack(
        children: [
          // Background Image
          Positioned(
            child: Container(
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    const Color.fromARGB(1000, 0, 70, 67).withOpacity(0.8),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),

          // Logo Lecturo
          Positioned(
            top: screenHeight * 0.15,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 22.5, backgroundColor: Color(0xfff9bc60)),
                SizedBox(width: 10),
                Text(
                  "Lecturo",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Box Login (Pakai Align agar tidak terpotong)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.3),
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  constraints: BoxConstraints(
                    maxHeight: screenHeight * 0.6, // Batasi tinggi maksimal
                  ),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Center(
                        child: Text(
                          "Selamat datang kembali!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Kode Pengguna
                      Text(
                        "Kode Pengguna",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _kodeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff004643),
                          hintText: "Kode anda",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 20),

                      // Kata Sandi
                      Text(
                        "Kata Sandi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff004643),
                          hintText: "Masukkan 5 karakter atau lebih",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),

                      // Error Message
                      if (errorMessage != null)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),

                      SizedBox(height: 50),

                      // Tombol Masuk
                      Center(
                        child: ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF9BC60),
                            padding: EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 50), // Tambahkan jarak agar lebih nyaman
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
