import 'package:assistant_app/app/api/api.dart';
import 'package:assistant_app/app/api/local_data.dart';
import 'package:assistant_app/app/screens/navigator/main_navigator.dart';
import 'package:assistant_app/app/widgets/buttons/custom_button.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class VerifyCodePage extends StatelessWidget {
  final String email;
  final String pass;
  final String name;
  final String pin;

  const VerifyCodePage(
      {super.key,
      required this.email,
      required this.name,
      required this.pass,
      required this.pin});

  @override
  Widget build(BuildContext context) {
    TextEditingController pinput = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
      ),
      backgroundColor: AppColors.kPrimaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 140,
            ),
            const Text(
              'Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Text(
                'Please enter verification code , we send to your phone number $email',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Pinput(
                onCompleted: (String? value) async {
                  if (value.toString() == pin) {
                    String userId = await ApiClient().createData('users', {
                      'name': name,
                      'phone': email,
                      'pass': pass,
                      'image': ''
                    });
                    if (userId.toString() != 'null') {
                      await SecureStorage().addData('userId', userId);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => CustomNavigationBar()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      const snackBar = SnackBar(
                        content: Text('Try again!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } else {
                    const snackBar = SnackBar(
                      content: Text('Incorrect pin code!'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                autofocus: false,
                length: 5,
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsUserConsentApi,
                controller: pinput,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(text: 'Continue')

            // Center(
            //   child: TextButton(
            //       onPressed: () {},
            //       child: Text(
            //         'Resend code',
            //         style: TextStyle(color: AppColors.kPrimaryGreen),
            //       )),
            // )
          ],
        ),
      ),
    );
  }
}
