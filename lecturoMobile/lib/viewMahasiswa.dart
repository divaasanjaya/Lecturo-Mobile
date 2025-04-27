import 'package:flutter/material.dart';
import 'viewCourse.dart';
import 'viewNilai.dart';
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
  String _dropdownValue = 'Mahasiswa';

  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController(
    text: 'IF-46-06',
  );

  List<Map<String, String>> mahasiswaList = [
    {'nim': '1301223248', 'nama': 'Muthia Rihadatul A', 'kelas': 'IF-46-06'},
    {'nim': '1301223248', 'nama': 'Nasywa Alif Widya', 'kelas': 'IF-46-06'},
    {'nim': '1301223248', 'nama': 'Achmad Rafly K Z', 'kelas': 'IF-46-06'},
    {'nim': '1301223248', 'nama': 'Farah Saraswati', 'kelas': 'IF-46-06'},
    {'nim': '1301223248', 'nama': 'Azra Feby Awfiyah', 'kelas': 'IF-46-06'},
    {'nim': '1301223248', 'nama': 'Diva Sanjaya W', 'kelas': 'IF-46-06'},
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
              MaterialPageRoute(builder: (context) => MyApp_course()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              const SizedBox(height: 24),
              // Dropdown Mahasiswa / Activity / Nilai
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
                    if (newValue != null) {
                      setState(() {
                        _dropdownValue = newValue;
                      });
                      if (newValue == 'Mahasiswa') {
                      } else if (newValue == 'Activity') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp_viewCourse(),
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
              const SizedBox(height: 20),

              // Table
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('NIM')),
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Kelas')),
                          DataColumn(label: Text('')),
                        ],
                        rows: [
                          _buildDataRow(
                            '1301223248',
                            'Muthia Rihadatul A',
                            'IF-46-06',
                          ),
                          _buildDataRow(
                            '1301223248',
                            'Nasywa Alif Widya',
                            'IF-46-06',
                          ),
                          _buildDataRow(
                            '1301223248',
                            'Achmad Rafly K Z',
                            'IF-46-06',
                          ),
                          _buildDataRow(
                            '1301223248',
                            'Farah Saraswati',
                            'IF-46-06',
                          ),
                          _buildDataRow(
                            '1301223248',
                            'Azra Feby Awfiyah',
                            'IF-46-06',
                          ),
                          _buildDataRow(
                            '1301223248',
                            'Diva Sanjaya W',
                            'IF-46-06',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Button Tambah
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFABD1C6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  showAddMahasiswaDialog(context);
                },
                child: Text(
                  'Tambah Mahasiswa',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
    );
  }

  DataRow _buildDataRow(String nim, String nama, String kelas) {
    return DataRow(
      cells: [
        DataCell(Text(nim)),
        DataCell(Text(nama)),
        DataCell(Text(kelas)),
        const DataCell(Icon(Icons.delete)),
      ],
    );
  }
}
