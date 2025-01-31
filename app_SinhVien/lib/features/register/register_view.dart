import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/register/register_contract.dart';
import 'package:frontend_flutter/features/register/register_presenter.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../components/Button.dart';
import '../../components/DialogMessage.dart';
import '../../components/RobotLoading.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> implements RegisterContract {
  final formGlobalKey = GlobalKey<FormState>();
  bool isloading = false;
  ScrollController scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cFPasswordController = TextEditingController();
  String validateFullName = "";
  String validateEmail = "";
  String validatePassWord = "";
  String validateCfPassWord = "";
  bool passwordVisible = true;
  bool cFPasswordVisible = true;
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cFPasswordController.dispose();
    formGlobalKey.currentState?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  late RegisterPresenter presenter;
  _RegisterState() {
    presenter = new RegisterPresenter(this);
  }
  @override
  void register() async {
    if (formGlobalKey.currentState!.validate()) {
      if (validateFullName == "" &&
          validateEmail == "" &&
          validatePassWord == "" &&
          validateCfPassWord == "") {
        var name = nameController.text.trim();
        var email = emailController.text.trim();
        var password = passwordController.text.trim();
        presenter.register(name, email, password);
      }
    }
  }

  @override
  void setIsLoading(bool _isloading) {
    setState(() {
      isloading = _isloading;
    });
  }

  @override
  void setValidateEmail(String validate) {
    setState(() {
      validateEmail = validate;
    });
  }

  @override
  void pushLogin() {
    Navigator.pushReplacementNamed(context, '/Login');
    // Navigator.pop(context);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => Login(),
    //     ));
  }

  @override
  void pushInfor(message) {
    DialogMessage(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
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
                  child: Form(
                    key: formGlobalKey,
                    child: Column(
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
                              margin: EdgeInsets.only(top: 40),
                              padding: EdgeInsets.only(top: 70, bottom: 50),
                              constraints: BoxConstraints(
                                minWidth: 320,
                                minHeight: 400,
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/img/home/frame1.png"),
                                    fit: BoxFit.fill),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: 8, left: 12),
                                          width: 220,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    'assets/img/home/textbutton2.png',
                                                  ),
                                                  fit: BoxFit.fill)),
                                          child: TextFormField(
                                            controller: nameController,
                                            style: TextStyle(
                                                fontFamily: 'Mitr',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 154, 122, 6)),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Họ Tên",
                                              hintStyle: TextStyle(
                                                fontFamily: 'Mitr',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 154, 122, 6),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == "") {
                                                validateFullName =
                                                    "Bạn chưa nhập họ tên";
                                              } else if (value!.length > 30) {
                                                validateFullName =
                                                    "Họ tên quá dài( phải nhỏ hơn 30 ký tự)";
                                              } else {
                                                validateFullName = "";
                                              }

                                              setState(() {});
                                              return null;
                                            },
                                          ),
                                        ),
                                        validateFullName != ""
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  validateFullName,
                                                  style: TextStyle(
                                                      fontFamily: 'Mitr',
                                                      color: Colors.red,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
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
                                              if (value == "") {
                                                validateEmail =
                                                    "Bạn chưa nhập email";
                                              } else if (!RegExp(
                                                      r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b')
                                                  .hasMatch(value!)) {
                                                validateEmail =
                                                    "Email không hợp lệ";
                                              } else {
                                                validateEmail = "";
                                              }

                                              setState(() {});
                                              return null;
                                            },
                                          ),
                                        ),
                                        validateEmail != ""
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  validateEmail,
                                                  style: TextStyle(
                                                      fontFamily: 'Mitr',
                                                      color: Colors.red,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: 8, left: 12),
                                          width: 220,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    'assets/img/home/textbutton2.png',
                                                  ),
                                                  fit: BoxFit.fill)),
                                          child: TextFormField(
                                            controller: passwordController,
                                            obscureText: passwordVisible,
                                            style: TextStyle(
                                                fontFamily: 'Mitr',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 154, 122, 6)),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              suffixIcon: IconButton(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                icon: Icon(
                                                  passwordVisible
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    passwordVisible =
                                                        !passwordVisible;
                                                  });
                                                },
                                              ),
                                              hintText: "Mật Khẩu",
                                              hintStyle: TextStyle(
                                                fontFamily: 'Mitr',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 154, 122, 6),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == "") {
                                                validatePassWord =
                                                    "Bạn chưa nhập mật khẩu";
                                              } else if (value!.length < 8) {
                                                validatePassWord =
                                                    "Mật khẩu phải dài hơn 8 ký tự";
                                              } else {
                                                validatePassWord = "";
                                              }

                                              setState(() {});
                                              return null;
                                            },
                                          ),
                                        ),
                                        validatePassWord != ""
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  validatePassWord,
                                                  style: TextStyle(
                                                      fontFamily: 'Mitr',
                                                      color: Colors.red,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: 8, left: 12),
                                          width: 220,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    'assets/img/home/textbutton2.png',
                                                  ),
                                                  fit: BoxFit.fill)),
                                          child: TextFormField(
                                            controller: cFPasswordController,
                                            obscureText: cFPasswordVisible,
                                            style: TextStyle(
                                                fontFamily: 'Mitr',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 154, 122, 6)),
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                suffixIcon: IconButton(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  icon: Icon(
                                                    cFPasswordVisible
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      cFPasswordVisible =
                                                          !cFPasswordVisible;
                                                    });
                                                  },
                                                ),
                                                hintText:
                                                    "Nhập Lại Mật Khẩu",
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Mitr',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color.fromARGB(
                                                        255, 154, 122, 6))),
                                            validator: (value) {
                                              if (value !=
                                                  passwordController.text) {
                                                validateCfPassWord =
                                                    "Mật khẩu không khớp";
                                              } else {
                                                validateCfPassWord = "";
                                              }
                                              setState(() {});
                                              return null;
                                            },
                                          ),
                                        ),
                                        validateCfPassWord != ""
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  validateCfPassWord,
                                                  style: TextStyle(
                                                      fontFamily: 'Mitr',
                                                      color: Colors.red,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              ),
                                      ],
                                    ),
                                  ),
                                  ButtonCustom(
                                    onTap: () => register(),
                                    child: Container(
                                      width: 220,
                                      height: 65,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/img/home/button.png"),
                                            fit: BoxFit.fill),
                                      ),
                                      child: Text(
                                        "Đăng Ký",
                                        style: TextStyle(
                                          fontFamily: 'Mitr',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                          "assets/img/home/register.gif"),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Bạn đã có tài khoản ?",
                                style: TextStyle(
                                  fontFamily: 'Mitr',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/Login');
                                  // Navigator.pop(context);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => Login()));
                                },
                                child: Text(
                                  "Đăng Nhập Ngay!",
                                  style: TextStyle(
                                      fontFamily: 'Mitr',
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: isKeyboardVisible ? 220 : 0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),              Positioned(
                left: MediaQuery.of(context).size.width / 30,
                top: MediaQuery.of(context).size.height / 20,
                child: ButtonCustom(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/LoginRegister');
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
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: RobotLoading(),
                      ),
                    ),
                  )
                : Container()
          ],
        );
      }),
    );
  }
}
