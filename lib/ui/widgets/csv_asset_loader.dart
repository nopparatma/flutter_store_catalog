
import 'dart:developer';
import 'dart:ui';

import 'package:csv/csv_settings_autodetection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class CsvAssetLoader extends AssetLoader {
  CSVParser csvParser;

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    if (csvParser == null) {
      log('easy localization loader: load csv file $path');
      var csvSettingsDetector = new FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);
      csvParser = CSVParser(await rootBundle.loadString(path), csvSettingsDetector: csvSettingsDetector);
    } else {
      log('easy localization loader: CSV parser already loaded, read cache');
    }
    return csvParser.getLanguageMap(locale.toString());
  }
}

class CSVParser {
  final String fieldDelimiter;
  final String strings;
  final List<List<dynamic>> lines;
  final CsvSettingsDetector csvSettingsDetector;

  CSVParser(this.strings, {this.fieldDelimiter = ',', this.csvSettingsDetector})
      : lines = CsvToListConverter()
      .convert(strings, fieldDelimiter: fieldDelimiter, csvSettingsDetector: csvSettingsDetector);

  List getLanguages() {
    return lines.first.sublist(1, lines.first.length);
  }

  Map<String, dynamic> getLanguageMap(String localeName) {
    final indexLocale = lines.first.indexOf(localeName);

    var translations = <String, dynamic>{};
    for (var i = 1; i < lines.length; i++) {
      translations.addAll({lines[i][0]: lines[i][indexLocale]});
    }
    return translations;
  }
}