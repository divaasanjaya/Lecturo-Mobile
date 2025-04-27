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
  int _selectedIndex = 0;
  String selectedMenu = 'Mahasiswa';
  List<String> menuOptions = ['Mahasiswa', 'Activity', 'Nilai'];

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
              // Langsung ke Dropdown, header DIHAPUS

              // Dropdown Mahasiswa / Activity / Nilai
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9BC60),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<String>(
                  value: selectedMenu,
                  dropdownColor: const Color(0xFFF9BC60),
                  iconEnabledColor: Colors.black,
                  underline: const SizedBox(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedMenu = value!;
                    });
                  },
                  items: menuOptions.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
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
                              '1301223248', 'Muthia Rihadatul A', 'IF-46-06'),
                          _buildDataRow(
                              '1301223248', 'Nasywa Alif Widya', 'IF-46-06'),
                          _buildDataRow(
                              '1301223248', 'Achmad Rafly K Z', 'IF-46-06'),
                          _buildDataRow(
                              '1301223248', 'Farah Saraswati', 'IF-46-06'),
                          _buildDataRow(
                              '1301223248', 'Azra Feby Awfiyah', 'IF-46-06'),
                          _buildDataRow(
                              '1301223248', 'Diva Sanjaya W', 'IF-46-06'),
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
                  // Tambah data action
                },
                child: Text('Tambah $selectedMenu',
                    style: const TextStyle(color: Colors.black)),
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
              label: 'Pengabdian \n Masyarakat',
            ),
          ],
        ),
      ),
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
