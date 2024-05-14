import 'package:assistant_app/app/api/api.dart';
import 'package:assistant_app/app/api/local_data.dart';
import 'package:assistant_app/app/screens/navigator/main_navigator.dart';
import 'package:assistant_app/app/screens/sign/sign_screen.dart';
import 'package:assistant_app/app/widgets/buttons/custom_button.dart';
import 'package:assistant_app/app/widgets/textfields/custom_phone_textfield.dart';
import 'package:assistant_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPass = true;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding:
              const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/login.png", width: double.infinity),
              SizedBox(
                height: 35,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/kz-flag.png',
                          width: 24,
                        ),
                        Text(
                          '+7',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 3),
                  Flexible(
                    child: TextFieldInput(
                      hintText: 'Номер телефона',
                      textInputType: TextInputType.phone,
                      textEditingController: email,
                      isPhoneInput: true,
                      autoFocus: true,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                  hintText: 'Password',
                  controller: pass,
                  isPassword: true,
                  passwordShow: showPass,
                  onTapIcon: () {
                    if (showPass) {
                      showPass = false;
                    } else {
                      showPass = true;
                    }
                    setState(() {});
                  }),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 15),
                child: CustomButton(
                  function: () async {
                    var userId =
                        await ApiClient().loginUser(email.text, pass.text);
                    if (userId.toString() != 'null') {
                      await SecureStorage()
                          .addData('userId', userId.toString());
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => CustomNavigationBar()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      const snackBar = SnackBar(
                        content: Text('Incorrect login or password!'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  text: "Login",
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignScreen()),
                  );
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Dont have a account?',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontFamily: 'Rubik',
                        fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Register',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ));
  }
}
