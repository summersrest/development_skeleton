import 'dart:ui';
import 'package:get/get.dart';

class Translator {
  static final List<Translation> _translations = [];

  Translator._();

  factory Translator.init() {
    Translator translator = Translator._();
    Get.put(translator, permanent: true);
    return translator;
  }

  Locale? get locale => Get.locale;

  set locale(Locale? newLocale) => Get.locale = newLocale;

  Future<void> updateLocale(Locale l) async {
    locale = l;
    await Get.forceAppUpdate();
  }

  List<Translation> get translations => _translations;

  void addTranslations(List<Translation>? tr) {
    if (tr != null) {
      translations.addAll(tr);
    }
  }

  void clearTranslations() {
    translations.clear();
  }

  Translation translation() {
    if (translations.isEmpty) {
      throw 'No translations found,Please add translations when startApp';
    }
    if (locale?.languageCode == null) {
      throw 'Locale is not set,Please set locale when startApp';
    }
    Translation? translation = translations.firstWhereOrNull((element) {
      return element.languageCode.toLowerCase() == locale!.languageCode.toLowerCase() &&
          element.countryCode.toLowerCase() == (locale!.countryCode ?? '').toLowerCase();
    }) ?? translations.first;
    return translation;
  }

  static Translator of() => Get.find();
}


abstract class Translation {
  /// The language code of the translation.
  final String languageCode;

  /// The country code of the translation.
  final String countryCode;

  Translation({
    required this.languageCode,
    required this.countryCode,
  });
}
