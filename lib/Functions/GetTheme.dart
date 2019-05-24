import 'package:mobile_app/Themes/MainTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetTheme {
  initialTheme() async {
    var storage = await SharedPreferences.getInstance();
    var mode = await storage.get('theme_mode') ?? false;
    if (mode) {
      return AppTheme().darkMode();
    } else {
      return AppTheme().lightMode();
    }
  }
}
