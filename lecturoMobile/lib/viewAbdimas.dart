import 'package:flutter/material.dart';
import 'abdimas.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp_viewAbdimas(kodeDosen: '', kodeAbdimas: 0));
}

class MyApp_viewAbdimas extends StatelessWidget {
  final String kodeDosen;
  final int kodeAbdimas;

  const MyApp_viewAbdimas({
    Key? key,
    required this.kodeDosen,
    required this.kodeAbdimas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Outfit'),
      home: LectureScreen(kodeDosen: kodeDosen, kodeAbdimas: kodeAbdimas),
    );
  }
}

class LectureScreen extends StatefulWidget {
  LectureScreen({Key? key, required this.kodeDosen, required this.kodeAbdimas})
    : super(key: key);
  final String kodeDosen;
  final int kodeAbdimas;

  @override
  _LectureScreenState createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  String? errorMessage;
  String namaAbdimas = '';
  String namaDosen = '';
  String kodeDosen = '';
  String tanggal = '';
  String deskripsi = '';

  @override
  void initState() {
    super.initState();
    fetchKodeAbdimas();
    fetchKodeDosen();
  }

  Future<void> fetchKodeDosen() async {
    final kode = widget.kodeDosen;
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/dosen/$kode"),
      );

      final data = jsonDecode(response.body);
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("dosen", jsonEncode(data["dosen"]));

        if (!mounted) return;
        setState(() {
          namaDosen = data["dosen"]["nama"];
          kodeDosen = data["dosen"]["kode"];
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

  Future<void> fetchKodeAbdimas() async {
    final kode = widget.kodeAbdimas;
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/abdimas/$kode"),
      );

      final data = jsonDecode(response.body);
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("abdimas", jsonEncode(data["abdimas"]));

        setState(() {
          namaAbdimas = data["abdimas"]["nama"];
          tanggal = data["abdimas"]["tanggal"];
          deskripsi = data["abdimas"]["deskripsi"];
        });
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
    return Scaffold(
      backgroundColor: const Color(0xFF004643),
      appBar: AppBar(
        backgroundColor: const Color(0xFF004643),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MyApp_abdimas(kodeDosen: widget.kodeDosen),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaAbdimas,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tanggal,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "Dosen pembimbing : ${namaDosen} [${kodeDosen}]",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFABD1C6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info, color: Color(0xFF004643)),
                              const SizedBox(width: 8),
                              Text(
                                "Deskripsi",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.black54, thickness: 1),
                          const SizedBox(height: 8),
                          Text(
                            deskripsi,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
