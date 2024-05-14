import 'package:assistant_app/app/api/local_data.dart';
import 'package:assistant_app/app/screens/login/login_screen.dart';
import 'package:assistant_app/app/screens/navigator/main_navigator.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    bool isLogged = false;
    String userId = await SecureStorage().getData('userId') ?? '';
    if (userId != '') {
      isLogged = true;
    } else {
      isLogged = false;
    }

    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) =>
              (isLogged) ? CustomNavigationBar() : LoginScreen()),
      (Route<dynamic> route) => false,
    );
    // try {
    //   var res = await ApiClient.checkUpdate('api/v1/users/countries/');
    //   if (res == 17000) {
    //     showDialog(
    //       barrierDismissible: false,
    //       context: context,
    //       builder: (context) {
    //         return UpdateModal(
    //           withSkip: false,
    //         );
    //       },
    //     );
    //   } else if (res == 16000) {
    //     showDialog(
    //       barrierDismissible: false,
    //       context: context,
    //       builder: (context) {
    //         return UpdateModal(
    //           withSkip: true,
    //         );
    //       },
    //     );

    //   } else {
    //     Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //           builder: (context) =>
    //               (isLogged) ? CustomNavigationBar() : LoginScreen()),
    //       (Route<dynamic> route) => false,
    //     );
    //   }
    // } catch (e) {
    //   CustomSnackbar()
    //       .showCustomSnackbar(context, 'No internet connection...', false);
    //   Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             (isLogged) ? CustomNavigationBar() : LoginScreen()),
    //     (Route<dynamic> route) => false,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 220,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
