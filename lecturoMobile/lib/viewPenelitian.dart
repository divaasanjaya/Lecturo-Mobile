import 'package:flutter/material.dart';
import 'penelitian.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp_viewPenelitian());
}

class MyApp_viewPenelitian extends StatelessWidget {
  const MyApp_viewPenelitian({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Outfit'),
      home: const LectureScreen(),
    );
  }
}

class LectureScreen extends StatelessWidget {
  const LectureScreen({super.key});

  void _launchURL() async {
    const url = "https://pebeo/penelitian/ai/knn";
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
              MaterialPageRoute(builder: (context) => MyApp_penelitian()),
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
                            "Judul Penelitian",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Bidang Penelitian",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Tanggal Penelitian",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Penulis : Nama dosen [Kode Dosen]",
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
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
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
                                      text: "https://pebeo/penelitian/ai/knn",
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
