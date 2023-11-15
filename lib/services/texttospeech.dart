import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  late String ttsText;

  String? lang;
  TtsService({required this.ttsText, this.lang});

  Future<void> speak() async {
    String currentlang;

    if (lang == null) {
      currentlang = 'en-GB';
    } else {
      currentlang = lang!;
    }

    await _flutterTts.setLanguage(currentlang);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(ttsText);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}


/*  Quick referent to supported lanagues
important 
zh-CN - Chinese (Simplified) (China)
ta-IN - Tamil (India)
en-GB - English (United Kingdom)
ms-MY - Malay (Malaysia)
hi-IN - Hindi (India)

not important



ko-KR - Korean (South Korea)
mr-IN - Marathi (India)
ru-RU - Russian (Russia)
zh-TW - Chinese (Traditional) (Taiwan)
hu-HU - Hungarian (Hungary)
sw-KE - Swahili (Kenya)
th-TH - Thai (Thailand)
ur-PK - Urdu (Pakistan)
nb-NO - Norwegian Bokmål (Norway)
da-DK - Danish (Denmark)
tr-TR - Turkish (Turkey)
et-EE - Estonian (Estonia)
pt-PT - Portuguese (Portugal)
vi-VN - Vietnamese (Vietnam)
en-US - English (United States)
sq-AL - Albanian (Albania)
sv-SE - Swedish (Sweden)
ar - Arabic
su-ID - Sundanese (Indonesia)
bs-BA - Bosnian (Bosnia and Herzegovina)
bn-BD - Bengali (Bangladesh)
gu-IN - Gujarati (India)
kn-IN - Kannada (India)
el-GR - Greek (Greece)
hi-IN - Hindi (India)
fi-FI - Finnish (Finland)
km-KH - Khmer (Cambodia)
bn-IN - Bengali (India)
fr-FR - French (France)
uk-UA - Ukrainian (Ukraine)
pa-IN - Punjabi (India)
en-AU - English (Australia)
lv-LV - Latvian (Latvia)
nl-NL - Dutch (Netherlands)
fr-CA - French (Canada)
sr - Serbian
pt-BR - Portuguese (Brazil)
ml-IN - Malayalam (India)
si-LK - Sinhala (Sri Lanka)
de-DE - German (Germany)
cs-CZ - Czech (Czech Republic)
pl-PL - Polish (Poland)
sk-SK - Slovak (Slovakia)
fil-PH - Filipino (Philippines)
it-IT - Italian (Italy)
ne-NP - Nepali (Nepal)

hr - Croatian
en-NG - English (Nigeria)
nl-BE - Dutch (Belgium)

es-ES - Spanish (Spain)
cy - Welsh

ja-JP - Japanese (Japan)
bg-BG - Bulgarian (Bulgaria)
yue-HK - Cantonese (Hong Kong)
en-IN - English (India)
es-US - Spanish (United States)
jv-ID - Javanese (Indonesia)
id-ID - Indonesian (Indonesia)
te-IN - Telugu (India)
ro-RO - Romanian (Romania)
ca - Catalan


*/