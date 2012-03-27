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

class GadgetMessageHandler <T extends GadgetEvents>{
  GadgetEventBus<T> _eventBus;
  Messenger _messenger;
  
  GadgetMessageHandler(this._eventBus):this._messenger = new Messenger() {
    _messenger.listen((Map map) {
      handle(map);
    });
    
    _eventBus.on.appLoaded((AppStatusEvent event) {
      //TODO: work on container reference
      _messenger.sendMessage('container', JSON.stringify(event.fields()));
    });
    
    _eventBus.on.requestProcessed((AppStatusEvent event) {
      //TODO: work on the container reference
      _messenger.sendMessage('container', JSON.stringify(event.fields()));
    });
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