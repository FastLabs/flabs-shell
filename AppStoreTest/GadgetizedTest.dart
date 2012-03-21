
class GadgetizedTest {
  
  void run() {
    group('gatdet', () {
      Application app = new Application('Rules');
      GadgetEventBus eventBus = new GadgetEventBus(app);
      
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
      
      test('resume application', () {
        
      });
      
      test('handle registration', () {
        
        
      });
    });
  }
}