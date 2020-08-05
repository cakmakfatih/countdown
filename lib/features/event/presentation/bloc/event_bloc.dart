import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/util/constants.dart';
import '../../models/category.dart';
import '../../models/date_model.dart';
import '../../models/event.dart';
import '../../models/repeat.dart';
import '../../models/typed_image.dart';
import '../../repositories/event_repository.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository repository;
  EventBloc({@required EventRepository repository})
      : assert(repository != null),
        repository = repository,
        super(EventState.initial());

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if (event is InitializeEvent) {
      final eventsOrFailure = await repository.getEvents();

      yield* eventsOrFailure.fold((failure) async* {
        print(failure);
      }, (events) async* {
        if (events.length == 0) {
          yield state.copyWith(pageState: EventPageState.info);
        } else {
          yield state.copyWith(
            events: events,
            activeEvent: events[0],
            pageState: EventPageState.main,
          );
        }
      });
    } else if (event is GetEventsEvent) {
      final eventsOrFailure = await repository.getEvents();

      yield* eventsOrFailure.fold((failure) async* {
        print(failure);
      }, (events) async* {
        yield state.copyWith(
          events: events,
          activeEvent: events[0],
        );
      });
    } else if (event is NavigateToMainEvent) {
      yield state.copyWith(pageState: EventPageState.main);
    } else if (event is NavigateToAddEvent) {
      yield state.copyWith(pageState: EventPageState.info);
    } else if (event is NavigateToPickImageEvent) {
      yield state.copyWith(pageState: EventPageState.image);
    } else if (event is ChangeTitleEvent) {
      yield state.copyWith(
        eventAddState: state.eventAddState.copyWith(
          title: event.title,
        ),
      );
    } else if (event is ChangeNotifyEvent) {
      yield state.copyWith(
        eventAddState: state.eventAddState.copyWith(
          notify: event.notify,
        ),
      );
    } else if (event is SetDateEvent) {
      yield state.copyWith(
        eventAddState: state.eventAddState.copyWith(
          dateModel: DateModel(dateTime: event.dateTime),
        ),
      );
    } else if (event is SetCategoryEvent) {
      yield state.copyWith(
        eventAddState: state.eventAddState.copyWith(
          category: event.category,
        ),
      );
    } else if (event is SetRepeatEvent) {
      yield state.copyWith(
        eventAddState: state.eventAddState.copyWith(
          repeat: event.repeat,
        ),
      );
    } else if (event is SetImageEvent) {
      yield state.copyWith(
        eventAddState: state.eventAddState.copyWith(
          image: event.image,
        ),
      );
    } else if (event is ResetDateEvent) {
      yield state.copyWith(
        eventAddState: state.eventAddState.copyWith(
          dateModel: DateModel(),
        ),
      );
    } else if (event is AddFromGalleryEvent) {
      final imageOrFailure = await repository.pickImageFromGallery();

      yield* imageOrFailure.fold((failure) async* {
        print(failure);
      }, (image) async* {
        yield state.copyWith(
          eventAddState: state.eventAddState.copyWith(
            image: TypedImage(
              type: ImageSourceType.gallery,
              path: image.path,
            ),
          ),
        );
      });
    } else if (event is GetImagesEvent) {
      final imagesOrFailure = await repository.getImages();

      yield* imagesOrFailure.fold((failure) async* {
        print(failure);
      }, (allImages) async* {
        yield state.copyWith(allImages: allImages);
      });
    } else if (event is CreateEventEvent) {
      final id = await repository.generateId();

      final newEvent = Event(
        id: id,
        title: state.eventAddState.title,
        image: state.eventAddState.image,
        category: state.eventAddState.category,
        dateString: DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(state.eventAddState.dateModel.dateTime),
        repeat: state.eventAddState.repeat,
        notify: state.eventAddState.notify,
      );

      final saveOrFailure = await repository.saveEvent(newEvent);

      yield* saveOrFailure.fold(
        (failure) async* {
          print(failure);
        },
        (_) async* {
          yield state.copyWith(
            pageState: EventPageState.main,
            eventAddState: EventAddState(),
          );

          add(GetEventsEvent());
        },
      );
    } else if (event is SetActiveEventEvent) {
      yield state.copyWith(activeEvent: event.event);
    }
  }
}
