import 'package:flutter/material.dart';

void main() {
  runApp(const LecturoApp());
}

class LecturoApp extends StatelessWidget {
  const LecturoApp({super.key});

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
  int _selectedIndex = 2;
  String selectedMenu = 'Nilai';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown Menu
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9BC60),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedMenu,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color(0xFF004643)),
                    dropdownColor: const Color(0xFFF9BC60),
                    style: const TextStyle(
                      color: Color(0xFF004643),
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMenu = newValue!;
                      });
                    },
                    items: <String>['Activity', 'Mahasiswa', 'Nilai']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
                              '1301223248', 'Muthia Rihadatul A', '100'),
                          _buildDataRowWithAction(
                              '1301223249', 'Nasywa Alif Widya', '100'),
                          _buildDataRowWithAction(
                              '1301223250', 'Achmad Rafly K Z', '100'),
                          _buildDataRowWithAction(
                              '1301223251', 'Farah Saraswati', '100'),
                          _buildDataRowWithAction(
                              '1301223252', 'Azra Feby Awfiyah', '100'),
                          _buildDataRowWithAction(
                              '1301223253', 'Diva Sanjaya W', '100'),
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF9BC60),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFFFFFFFF),
          unselectedItemColor: const Color(0xFF004643),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Homepage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Mata Kuliah',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Penelitian',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Pengabdian \nMasyarakat',
            ),
          ],
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
        DataCell(Row(
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
        )),
      ],
    );
  }

  // === Ini pop up Edit yang sudah diperbaiki ===
  void _showEditDialog(
      BuildContext context, String nim, String nama, String nilai) {
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
