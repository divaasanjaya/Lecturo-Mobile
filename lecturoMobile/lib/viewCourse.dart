import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCourse extends StatefulWidget {
  final String kodeMatkul;
  final String kodeKelas;
  final String kodeDosen;

  ViewCourse({
    required this.kodeMatkul,
    required this.kodeKelas,
    required this.kodeDosen,
  });

  @override
  _ViewCourseState createState() => _ViewCourseState();
}

class _ViewCourseState extends State<ViewCourse> {
  List<dynamic> quizzes = [];
  String namaDosen = '';
  String namaCourse = '';
  int sks = 0;
  String errorMessage = '';
  String kodeDosenKoor = '';
  String namaDosenKoor = '';
  String kontak = '';
  String email = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  late TapGestureRecognizer _tapRecognizer;

  @override
  void initState() {
    super.initState();
    getQuiz();
    fetchKodeCourse();
    fetchKodeDosen();
    fetchDosenKoor();
    _tapRecognizer =
        TapGestureRecognizer()
          ..onTap = () {
            _showDosenDialog(
              context,
              kodeDosenKoor: kodeDosenKoor,
              namaDosenKoor: namaDosenKoor,
              email: email,
              kontak: kontak,
              namaCourse: namaCourse,
              kodeMatkul: widget.kodeMatkul,
            );
          };
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  void getQuiz() async {
    var url = Uri.parse('http://10.0.2.2/lecturo/getInfoQuiz.php');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'kodeMatkul': widget.kodeMatkul,
        'kodeKelas': widget.kodeKelas,
      }),
    );

    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);
        setState(() {
          quizzes = data['quiz'] ?? [];
        });
      } catch (e) {
        print("Error parsing response: $e");
      }
    } else {
      print("Failed to load quizzes");
    }
  }

  void addQuiz(BuildContext context) async {
    var url = Uri.parse('http://10.0.2.2/lecturo/addQuiz.php');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'nama': nameController.text,
        'deskripsi': deskripsiController.text,
        'kodeMatkul': widget.kodeMatkul,
        'kodeKelas': widget.kodeKelas,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      nameController.clear();
      deskripsiController.clear();
      getQuiz();
    } else {
      print("Failed to add quiz");
    }
  }

  void deleteQuiz(String nama) async {
    var url = Uri.parse('http://10.0.2.2/lecturo/delQuiz.php');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'nama': nama,
        'kodeMatkul': widget.kodeMatkul,
        'kodeKelas': widget.kodeKelas,
      }),
    );

    if (response.statusCode == 200) {
      getQuiz();
    } else {
      print("Failed to delete quiz");
    }
  }

  Future<void> fetchDosenKoor() async {
    try {
      var url = Uri.parse('http://10.0.2.2/lecturo/getDosenKoor.php');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'kode': widget.kodeMatkul}),
      );

      var data = json.decode(response.body);
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("dosenkoor", jsonEncode(data["dosenkoor"]));

        setState(() {
          kodeDosenKoor = data["dosenkoor"]["kodeDosen"];
          kontak = data["dosenkoor"]["kontakKoor"];
          email = data["dosenkoor"]["email"];
        });
        fetchKodeDosen2();
      } else {
        setState(() {
          errorMessage = data["message"];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching coordinator data";
      });
    }
  }

  Future<void> fetchKodeDosen2() async {
    try {
      var url = Uri.parse('http://10.0.2.2/lecturo/getDosen.php');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'kode': kodeDosenKoor}),
      );

      var data = json.decode(response.body);
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("dosen", jsonEncode(data["dosen"]));

        setState(() {
          namaDosenKoor = data["dosen"]["nama"];
          kodeDosenKoor = data["dosen"]["kode"];
        });
      } else {
        setState(() {
          errorMessage = data["message"];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching coordinator details";
      });
    }
  }

  Future<void> fetchKodeDosen() async {
    try {
      var url = Uri.parse('http://10.0.2.2/lecturo/getDosen.php');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'kode': widget.kodeDosen}),
      );

      var data = json.decode(response.body);
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("dosen", jsonEncode(data["dosen"]));

        setState(() {
          namaDosen = data["dosen"]["nama"];
        });
      } else {
        setState(() {
          errorMessage = data["message"];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching lecturer data";
      });
    }
  }

  Future<void> fetchKodeCourse() async {
    try {
      var url = Uri.parse('http://10.0.2.2/lecturo/getCourse2.php');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "kodeMatkul": widget.kodeMatkul,
          "kodeDosen": widget.kodeDosen,
          "kodeKelas": widget.kodeKelas,
        }),
      );

      var data = json.decode(response.body);
      if (data["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("course", jsonEncode(data["course"]));

        setState(() {
          namaCourse = data["course"]["nama"];
          sks = data["course"]["sks"];
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

  void _showCreateQuizDialog() {
    nameController.clear();
    deskripsiController.clear();

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
                            const Text(
                              "Create Quiz",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004643),
                              ),
                            ),
                            const SizedBox(height: 13),
                            _buildTextField(
                              "Nama Quiz",
                              "Masukkan nama quiz",
                              nameController,
                            ),
                            _buildTextField(
                              "Deskripsi",
                              "Masukkan deskripsi quiz",
                              deskripsiController,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => addQuiz(context),
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
                                  "Tambah",
                                  style: TextStyle(
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

  void _showDosenDialog(
    BuildContext context, {
    String? kodeDosenKoor,
    String? namaDosenKoor,
    String? email,
    String? kontak,
    String? namaCourse,
    String? kodeMatkul,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Informasi Dosen Koordinator',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(thickness: 2),
              SizedBox(height: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kode: $kodeDosenKoor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama: $namaDosenKoor',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Email: $email'),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Nomor Telepon: $kontak'),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Koordinator Mata Kuliah: $namaCourse [$kodeMatkul]',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004643),
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Color(0xFFF9BC60),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuButton(String label, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
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
      backgroundColor: const Color(0xFF004643),
      appBar: AppBar(
        backgroundColor: const Color(0xFF004643),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                    _buildMenuButton("Activity", null),
                    const SizedBox(width: 12),
                    _buildMenuButton("Mahasiswa", () {
                      // Navigation to Mahasiswa view would go here
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Info Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaCourse,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            widget.kodeMatkul,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Kelas: ${widget.kodeKelas}",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text("SKS: $sks", style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 16),
                          Text(
                            "Dosen Pengampu: $namaDosen [${widget.kodeDosen}]",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(text: 'Dosen Koordinator: '),
                                TextSpan(
                                  text: '$namaDosenKoor [$kodeDosenKoor]',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: _tapRecognizer,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Create Quiz Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9BC60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _showCreateQuizDialog,
                      child: const Text(
                        'Create Quiz',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004643),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Quiz List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = quizzes[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigation to quiz details would go here
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFABD1C6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.assignment,
                                          color: Color(0xFF004643),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          quiz['nama'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.black54,
                                      thickness: 1,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Deskripsi: ${quiz['deskripsi'] ?? ''}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                          onPressed:
                                              () => deleteQuiz(quiz['nama']),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
