#library('gadgetized');
#import('Application.dart');
#import('../Commons/Commons.dart');

typedef void GadgetEventHandler(CommandEvent event);
typedef void ContainerMessageHandler(ContainerMessage message);

class CommandEvent extends ContainerEvent<String> {
  static final String EVENT_PORT = 'GADGET_COMMAND_PART';
  final String _command;
  const CommandEvent.suspend():super(EVENT_PORT), this._command = 'suspend';
  const CommandEvent.resume():super(EVENT_PORT), this._command = 'resume';
  const CommandEvent.init():super(EVENT_PORT), this._command = 'init';
  
  String get command() => _command;
}

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
      this.handlerRegistration = _containerCommandHandler.add(CommandEvent.EVENT_PORT, handler);
      return this;
    }
    
    GadgetEvents containerMessage(ContainerMessageHandler handler) {
      this.handlerRegistration = _containerMessageHandler.add(ContainerMessage.EVENT_PORT, handler);
      return this;
    }
} 

class GadgetEventBus {
  GadgetEvents _on;
  Application _app;
  GadgetEventBus(this._app);
  
  void appResumed() {
    
    _on._containerCommandHandler.dispatch();
    
  }
  
  void appLoaded() {
    
  }
  
  GadgetEvents get on() => _on;
}