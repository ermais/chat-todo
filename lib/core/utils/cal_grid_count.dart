int calCrossAxisCount(int length) {
  if (length == 1) return 1;
  if (length == 2 || length == 4 || length == 3) return 2;
  if (length >= 5) return 3;
  return 3;
}
