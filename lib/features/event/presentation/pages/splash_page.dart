import 'package:countdown/features/event/presentation/bloc/event_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../injection_container.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  EventBloc get bloc => sl<EventBloc>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(InitializeEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
