import 'package:intl/intl.dart';

String localizeDate(String languageCode, DateTime date) {
  final locale = languageCode.toLowerCase();
  
  // Map of language codes to their date formats
  final dateFormats = {
    'cs': 'd. M. yyyy',     // Czech: 10. 12. 2025
    'sk': 'd. M. yyyy',     // Slovak: 10. 12. 2025
    'de': 'd.M.yyyy',       // German: 10.12.2025
    'fr': 'd/M/yyyy',       // French: 10/12/2025
    'es': 'd/M/yyyy',       // Spanish: 10/12/2025
    'it': 'd/M/yyyy',       // Italian: 10/12/2025
    'pl': 'd.M.yyyy',       // Polish: 10.12.2025
    'ru': 'd.M.yyyy',       // Russian: 10.12.2025
    'ja': 'yyyy/M/d',       // Japanese: 2025/12/10
    'ko': 'yyyy. M. d.',    // Korean: 2025. 12. 10.
    'zh': 'yyyy/M/d',       // Chinese: 2025/12/10
    'en': 'M/d/yyyy',       // English (US): 12/10/2025
  };
  
  // Use the specified format or fallback to US format if language not found
  final format = dateFormats[locale] ?? 'M/d/yyyy';
  
  return DateFormat(format, locale).format(date);
}
