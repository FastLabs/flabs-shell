#library('contaoner');
#import('../Events/GenericEvents.dart');
#import('../AppStore/Application.dart');

typedef AppEventHandler(ContainerEvent event);

/**
- load application
- close application
- suspend application: in case when we swithc the application context
- resume application
- load in progress 
- task in progress
- application loaded
- task done
*/


class ContainerEvent <T extends Hashable>extends TopicEvent <T> {
  ContainerEvent(T topic):super(topic); 
}


class AppStatusEvent extends ContainerEvent <AppStatus>{
  AppStatus _status;
  Application _app;
  
  AppStatusEvent.loaded(Application this._app): super(LOADED);
  AppStatusEvent.start(Application this._app): super(START);
  AppStatusEvent.close(Application this._app): super(CLOSE);
  
  AppStatus get status() => topic;
  Application get application() => _app;
}
/**
Encapsulates the events related to application container
*/
class ContainerEvents {
  TopicHandler<AppStatus, AppEventHandler> _handlers;
  ContainerEvents () :_handlers = new TopicHandler();
  
  ContainerEvents appLoaded(AppEventHandler handler) {
    _handlers.add(LOADED, handler);
    return this;
  }
  
  ContainerEvents appStartRequest(AppEventHandler handler) {
    _handlers.add(START, handler);
    return this;
  }
  
  ContainerEvents appCloseRequest(AppEventHandler handler) {
    _handlers.add(CLOSE, handler);
    return this;
  }
}


class ContainerMessageBus {
  ContainerEvents _on;
  
  ContainerMessageBus() : this._on = new ContainerEvents();
  
  void appLoaded(Application app) {
      _on._handlers.dispatch(new AppStatusEvent.loaded(app));
  }
  
  void requestAppStart(Application app) {
    _on._handlers.dispatch(new AppStatusEvent.start(app));
  }
  
  void requestAppClose(Application app) {
    _on._handlers.dispatch(new AppStatusEvent.close(app));
  }
  
  
  ContainerEvents get on() =>_on;
}