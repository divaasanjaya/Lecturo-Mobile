import 'package:flutter/material.dart';
import 'course.dart';

void main() {
  runApp(const MyApp_viewNilai());
}

class MyApp_viewNilai extends StatelessWidget {
  const MyApp_viewNilai({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecturo',
      theme: ThemeData(
        fontFamily: 'Outfit',
        scaffoldBackgroundColor: const Color(0xFF004643),
      ),
      home: const NilaiPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NilaiPage extends StatefulWidget {
  const NilaiPage({super.key});

  @override
  State<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends State<NilaiPage> {
  final List<Map<String, String>> nilaiList = [
    {"nim": "1301223248", "nama": "Muthia Rihadatul A", "nilai": "100"},
    {"nim": "1301223249", "nama": "Nasywa Alif Widya", "nilai": "100"},
    {"nim": "1301223250", "nama": "Achmad Rafly K Z", "nilai": "100"},
    {"nim": "1301223251", "nama": "Farah Saraswati", "nilai": "100"},
    {"nim": "1301223252", "nama": "Azra Feby Awfiyah", "nilai": "100"},
    {"nim": "1301223253", "nama": "Diva Sanjaya W", "nilai": "100"},
  ];

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
            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Quiz 1 : Class Diagram",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // list nilai
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16), // jarak dari kiri-kanan layar
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
                          Expanded(flex: 3, child: Text('NIM', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 3, child: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text('Nilai', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: SizedBox()), // untuk ikon delete
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      const Divider(),

                      // List Data
                      Expanded(
                        child: ListView.builder(
                          itemCount: nilaiList.length,
                          itemBuilder: (context, index) {
                            final nilai = nilaiList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(flex: 3, child: Text(nilai['nim'] ?? '')),
                                  Expanded(flex: 3, child: Text(nilai['nama'] ?? '')),
                                  Expanded(flex: 1, child: Text(nilai['nilai'] ?? '')),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit, color: Color(0xFF004643)),
                                      onPressed: () {
                                        _showEditDialog(context, nilai);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete, color: Color(0xFF004643)),
                                      onPressed: () {
                                        _showDeleteDialog(context, nilai);
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

  void _showEditDialog(BuildContext context, Map<String, String> nilai) {
    final TextEditingController nimController = TextEditingController(text: nilai['nim']);
    final TextEditingController namaController = TextEditingController(text: nilai['nama']);
    final TextEditingController nilaiController = TextEditingController(text: nilai['nilai']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFA7D7C5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Nilai Mahasiswa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004643),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('NIM', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004643))),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: nimController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Nama', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004643))),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: namaController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Nilai', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004643))),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: TextField(
                      controller: nilaiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final newNilai = nilaiController.text;
                        setState(() {
                          final index = nilaiList.indexWhere((item) => item['nim'] == nilai['nim']);
                          if (index != -1) {
                            nilaiList[index]['nilai'] = newNilai;
                          }
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9BC60),
                        foregroundColor: const Color(0xFF004643),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, String> nilai) {
    final nim = nilai['nim'] ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: Text('Apakah kamu yakin ingin menghapus data untuk NIM: $nim?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  nilaiList.removeWhere((item) => item['nim'] == nim);
                });
                Navigator.of(context).pop(); // Tutup dialog setelah hapus
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}