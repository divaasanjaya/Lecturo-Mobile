import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Outfit'),
      home: ReadPenlitianScreen(),
    );
  }
}

class ReadPenlitianScreen extends StatelessWidget {
  final List<Map<String, String>> researchList = [
    {
      "title": "Klasifikasi Wine menggunakan K-Nearest Neighbors",
      "category": "Artificial Intelligence",
      "date": "7 Maret 2025"
    },
    {
      "title": "Klasifikasi Wine menggunakan K-Nearest Neighbors",
      "category": "Artificial Intelligence",
      "date": "7 Maret 2025"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004643),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Tinggi AppBar
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Judul dengan Background
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9BC60), 
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Daftar Penelitian",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004643),
                    ),
                  ),
                ),

                // Icon Button (dengan ukuran setara dengan Container Daftar Penelitian)
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF9BC60),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Color(0xFF004643)),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: researchList.length,
          itemBuilder: (context, index) {
            final research = researchList[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Sudut membulat
              ),
              margin: EdgeInsets.only(bottom: 20),
              color: Color(0xFFABD1C6), // Warna Card
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul
                    Text(
                      research["title"]!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Warna teks lebih jelas
                      ),
                    ),
                    SizedBox(height: 4),

                    // Kategori
                    Text(
                      research["category"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87, // Kontras lebih baik
                      ),
                    ),
                    SizedBox(height: 4),

                    // Tanggal
                    Text(
                      "Tanggal: ${research["date"]!}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF3C4945),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Tombol & Ikon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tombol View Penelitian dengan ElevatedButton
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF004643), // Warna hijau tua
                            foregroundColor: Color(0xFFABD1C6), // Warna teks
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 6),
                          ),
                          onPressed: () {},
                          child: Text(
                            "View Penelitian",
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
                              width: 53, // Atur ukuran sesuai kebutuhan
                              child: IconButton(
                                icon: Icon(Icons.edit, color: Color(0xFF004643), size: 25),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              width: 30, // Atur ukuran sesuai kebutuhan
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Color(0xFF004643), size: 25),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),


                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: Container(
        height: 111,
        decoration: const BoxDecoration(
          color: Color(0xFFF9BC60), // Warna navbar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Homepage'),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Mata Kuliah',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Penelitian',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Pengabdian Masyarakat',
            ),
          ],
          currentIndex: 2,
          selectedItemColor: Colors.white,
          unselectedItemColor: Color(0xFF004643),
          backgroundColor: Colors.transparent,
          showUnselectedLabels: true, // Menampilkan semua label
          type: BottomNavigationBarType.fixed,
          elevation: 0, // Menghapus shadow pada navbar
        ),
      ),
    );
  }
}
