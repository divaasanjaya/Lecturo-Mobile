import 'package:flutter/material.dart';
import 'penelitian.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp_viewPenelitian(kodeDosen: '', kodePenelitian: 0));
}

class MyApp_viewPenelitian extends StatelessWidget {
  final String kodeDosen;
  final int kodePenelitian;
  const MyApp_viewPenelitian({
    Key? key,
    required this.kodeDosen,
    required this.kodePenelitian,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Outfit'),
      home: LectureScreen(kodeDosen: kodeDosen, kodePenelitian: kodePenelitian),
    );
  }
}

class LectureScreen extends StatefulWidget {
  const LectureScreen({
    Key? key,
    required this.kodeDosen,
    required this.kodePenelitian,
  }) : super(key: key);

  final String kodeDosen;
  final int kodePenelitian;

  @override
  _LectureScreenState createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  final Dio _dio = Dio();
  String? errorMessage;
  String namaPenelitian = '';
  String namaDosen = '';
  String kodeDosen = '';
  String tanggal = '';
  String deskripsi = '';
  String bidang = '';
  String url = '';

  @override
  void initState() {
    super.initState();
    fetchKodePenelitian();
    fetchKodeDosen();
  }

  Future<void> fetchKodeDosen() async {
    try {
      final response = await _dio.post(
        "http://10.0.2.2/lecturo/getDosen.php",
        data: {"kode": widget.kodeDosen},
      );

      final data = response.data;
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

  Future<void> fetchKodePenelitian() async {
    try {
      final response = await _dio.post(
        "http://10.0.2.2/lecturo/getInfoPenelitian.php",
        data: {"kode": widget.kodePenelitian},
      );

      final data = response.data;
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("penelitian", jsonEncode(data["penelitian"]));

        setState(() {
          namaPenelitian = data["penelitian"]["nama"];
          tanggal = data["penelitian"]["tanggal"];
          bidang = data["penelitian"]["bidang"];
          deskripsi = data["penelitian"]["deskripsi"];
          url = data["penelitian"]["tautan"];
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

  void _launchURL() async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $url";
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
                    (context) => MyApp_penelitian(kodeDosen: widget.kodeDosen),
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
                            namaPenelitian,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            bidang,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tanggal,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Penulis : ${namaDosen} [${kodeDosen}]",
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
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _launchURL,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF004643),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "URL/DOI : ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: const Color(0xFFF9BC60),
                                      ),
                                    ),
                                    TextSpan(
                                      text: url,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
