import 'package:flutter/material.dart';
import 'viewCourse.dart';
import 'course.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String selectedKelas = 'IF-46-06'; // Default value

  List<Map<String, dynamic>> mahasiswaList = [];
  List<String> kelasList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKelas();
    _fetchMahasiswa();
  }

  Future<void> _fetchKelas() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/lecturo/getKelasList.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            kelasList = List<String>.from(data['kelas']);
            if (kelasList.isNotEmpty) {
              selectedKelas = kelasList.first;
            }
          });
        }
      }
    } catch (e) {
      print('Error fetching kelas: $e');
    }
  }

  Future<void> _fetchMahasiswa() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/lecturo/getInfoMahasiswa.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'kodeKelas': selectedKelas}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            mahasiswaList = List<Map<String, dynamic>>.from(data['mahasiswa']);
            isLoading = false;
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _addMahasiswa() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/lecturo/updaddMahasiswa.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'NIM': _nimController.text,
          'nama': _namaController.text,
          'kodeKelas': selectedKelas,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == true) {
          // Clear controllers first
          _nimController.clear();
          _namaController.clear();

          // Close the dialog before updating state
          Navigator.of(context).pop();

          // Refresh the data
          await _fetchMahasiswa();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mahasiswa berhasil ditambahkan')),
          );
        } else {
          throw Exception(result['message']);
        }
      } else {
        throw Exception('Failed to add data');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _deleteMahasiswa(String nim) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/lecturo/delMahasiswa.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'NIM': nim}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == true) {
          await _fetchMahasiswa();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mahasiswa berhasil dihapus')),
          );
        } else {
          throw Exception(result['message']);
        }
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void showAddMahasiswaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFFABD1C6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
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
                      color: Color(0xFF004643),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // NIM
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NIM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004643),
                        ),
                      ),
                      const SizedBox(height: 4),
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Nama
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004643),
                        ),
                      ),
                      const SizedBox(height: 4),
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Kelas
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kelas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004643),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Material(
                        elevation: 2,
                        shadowColor: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                        child: TextField(
                          controller: TextEditingController(
                            text: selectedKelas,
                          ),
                          enabled: false,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Button Tambah
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9BC60),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        if (_nimController.text.isNotEmpty &&
                            _namaController.text.isNotEmpty) {
                          await _addMahasiswa();
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
          ),
        );
      },
    );
  }

  Widget _buildMenuButton(String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Activity') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ViewCourse(kodeDosen: '', kodeMatkul: '', kodeKelas: ''),
            ),
          );
        } else if (label == 'Mahasiswa') {
          // Biarkan tetap di halaman ini
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
              padding: const EdgeInsets.only(left: 16),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      const Divider(),

                      // List Data
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Expanded(
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
                                        child: Text(
                                          mahasiswa['NIM']?.toString() ?? '',
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          mahasiswa['nama']?.toString() ?? '',
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          mahasiswa['kodeKelas']?.toString() ??
                                              '',
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color(0xFF004643),
                                          ),
                                          onPressed: () {
                                            _deleteMahasiswa(
                                              mahasiswa['NIM']?.toString() ??
                                                  '',
                                            );
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
