import 'dart:convert';

import 'package:cupertino_bmi/widgets/user_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

enum BMIStatus { normal, overWeight, underWeight }

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  BMIStatus bmiStatus = BMIStatus.normal;
  double bmiValue = 0;
  DateTime dateTime = DateTime.now();
  late SharedPreferences prefs;
  bool isUserHasStorageData = true;

  @override
  void initState() {
    super.initState();
    initStorage();
  }

  void initStorage() async {
    prefs = await SharedPreferences.getInstance();
    final userInfo = getDataFromStorage();
    print(userInfo == null);
    if (userInfo != null) {
      setState(() {
        bmiValue = userInfo['bmiValue'];
        bmiStatus = getBmiStatusBaseOnString(userInfo['bmi status']) ??
            BMIStatus.normal;
        dateTime = DateTime.parse(userInfo['bmi date']);
      });
    } else {
      setState(() {
        isUserHasStorageData = false;
      });
    }
  }

  Map? getDataFromStorage() {
    final userInfoString = prefs.getString('userInfo') ?? '';
    if (userInfoString.isNotEmpty) {
      final Map userInfo = jsonDecode(userInfoString) as Map;
      return userInfo;
    }
    return null;
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

  @override
  Widget build(BuildContext context) {
    return isUserHasStorageData
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Center(
              child: UserInfoCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                bmiStatus.name,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${dateTime.day}/${dateTime.month}/${dateTime.year}',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                bmiValue.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w200),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Center(
            child: Text(
              'Your history data is empty',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w200),
            ),
          );
  }
}
