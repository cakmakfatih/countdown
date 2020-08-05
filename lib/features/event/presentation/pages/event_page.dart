import 'package:countdown/features/event/presentation/bloc/event_bloc.dart';
import 'package:countdown/features/event/presentation/pages/splash_page.dart';
import 'package:countdown/features/event/presentation/widgets/event_add_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../widgets/event_main_view.dart';

class EventPage extends StatefulWidget {
  EventPage({Key key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventBloc>(
      create: (context) => sl<EventBloc>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: buildState(),
        ),
      ),
    );
  }

  BlocBuilder buildState() {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        Widget child;

        if (EventPageState.info == state.pageState ||
            state.pageState == EventPageState.image) {
          child = EventAddView();
        } else if (state.pageState == EventPageState.main) {
          child = EventMainView();
        } else {
          child = SplashPage();
        }

        return AnimatedSwitcher(
          duration: Duration(
            milliseconds: 300,
          ),
          child: child,
        );
      },
    );
  }
}
