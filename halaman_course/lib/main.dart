import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.outfit().fontFamily,
      ),
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

  void _showDosenDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Informasi Dosen Koordinator',
        style: GoogleFonts.outfit(
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
                fontWeight: FontWeight.bold, // atau FontWeight.w600, FontWeight.w500, dll
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
                fontWeight: FontWeight.bold, // atau FontWeight.w600, FontWeight.w500, dll
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
                fontWeight: FontWeight.bold, // atau FontWeight.w600, FontWeight.w500, dll
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
              borderRadius: BorderRadius.circular(6), // sudut tidak terlalu lonjong
            ),
          ),
          onPressed: () => Navigator.pop(context),
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
                        const Icon(Icons.circle, color: Color(0xFFF9BC60), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Lecturo",
                          style: GoogleFonts.outfit(
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
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF004643),
                        ),
                        items: <String>['Activity', 'Mahasiswa', 'Nilai']
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropdownValue = newValue!;
                          });
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
                          Text("NAMA MATA KULIAH",
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          const SizedBox(height: 0),
                          Text("[KODE MATA KULIAH]",
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                          const SizedBox(height: 8),
                          Text("Kelas: ...",
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          Text("SKS: ...",
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          const SizedBox(height: 16),
                          Text("Dosen Pengampu: Nama Dosen [Kode Dosen]",
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                          const SizedBox(height: 0),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.outfit(
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
                              recognizer: TapGestureRecognizer()
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
                      onPressed: () {},
                      child: Text(
                        'Create Quiz',
                        style: GoogleFonts.outfit(
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
                                  const Icon(Icons.assignment, color: Color(0xFF004643)),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Quiz 1: Nama Quiz",
                                    style: GoogleFonts.outfit(
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
                                "Closed : Hari, Tanggal Bulan Tahun, Jam",
                                style: GoogleFonts.outfit(
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
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Homepage'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Mata Kuliah'),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Penelitian'),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Pengabdian\nMasyarakat',
            ),
          ],
          currentIndex: 1,
          selectedItemColor: Colors.white,
          unselectedItemColor: Color(0xFF004643),
          backgroundColor: Color(0xFFF9BC60),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }
}
