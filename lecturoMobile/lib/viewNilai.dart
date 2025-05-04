import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'viewMahasiswa.dart';
import 'viewNilai.dart';
import 'course.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp_viewCourse(kodeDosen: '', kodeMatkul: '', kodeKelas: ''));
}

class MyApp_viewCourse extends StatelessWidget {
  final String kodeDosen;
  final String kodeMatkul;
  final String kodeKelas;

  const MyApp_viewCourse({
    Key? key,
    required this.kodeDosen,
    required this.kodeMatkul,
    required this.kodeKelas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Outfit'),
      home: LectureScreen(
        kodeDosen: kodeDosen,
        kodeMatkul: kodeMatkul,
        kodeKelas: kodeKelas,
      ),
    );
  }
}

class LectureScreen extends StatefulWidget {
  LectureScreen({
    Key? key,
    required this.kodeDosen,
    required this.kodeMatkul,
    required this.kodeKelas,
  }) : super(key: key);

  final String kodeDosen;
  final String kodeMatkul;
  final String kodeKelas;

  @override
  State<LectureScreen> createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  final Dio _dio = Dio();
  String? errorMessage;
  String namaDosen = '';
  String kodeDosen = '';
  String namaCourse = '';
  String kodeKelas = '';
  int sks = 0;
  String kodeMatkul = '';
  String kodeDosenKoor = '';
  String namaDosenKoor = '';
  String kontak = '';
  String email = '';

  late TapGestureRecognizer _tapRecognizer;

  @override
  void initState() {
    super.initState();
    fetchKodeCourse();
    fetchKodeDosen();
    fetchDosenKoor();
    _tapRecognizer =
        TapGestureRecognizer()
          ..onTap = () {
            _showDosenDialog(
              context,
              kodeDosenKoor: kodeDosenKoor,
              namaDosenKoor: namaDosenKoor,
              email: email,
              kontak: kontak,
              namaCourse: namaCourse,
              kodeMatkul: kodeMatkul,
            );
          };
  }

  @override
  void dispose() {
    _tapRecognizer.dispose(); // Hindari memory leak & error gesture
    super.dispose();
  }

  Future<void> fetchDosenKoor() async {
    try {
      final response = await _dio.post(
        "http://10.0.2.2/lecturo/getDosenKoor.php",
        data: {"kode": widget.kodeMatkul},
      );

      final data = response.data;
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("dosenkoor", jsonEncode(data["dosenkoor"]));

        setState(() {
          kodeDosenKoor = data["dosenkoor"]["kodeDosen"];
          kontak = data["dosenkoor"]["kontakKoor"];
          email = data["dosenkoor"]["email"];
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

    fetchKodeDosen2();
  }

  Future<void> fetchKodeDosen2() async {
    try {
      final response = await _dio.post(
        "http://10.0.2.2/lecturo/getDosen.php",
        data: {"kode": kodeDosenKoor},
      );

      final data = response.data;
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("dosen", jsonEncode(data["dosen"]));

        setState(() {
          namaDosenKoor = data["dosen"]["nama"];
          kodeDosenKoor = data["dosen"]["kode"];
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

        setState(() {
          namaDosen = data["dosen"]["nama"];
          kodeDosen = data["dosen"]["kode"];
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

  Future<void> fetchKodeCourse() async {
    try {
      final response = await _dio.post(
        "http://10.0.2.2/lecturo/getCourse2.php",
        data: {
          "kodeMatkul": widget.kodeMatkul,
          "kodeDosen": widget.kodeDosen,
          "kodeKelas": widget.kodeKelas,
        },
      );

      final data = response.data;
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("course", jsonEncode(data["course"]));

        if (!mounted) return;
        setState(() {
          namaCourse = data["course"]["nama"];
          kodeKelas = data["course"]["kodeKelas"];
          kodeMatkul = data["course"]["kodeMatkul"];
          sks = data["course"]["sks"];
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

  final TextEditingController namaQuizInput = TextEditingController();
  final TextEditingController kodeMatkulInput = TextEditingController();
  final TextEditingController deadlineInput = TextEditingController();
  final TextEditingController kodeKelasInput = TextEditingController();

  final List<Map<String, String>> quizList = [
    {
      'title': 'Quiz 1: Algoritma Dasar',
      'closed': 'Senin, 5 Mei 2025, 10:00'
    },
    {
      'title': 'Quiz 2: Struktur Data',
      'closed': 'Rabu, 7 Mei 2025, 13:30'
    },
  ];

  void _showCreateQuizDialog() {
    // Kosongkan form setiap kali dialog dibuka
    namaQuizInput.clear();
    kodeMatkulInput.clear();
    deadlineInput.clear();
    kodeKelasInput.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFABD1C6),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF2A2A2A),
                              offset: Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Create Quiz",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004643),
                              ),
                            ),
                            const SizedBox(height: 13),
                            _buildTextField(
                              "Nama Quiz",
                              "Masukkan nama quiz",
                              namaQuizInput,
                            ),
                            _buildTextField(
                              "Kode Mata Kuliah",
                              "Masukkan kode matkul",
                              kodeMatkulInput,
                            ),
                            _buildTextField(
                              "Deadline",
                              "Masukkan deadline quiz",
                              deadlineInput,
                            ),
                            _buildTextField(
                              "Kode Kelas",
                              "Masukkan kode kelas",
                              kodeKelasInput,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    quizList.add({
                                      'title': namaQuizInput.text,
                                      'closed': deadlineInput.text,
                                    });
                                  });
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF9BC60),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  elevation: 6,
                                  shadowColor: Color(0xFFA9A9A9),
                                ),
                                child: Text(
                                  "Tambah",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF001E1D),
                                  ),
                                ),
                              ),
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
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: _boxShadowDecoration(),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 13),
      ],
    );
  }

  BoxDecoration _boxShadowDecoration() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color(0xFFA9A9A9),
          blurRadius: 8,
          offset: const Offset(3, 3),
        ),
      ],
    );
  }

  void _showDosenDialog(
    BuildContext context, {
    String? kodeDosenKoor,
    String? namaDosenKoor,
    String? email,
    String? kontak,
    String? namaCourse,
    String? kodeMatkul,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        // <- gunakan dialogContext
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Informasi Dosen Koordinator',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(thickness: 2),
              SizedBox(height: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kode: $kodeDosenKoor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama: $namaDosenKoor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Email: $email'),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Nomor Telepon: $kontak'),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Koordinator Mata Kuliah: $namaCourse [$kodeMatkul]',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004643),
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(); // <- gunakan context dari dialog
              },
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Color(0xFFF9BC60),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuButton(String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Activity') {
          // Biarkan tetap di halaman ini
        } else if (label == 'Mahasiswa') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApp_viewMahasiswa()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF9BC60),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF004643),
          ),
        ),
      ),
    );
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
                    (context) => MyApp_course(kodePengampu: widget.kodeDosen),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Lecturo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
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
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16), // Jarak dari sisi kanan
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuButton("Activity"),
                    const SizedBox(width: 12),
                    _buildMenuButton("Mahasiswa"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === Container 1 ===
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
                            namaCourse,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            kodeMatkul,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text("Kelas: $kodeKelas", style: TextStyle(fontSize: 12)),
                          Text("SKS: $sks", style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 16),
                          Text(
                            "Dosen Pengampu: $namaDosen [$kodeDosen]",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(text: 'Dosen Koordinator: '),
                                TextSpan(
                                  text: '$namaDosenKoor [$kodeDosenKoor]',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: _tapRecognizer,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // === Tombol Create Quiz ===
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9BC60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _showCreateQuizDialog,
                      child: const Text(
                        'Create Quiz',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004643),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // === ListView builder for Quiz ===
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: quizList.length,
                      itemBuilder: (context, index) {
                        final quiz = quizList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyApp_viewNilai(),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFABD1C6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.assignment, color: Color(0xFF004643)),
                                        const SizedBox(width: 8),
                                        Text(
                                          quiz['title'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(color: Colors.black54, thickness: 1),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Closed : ${quiz['closed']}",
                                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.black),
                                          onPressed: () {
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
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