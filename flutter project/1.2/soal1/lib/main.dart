void main() {
  List<List<int>> arr = [];

  List<int> row1 = List.generate(4, (i) => (i + 1) * 6);
  arr.add(row1);

  List<int> row2 = List.generate(5, (i) => 3 + (i * 2));
  arr.add(row2);

  List<int> row3 = List.generate(6, (i) => (i + 4) * (i + 4) * (i + 4));
  arr.add(row3);

  List<int> row4 = List.generate(7, (i) => 3 + (i * 7));
  arr.add(row4);

  print("Isi List:");
  for (var row in arr) {
    print(row.join(" "));
  }
}
