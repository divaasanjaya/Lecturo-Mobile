import 'package:flutter/material.dart';
import 'viewAbdimas.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp_abdimas(kodeDosen: ''));
}

class MyApp_abdimas extends StatelessWidget {
  final String kodeDosen;
  const MyApp_abdimas({Key? key, required this.kodeDosen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecturo Abdimas',
      theme: ThemeData(fontFamily: 'Outfit'),
      home: MyHomePage(title: 'Lecturo Abdimas', kodeDosen: kodeDosen),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.kodeDosen})
    : super(key: key);
  final String title;
  final String kodeDosen;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> abdimas = [];
  String? errorMessage;
  String? menu;
  int? kodeAbdimas;

  @override
  void initState() {
    super.initState();
    fetchKodeAbdimas();
  }

  Future<void> delAbdimas() async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/abdimas/delete"),
        body: {
          "kodeDosen": widget.kodeDosen,
          "kodeAbdimas": kodeAbdimas.toString(),
        },
      );
      print(response.body);
    } catch (e) {
      if (!mounted) return;
      print('Error connecting to Laravel backend: $e');
    }
  }

  Future<void> updateAbdimas() async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/abdimas/save"),
        body: {
          "kodeDosen": widget.kodeDosen,
          "menu": menu,
          "kode": kodeAbdimas?.toString() ?? '',
          "nama": judulInput.text,
          "deskripsi": deskripsiInput.text,
          "tanggal": tanggalInput.text,
        },
      );
      print(response.body);
    } catch (e) {
      if (!mounted) return;
      print('Error connecting to Laravel backend: $e');
    }
  }

  Future<void> fetchKodeAbdimas() async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/abdimas"),
        body: {"kode": widget.kodeDosen},
      );

      final data = jsonDecode(response.body);
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("abdimas", jsonEncode(data["abdimas"]));

        if (!mounted) return;
        setState(() {
          abdimas = List<Map<String, dynamic>>.from(data["abdimas"]);
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

  List<Map<String, dynamic>> get data => abdimas;

  final judulInput = TextEditingController();
  final deskripsiInput = TextEditingController();
  final tanggalInput = TextEditingController();

  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  final List<String> bulan = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

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
                                      hintText: "Cari abdimas...",
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
                                "Daftar Abdimas",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF004643),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 71,
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
                              // Judul
                              Text(
                                research["nama"] ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Warna teks lebih jelas
                                ),
                              ),
                              SizedBox(height: 4),
                              // Tanggal
                              Text(
                                "Tanggal: ${research["tanggal"] ?? ""}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF3C4945),
                                ),
                              ),
                              SizedBox(height: 8),

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
                                              (context) => MyApp_viewAbdimas(
                                                kodeDosen: widget.kodeDosen,
                                                kodeAbdimas: research["kode"],
                                              ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "View Abdimas",
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
                                              kodeAbdimas: research["kode"],
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Color(0xFF004643),
                                            size: 25,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          onPressed: () async {
                                            kodeAbdimas = research["kode"];
                                            await delAbdimas();
                                            await fetchKodeAbdimas();
                                            setState(() {});
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

  void _showTambahDialog({
    Map<String, dynamic>? initialData,
    int? kodeAbdimas,
  }) {
    this.kodeAbdimas = kodeAbdimas;
    // Reset atau isi form tergantung mode
    if (initialData != null) {
      // Mode edit
      judulInput.text = initialData['nama'] ?? '';
      deskripsiInput.text = initialData['deskripsi'] ?? '';
      tanggalInput.text = initialData['tanggal'] ?? '';
    } else {
      // Mode tambah - kosongkan semua input
      judulInput.clear();
      deskripsiInput.clear();
      tanggalInput.clear();
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
                                  ? "Edit Abdimas"
                                  : "Create Abdimas",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004643),
                              ),
                            ),
                            const SizedBox(height: 13),
                            _buildTextField(
                              "Nama Kegiatan",
                              "isi nama kegiatan pengabdian masyarakat",
                              judulInput,
                            ),
                            _buildTextField(
                              "Deskripsi",
                              "isi deskripsi kegiatan",
                              deskripsiInput,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Tanggal Pelaksanaan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF001E1D),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: _boxShadowDecoration(),
                              child: TextField(
                                controller: tanggalInput,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    final formattedDate =
                                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                    setState(() {
                                      tanggalInput.text = formattedDate;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "dd/mm/yyyy",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF001E1D),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (initialData != null && kodeAbdimas != 0) {
                                    menu = "upd";
                                    await updateAbdimas();
                                    await fetchKodeAbdimas();
                                    setState(() {});
                                  } else {
                                    menu = "add";
                                    kodeAbdimas = 0;
                                    await updateAbdimas();
                                    await fetchKodeAbdimas();
                                    setState(() {});
                                  }
                                  judulInput.clear();
                                  deskripsiInput.clear();
                                  tanggalInput.clear();

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
