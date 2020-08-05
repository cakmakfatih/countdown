import 'package:flutter/material.dart';

import '../../../../core/helpers/get_days_left.dart';
import '../../models/event.dart';

class ActiveEventWidget extends StatelessWidget {
  const ActiveEventWidget({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final daysLeft = getDaysLeft(event);

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(59),
          child: Column(
            children: <Widget>[
              Container(
                width: width * 3 / 4,
                height: 208,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      daysLeft,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 102,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      !("< 1" == daysLeft || daysLeft == "1")
                          ? "DAYS TO"
                          : "DAY TO",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width * 3 / 4,
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                    right: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    event.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 303,
          child: Icon(
            event.category.icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}
