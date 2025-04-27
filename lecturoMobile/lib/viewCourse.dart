import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'viewMahasiswa.dart';
import 'viewNilai.dart';
import 'course.dart';

void main() {
  runApp(const MyApp_viewCourse());
}

class MyApp_viewCourse extends StatelessWidget {
  const MyApp_viewCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Outfit'),
      home: const LectureScreen(),
    );
  }
}

class LectureScreen extends StatefulWidget {
  const LectureScreen({super.key});

  @override
  State<LectureScreen> createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  String _dropdownValue = 'Activity';
  final TextEditingController namaQuizInput = TextEditingController();
  final TextEditingController kodeMatkulInput = TextEditingController();
  final TextEditingController deadlineInput = TextEditingController();
  final TextEditingController kodeKelasInput = TextEditingController();

  List<Map<String, dynamic>> daftarQuiz = [
    {"quiz": "Class Diagram", "dl": "Tuesday, 31 December 2024, 12:40"},
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
                                    daftarQuiz.add({
                                      'quiz': namaQuizInput.text,
                                      'dl': deadlineInput.text,
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
                                child: const Text(
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

  void _showDosenDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Informasi Dosen Koordinator',
              style: TextStyle(
                fontSize: 16, // Atur ukuran font
                fontWeight: FontWeight.bold, // Atur ketebalan
                color: Colors.black, // Opsional: atur warna
              ),
            ),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Divider(thickness: 2),
                SizedBox(height: 2),
                Align(
                  alignment: Alignment.centerLeft, // Membuat teks rata kiri
                  child: Text(
                    'Kode: Kode Dosen',
                    style: TextStyle(
                      fontWeight:
                          FontWeight
                              .bold, // atau FontWeight.w600, FontWeight.w500, dll
                      fontSize: 14, // opsional: atur ukuran juga kalau perlu
                    ),
                  ),
                ),
                SizedBox(height: 0),
                Align(
                  alignment: Alignment.centerLeft, // Membuat teks rata kiri
                  child: Text(
                    'Nama: Nama Dosen',
                    style: TextStyle(
                      fontWeight:
                          FontWeight
                              .bold, // atau FontWeight.w600, FontWeight.w500, dll
                      fontSize: 14, // opsional: atur ukuran juga kalau perlu
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft, // Membuat teks rata kiri
                  child: Text('Email: Email Dosen'),
                ),
                SizedBox(height: 0),
                Align(
                  alignment: Alignment.centerLeft, // Membuat teks rata kiri
                  child: Text('Nomor Telepon: No. Telp Dosen'),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft, // Membuat teks rata kiri
                  child: Text(
                    'Koordinator Mata Kuliah: NAMA MATA KULIAH [KODE MATA KULIAH]',
                    style: TextStyle(
                      fontWeight:
                          FontWeight
                              .bold, // atau FontWeight.w600, FontWeight.w500, dll
                      fontSize: 14, // opsional: atur ukuran juga kalau perlu
                    ),
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
                    borderRadius: BorderRadius.circular(
                      6,
                    ), // sudut tidak terlalu lonjong
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    color: const Color(0xFFF9BC60),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
              MaterialPageRoute(builder: (context) => MyApp_course()),
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
                    const SizedBox(height: 24),

                    // Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9BC60),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: DropdownButton<String>(
                        value: _dropdownValue,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down),
                        borderRadius: BorderRadius.circular(16),
                        dropdownColor: const Color(0xFFF9BC60),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF004643),
                        ),
                        items:
                            <String>['Activity', 'Mahasiswa', 'Nilai'].map((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          print('Dropdown value changed: $newValue');
                          if (newValue != null) {
                            setState(() {
                              _dropdownValue = newValue;
                            });
                            print('Navigating to page for: $newValue');
                            if (newValue == 'Activity') {
                            } else if (newValue == 'Mahasiswa') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyApp_viewMahasiswa(),
                                ),
                              );
                            } else if (newValue == 'Nilai') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyApp_viewNilai(),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Container 1
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
                            "NAMA MATA KULIAH",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 0),
                          Text(
                            "[KODE MATA KULIAH]",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Kelas: ...",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          Text(
                            "SKS: ...",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Dosen Pengampu: Nama Dosen [Kode Dosen]",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 0),
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
                                  text: 'Nama Dosen [Kode Dosen]',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          _showDosenDialog(context);
                                        },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tombol Create Quiz
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9BC60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        _showCreateQuizDialog();
                      },
                      child: Text(
                        'Create Quiz',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold, // atur ketebalan
                          color: const Color(0xFF004643), // atur warna
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Container 2
                    Container(
                      width: double.infinity,
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
                                  const Icon(
                                    Icons.assignment,
                                    color: Color(0xFF004643),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Quiz 1: Nama Quiz",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.black54,
                                thickness: 1,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Closed : Hari, Tanggal Bulan Tahun, Jam",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(Icons.delete, color: Colors.black),
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
