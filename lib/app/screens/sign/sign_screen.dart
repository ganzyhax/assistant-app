import 'package:assistant_app/app/api/api.dart';
import 'package:assistant_app/app/screens/login/login_screen.dart';
import 'package:assistant_app/app/screens/sign/components/verify_screen.dart';
import 'package:assistant_app/app/screens/sign/functions/function.dart';
import 'package:assistant_app/app/widgets/buttons/custom_button.dart';
import 'package:assistant_app/app/widgets/textfields/custom_phone_textfield.dart';
import 'package:assistant_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:assistant_app/const/app_colors.dart';
import 'package:flutter/material.dart';

class SignScreen extends StatefulWidget {
  SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  bool showPass = true;
  bool showrPass = true;
  bool isLoading = false;
  TextEditingController email = TextEditingController();

  TextEditingController name = TextEditingController();

  TextEditingController pass = TextEditingController();
  TextEditingController rpass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding:
              const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 40),
          child: Column(
            children: [
              Image.asset("assets/images/login.png", width: double.infinity),
              SizedBox(
                height: 20,
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
              Container(
                margin: const EdgeInsets.only(bottom: 0, top: 20),
                child: CustomTextField(
                  hintText: "Name",
                  controller: name,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 0, top: 20),
                child: CustomTextField(
                  hintText: "Password",
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
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 0, top: 20),
                child: CustomTextField(
                  hintText: "Repeat password",
                  controller: rpass,
                  isPassword: true,
                  passwordShow: showrPass,
                  onTapIcon: () {
                    if (showrPass) {
                      showrPass = false;
                    } else {
                      showrPass = true;
                    }
                    setState(() {});
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 0),
                child: CustomButton(
                  function: () async {
                    isLoading = true;
                    setState(() {});
                    if (name.text.length == 0 ||
                        email.text.length == 0 ||
                        pass.text.length == 0 ||
                        rpass == 0) {
                      const snackBar = SnackBar(
                        content: Text('Please,fill all the blank!'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      if (pass.text == rpass.text) {
                        bool isExistUser = await ApiClient()
                            .doesStringExistInCollection(email.text, 'users');
                        print(isExistUser);
                        if (isExistUser == true) {
                          const snackBar = SnackBar(
                            content: Text(
                                'This phone number is uses in another account!'),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          String phoneNumber = email.text
                              .replaceAll("-", "")
                              .replaceAll("(", "")
                              .replaceAll(")", "");

                          String pin =
                              SignFunctions().generateRandomPin().toString();
                          bool isSuccess = await SignFunctions()
                              .sendVerificationCode(
                                  phoneNumber: '7' + phoneNumber,
                                  generatedCode: pin);
                          if (isSuccess) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyCodePage(
                                      email: email.text,
                                      pass: pass.text,
                                      name: name.text,
                                      pin: pin)),
                            );
                          } else {
                            const snackBar = SnackBar(
                              content: Text('Server error!'),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      } else {
                        const snackBar = SnackBar(
                          content: Text('Passwords are not match!'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                    isLoading = false;
                    setState(() {});
                  },
                  isLoading: isLoading,
                  text: "Register",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Have a account?',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontFamily: 'Rubik',
                        fontSize: 14),
                    children: const <TextSpan>[
                      TextSpan(
                          text: ' Login',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'By registering you agree to ',
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontFamily: 'Rubik',
                      fontSize: 14),
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: ' and ',
                    ),
                    TextSpan(
                        text: 'Offer',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
