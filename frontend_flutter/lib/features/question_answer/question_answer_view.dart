import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend_flutter/features/question_answer/question_answer_contract.dart';
import 'package:frontend_flutter/features/question_answer/question_answer_presenter.dart';
import 'package:frontend_flutter/models/Question.dart';

import '../../constants.dart';

// ignore: must_be_immutable
class QuestionAnswerView extends StatefulWidget {
  String topicsType;
  int level;
  QuestionAnswerView(
      {super.key, required this.level, required this.topicsType});

  @override
  State<QuestionAnswerView> createState() => _QuestionAnswerViewState();
}

class _QuestionAnswerViewState extends State<QuestionAnswerView>
    with TickerProviderStateMixin
    implements QuestionAnswerContract {
  late QuestionAnswerPresenter _presenter;
  _QuestionAnswerViewState() {
    _presenter = QuestionAnswerPresenter(this);
  }
  int? selectedAnswerIndex;
  int? time;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  int _countDown = 3;
  int expEarned = 0;
  int goldEarned = 0;
  int star = 1;
  bool isSumarry = false;
  summaryScore() async {
    // final result = await UsersLevelController()
    //     .summaryScore(score, this.widget.level, gold!);
    // expEarned = result['exp'];
    // goldEarned = result['gold'];
    // star = result['star'];
    // setState(() {
    //   isSumarry = true;
    // });
  }
  @override
  setTime(int _time) {
    time = _time;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  setGold(int _gold) {
    gold = _gold;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  setQuestion(List<Question> _questions) {
    questions = _questions;
    questions!.shuffle();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  CountDown() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          setState(() {
            --_countDown;
          });

          if (_countDown == -1) {
            _controller.stop();
            start();
          } else {
            _controller.forward();
          }
        }
      });
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(_controller);
    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    _controller.forward();
  }

  List<Question>? questions;
  int? gold;
  int index = 0;
  int score = 0;
  int x2Score = 1;
  bool toolWasUsed = false;
  bool fiftyFiftyWasUsed = false;
  bool specialWasUsed = false;
  bool doubleScoreWasUsed = false;
  bool TimePlusWasUsed = false;
  bool isloading = true;
  bool isAnswer = false;
  bool isEnd = false;
  int isCorrect = 0;
  @override
  void initState() {
    _presenter.getGoldAndQuestion(this.widget.topicsType, this.widget.level);
    super.initState();
  }

  void start() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (time! > 0) {
        setState(() {
          time = time! - 1;
        });
      } else {
        timer.cancel();
        // summaryScore();
        // setState(() {
        //   isEnd = true;
        // });
      }
    });
  }

  void handleFiftyFifty() {
    if (!toolWasUsed && !fiftyFiftyWasUsed && gold! > 100 && !isAnswer) {
      fiftyFiftyWasUsed = true;
      // Lấy ra 2 đáp án sai
      List<Answer> wrongAnswers =
          questions![index].answers.where((answer) => !answer.score).toList();
      wrongAnswers.shuffle();
      wrongAnswers = wrongAnswers.sublist(0, 2);
// Thay thế 2 đáp án sai bằng chuỗi rỗng
      questions![index].answers.forEach((answer) {
        if (answer.answerText == wrongAnswers[0].answerText ||
            answer.answerText == wrongAnswers[1].answerText) {
          answer.answerText = "";
        }
      });

      // Cập nhật lại giao diện
      setState(() {});
      toolWasUsed = true;
    }
  }

  void handleDoubleScore() {
    if (!toolWasUsed && !doubleScoreWasUsed && gold! > 50 && !isAnswer) {
      doubleScoreWasUsed = true;
      x2Score = 2;
      // Cập nhật lại giao diện
      setState(() {});
      toolWasUsed = true;
    }
  }

  void handlePlusTime() {
    if (!toolWasUsed && !TimePlusWasUsed && gold! > 30 && !isAnswer) {
      TimePlusWasUsed = true;
      time = time! + 5;
      // Cập nhật lại giao diện
      setState(() {});
      toolWasUsed = true;
    }
  }

  void handleSpecial() {
    if (!toolWasUsed && !specialWasUsed && gold! > 200 && !isAnswer) {
      specialWasUsed = true;
      // thay thế chuổi rỗng tất cả đáp án sai khỏi câu hỏi
      questions![index].answers.forEach((answer) {
        if (!answer.score) {
          answer.answerText = "";
        }
      });

      // Cập nhật lại giao diện
      setState(() {});
      toolWasUsed = true;
    }
  }

  void handleAnswer(answer) {
    if (answer) {
      setState(() {
        score += questions![index].score * x2Score;

        if (index < questions!.length - 1) {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              index++;
              x2Score = 1;
              isAnswer = false;
              toolWasUsed = false;
              selectedAnswerIndex = null;
            });
          });
        } else {
          setState(() {
            time = 1;
            isAnswer = true;
          });
          print("hết câu hỏi");
        }
      });
    } else {
      // Đáp án sai
      setState(() {
        x2Score = 1;
        isAnswer = false;
        toolWasUsed = false;

        if (index < questions!.length - 1) {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              index++;
              x2Score = 1;
              isAnswer = false;
              toolWasUsed = false;
              selectedAnswerIndex = null;
            });
          });
        } else {
          setState(() {
            time = 1;
            isAnswer = true;
          });

          print("hết câu hỏi");
        }
      });
    }
  }

  @override
  setIsLoading(bool _isloading) {
    isloading = _isloading;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        AssetImage("assets/img/battletraining/bgquestion.png"),
                    fit: BoxFit.fill)),
            child: !isloading
                ? Stack(
                    children: [
                      IgnorePointer(
                        ignoring: !(_countDown == -1) || isEnd,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context, 1);
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/img/battletraining/back.png"))),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 180,
                                    height: 65,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/img/battletraining/cloudtitle.png"),
                                            fit: BoxFit.fill)),
                                    child: Text(
                                      "Ngôn Ngữ ${this.widget.topicsType.toUpperCase()}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 110,
                                    height: 65,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/img/battletraining/cloud.png"),
                                            fit: BoxFit.fill)),
                                    child: Text(
                                      "Level ${this.widget.level}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/img/battletraining/alarm.png"),
                                            fit: BoxFit.fill)),
                                    child: Text(
                                      "${time}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 110,
                                    height: 65,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/img/battletraining/cloud.png"),
                                            fit: BoxFit.fill)),
                                    child: Text(
                                      "$score",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/img/battletraining/board.png"),
                                      fit: BoxFit.fill)),
                              constraints:
                                  BoxConstraints(minHeight: 200, minWidth: 320),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Câu ${index + 1}/${questions!.length}:",
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                  Text('${questions![index].title}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                                  Container(
                                    width: 1,
                                    height: 1,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: questions![index]
                                    .answers
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final answerIndex = entry.key;
                                  final answer = entry.value;

                                  return InkWell(
                                    onTap: () {
                                      if (!isAnswer &&
                                          answer.answerText != "") {
                                        selectedAnswerIndex =
                                            answerIndex; // Lưu vị trí được chọn
                                        handleAnswer(answer.score);
                                        isAnswer = true;
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 25, right: 25, bottom: 5),
                                      padding: EdgeInsets.all(1.5),
                                      decoration: BoxDecoration(
                                          color: Colors
                                              .black, // Thay đổi màu tương ứng
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: selectedAnswerIndex ==
                                                    answerIndex
                                                ? answer.score
                                                    ? Colors.green
                                                    : Colors.red
                                                : Colors
                                                    .white, // Thay đổi màu tương ứng
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        constraints: BoxConstraints(
                                            minHeight: 50, minWidth: 320),
                                        child: Center(
                                          child: Text(answer.answerText,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //5050
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          handleFiftyFifty();
                                        },
                                        child: ColorFiltered(
                                          colorFilter: (gold! > 100&&!fiftyFiftyWasUsed)
                                              ? transparentscale
                                              : greyscale,
                                          child: Container(
                                            width: 65,
                                            height: 55,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/img/battletraining/50.png"),
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "100",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Image.asset(
                                              "assets/img/maingame/gold.png",
                                              fit: BoxFit.fill,
                                              width: 30,
                                              height: 30,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  //đạc biệt
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          handleSpecial();
                                        },
                                        child: ColorFiltered(
                                          colorFilter: (gold! > 200&&!specialWasUsed)
                                              ? transparentscale
                                              : greyscale,
                                          child: Container(
                                            width: 65,
                                            height: 55,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/img/battletraining/special.png"),
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "200",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Image.asset(
                                              "assets/img/maingame/gold.png",
                                              fit: BoxFit.fill,
                                              width: 30,
                                              height: 30,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  //+5 giây
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          handlePlusTime();
                                        },
                                        child: ColorFiltered(
                                          colorFilter: (gold! > 30&&!TimePlusWasUsed)
                                              ? transparentscale
                                              : greyscale,
                                          child: Container(
                                            width: 65,
                                            height: 55,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/img/battletraining/plustime.png"),
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "30",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Image.asset(
                                              "assets/img/maingame/gold.png",
                                              fit: BoxFit.fill,
                                              width: 30,
                                              height: 30,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  //x2 điểm
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          handleDoubleScore();
                                        },
                                        child: ColorFiltered(
                                          colorFilter: (gold! > 50&&!doubleScoreWasUsed
                                          )? transparentscale
                                              : greyscale,
                                          child: Container(
                                            width: 65,
                                            height: 55,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/img/battletraining/x2score.png"),
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "50",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Image.asset(
                                              "assets/img/maingame/gold.png",
                                              fit: BoxFit.fill,
                                              width: 30,
                                              height: 30,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      !(_countDown == -1)
                          ? Center(
                              child: Stack(
                                children: [
                                  Text(
                                    _countDown == 0
                                        ? "Bắt Đầu"
                                        : '$_countDown',
                                    style: TextStyle(
                                      fontSize: 50.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  AnimatedBuilder(
                                    animation: _scaleAnimation,
                                    builder: (context, child) =>
                                        Transform.scale(
                                      scale: _scaleAnimation.value,
                                      child: child,
                                    ),
                                    child: AnimatedBuilder(
                                      animation: _opacityAnimation,
                                      builder: (context, child) => Opacity(
                                        opacity: _opacityAnimation.value,
                                        child: child,
                                      ),
                                      child: Text(
                                        _countDown == 0
                                            ? "Bắt Đầu"
                                            : '$_countDown',
                                        style: TextStyle(
                                          fontSize: 50.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container()
                    ],
                  )
                : Container(),
          ),
          isEnd
              ? Center(
                  child: Container(
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                        ),
                        Positioned(
                          top: 40,
                          left: 10,
                          right: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("img/frame.png"),
                                    fit: BoxFit.fill)),
                            child: isSumarry
                                ? Center(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "img/topic/star$star.png",
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "+${goldEarned}",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                              Image.asset(
                                                "assets/img/maingame/gold.png",
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.fill,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "+${expEarned}",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                              Image.asset(
                                                "img/exp.png",
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.fill,
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ))
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: MediaQuery.of(context).size.width / 6,
                          right: MediaQuery.of(context).size.width / 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 230,
                                height: 90,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("img/logo.png"),
                                        fit: BoxFit.fill)),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: MediaQuery.of(context).size.height / 10,
                          left: MediaQuery.of(context).size.width / 10,
                          right: MediaQuery.of(context).size.width / 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IgnorePointer(
                                ignoring: !isSumarry,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context, 1);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  AssetImage("img/button.png"),
                                              fit: BoxFit.fill)),
                                      child: Text(
                                        "Quay Về",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IgnorePointer(
                                ignoring: !isSumarry,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _countDown = 3;
                                        index = 0;
                                        score = 0;
                                        x2Score = 1;
                                        toolWasUsed = false;
                                        fiftyFiftyWasUsed = false;
                                        specialWasUsed = false;
                                        doubleScoreWasUsed = false;
                                        TimePlusWasUsed = false;
                                        isloading = false;
                                        isAnswer = false;
                                        isEnd = false;
                                        isCorrect = 0;
                                        selectedAnswerIndex = null;
                                        questions = null;
                                        isSumarry = false;
                                        _presenter.getGoldAndQuestion(
                                            this.widget.topicsType,
                                            this.widget.level);
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  AssetImage("img/button.png"),
                                              fit: BoxFit.fill)),
                                      child: Text(
                                        "Chơi Lại",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
