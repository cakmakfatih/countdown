import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:select_dialog/select_dialog.dart';

import '../../../../core/util/constants.dart';
import '../../../../injection_container.dart';
import '../../models/category.dart';
import '../bloc/event_bloc.dart';
import 'add_app_bar.dart';
import 'event_select_image_view.dart';
import 'typed_image_background_widget.dart';

class EventAddView extends StatefulWidget {
  EventAddView({Key key}) : super(key: key);

  @override
  _EventAddViewState createState() => _EventAddViewState();
}

class _EventAddViewState extends State<EventAddView> {
  EventBloc get bloc => sl<EventBloc>();

  final _eventTitleFocusNode = FocusNode();
  TextEditingController _eventTitleController;

  @override
  void initState() {
    super.initState();

    _eventTitleController =
        TextEditingController(text: bloc.state.eventAddState.title);
    _eventTitleController.addListener(_onTitleChanged);

    if (bloc.state.allImages.length == 0) {
      bloc.add(GetImagesEvent());
    }
  }

  @override
  void dispose() {
    super.dispose();

    _eventTitleFocusNode.unfocus();

    _eventTitleFocusNode.dispose();
    _eventTitleController.dispose();
  }

  void _onTitleChanged() {
    bloc.add(ChangeTitleEvent(title: _eventTitleController.text));
  }

  Widget _buildSelectSwitchButton({
    IconData icon,
    String title,
    Function onSelect,
    bool value,
    Function onChanged,
  }) {
    return InkWell(
      onTap: () {
        if (_eventTitleFocusNode.hasFocus) {
          _eventTitleFocusNode.unfocus();
        }

        onSelect();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          10,
          0,
          0,
          0,
        ),
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(child: Container()),
            CupertinoSwitch(
              value: value ?? false,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(
      {IconData icon, String title, Function onSelect, String value}) {
    return InkWell(
      onTap: () {
        if (_eventTitleFocusNode.hasFocus) {
          _eventTitleFocusNode.unfocus();
        }

        onSelect();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          10,
          10,
          10,
          10,
        ),
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(child: Container()),
            Text(
              value ?? "Select",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final state = bloc.state;

    return _buildSelectButton(
      icon: Icons.category,
      title: "Category",
      onSelect: () {
        showModalBottomSheet(
          context: context,
          builder: (dialogContext) {
            final selectedItemIndex =
                Constants.categories.indexOf(state.eventAddState.category);

            return Container(
              height: 240,
              child: CupertinoPicker.builder(
                scrollController: FixedExtentScrollController(
                  initialItem: selectedItemIndex > -1 ? selectedItemIndex : 0,
                ),
                onSelectedItemChanged: (int index) {
                  bloc.add(
                      SetCategoryEvent(category: Constants.categories[index]));
                },
                itemExtent: 45,
                childCount: Constants.categories.length,
                itemBuilder: (dialogContext, index) {
                  final category = Constants.categories[index];

                  return Container(
                    key: ValueKey(index),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(category.icon),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          category.name,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
        // SelectDialog.showModal<Category>(
        //   context,
        //   autofocus: false,
        //   label: "Categories",
        //   titleStyle: TextStyle(color: Colors.brown),
        //   showSearchBox: false,
        //   selectedValue: state.eventAddState.category,
        //   backgroundColor: Colors.white,
        //   items: Constants.categories,
        //   itemBuilder: (context, category, isSelected) {
        //     return Container(
        //       padding: EdgeInsets.symmetric(vertical: 10),
        //       decoration: BoxDecoration(
        //         border: Border(
        //           top: BorderSide(
        //             width: 1,
        //             color: Colors.grey.shade200,
        //           ),
        //         ),
        //       ),
        //       child: Row(
        //         children: [
        //           Icon(
        //             category.icon,
        //             color: Colors.black,
        //           ),
        //           SizedBox(
        //             width: 5,
        //           ),
        //           Text(category.name),
        //           Expanded(child: Container()),
        //           if (isSelected)
        //             Icon(
        //               Icons.check,
        //               color: Colors.green,
        //             )
        //         ],
        //       ),
        //     );
        //   },
        //   onChange: (Category selected) {
        //     bloc.add(SetCategoryEvent(category: selected));
        //   },
        // );
      },
      value: state.eventAddState.category == null
          ? null
          : state.eventAddState.category.name,
    );
  }

  Widget _buildDate() {
    final state = bloc.state;
    final now = DateTime.now();

    DateTime minimumDate =
        DateTime(now.year, now.month, now.day, 0, 0).add(Duration(days: 1));

    final maximumDate = DateTime(
      minimumDate.year + 10,
      minimumDate.month,
      minimumDate.day,
    );

    String dateFormat = "dd-MMMM-yyyy";

    if (state.eventAddState.repeat.value == RepeatValue.year) {
      minimumDate = DateTime(
        minimumDate.year - 1,
        1,
        1,
        1,
        1,
      );

      dateFormat = "dd-MMMM";
    } else if (state.eventAddState.repeat.value == RepeatValue.month) {
      minimumDate = DateTime(
        minimumDate.year - 1,
        1,
        1,
        1,
        1,
      );

      dateFormat = "dd";
    } else if (state.eventAddState.repeat.value == RepeatValue.week) {
      dateFormat = "EEEE";
    }

    return _buildSelectButton(
      icon: Icons.event,
      title: "Date",
      onSelect: () {
        if (dateFormat == "EEEE") {
          showModalBottomSheet(
            isDismissible: true,
            context: context,
            builder: (dialogContext) {
              return Container(
                height: 240,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("Done"),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: CupertinoPicker.builder(
                        itemExtent: 45,
                        onSelectedItemChanged: (int dayIndex) {
                          final now = DateTime.now();

                          int daysToAdd;

                          final weekDayIndex = dayIndex + 1;
                          final nowWeekDayIndex = now.weekday;

                          if (nowWeekDayIndex > weekDayIndex) {
                            daysToAdd = (weekDayIndex + 7) - nowWeekDayIndex;
                          } else {
                            daysToAdd = weekDayIndex - nowWeekDayIndex;
                          }

                          bloc.add(SetDateEvent(
                              dateTime: now.add(Duration(days: daysToAdd))));
                        },
                        childCount: Constants.days.length,
                        itemBuilder: (context, index) {
                          final day = Constants.days[index];

                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              day,
                              key: ValueKey(index),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          DatePicker.showDatePicker(
            context,
            initialDateTime: minimumDate,
            minDateTime: minimumDate,
            maxDateTime: maximumDate,
            pickerTheme: DateTimePickerTheme(
              itemTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            dateFormat: dateFormat,
            onConfirm: (DateTime dateTime, _) {
              final formattedDateTime =
                  DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0);

              bloc.add(SetDateEvent(dateTime: formattedDateTime));
            },
            onChange: (DateTime dateTime, _) {
              final formattedDateTime =
                  DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0);

              bloc.add(SetDateEvent(dateTime: formattedDateTime));
            },
          );
        }
      },
      value: dateFormatted(),
    );
  }

  String dateFormatted() {
    final state = bloc.state;

    if (state.eventAddState.dateModel.dateTime == null) {
      return null;
    }

    if (state.eventAddState.repeat.value == RepeatValue.year) {
      return "Every year at ${state.eventAddState.dateModel.dateTime.day < 10 ? '0' + state.eventAddState.dateModel.dateTime.day.toString() : state.eventAddState.dateModel.dateTime.day}/${state.eventAddState.dateModel.dateTime.month < 10 ? '0' + state.eventAddState.dateModel.dateTime.month.toString() : state.eventAddState.dateModel.dateTime.month}";
    } else if (state.eventAddState.repeat.value == RepeatValue.month) {
      String suffix = "th";

      if (state.eventAddState.dateModel.dateTime.day.toString().endsWith("1")) {
        suffix = "st";
      } else if (state.eventAddState.dateModel.dateTime.day
          .toString()
          .endsWith("2")) {
        suffix = "nd";
      } else if (state.eventAddState.dateModel.dateTime.day
          .toString()
          .endsWith("3")) {
        suffix = "rd";
      }

      return "Every month's ${state.eventAddState.dateModel.dateTime.day}$suffix";
    } else if (state.eventAddState.repeat.value == RepeatValue.week) {
      return "Every ${Constants.days[state.eventAddState.dateModel.dateTime.weekday - 1]}";
    }

    return "${state.eventAddState.dateModel.dateTime.day < 10 ? '0' + state.eventAddState.dateModel.dateTime.day.toString() : state.eventAddState.dateModel.dateTime.day}/${state.eventAddState.dateModel.dateTime.month < 10 ? '0' + state.eventAddState.dateModel.dateTime.month.toString() : state.eventAddState.dateModel.dateTime.month}/${state.eventAddState.dateModel.dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (bloc.state.pageState == EventPageState.info) {
          bloc.add(NavigateToMainEvent());
        } else if (bloc.state.pageState == EventPageState.image) {
          bloc.add(NavigateToAddEvent());
        }

        return false;
      },
      child: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state.pageState == EventPageState.image) {
            return EventSelectImageView();
          }

          final body = buildBody(state);

          if (state.eventAddState.image != null) {
            return TypedImageBackgroundWidget(
              image: state.eventAddState.image,
              child: body,
            );
          }

          return body;
        },
      ),
    );
  }

  Container buildBody(EventState currentState) {
    return Container(
      color: Colors.black12,
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
                    bloc.add(NavigateToMainEvent());
                  },
                ),
                SizedBox(width: 5),
                Text(
                  "Create an event",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      10,
                      0,
                      10,
                      0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.title),
                        Expanded(
                          child: TextField(
                            focusNode: _eventTitleFocusNode,
                            autofocus: false,
                            controller: _eventTitleController,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            maxLength: 24,
                            maxLengthEnforced: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              hintText: "Title",
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "${currentState.eventAddState.title == null ? '0' : currentState.eventAddState.title.length}/24",
                        ),
                      ],
                    ),
                  ),
                  _buildCategories(),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildDate(),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildSelectButton(
                    icon: Icons.photo,
                    title: "Background",
                    onSelect: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (dialogContext) {
                          return Container(
                            height: 140,
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    bloc.add(AddFromGalleryEvent());

                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.photo_library),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Add from gallery"),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    bloc.add(NavigateToPickImageEvent());

                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.event),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Add from Days To images"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    value: currentState.eventAddState.image == null
                        ? null
                        : "Selected",
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildSelectSwitchButton(
                    icon: Icons.notifications,
                    title: "Notify",
                    value: currentState.eventAddState.notify,
                    onSelect: () {
                      bloc.add(ChangeNotifyEvent(
                          notify: !currentState.eventAddState.notify));
                    },
                    onChanged: (bool isSelected) {
                      bloc.add(ChangeNotifyEvent(notify: isSelected));
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          FlatButton(
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            onPressed: !currentState.eventAddState.isValid
                ? null
                : () {
                    bloc.add(CreateEventEvent());
                  },
            child: Text(
              "CREATE",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            color: Theme.of(context).primaryColor,
            disabledColor: Colors.grey.shade500,
            disabledTextColor: Colors.grey.shade400,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
