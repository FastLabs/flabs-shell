//test suite
class GadgetizedTest {  
  void run() {
    group('gatdet', () {
      Application app = new Application('Rules');
      AppSession session = new AppSession('unu', app);
      SimpleGadgetEventBus eventBus = new SimpleGadgetEventBus(session);
      
      test('suspend application', () {
        Expect.isNotNull(eventBus);
        bool processed = false;
       HandleRegistration handle = eventBus.on.suspendAppRequest((AppCommandEvent event){
          processed = true;
          Expect.equals('suspend',event.command);
          Expect.equals('Rules', event.session.app.name);
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
          Expect.equals('Rules', event.session.app.name);
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
          Expect.equals('Rules', event.session.app.name);
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