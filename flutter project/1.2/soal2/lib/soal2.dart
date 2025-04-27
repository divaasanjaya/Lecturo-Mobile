import 'dart:io';

int hitungFPB(int a, int b) {
  while (b != 0) {
    int temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}

void main() {
  stdout.write("Bilangan pertama: ");
  int? bil1 = int.tryParse(stdin.readLineSync() ?? '');
  stdout.write("Bilangan kedua: ");
  int? bil2 = int.tryParse(stdin.readLineSync() ?? '');

  // Pastikan input tidak null sebelum dihitung
  if (bil1 != null && bil2 != null) {
    int fpb = hitungFPB(bil1, bil2);
    print("FPB dari $bil1 dan $bil2 adalah $fpb");
  } else {
    print("Input tidak valid! Harap masukkan angka.");
  }
}
