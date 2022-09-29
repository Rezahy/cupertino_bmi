import 'package:flutter/material.dart';

import 'custom_button.dart';

class UserInfoController extends StatelessWidget {
  const UserInfoController(
      {Key? key,
      required this.controllerTitle,
      required this.controllerValue,
      required this.actions})
      : super(key: key);
  final String controllerTitle;
  final int controllerValue;
  final Map actions;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          controllerTitle,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '$controllerValue',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w200),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              onPressed: actions['decrease$controllerTitle'],
              child: Text(
                '-',
                style: TextStyle(color: Colors.redAccent, fontSize: 25),
              ),
            ),
            CustomButton(
                onPressed: actions['increase$controllerTitle'],
                child: Text(
                  '+',
                  style: TextStyle(fontSize: 25, color: Colors.blueAccent),
                ))
          ],
        )
      ],
    );
  }
}
