import 'package:flutter/material.dart';
import 'viewCourse.dart';
import 'course.dart';

void main() {
  runApp(const MyApp_viewMahasiswa());
}

class MyApp_viewMahasiswa extends StatelessWidget {
  const MyApp_viewMahasiswa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecturo',
      theme: ThemeData(
        fontFamily: 'Outfit',
        scaffoldBackgroundColor: const Color(0xFF004643),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController(
    text: 'IF-46-06',
  );

  final List<Map<String, String>> mahasiswaList = [
    {"nim": "1301223248", "nama": "Muthia Rihadatul A", "kelas": "IF-46-06"},
    {"nim": "1301223249", "nama": "Nasywa Alif Widya", "kelas": "IF-46-06"},
    {"nim": "1301223250", "nama": "Achmad Rafly K Z", "kelas": "IF-46-06"},
    {"nim": "1301223251", "nama": "Farah Saraswati", "kelas": "IF-46-06"},
    {"nim": "1301223252", "nama": "Azra Feby Awfiyah", "kelas": "IF-46-06"},
    {"nim": "1301223253", "nama": "Diva Sanjaya W", "kelas": "IF-46-06"},
  ];
  void showAddMahasiswaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFFABD1C6), // hijau muda
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Mahasiswa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004643), // hijau tua
                  ),
                ),
                const SizedBox(height: 20),
                // NIM
                Material(
                  elevation: 2,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                  child: TextField(
                    controller: _nimController,
                    decoration: InputDecoration(
                      hintText: 'isi nim Mahasiswa',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Nama
                Material(
                  elevation: 2,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                  child: TextField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      hintText: 'isi nama mahasiswa',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Kelas
                Material(
                  elevation: 2,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                  child: TextField(
                    controller: _kelasController,
                    decoration: InputDecoration(
                      hintText: 'Kelas',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Button Tambah
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF9BC60), // kuning
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      if (_nimController.text.isNotEmpty &&
                          _namaController.text.isNotEmpty) {
                        setState(() {
                          mahasiswaList.add({
                            'nim': _nimController.text,
                            'nama': _namaController.text,
                            'kelas': _kelasController.text,
                          });
                        });
                        _nimController.clear();
                        _namaController.clear();
                        _kelasController.text = 'IF-46-06';
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Tambah',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF004643),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyApp_course(kodePengampu: ''),
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
                  const Icon(Icons.circle, color: Color(0xFFF9BC60), size: 20),
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
                    const SizedBox(width: 68),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF9BC60),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF2A2A2A),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => showAddMahasiswaDialog(context),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF004643),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // list mahasiswa
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ), // jarak dari kiri-kanan layar
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Header Tabel
                      Row(
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'NIM',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Nama',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Kelas',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(),
                          ), // untuk ikon delete
                        ],
                      ),
                      const Divider(),

                      // List Data
                      Expanded(
                        child: ListView.builder(
                          itemCount: mahasiswaList.length,
                          itemBuilder: (context, index) {
                            final mahasiswa = mahasiswaList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(mahasiswa['nim'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(mahasiswa['nama'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(mahasiswa['kelas'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color(0xFF004643),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          mahasiswaList.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
