#library('Container');
#import('../AppStore/Application.dart');
#import('../commons/Commons.dart');
typedef AppEventHandler(ContainerEvent event);
typedef AppRouteHandler(RouteMessageEvent event);
typedef AppRepositoryHandler(AppRepositoryEvent event);

/**
- load application
- close application
- suspend application: in case when we switch the application context
- resume application
- load in progress 
- task in progress
- application loaded
- task done
*/

/**Message that delivers the status information to the container*/
class AppStatusEvent extends ContainerEvent <String>{
  Application _app;
  AppStatusEvent.loaded(Application this._app): super(AppStatus.LOADED);
  AppStatusEvent.start(Application this._app): super(AppAction.START);
  AppStatusEvent.close(Application this._app): super(AppAction.CLOSE);
  Application get application() => _app;
}

class AppRepositoryEvent extends ContainerEvent<String> {
  Collection<Application> _apps;
  
  AppRepositoryEvent.loaded(Collection<Application> this._apps):super('REPOSITORY_LOADED');
  Collection<Application> get apps() => _apps;
}

/**A message that contain routing information*/
class RouteMessageEvent extends ContainerEvent<String> {
  Application _source;
  Application _destination;
  String _payload;
  
  RouteMessageEvent(Application this._source, Application this._destination, [String this._payload]): super(AppAction.ROUTE);
  
  String get payload() => _payload;
  Application get source() => _source;
  Application get destination() => _destination;
  
}
/**
Encapsulates the events related to application container
*/
class ContainerEvents {
  TopicHandler<String, AppEventHandler> _actionHandlers;
  TopicHandler<String, AppEventHandler> _statusHandlers;
  TopicHandler<String, AppRouteHandler> _routingHandlers;
  TopicHandler<String, AppRepositoryHandler> _appRepoHandler;
  HandleRegistration handlerRegistration;
  
  ContainerEvents () :_actionHandlers = new TopicHandler(),
                      _statusHandlers = new TopicHandler(),
                      _routingHandlers = new TopicHandler(),
                      _appRepoHandler = new TopicHandler();
  
  ContainerEvents appLoaded(AppEventHandler handler) {
    this.handlerRegistration = _statusHandlers.add(AppStatus.LOADED, handler);
    return this;
  }
  ContainerEvents appRepositoryLoaded(AppRepositoryHandler handler) {
    this.handlerRegistration = _appRepoHandler.add('REPOSITORY_LOADED', handler);
    return this;
  }
  
  ContainerEvents route(AppRouteHandler handler) {
    this.handlerRegistration =_routingHandlers.add(AppAction.ROUTE, handler);
    return this;
  }
  
  ContainerEvents appStartRequest(AppEventHandler handler) {
    this.handlerRegistration =_actionHandlers.add(AppAction.START, handler);
    return this;
  }
  
  ContainerEvents appCloseRequest(AppEventHandler handler) {
    this.handlerRegistration = _actionHandlers.add(AppAction.CLOSE, handler);
    return this;
  }
}


class ContainerMessageBus {
  ContainerEvents _on;
  
  ContainerMessageBus() : this._on = new ContainerEvents();
  
  void appLoaded(Application app) {
    _on._statusHandlers.dispatch(new AppStatusEvent.loaded(app));
      
  }
  
  void appRepositoryProvided(Collection<Application> apps) {
    _on._appRepoHandler.dispatch(new AppRepositoryEvent.loaded(apps));
  }
  
  void routeMessage(Application from, Application to,[ String payload]) {
    _on._routingHandlers.dispatch(new RouteMessageEvent(from, to, payload));
  }
  
  void requestAppStart(Application app) {
    _on._actionHandlers.dispatch(new AppStatusEvent.start(app));
  }
  
  void requestAppClose(Application app) {
    _on._actionHandlers.dispatch(new AppStatusEvent.close(app));
  } 
  
  ContainerEvents get on() =>_on;
}