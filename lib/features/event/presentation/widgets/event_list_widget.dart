import 'package:countdown/core/helpers/get_days_left.dart';
import 'package:flutter/material.dart';

import '../../../../injection_container.dart';
import '../bloc/event_bloc.dart';

class EventListWidget extends StatelessWidget {
  const EventListWidget({
    Key key,
  }) : super(key: key);

  EventBloc get bloc => sl<EventBloc>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bloc.state.events.length,
      itemBuilder: (BuildContext context, int index) {
        final event = bloc.state.events[index];

        final color = event.id != bloc.state.activeEvent.id
            ? Colors.white
            : Colors.yellow;
        final fontWeight = event.id != bloc.state.activeEvent.id
            ? FontWeight.normal
            : FontWeight.bold;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              bloc.add(SetActiveEventEvent(event: event));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                key: ValueKey(index),
                children: <Widget>[
                  Icon(
                    event.category.icon,
                    color: color,
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Text(
                    event.title,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: fontWeight,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    "${getDaysLeft(event)}d",
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: fontWeight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
