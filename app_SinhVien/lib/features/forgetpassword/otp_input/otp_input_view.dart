import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:frontend_flutter/features/forgetpassword/otp_input/otp_input_contract.dart';
import 'package:frontend_flutter/features/forgetpassword/otp_input/otp_input_presenter.dart';

import '../../../components/Button.dart';

// ignore: must_be_immutable
class OTPInput extends StatefulWidget {
  String otp;
  String email;
  OTPInput({super.key, required this.otp, required this.email});

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> implements OTPInputContract {
  String otp = "";
  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];
  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  String otpCheck = "";
  late OTPInputPresenter _presenter;
  _OTPInputState() {
    _presenter = OTPInputPresenter(this);
  }
  @override
  void initState() {
    otp = this.widget.otp;
    if (mounted) {
      setState(() {});
    }
    super.initState();
  }

  @override
  void setOTPCheck(String _otpCheck) {
    otpCheck = _otpCheck;
    setState(() {});
  }

  @override
  setOtp(String _otp) {
    otp = _otp;
    setState(() {});
  }

  @override
  void showSnackbar(String message) {
    print(message);
    _showSnackbar(message);
  }

  @override
  void setFocusNodes(int index) {
    FocusScope.of(context).requestFocus(focusNodes[index]);
    setState(() {});
  }

  @override
  void pushFillPassWordScreen() {
    Navigator.pushReplacementNamed(context, '/PassWordInput',
        arguments: [this.widget.email]);
    // Navigator.pop(context);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => PasswordInput(
    //         email: this.widget.email,
    //       ),
    //     ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return GestureDetector(
          onTap: () {
            // Đóng bàn phím khi nhấn bất kỳ đâu trên màn hình
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: [
              Container(
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nhập mã OTP:",
                                      style: TextStyle(
                                          fontFamily: 'Mitr',
                                          color:
                                              Color.fromARGB(255, 122, 97, 5),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  width: 220,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      4,
                                      (index) => Container(
                                        width: 50,
                                        height: 50,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/img/home/otpframe.png"),
                                                fit: BoxFit.fill)),
                                        child: TextField(
                                          cursorColor:
                                              Color.fromARGB(255, 173, 147, 2),
                                          style: TextStyle(
                                              fontFamily: 'Mitr',
                                              color: Color.fromARGB(
                                                  255, 173, 147, 2),
                                              fontWeight: FontWeight.w700),
                                          controller: controllers[index],
                                          focusNode: focusNodes[index],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            counterText: '',
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 173, 147, 2),
                                                  width: 2),
                                            ),
                                          ),
                                          onChanged: (value) =>
                                              _presenter.handleInput(
                                                  otp,
                                                  value,
                                                  index,
                                                  controllers),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      otpCheck != ""
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                otpCheck,
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
                                      ButtonCustom(
                                          onTap: () => _presenter.ReSendOtp(
                                              this.widget.email),
                                          child: Text(
                                            "Gửi lại mã",
                                            style: TextStyle(
                                                fontFamily: 'Mitr',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: Color.fromARGB(
                                                    255, 121, 91, 2)),
                                          ))
                                    ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ButtonCustom(
                                      onTap: () => _presenter.Redirect(
                                          otp, controllers),
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
                                            fontSize: 17,
                                            fontFamily: 'Mitr',
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
              Positioned(
                left: MediaQuery.of(context).size.width / 30,
                top: MediaQuery.of(context).size.height / 20,
                child: ButtonCustom(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/Login');
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
            ],
          ),
        );
      }),
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
