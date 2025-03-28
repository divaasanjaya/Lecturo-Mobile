import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Penelitian',
      theme: ThemeData(fontFamily: 'Outfit'),
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
      backgroundColor: const Color(0xFF004643), // Warna latar belakang utama
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Container utama yang berisi form
              Expanded(
                child: Container(
                  height: 500,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFABD1C6), // Warna container
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul "Edit Penelitian"
                        Text(
                          "Edit Penelitian",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF001E1D),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Input fields dengan label
                        _buildTextField(
                          "Judul Penelitian",
                          "isi nama penelitian",
                          _judulController,
                        ),
                        _buildTextField(
                          "Bidang",
                          "isi bidang",
                          _bidangController,
                        ),
                        _buildTextField(
                          "Deskripsi",
                          "isi deskripsi penelitian",
                          _deskripsiController,
                        ),
                        _buildTextField(
                          "URL/DOI",
                          "isi url/doi jurnal",
                          _urlController,
                        ),

                        // Tanggal Pelaksanaan dengan Icon Kalender
                        Text(
                          "Tanggal Pelaksanaan",
                          style: TextStyle(
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

                        // Tombol "Edit"
                        SizedBox(
                          width: double.infinity, // Menyesuaikan panjang tombol
                          child: ElevatedButton(
                            onPressed: () {
                              // Aksi tombol Edit
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                0xFFF9BC60,
                              ), // Warna tombol
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Edit",
                              style: TextStyle(
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

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 120,
        decoration: const BoxDecoration(
          color: Color(0xFFF9BC60), // Warna navbar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Homepage'),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Mata Kuliah',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Penelitian',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Pengabdian Masyarakat',
            ),
          ],
          currentIndex: 2,
          selectedItemColor: Colors.white,
          unselectedItemColor: Color(0xFF004643),
          backgroundColor: Colors.transparent,
          showUnselectedLabels: true, // Menampilkan semua label
          type: BottomNavigationBarType.fixed,
          elevation: 0, // Menghapus shadow pada navbar
        ),
      ),
    );
  }

  // Fungsi untuk membuat TextField dengan shadow dan styling
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
          style: TextStyle(
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

  // Fungsi untuk memberikan efek shadow pada input box
  BoxDecoration _boxShadowDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.1), // Mengurangi opacity shadow
          blurRadius: 2, // Blur lebih kecil
          spreadRadius: 1, // Menyebar lebih sedikit
          offset: Offset(0, 1), // Shadow lebih dekat ke elemen
        ),
      ],
    );
  }
}
