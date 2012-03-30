
class AppMessengerTest {
  void run() {
    group('messenger test', () {
      Application app = new Application('Admin');
      SimpleGadgetEventBus eventBus = new SimpleGadgetEventBus(app);
      ContainerMessageBus containerMessageBus = new ContainerMessageBus();
      SimpleMessenger messenger = new SimpleMessenger();
      GadgetMessageHandler <SimpleGadgetEvents> messageHandler = new GadgetMessageHandler(eventBus, messenger); 
      bool received = false;
      
      
      
      
      test('receiving resume message', () {
        bool processed = false;
        eventBus.on.resumeAppRequest((handler) {
          print('resume requested');
          processed = true;
        });
        DataHandler handler = messenger.mockHandler;
        Map data = {'name': 'Admin', 'action': 'resume'};
        handler(data);
        Expect.isTrue(processed);
      });
      
      test('receiving suspend message', (){
        bool processed = false;
        eventBus.on.suspendAppRequest((handler){
          print('suspend requested');
          processed = true;
        });
        Map data = {'name': 'Admin', 'action': 'suspend'};
        DataHandler handler = messenger.mockHandler;
        handler(data);
        Expect.isTrue(processed);
      });
    });
  }  
}
