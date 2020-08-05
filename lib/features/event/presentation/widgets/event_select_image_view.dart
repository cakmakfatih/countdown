import 'package:countdown/features/event/presentation/bloc/event_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../injection_container.dart';
import '../../models/typed_image.dart';
import 'add_app_bar.dart';
import 'typed_image_widget.dart';

class EventSelectImageView extends StatefulWidget {
  EventSelectImageView({Key key}) : super(key: key);

  @override
  _EventSelectImageViewState createState() => _EventSelectImageViewState();
}

class _EventSelectImageViewState extends State<EventSelectImageView> {
  EventBloc get bloc => sl<EventBloc>();
  int _selectedImageIndex;

  Widget buildImage(TypedImage image, int index) {
    return Material(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedImageIndex = index;
          });

          bloc.add(SetImageEvent(image: image));
        },
        child: Container(
          key: ValueKey(index),
          decoration: BoxDecoration(
            border: _selectedImageIndex != index
                ? null
                : Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
          ),
          child: TypedImageWidget(
            image: image,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = bloc.state;

    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AddAppBar(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    bloc.add(NavigateToAddEvent());
                  },
                ),
                SizedBox(width: 5),
                Text(
                  "Pick an image",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              padding: EdgeInsets.all(0),
              itemCount: state.allImages.length,
              itemBuilder: (BuildContext context, int index) {
                final image = state.allImages[index];

                return buildImage(
                  image,
                  index,
                );
              },
            ),
          ),
          FlatButton(
            onPressed: () {
              bloc.add(NavigateToAddEvent());
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            child: Text(
              "DONE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            color: Colors.white,
            textColor: Colors.black,
            padding: EdgeInsets.all(20),
          ),
        ],
      ),
    );
  }
}
