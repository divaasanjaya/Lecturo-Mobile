import 'dart:convert';
import 'package:flutter/material.dart';
import 'viewCourse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp_viewNilai(kodeMatkul: '', kodeKelas: '', nama: ''));
}

class MyApp_viewNilai extends StatelessWidget {
  final String kodeMatkul;
  final String kodeKelas;
  final String nama;
  const MyApp_viewNilai({
    Key? key,
    required this.kodeMatkul,
    required this.kodeKelas,
    required this.nama,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecturo',
      theme: ThemeData(
        fontFamily: 'Outfit',
        scaffoldBackgroundColor: const Color(0xFF004643),
      ),
      home: NilaiPage(kodeMatkul: kodeMatkul, kodeKelas: kodeKelas, nama: nama),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NilaiPage extends StatefulWidget {
  const NilaiPage({
    Key? key,
    required this.kodeMatkul,
    required this.kodeKelas,
    required this.nama,
  }) : super(key: key);
  final String kodeMatkul;
  final String kodeKelas;
  final String nama;

  @override
  State<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends State<NilaiPage> {
  List<Map<String, dynamic>> mquiz = [];
  String? nama;
  String? errorMessage;
  String kodePengampu = '';

  @override
  void initState() {
    super.initState();
    fetchKodeCourse();
    fetchNilai();
  }

  Future<void> fetchNilai() async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/quiz/nilai"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"nama": widget.nama, "kodeKelas": widget.kodeKelas}),
      );

      final data = jsonDecode(response.body);
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("mquiz", jsonEncode(data["mquiz"]));

        if (!mounted) return;
        setState(() {
          mquiz = List<Map<String, dynamic>>.from(data["mquiz"]);
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
      print("Nilai error: $e");
    }
  }

  Future<void> updelNilai(int nim, int nilai) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/quiz/editnilai"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "nim": nim.toString(),
          "namaQuiz": widget.nama,
          "kodeKelas": widget.kodeKelas,
          "nilai": nilai,
        }),
      );
      print(response.body);
    } catch (e) {
      if (!mounted) return;
      print("error: $e");
    }
  }

  Future<void> fetchKodeCourse() async {
    try {
      var url = Uri.parse("http://10.0.2.2:8000/api/course2");
      ;
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "kodeMatkul": widget.kodeMatkul,
          "kodeKelas": widget.kodeKelas,
        }),
      );

      var data = json.decode(response.body);
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("course", jsonEncode(data["course"]));

        setState(() {
          kodePengampu = data["course"]["dosenPengampu"];
        });
      } else {
        setState(() {
          errorMessage = data["message"];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching course data";
      });
    }
  }

  List<Map<String, dynamic>> get nilaiList => mquiz;

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
                builder:
                    (context) => ViewCourse(
                      kodeDosen: kodePengampu,
                      kodeMatkul: widget.kodeMatkul,
                      kodeKelas: widget.kodeKelas,
                    ),
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
            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.nama,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ), // jarak dari kiri-kanan layar
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
                            flex: 1,
                            child: Text(
                              'Nilai',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(),
                          ), // untuk ikon delete
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(nilai['nim'].toString()),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(nilai['namaMahasiswa'] ?? ''),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(nilai['nilai'].toString()),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Color(0xFF004643),
                                      ),
                                      onPressed: () {
                                        _showEditDialog(context, nilai);
                                      },
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> nilai) {
    final TextEditingController nimController = TextEditingController(
      text: nilai['nim'].toString(),
    );
    final TextEditingController namaController = TextEditingController(
      text: nilai['namaMahasiswa'],
    );
    final TextEditingController nilaiController = TextEditingController(
      text: nilai['nilai'].toString(),
    );

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
                      onPressed: () async {
                        await updelNilai(
                          nilai['nim'],
                          int.parse(nilaiController.text),
                        );
                        await fetchNilai();
                        setState(() {});
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

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> nilai) {
    final nim = nilai['nim'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: Text(
            'Apakah kamu yakin ingin menghapus data untuk NIM: $nim?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await updelNilai(nilai['nim'], 0);
                await fetchNilai();
                setState(() {});
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
