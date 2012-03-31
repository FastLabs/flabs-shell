#library('Container');
#import('../AppStore/Application.dart');
#import('../commons/Commons.dart');
#import('../commons/Messenger.dart');
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



class AppRepositoryEvent extends ContainerEvent<String> {
  Collection<Application> _apps;
  
  AppRepositoryEvent.loaded(Collection<Application> this._apps):super('REPOSITORY_LOADED');
  Collection<Application> get apps() => _apps;
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

//TODO: probably I should rename this to Event bus as message is used to comunicate between windows and applications
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
    _on._actionHandlers.dispatch(const AppCommandEvent.start(app));
  }
  
  void requestAppClose(Application app) {
    _on._actionHandlers.dispatch(const AppCommandEvent.close(app));
  } 
  
  ContainerEvents get on() =>_on;
}


//TODO: this should be implemented
class ContainerMessageProcessor extends MessageProcessor {
  ContainerMessageBus _containerMessageBus;
  ApplicationRepository _repository;
  
  
  ContainerMessageProcessor(ApplicationRepository this._repository, ContainerMessageBus this._containerMessageBus) {
    //here should be defined the handlers that will send messages to applications such as : init, route...
    //_containerMessageBus.on.appLoaded(handler)
  }
  //TODO: have a look at the switch statement in order to improve status handling
  void handle(Map message) {
    var status = message['status'];
    var action = message['action'];
    
    var app = _repository[message['name']];
    if(app != null && status != null ) {
      if(status == 'loaded') {
        _containerMessageBus.appLoaded(app);
      } else if(action == 'route' ) {
        //TODO: this is wrong but added here just to elaborate the logic of message handling
        var destination = message['destination'];
        if(destination != null) {
          var destApp = _repository[message[destination]];
          var payload = message['payload'];
          if(destApp != null) {
            _containerMessageBus.routeMessage(app, destApp, payload);
          } else {
            throw 'Application ${destination} is unavailable in repository';
          }
        }
      }
    }
  }
}