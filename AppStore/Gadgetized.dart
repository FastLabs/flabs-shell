#library('gadgetized');
#import('Application.dart');
#import('../commons/Commons.dart');

typedef void GadgetEventHandler(AppCommandEvent event);
typedef void ContainerMessageHandler(ContainerMessage message);
typedef void MessageHandler<T>(T message); 
typedef void AppStatusHandler(AppStatusEvent event);

class ContainerMessage extends ContainerEvent <String> {
  static final String EVENT_PORT = 'CONTAINER_MESSAGE_PORT';
  
  final String message;
  const ContainerMessage(this.message):super(EVENT_PORT);
}


 class GadgetEvents <T extends GadgetMessageEvent>{
    TopicHandler<String, GadgetEventHandler> _containerCommandHandler;
    TopicHandler<String, ContainerMessageHandler> _containerMessageHandler;
    TopicHandler<String, AppStatusHandler> _statusMessageHandler;

    GadgetEvents (): 
      _containerCommandHandler = new TopicHandler(),
      _containerMessageHandler = new TopicHandler(),
      _statusMessageHandler = new TopicHandler();
    
    HandleRegistration handlerRegistration;
    
    GadgetEvents suspendAppRequest(GadgetEventHandler handler) {
      this.handlerRegistration = _containerCommandHandler.add(AppAction.SUSPEND, handler);
      return this;
    }
    
    GadgetEvents appLoaded(AppStatusHandler handler) {
      this.handlerRegistration = _statusMessageHandler.add(AppStatus.LOADED, handler);
      return this;
    }
    
    GadgetEvents requestProcessed(AppStatusHandler handler) {
      this.handlerRegistration = _statusMessageHandler.add(AppStatus.PROCESSED, handler);
      return this;
    }
    
    GadgetEvents closeAppRequest(GadgetEventHandler handler) {
      this.handlerRegistration = _containerCommandHandler.add(AppAction.CLOSE, handler);
      return this;
    }
    
    GadgetEvents resumeAppRequest(GadgetEventHandler handler) {
      this.handlerRegistration = _containerCommandHandler.add(AppAction.RESUME, handler);
      return this;
    }
    
    GadgetEvents containerMessage(ContainerMessageHandler handler) {
      this.handlerRegistration = _containerMessageHandler.add(ContainerMessage.EVENT_PORT, handler);
      return this;
    }
    
   // abstract Y message(MessageHandler<T> handler);
} 

class GadgetEventBus <T extends GadgetEvents>{
  final T _on;
  final Application _app;
  
  const GadgetEventBus(T this._on, Application this._app);

  
  void appResumed() {
    _on._containerCommandHandler.dispatch(new AppCommandEvent.resume(_app));
    
  }
  
  void appClosed() {
    _on._containerCommandHandler.dispatch(new AppCommandEvent.close(_app));
  }
  
  void appLoaded() {
    _on._statusMessageHandler.dispatch(new AppStatusEvent.loaded(_app));
  }
  
  void appSuspended() {
    _on._containerCommandHandler.dispatch(new  AppCommandEvent.suspend(_app));
  }
  T get on() => _on;
}

class GadgetMessageEvent <T> extends ContainerEvent <String> {
  
  static final String MESSAGE_PORT = 'MESSAGE_PORT';
  T _payload;
  
  GadgetMessageEvent([this._payload]):super(MESSAGE_PORT);
  T get payload()=> _payload;
}

