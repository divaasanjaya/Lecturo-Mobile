import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edit Penelitian',
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: EditPenelitianScreen(),
    );
  }
}

class EditPenelitianScreen extends StatelessWidget {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _bidangController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  EditPenelitianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004643),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFABD1C6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create Penelitian",
                          style: GoogleFonts.outfit(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF001E1D),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField("Judul Penelitian", "isi nama penelitian", _judulController),
                        _buildTextField("Bidang", "isi bidang", _bidangController),
                        _buildTextField("Deskripsi", "isi deskripsi penelitian", _deskripsiController),
                        _buildTextField("URL/DOI", "isi url/doi jurnal", _urlController),
                        Text(
                          "Tanggal Pelaksanaan",
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF001E1D),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: _boxShadowDecoration(),
                          child: TextField(
                            controller: _tanggalController,
                            decoration: InputDecoration(
                              hintText: "dd/mm/yyyy",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: Color(0xFF001E1D),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF9BC60),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Tambah",
                              style: GoogleFonts.outfit(
                                fontSize: 18,
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Homepage'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Mata Kuliah'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Penelitian'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pengabdian Masyarakat'),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xFF004643),
        backgroundColor: Color(0xFFF9BC60),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF001E1D),
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
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  BoxDecoration _boxShadowDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 2,
          spreadRadius: 1,
          offset: Offset(0, 1),
        ),
      ],
    );
  }
}
