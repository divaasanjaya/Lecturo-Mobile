import 'package:flutter/material.dart';
import 'viewCourse.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp_course(kodePengampu: ''));
}

class MyApp_course extends StatelessWidget {
  final String kodePengampu;
  const MyApp_course({Key? key, required this.kodePengampu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecturo Mata Kuliah',
      theme: ThemeData(fontFamily: 'Outfit'),
      home: MyHomePage(
        title: 'Lecturo Mata Kuliah',
        kodePengampu: kodePengampu,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.kodePengampu})
    : super(key: key);
  final String title;
  final String kodePengampu;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> course = [];
  final Dio _dio = Dio();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchKodeCourse();
  }

  Future<void> fetchKodeCourse() async {
    try {
      final response = await _dio.post(
        "http://10.0.2.2/lecturo/getCourse.php",
        data: {"kode": widget.kodePengampu},
      );

      final data = response.data;
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("course", jsonEncode(data["course"]));

        if (!mounted) return;
        setState(() {
          course = List<Map<String, dynamic>>.from(data["course"]);
        });
      } else {
        if (!mounted) return;
        setState(() {
          errorMessage = data["message"];
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Kode atau password Anda salah!";
      });
    }
  }

  List<Map<String, dynamic>> get data => course;

  final kodeInput = TextEditingController();
  final namaInput = TextEditingController();
  final kelasInput = TextEditingController();
  final sksInput = TextEditingController();
  final doskorInput = TextEditingController();

  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSearching) {
          setState(() {
            isSearching = false;
            searchController.clear();
          });
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          if (isSearching) {
            setState(() {
              isSearching = false;
              searchController.clear();
            });
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: const Color(0xFF004643),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    // Jika sedang mencari, tampilkan search bar
                    isSearching
                        ? Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    autofocus: true,
                                    style: const TextStyle(fontSize: 14),
                                    decoration: const InputDecoration(
                                      hintText: "Cari course...",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.mic,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    // aksi mic
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                        : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9BC60),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF2A2A2A),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "Daftar Course",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF004643),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 85,
                            ), // jarak tambahan antara tulisan dan icon search
                          ],
                        ),

                    // Ikon search dengan dekorasi
                    if (!isSearching)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSearching = true;
                          });
                        },
                        child: Container(
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
                          child: const Icon(
                            Icons.search,
                            color: Color(0xFF004643),
                          ),
                        ),
                      ),

                    const SizedBox(width: 10),

                    // Tombol tambah tetap di paling kanan
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
                          onTap: _showTambahDialog,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ), // Jarak kanan-kiri
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final research = data[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.only(bottom: 20),
                        color: Color(0xFFABD1C6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                research["kodeMatkul"] ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Warna teks lebih jelas
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                research["nama"] ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Warna teks lebih jelas
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                research["kodeKelas"] ?? "",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF3C4945),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "SKS: ${research["sks"] ?? ""}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF3C4945),
                                ),
                              ),
                              SizedBox(height: 4),

                              // Tombol & Ikon
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(
                                        0xFF004643,
                                      ), // Warna hijau tua
                                      foregroundColor: Color(
                                        0xFFABD1C6,
                                      ), // Warna teks
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 6,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ViewCourse(
                                                kodeDosen: widget.kodePengampu,
                                                kodeMatkul:
                                                    research["kodeMatkul"],
                                                kodeKelas:
                                                    research["kodeKelas"],
                                              ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "View Course",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  // Ikon Edit & Delete
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 53,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Color(0xFF004643),
                                            size: 25,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          onPressed: () {
                                            _showTambahDialog(
                                              initialData: data[index],
                                              index: index,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Color(0xFF004643),
                                            size: 25,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          onPressed: () {
                                            // Aksi hapus
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTambahDialog({Map<String, dynamic>? initialData, int? index}) {
    // Reset atau isi form tergantung mode
    if (initialData != null) {
      // Mode edit
      namaInput.text = initialData['title'] ?? '';
      kelasInput.text = initialData['kelas'] ?? '';
      sksInput.text = initialData['sks'] ?? '';
    } else {
      // Mode tambah - kosongkan semua input
      kodeInput.clear();
      namaInput.clear();
      kelasInput.clear();
      sksInput.clear();
      doskorInput.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      // Optional biar container-nya ketengah
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFABD1C6),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF2A2A2A),
                              offset: Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              initialData != null
                                  ? "Edit Course"
                                  : "Create Course",
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004643),
                              ),
                            ),
                            const SizedBox(height: 13),
                            if (initialData == null)
                              _buildTextField(
                                "Kode Mata Kuliah",
                                "isi kode mata kuliah",
                                kodeInput,
                              ),

                            _buildTextField(
                              "Nama Mata Kuliah",
                              "isi nama mata kuliah",
                              namaInput,
                            ),
                            _buildTextField("Kelas ", "isi  kelas", kelasInput),
                            _buildTextField("SKS", "isi sks", sksInput),
                            if (initialData == null)
                              _buildTextField(
                                "Kode Dosen Koordinator ",
                                "isi kode dosen koordinator",
                                doskorInput,
                              ),

                            const SizedBox(height: 12),
                            const Text(
                              "Dosen : Diva Sanjaya [DSW]",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF000000),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (initialData != null && index != null) {
                                      // Edit data (tanpa deskripsi dan URL)
                                      data[index] = {
                                        'kode':
                                            data[index]['kode'], // pertahankan
                                        'title': namaInput.text,
                                        'kelas': kelasInput.text,
                                        'sks': sksInput.text,
                                        'doskor':
                                            data[index]['doskor'], // pertahankan
                                      };
                                    } else {
                                      data.add({
                                        'kode': kodeInput.text,
                                        'title': namaInput.text,
                                        'kelas': kelasInput.text,
                                        'sks': sksInput.text,
                                        'kordos': doskorInput.text,
                                      });
                                    }
                                    kodeInput.clear();
                                    namaInput.clear();
                                    kelasInput.clear();
                                    sksInput.clear();
                                    doskorInput.clear();
                                  });
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF9BC60),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  elevation: 6,
                                  shadowColor: Color(0xFFA9A9A9),
                                ),
                                child: Text(
                                  initialData != null ? "Edit" : "Tambah",
                                  style: const TextStyle(
                                    fontSize: 22,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF000000),
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
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 13),
      ],
    );
  }

  BoxDecoration _boxShadowDecoration() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color(0xFFA9A9A9),
          blurRadius: 8,
          offset: const Offset(3, 3),
        ),
      ],
    );
  }
}
