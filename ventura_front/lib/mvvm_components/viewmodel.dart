import 'observer.dart';

abstract class EventViewModel {
  final List<EventObserver> observerList = List.empty(growable: true);
  bool _isSuscribing = false;

  void subscribe(EventObserver o){
    observerList.clear();
    observerList.add(o);
  }

  bool isSuscribed(EventObserver o) {
    return observerList.contains(o);
  }

  bool unsubscribe(EventObserver o) {
    if (observerList.contains(o)) {
      observerList.remove(o);
      return true;
    } else {
      return false;
    }
  }

  void notify(ViewEvent event) {
    for (EventObserver observer in observerList) {
      observer.notify(event);
    }
  }

  bool isSuscribing() {
    return _isSuscribing;
  }
}