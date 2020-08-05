part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List get props => [];
}

class InitializeEvent extends EventEvent {}

class GetEventsEvent extends EventEvent {}

class NavigateToMainEvent extends EventEvent {}

class NavigateToAddEvent extends EventEvent {}

class NavigateToPickImageEvent extends EventEvent {}

class ChangeTitleEvent extends EventEvent {
  final String title;

  ChangeTitleEvent({this.title});
}

class ChangeNotifyEvent extends EventEvent {
  final bool notify;

  ChangeNotifyEvent({this.notify});
}

class SetDateEvent extends EventEvent {
  final DateTime dateTime;

  SetDateEvent({this.dateTime});
}

class SetCategoryEvent extends EventEvent {
  final Category category;

  SetCategoryEvent({this.category});
}

class SetRepeatEvent extends EventEvent {
  final Repeat repeat;

  SetRepeatEvent({this.repeat});
}

class SetImageEvent extends EventEvent {
  final TypedImage image;

  SetImageEvent({this.image});
}

class ResetDateEvent extends EventEvent {}

class AddFromGalleryEvent extends EventEvent {}

class GetImagesEvent extends EventEvent {}

class CreateEventEvent extends EventEvent {}

class SetActiveEventEvent extends EventEvent {
  final Event event;

  SetActiveEventEvent({this.event});
}
