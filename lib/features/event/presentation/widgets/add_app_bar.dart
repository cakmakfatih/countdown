import 'package:flutter/material.dart';

class AddAppBar extends PreferredSize {
  final Widget child;

  AddAppBar({Key key, this.child});

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).accentColor,
      child: Container(
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
        padding:
            EdgeInsets.fromLTRB(5, MediaQuery.of(context).padding.top, 5, 0),
        child: Container(child: child),
      ),
    );
  }
}
