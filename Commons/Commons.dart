#library('commons');

class Key <T extends Hashable> implements Hashable {
  final T _value;
  const Key(T this._value);
  
  bool operator == (Hashable other) {
    if(other != null && other is Key<T>) {
      return hashCode() == other.hashCode();
    }
    return false;
  }
  
  int hashCode() {
    return _value.hashCode();
  }
  
  String toString() {
    if(_value != null) {
      return _value.toString();
    }
    return '';
  }
}


class GenericEvent {
  
}

//Think about as templates
typedef GenericEventListener(GenericEvent event);

interface EventSet {
  EventSet add (GenericEventListener handler);
  EventSet remove(GenericEventListener handler);
  void dispatch(GenericEvent event);
}

 class DefaultEventSet implements EventSet {
  List<GenericEventListener> _handlers;
  DefaultEventSet(): this._handlers =  [];
  
  EventSet add(GenericEventListener handler) {
   _handlers.add(handler); 
  }
  
  EventSet remove(GenericEventListener handler) {
    _handlers.removeRange(_handlers.indexOf(handler), 1);
  }
}
 
 interface SimpleEvents default SimpleEventsImpl {
   SimpleEvents();
   EventSet genericEvent();
 }
 
 class SimpleEventsImpl implements SimpleEvents {
   DefaultEventSet _eventSet;
   
   SimpleEventsImpl() {
     this._eventSet = new DefaultEventSet();  
   }
   EventSet genericEvent() {
     return _eventSet;
   }
 }

class SimpleEventBus  {
  SimpleEvents _on;
  
  SimpleEventBus():this._on = new SimpleEvents();
  
  void dispatch(GenericEvent event) {
    for(GenericEventListener handler in _on._eventSet._handlers) {
      handler(event);
    }
  }
  SimpleEvents get on () => _on;
}

class TopicEvent <T extends Hashable> {
  T _topic;
  TopicEvent (this._topic);
  T get topic() => _topic;
}

class TopicHandler <K extends Hashable, T extends Function> {
  
  Map <K, List<T>> _topics;
  
  TopicHandler(): this._topics = new Map();
  
  void dispatch(TopicEvent<K>  event) {
    final handlers = _topics[event.topic];
    
    if(handlers != null) {
      for(T listener in handlers) {
        listener(event);
      }
    }
  }

  
  void add(K topic, T listener) {
    var listeners = _topics[topic];
    if(listeners == null) {
      listeners = [];
      _topics[topic] = listeners;
    }
    
    listeners.add(listener);
  }
}


class TopicEvents {
  TopicHandler <String, GenericEventListener> _handlers;
  
  TopicEvents(): this._handlers = new TopicHandler<String, GenericEventListener>();
  
  TopicHandler topicEvent(String topic, GenericEventListener listener) {
   _handlers.add(topic, listener); 
  }
}
 
class TopicEventBus <T> {
  TopicEvents _on;
  
  TopicEventBus() {
    _on = new TopicEvents();
  }
  
  void dispatch(TopicEvent event) {
    _on._handlers.dispatch(event);
  }
  
  TopicEvents get on() => _on;
}