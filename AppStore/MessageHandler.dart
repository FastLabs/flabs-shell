#library ('app message handler');
#import('Gadgetized.dart');
#import('../Commons/Messenger.dart');
#import('Application.dart');
#import('dart:json');

//TODO: I think this should go in the application library
class InitAppHandler {
  void handle() {
    
  }
}

class ResumeAppHandler {
  void handle() {
    
  }
}

class SuspendAppHandler {
  void handle() {
    
  }
}

//TODO: an abstraction should be built on top fo a Message handler
// this is required due of diffferences how the container and gadget handles messages and 

class GadgetMessageHandler <T extends GadgetEvents> {
  GadgetEventBus<T> _eventBus;
  Messenger _messenger;
  
  AppStatusHandler _statusHandler;
  
  GadgetMessageHandler.usingMessenger(GadgetEventBus<T> eventBus, Messenger messenger): this(eventBus, messenger);
  GadgetMessageHandler.usingWindowMessenger(GadgetEventBus<T> eventBus): this(eventBus, new Messenger());
  
  GadgetMessageHandler(this._eventBus, this._messenger) {
    _messenger.listen((Map map) {
      handle(map);
    });
    
    //TODO: when the lazy field initialization will be available move this at the declaration level
    _statusHandler =  (AppStatusEvent event) {
      _messenger.sendContainerMessage(JSON.stringify(event.fields()));
    };
 
    _eventBus.on.appLoaded(_statusHandler); 
    _eventBus.on.requestProcessed(_statusHandler);
  }
  
  void handle(Map messageAttributes) {
    String action = messageAttributes['action'];
    if(action != null) {
      if(action == 'resume') {
        _eventBus.appResumed();
      } else if(action == 'suspend') {
        _eventBus.appSuspended();
      }
      if(messageAttributes.containsKey('payload')) {
        //TODO: parse the content
        //TODO: if the action is init then the message should have payload
      }
      
      
      //TODO: when the container is asked to route a message it will transform in a init message (consider to rename the init message )
      //in something more generic as container will send commands and if the message has a payload I think the gadget will treat in
      // the same way the message: will take an action
      
    }
  }
}