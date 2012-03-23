class SimpleMessageEvent extends GadgetMessageEvent<String> {
  SimpleMessageEvent(payload):super(payload);
}
// demo classa of a gadget specific event handler
class SimpleGadgetEvents extends GadgetEvents <SimpleMessageEvent> {
  TopicHandler <String, MessageHandler<SimpleMessageEvent>> _simpleMessageHandlers;
  
  SimpleGadgetEvents () : this._simpleMessageHandlers = new TopicHandler();
  
  SimpleGadgetEvents message(MessageHandler<SimpleMessageEvent> handler) {
    this.handlerRegistration = _simpleMessageHandlers.add(GadgetMessageEvent.MESSAGE_PORT, handler);
    return this;
  }
}

class SimpleGadgetEventBus extends GadgetEventBus<SimpleGadgetEvents> {
  
  SimpleGadgetEventBus(Application app):super(new SimpleGadgetEvents(), app);
  
  void dispatchMessage(SimpleMessageEvent message) {
    on._simpleMessageHandlers.dispatch(message);
  }
  
}

//test suite
class GadgetizedTest {  
  void run() {
    group('gatdet', () {
      Application app = new Application('Rules');
      SimpleGadgetEventBus eventBus = new SimpleGadgetEventBus(app);
      
      test('suspend application', () {
        Expect.isNotNull(eventBus);
        bool processed = false;
       HandleRegistration handle = eventBus.on.suspendAppRequest((AppCommandEvent event){
          processed = true;
          Expect.equals('suspend',event.command);
          Expect.equals('Rules', event.app.name);
         // Expect.isFalse(true);
        }).handlerRegistration;
        eventBus.appSuspended();
        Expect.isTrue(processed);
        handle.remove();
      });
      
      test('resume application event', () {
        Expect.isNotNull(eventBus);
        bool processed = false;
        HandleRegistration handle = eventBus.on.resumeAppRequest((AppCommandEvent event) {
          processed = true;
          Expect.equals('Rules', event.app.name);
        }).handlerRegistration;
        
        eventBus.appResumed();
        Expect.isTrue(processed);
        handle.remove();
        
      });
      
      test('close application event', () {
        Expect.isNotNull(eventBus);
        bool processed = false;
        
        HandleRegistration handle = eventBus.on.closeAppRequest((AppCommandEvent event) {
          processed = true;
          Expect.equals('Rules', event.app.name);
        }).handlerRegistration;
        eventBus.appClosed();
        Expect.isTrue(processed);
        
        handle.remove();
        
      });
      
      test('handle registration', () {
        Expect.isNotNull(eventBus);
        bool processed = false;
        HandleRegistration handle = eventBus.on.resumeAppRequest((AppCommandEvent event) {
          processed = true;
        }).handlerRegistration;
        eventBus.appResumed();
        Expect.isTrue(processed);
        
        handle.remove();
        processed = false;
        eventBus.appResumed();
        Expect.isFalse(processed);
        
      });
      
      test('custom gadget message', () {
        Expect.isNotNull(eventBus);
        bool processed = false;
        eventBus.on.message((SimpleMessageEvent event) {
          processed = true;
          Expect.isNotNull(event);
          Expect.isNotNull(event.payload);
        });
        eventBus.dispatchMessage(new SimpleMessageEvent('hello'));
        Expect.isTrue(processed);
      });
    });
  }
}