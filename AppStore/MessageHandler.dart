#library ('app message handler');
#import('Gadgetized.dart');
#import('../Commons/Messenger.dart');
#import('Application.dart');
#import('dart:json');

//TODO: an abstraction should be built on top fo a Message handler
// this is required due of diffferences how the container and gadget handles messages and 


class GadgetMessageProcessor <T extends GadgetEvents>  extends MessageProcessor {
  GadgetEventBus<T> _eventBus;
  Messenger _messenger;
  
  AppStatusHandler _statusHandler;
  
  GadgetMessageProcessor.usingMessenger(GadgetEventBus<T> eventBus, Messenger messenger): this(eventBus, messenger);
  GadgetMessageProcessor.usingWindowMessenger(GadgetEventBus<T> eventBus): this(eventBus, new Messenger());
  
  GadgetMessageProcessor(this._eventBus, Messenger this._messenger) {
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
  //TODO: have a look at the switch statement in order to improve the action handling
  void handle(Map messageAttributes) {
    String action = messageAttributes['action'];
    if(action != null) {
      switch(action) {
            case AppAction.RESUME : _eventBus.appResumed(); break;
            case AppAction.SUSPEND : _eventBus.appSuspended(); break;
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