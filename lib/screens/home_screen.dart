import 'package:cupertino_bmi/widgets/user_info_card.dart';
import 'package:cupertino_bmi/widgets/user_info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum Gender { male, female }
enum BMIStatus { normal, overWeight, underWeight }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final SharedPreferences prefs;
  int _age = 25;
  int _weight = 80;
  late final Map actions;
  final action = {};
  int _height = 160;
  Gender _userGender = Gender.male;
  BMIStatus _bmiStatus = BMIStatus.normal;
  double finalCalculationBmi = 0.0;

  @override
  void initState() {
    super.initState();
    initStorage();
    actions = {
      'ageActions': {
        'increaseAge': () {
          if (_age > 0) {
            setState(() {
              _age += 1;
            });
          }
        },
        'decreaseAge': () {
          if (_age > 0) {
            setState(() {
              _age -= 1;
            });
          }
        }
      },
      'weightActions': {
        'increaseWeight': () {
          if (_weight > 0) {
            setState(() {
              _weight++;
            });
          }
        },
        'decreaseWeight': () {
          if (_weight > 0) {
            setState(() {
              _weight--;
            });
          }
        }
      },
      'heightAction': (double newValue) {
        setState(() {
          _height = newValue.toInt();
        });
      },
      'genderAction': (Gender? newValue) {
        if (newValue != null) {
          setState(() {
            _userGender = newValue;
          });
        }
      },
      'calculateBmi': (BuildContext context) {
        setState(() {
          finalCalculationBmi = _weight / pow(_height / 100, 2);
        });

        if (finalCalculationBmi >= 25) {
          setState(() {
            _bmiStatus = BMIStatus.overWeight;
          });
        } else if (finalCalculationBmi >= 18.5) {
          setState(() {
            _bmiStatus = BMIStatus.normal;
          });
        } else {
          setState(() {
            _bmiStatus = BMIStatus.underWeight;
          });
        }
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('status: ${_bmiStatus.name}'),
            content: Text(
              'bmi value: ${finalCalculationBmi.toStringAsFixed(2)}',
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
        savedDataIntoStorage();
      }
    };
  }

  void initStorage() async {
    prefs = await SharedPreferences.getInstance();
    final userInfo = getDataFromStorage();
    print(userInfo == null);
    if (userInfo != null) {
      setState(() {
        _userGender =
            userInfo['gender'] == 'male' ? Gender.male : Gender.female;
        _age = userInfo['age'];
        _height = userInfo['height'];
        _weight = userInfo['weight'];
        finalCalculationBmi = userInfo['bmiValue'];
        _bmiStatus = getBmiStatusBaseOnString(userInfo['bmi status']) ??
            BMIStatus.normal;
      });
    }
  }

  BMIStatus? getBmiStatusBaseOnString(String bmiStatusName) {
    switch (bmiStatusName) {
      case 'overWeight':
        return BMIStatus.overWeight;
      case 'underWeight':
        return BMIStatus.underWeight;
      case 'normal':
        return BMIStatus.normal;
      default:
        return null;
    }
  }

  void savedDataIntoStorage() async {
    final Map userInfo = {
      'gender': _userGender == Gender.male ? 'male' : 'female',
      'age': _age,
      'height': _height,
      'weight': _weight,
      'bmiValue': finalCalculationBmi,
      'bmi status': _bmiStatus.name,
      'bmi date': DateTime.now().toString()
    };
    await prefs.setString('userInfo', jsonEncode(userInfo));
    print('saved');
  }

  Map? getDataFromStorage() {
    final userInfoString = prefs.getString('userInfo') ?? '';
    if (userInfoString.isNotEmpty) {
      final Map userInfo = jsonDecode(userInfoString) as Map;
      return userInfo;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            Row(
              children: [
                Expanded(
                  child: UserInfoCard(
                      child: UserInfoController(
                    controllerTitle: 'Age',
                    controllerValue: _age,
                    actions: actions['ageActions'],
                  )),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: UserInfoCard(
                      child: UserInfoController(
                    controllerTitle: 'Weight',
                    controllerValue: _weight,
                    actions: actions['weightActions'],
                  )),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: UserInfoCard(
                    child: Column(
                      children: [
                        Text(
                          'Height',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '$_height',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w200),
                        ),
                        SizedBox(
                          width: size.width,
                          child: CupertinoSlider(
                              activeColor: Colors.blueAccent,
                              min: 100,
                              max: 250,
                              value: _height.toDouble(),
                              onChanged: actions['heightAction']),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: UserInfoCard(
                    child: Column(
                      children: [
                        Text(
                          'Gender',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CupertinoSlidingSegmentedControl<Gender>(
                          onValueChanged: actions['genderAction'],
                          groupValue: _userGender,
                          children: {
                            Gender.male: Text(
                              'Male',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16),
                            ),
                            Gender.female: Text(
                              'Female',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16),
                            ),
                          },
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                child: Text('Calculate BMI'),
                onPressed: () {
                  actions['calculateBmi'](context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
