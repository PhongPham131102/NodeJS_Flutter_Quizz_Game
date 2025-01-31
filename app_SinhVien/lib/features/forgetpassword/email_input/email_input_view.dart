import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:frontend_flutter/features/forgetpassword/email_input/email_input_contract.dart';
import 'package:frontend_flutter/features/forgetpassword/email_input/email_input_presenter.dart';

import '../../../components/Button.dart';
import '../../../components/RobotLoading.dart';

class EmailImputView extends StatefulWidget {
  const EmailImputView({super.key});

  @override
  State<EmailImputView> createState() => _EmailImputViewState();
}

class _EmailImputViewState extends State<EmailImputView>
    implements EmailInputContract {
  late EmailInputPresenter _presenter;
  _EmailImputViewState() {
    _presenter = new EmailInputPresenter(this);
  }
  bool isloading = false;
  TextEditingController emailController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  String emailCheck = "";

  @override
  void setEmailCheck(String message) {
    emailCheck = message;
    setState(() {});
  }

  @override
  void setisLoading(bool _isLoading) {
    isloading = _isLoading;
    setState(() {});
  }

  @override
  void showSnackbar(String message) {
    print(message);
    _showSnackbar(message);
  }

  @override
  void pushOTPInputScreen(String otp) {
    Navigator.pushReplacementNamed(context, '/OtpInput',
        arguments: [otp, emailController.text]);
    // Navigator.pop(context);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => OTPInput(
    //         otp: otp,
    //         email: emailController.text,
    //       ),
    //     ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Stack(
            children: [
              IgnorePointer(
                ignoring: isloading,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/img/home/bg.png",
                          ),
                          fit: BoxFit.fill)),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 80),
                          width: 230,
                          height: 90,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/img/home/logo.gif"),
                                  fit: BoxFit.fill)),
                        ),
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: 40,
                              ),
                              padding: EdgeInsets.only(left: 50, right: 50),
                              width: 320,
                              height: 300,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/img/home/frame.png"),
                                    fit: BoxFit.fill),
                              ),
                              child: Form(
                                key: formGlobalKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nhập email:",
                                          style: TextStyle(
                                              fontFamily: 'Mitr',
                                              color: Color.fromARGB(
                                                  255, 122, 97, 5),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding: EdgeInsets.only(
                                          bottom: 8, left: 12, right: 20),
                                      width: 220,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                'assets/img/home/textbutton2.png',
                                              ),
                                              fit: BoxFit.fill)),
                                      child: TextFormField(
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        controller: emailController,
                                        style: TextStyle(
                                            fontFamily: 'Mitr',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromARGB(
                                                255, 154, 122, 6)),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email",
                                          hintStyle: TextStyle(
                                            fontFamily: 'Mitr',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color.fromARGB(
                                                255, 154, 122, 6),
                                          ),
                                        ),
                                        validator: (value) {
                                          _presenter.checkvalidEmail(value!);
                                          return null;
                                        },
                                      ),
                                    ),
                                    emailCheck != ""
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              emailCheck,
                                              style: TextStyle(
                                                  fontFamily: 'Mitr',
                                                  color: Colors.red,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : Container(
                                            width: 0,
                                            height: 0,
                                          ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ButtonCustom(
                                          onTap: () {
                                            if (formGlobalKey.currentState!
                                                .validate()) {
                                              _presenter.checkEmail(emailCheck,
                                                  emailController.text);
                                            }
                                          },
                                          child: Container(
                                            width: 140,
                                            height: 45,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/img/home/button.png"),
                                                  fit: BoxFit.fill),
                                            ),
                                            child: Text(
                                              "Tiếp theo",
                                              style: TextStyle(
                                                fontFamily: 'Mitr',
                                                fontSize: 17,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              right: 10,
                              child: Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height / 8,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/img/home/forgetpassword.gif"),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: isKeyboardVisible ? 220 : 0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width/30,
                top: MediaQuery.of(context).size.height/20,
                child: ButtonCustom(
                  onTap: () {
                   Navigator.pushReplacementNamed(
                                  context, '/Login');
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/img/store/return.png"),
                            fit: BoxFit.fill)),
                  ),
                ),
              ),
              isloading
                  ? Positioned(
                      child: ButtonCustom(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: RobotLoading(),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          );
        },
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Mitr',
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
