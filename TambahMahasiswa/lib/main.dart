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

  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kelasController =
      TextEditingController(text: 'IF-46-06');

  List<Map<String, String>> mahasiswaList = [
    {'nim': '1301223248', 'nama': 'Muthia Rihadatul A', 'kelas': 'IF-46-06'},
    {'nim': '1301223248', 'nama': 'Nasywa Alif Widya', 'kelas': 'IF-46-06'},
    {'nim': '1301223248', 'nama': 'Achmad Rafly K Z', 'kelas': 'IF-46-06'},
    {'nim': '1301223248', 'nama': 'Farah Saraswati', 'kelas': 'IF-46-06'},
    {'nim': '1301223248', 'nama': 'Azra Feby Awfiyah', 'kelas': 'IF-46-06'},
    {'nim': '1301223248', 'nama': 'Diva Sanjaya W', 'kelas': 'IF-46-06'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        rows: mahasiswaList.map((mahasiswa) {
                          return DataRow(
                            cells: [
                              DataCell(Text(mahasiswa['nim']!)),
                              DataCell(Text(mahasiswa['nama']!)),
                              DataCell(Text(mahasiswa['kelas']!)),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      mahasiswaList.remove(mahasiswa);
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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
                  if (selectedMenu == 'Mahasiswa') {
                    showAddMahasiswaDialog(context);
                  }
                },
                child: Text('Tambah $selectedMenu',
                    style: const TextStyle(color: Colors.black)),
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
              label: 'Pengabdian\nMasyarakat',
            ),
          ],
        ),
      ),
    );
  }
}
