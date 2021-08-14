import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_class_canine_demo/UIComponents/UIComponents/TopSnackbar.dart';

class ConnectivityCheck{
  Future<bool> getConnectionState() async{
    ConnectivityResult state=await Connectivity().checkConnectivity();
    switch(state)
    {
      case ConnectivityResult.none:
        TopSnackBar.show();
        return false;
      case ConnectivityResult.mobile:
        return true;
      case ConnectivityResult.wifi:
        return true;
    }
  }
  checkNetwork(){
    getConnectionState();
  }
}