import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../injection_container.dart';
import '../bloc/event_bloc.dart';
import 'active_event_widget.dart';
import 'event_list_widget.dart';
import 'typed_image_background_widget.dart';

class EventMainView extends StatelessWidget {
  const EventMainView({
    Key key,
  }) : super(key: key);

  EventBloc get bloc => sl<EventBloc>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      child: TypedImageBackgroundWidget(
        image: bloc.state.activeEvent.image,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: width,
              height: height,
              color: Colors.black26,
            ),
            Container(
              height: height - 78,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ActiveEventWidget(event: bloc.state.activeEvent),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(59, 0, 59, 59),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: EventListWidget(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.black.withOpacity(.4),
                child: Container(
                  height: 56,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 34,
              height: 44,
              width: 44,
              child: Transform.rotate(
                angle: pi / 4,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(
                          0,
                          4,
                        ),
                        color: Color(0x33000000),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.white,
                    child: Transform.rotate(
                      angle: pi / 4,
                      child: InkWell(
                        onTap: () {
                          bloc.add(NavigateToAddEvent());
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 34,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ), /* add child content here */
      ),
    );
  }
}
