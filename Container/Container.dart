#library('contaoner');
#import('../AppStore/Application.dart');
#import('../commons/Commons.dart');
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


abstract class ContainerEvent <T extends Hashable> extends TopicEvent <T> {
  ContainerEvent(T topic):super(topic); 
  
}

class AppStatusEvent extends ContainerEvent <String>{
  Application _app;
  
  AppStatusEvent.loaded(Application this._app): super(AppStatus.LOADED);
  AppStatusEvent.start(Application this._app): super(AppAction.START);
  AppStatusEvent.close(Application this._app): super(AppAction.CLOSE);
  
  Application get payload() => _app;
}
/**
Encapsulates the events related to application container
*/
class ContainerEvents {
  TopicHandler<String, AppEventHandler> _actionHandlers;
  TopicHandler<String, AppEventHandler> _statusHandlers;
  
  ContainerEvents () :_actionHandlers = new TopicHandler(),
                      _statusHandlers = new TopicHandler();
  
  ContainerEvents appLoaded(AppEventHandler handler) {
    _statusHandlers.add(AppStatus.LOADED, handler);
    return this;
  }
  
  ContainerEvents appStartRequest(AppEventHandler handler) {
    _actionHandlers.add(AppAction.START, handler);
    return this;
  }
  
  ContainerEvents appCloseRequest(AppEventHandler handler) {
    _actionHandlers.add(AppAction.CLOSE, handler);
    return this;
  }
}


class ContainerMessageBus {
  ContainerEvents _on;
  
  ContainerMessageBus() : this._on = new ContainerEvents();
  
  void appLoaded(Application app) {
    _on._statusHandlers.dispatch(new AppStatusEvent.loaded(app));
      
  }
  
  void requestAppStart(Application app) {
    _on._actionHandlers.dispatch(new AppStatusEvent.start(app));
  }
  
  void requestAppClose(Application app) {
    _on._actionHandlers.dispatch(new AppStatusEvent.close(app));
  }
  
  
  ContainerEvents get on() =>_on;
}