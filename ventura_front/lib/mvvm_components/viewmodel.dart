import 'observer.dart';

abstract class EventViewModel {
  final List<EventObserver> observerList = List.empty(growable: true);
  bool _isSuscribing = false;

  void subscribe(EventObserver o) {
    _isSuscribing = true;
    if (observerList.contains(o)) return;
    observerList.add(o);
    _isSuscribing = false;
  }

  void unsubscribeAll() {
    observerList.clear();
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