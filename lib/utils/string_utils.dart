import 'package:diacritic/diacritic.dart';

String normalizeString(String input) {
  return removeDiacritics(input.toLowerCase());
}