import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/pick_character/pick_character_contract.dart';
import 'package:frontend_flutter/features/pick_character/pick_character_presenter.dart';

import '../../components/Button.dart';
import '../../components/DialogMessage.dart';
import '../../components/RobotLoading.dart';

// ignore: must_be_immutable
class PickCharacterView extends StatefulWidget {
  String token;
  String uid;
  PickCharacterView({super.key, required this.token, required this.uid});

  @override
  State<PickCharacterView> createState() => _PickCharacterViewState();
}

class _PickCharacterViewState extends State<PickCharacterView>
    implements PickCharacterContract {
  late PickCharacterPresenter _presenter;
  _PickCharacterViewState() {
    _presenter = PickCharacterPresenter(this);
  }
  int selectedGender = 0;
  bool isloading = false;
  @override
  void setIsLoading(bool _isLoading) {
    isloading = _isLoading;
    setState(() {});
  }

  @override
  void setselectedGender(int _selectedGender) {
    selectedGender = _selectedGender;
    setState(() {});
  }

  @override
  void pushSetNameScreen() {
    Navigator.pushReplacementNamed(context, '/SetName',
        arguments: [this.widget.token, this.widget.uid]);
    // Navigator.pop(context);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) =>
    //           SetNameView(token: this.widget.token, uid: this.widget.uid),
    //     ));
  }

  @override
  void showDialog(String message) {
    DialogMessage(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                    padding: EdgeInsets.only(left: 50, right: 50, top: 30),
                    width: 320,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/img/home/frame.png"),
                          fit: BoxFit.fill),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ButtonCustom(
                              onTap: () => _presenter.PickMale(),
                              child: Container(
                                width: 100,
                                height: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: selectedGender == 0
                                            ? AssetImage(
                                                'assets/img/character/selectedframe.png')
                                            : AssetImage(
                                                'assets/img/character/unselectedframe.png'),
                                        fit: BoxFit.fill)),
                                child: Center(
                                    child: Image.asset(
                                  "assets/img/character/male.png",
                                  width: 75,
                                  height: 130,
                                  fit: BoxFit.fill,
                                )),
                              ),
                            ),
                            ButtonCustom(
                              onTap: () => _presenter.PickFemale(),
                              child: Container(
                                width: 100,
                                height: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: selectedGender == 1
                                            ? AssetImage(
                                                'assets/img/character/selectedframe.png')
                                            : AssetImage(
                                                'assets/img/character/unselectedframe.png'),
                                        fit: BoxFit.fill)),
                                child: Center(
                                    child: Image.asset(
                                  "assets/img/character/female.png",
                                  width: 75,
                                  height: 130,
                                  fit: BoxFit.fill,
                                )),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonCustom(
                              onTap: () => _presenter.SetCharacter(
                                  this.widget.token, selectedGender),
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
                  Positioned(
                    left: 10,
                    right: 10,
                    child: Container(
                      alignment: Alignment.center,
                      width: 250,
                      height: 90,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/img/home/pickcharacter.gif"),
                            fit: BoxFit.fill),
                      ),
                    ),
                  )
                ],
              ),
            ]),
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
    ));
  }
}
