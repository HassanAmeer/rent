import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rent/services/toast.dart';

/// 🔹 Internet connection check karega
/// Agar net nahi hoga to false return karega
Future<bool> checkInternet() async {
  var result = await Connectivity().checkConnectivity();
  if (result.contains(ConnectivityResult.wifi) ||
      result.contains(ConnectivityResult.ethernet) ||
      result.contains(ConnectivityResult.mobile)) {
    // print("have internet");
    return true;
  } else {
    // print("No internet");
    toast("Check Internet Connection");
    return false;
  }
}
