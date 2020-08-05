part of 'event_bloc.dart';

enum EventPageState {
  splash,
  info,
  image,
  main,
}

class EventState extends Equatable {
  final EventPageState pageState;
  final EventAddState eventAddState;

  final List<TypedImage> allImages;
  final List<Category> categories;
  final List<Repeat> repeats;

  final List<Event> events;
  final Event activeEvent;

  EventState({
    this.eventAddState: const EventAddState(),
    this.allImages: const [],
    this.categories: Constants.categories,
    this.pageState: EventPageState.splash,
    this.repeats: Constants.repeats,
    this.events: const [],
    this.activeEvent,
  });

  factory EventState.initial() => EventState();

  EventState copyWith({
    final EventAddState eventAddState,
    final List<TypedImage> allImages,
    final List<Category> categories,
    final List<Repeat> repeats,
    final EventPageState pageState,
    final List<Event> events,
    final Event activeEvent,
  }) {
    return EventState(
      eventAddState: eventAddState ?? this.eventAddState,
      allImages: allImages ?? this.allImages,
      categories: categories ?? this.categories,
      repeats: repeats ?? this.repeats,
      pageState: pageState ?? this.pageState,
      events: events ?? this.events,
      activeEvent: activeEvent ?? this.activeEvent,
    );
  }

  @override
  List<Object> get props => [
        eventAddState,
        allImages,
        categories,
        repeats,
        pageState,
        events,
        activeEvent,
      ];
}

class EventAddState extends Equatable {
  final String title;
  final TypedImage image;
  final Category category;
  final DateModel dateModel;
  final Repeat repeat;
  final bool notify;

  bool get isValid =>
      title != null &&
      image != null &&
      category != null &&
      dateModel.dateTime != null &&
      repeat != null &&
      notify != null;

  const EventAddState({
    this.title,
    this.image,
    this.category,
    this.dateModel: const DateModel(),
    this.repeat: const Repeat(RepeatValue.never),
    this.notify: true,
  });

  EventAddState copyWith({
    String title,
    TypedImage image,
    Category category,
    DateModel dateModel,
    Repeat repeat: const Repeat(RepeatValue.never),
    bool notify: true,
  }) {
    return EventAddState(
      title: title ?? this.title,
      image: image ?? this.image,
      category: category ?? this.category,
      dateModel: dateModel ?? this.dateModel,
      repeat: repeat ?? this.repeat,
      notify: notify ?? this.notify,
    );
  }

  @override
  List<Object> get props => [
        title,
        image,
        category,
        dateModel,
        repeat,
        notify,
      ];
}
