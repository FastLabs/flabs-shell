#library('gadgetized');
#import('Application.dart');
#import('../commons/Commons.dart');

typedef void GadgetEventHandler(AppCommandEvent event);
typedef void ContainerMessageHandler(ContainerMessage message);

class ContainerMessage extends ContainerEvent <String> {
  static final String EVENT_PORT = 'CONTAINER_MESSAGE_PORT';
  
  final String message;
  const ContainerMessage(this.message):super(EVENT_PORT);
}


class GadgetEvents {
  
    TopicHandler<String, GadgetEventHandler> _containerCommandHandler;
    TopicHandler<String, ContainerMessageHandler> _containerMessageHandler;
    
    
    GadgetEvents (): 
      _containerCommandHandler = new TopicHandler(),
      _containerMessageHandler = new TopicHandler();
    
    HandleRegistration handlerRegistration;
    
    GadgetEvents suspendAppRequest(GadgetEventHandler handler) {
      this.handlerRegistration = _containerCommandHandler.add(AppAction.SUSPEND, handler);
      return this;
    }
    
    GadgetEvents containerMessage(ContainerMessageHandler handler) {
      this.handlerRegistration = _containerMessageHandler.add(ContainerMessage.EVENT_PORT, handler);
      return this;
    }
} 

class GadgetEventBus {
  final GadgetEvents _on;
  final Application _app;
  
  const GadgetEventBus(this._app): this._on = new GadgetEvents();
  
  void appResumed() {
    _on._containerCommandHandler.dispatch(new AppCommandEvent.resume(_app));
    
  }
  
  void appLoaded() {
    _on._containerCommandHandler.dispatch(new AppCommandEvent.suspend(_app));
  }
  
  void appSuspended() {
    _on._containerCommandHandler.dispatch(new  AppCommandEvent.suspend(_app));
  }
  
  GadgetEvents get on() => _on;
}