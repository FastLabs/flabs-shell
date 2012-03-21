#library('commons');

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
  
  void dispatch(GenericEvent event) {
    
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
  SimpleEventsImpl _on;
  
  SimpleEventBus():this._on = new SimpleEvents();
  
  void dispatch(GenericEvent event) {
    for(GenericEventListener handler in _on._eventSet._handlers) {
      handler(event);
    }
  }
  SimpleEvents get on () => _on;
}

class TopicEvent <T extends Hashable> {
  final T _topic;
  const TopicEvent (this._topic);
  T get topic() => _topic;
}

interface HandleRegistration<T> default _HandlerRegister<T> {
  HandleRegistration(T handler, List<T> handlerContainer);
  void remove();
}

interface Taggable <T> default TagContainer <T>{
  void tagIt(T tag);
  bool isTagged(T tag);
  void removeTag(T tag);
}

class TagContainer<T> implements Taggable<T> {
  List<T> _tags;
  
  void tagIt(T tag) {
    if(_tags ==  null) {
      _tags = [];
    }
    _tags.add(tag);
  }
  
  void removeTag(T tag) {
    if(_tags != null && tag != null) {
      int index = _tags.indexOf(tag);
      if(index >= 0) {
        _tags.removeRange(index, 1);
      }
    }
  }
  
  bool isTagged(T isTag) {
    if(_tags != null && isTag != null) {
      return _tags.some((tag) => isTag == tag );
    }
    return false;
  }
}
//TODO: not sure if this is required
interface Unwrapable <T> {
  Map<String, Object> unwrapInstance(T object);
  List<Map<String, Object>> unwrapList(List<T> objects);
}
//TODO: not sure if this is required
interface Wrapable <T> {
  T wrapInstance(Map<String, Object> properties);
  List<T> wrapList(List<Map<String, Object>> collection);
}

class _HandlerRegister <T> implements HandleRegistration {
  T _handler;
  List<T> _handlerContainer;
  _HandlerRegister(T this._handler, List<T> this._handlerContainer);
  void remove () {
    if(_handlerContainer != null) {
    {
      int handleIndex = _handlerContainer.indexOf(_handler);
      if(handleIndex >= 0) {
        _handlerContainer.removeRange(handleIndex, 1);
        }
      }
    }
    
  }
  
}
//TODO: I need to think how i can remove a handler from the topic
//TODO: check the blog where the callback is treated as future
//TODO: possible when the class as function posibility will be included i will be able to implement this
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
  
  void remove(K topic) {
    if(topic != null) {
      _topics.remove(topic);
    }
  }
  
  HandleRegistration<T> add(K topic, T listener) {
    var listeners = _topics[topic];
    if(listeners == null) {
      listeners = [];
      _topics[topic] = listeners;
    }
    
    listeners.add(listener);
    return new HandleRegistration<T>(listener, listeners);
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


class ContainerEvent <T extends Hashable> extends TopicEvent <T> {
  const ContainerEvent(T topic):super(topic); 
  
}

