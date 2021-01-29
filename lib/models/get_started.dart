import 'package:connectivity/connectivity.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

Future<dynamic> getConnection() async {
  try {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  } catch (e) {
    print(e);
  }
}

void startAds() async {
  try {
    FacebookAudienceNetwork.init(
      testingId: "",
    );
  } catch (e) {
    print('Error Start: $e');
  }
}
