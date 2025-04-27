import 'package:flutter/material.dart';
import 'viewCourse.dart';
import 'viewMahasiswa.dart';
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
  String _dropdownValue = 'Nilai'; // Dropdown menu

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
              // Dropdown Menu
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
                      if (newValue == 'Nilai') {
                      } else if (newValue == 'Activity') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp_viewCourse(),
                          ),
                        );
                      } else if (newValue == 'Mahasiswa') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp_viewMahasiswa(),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                'Quiz 1 : Class Diagram',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

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
                          DataColumn(label: Text('Nilai')),
                          DataColumn(label: Text('')),
                        ],
                        rows: [
                          _buildDataRowWithAction(
                            '1301223248',
                            'Muthia Rihadatul A',
                            '100',
                          ),
                          _buildDataRowWithAction(
                            '1301223248',
                            'Nasywa Alif Widya',
                            '100',
                          ),
                          _buildDataRowWithAction(
                            '1301223248',
                            'Achmad Rafly K Z',
                            '100',
                          ),
                          _buildDataRowWithAction(
                            '1301223248',
                            'Farah Saraswati',
                            '100',
                          ),
                          _buildDataRowWithAction(
                            '1301223248',
                            'Azra Feby Awfiyah',
                            '100',
                          ),
                          _buildDataRowWithAction(
                            '1301223248',
                            'Diva Sanjaya W',
                            '100',
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
      ),
    );
  }

  DataRow _buildDataRowWithAction(String nim, String nama, String nilai) {
    return DataRow(
      cells: [
        DataCell(Text(nim)),
        DataCell(Text(nama)),
        DataCell(Text(nilai)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () {
                  _showEditDialog(context, nim, nama, nilai);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18),
                onPressed: () {
                  _showDeleteDialog(context, nim);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(
    BuildContext context,
    String nim,
    String nama,
    String nilai,
  ) {
    TextEditingController nimController = TextEditingController(text: nim);
    TextEditingController namaController = TextEditingController(text: nama);
    TextEditingController nilaiController = TextEditingController(text: nilai);

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
                  const Text(
                    'NIM',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004643),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: nimController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Nama',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004643),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: namaController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Nilai',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004643),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: nilaiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // TODO: update nilai di list kalau ada
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9BC60),
                        foregroundColor: const Color(0xFF004643),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
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

  void _showDeleteDialog(BuildContext context, String nim) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: Text('Are you sure you want to delete data for NIM: $nim?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // TODO: hapus data dari list kalau ada
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
