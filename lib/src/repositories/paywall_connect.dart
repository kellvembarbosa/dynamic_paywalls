import 'package:get/get.dart';

class PaywallConnect extends GetConnect {
  Future<Map<String, dynamic>> getPaywallRemote(String url) async {
    final response = await get(url);
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return response.body;
    }
  }
}
