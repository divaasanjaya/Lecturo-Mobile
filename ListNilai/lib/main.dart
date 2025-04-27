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
  int _selectedIndex = 2; // Ini biar default yang aktif Penelitian misal
  String selectedMenu = 'Nilai'; // Dropdown menu

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // TODO: ganti halaman kalau mau
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
                              '1301223248', 'Muthia Rihadatul A', '100'),
                          _buildDataRowWithAction(
                              '1301223248', 'Nasywa Alif Widya', '100'),
                          _buildDataRowWithAction(
                              '1301223248', 'Achmad Rafly K Z', '100'),
                          _buildDataRowWithAction(
                              '1301223248', 'Farah Saraswati', '100'),
                          _buildDataRowWithAction(
                              '1301223248', 'Azra Feby Awfiyah', '100'),
                          _buildDataRowWithAction(
                              '1301223248', 'Diva Sanjaya W', '100'),
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

      // Bottom Navigation Bar
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
                // TODO: fungsi edit nilai
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18),
              onPressed: () {
                // TODO: fungsi hapus data
              },
            ),
          ],
        )),
      ],
    );
  }
}
