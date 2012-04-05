
class AppMessengerTest {
  void run() {
    group('messenger test', () {
      Application app = new Application('Admin');
      AppSession session = new AppSession('unu', app);
      SimpleGadgetEventBus eventBus = new SimpleGadgetEventBus(session);
      ContainerMessageBus containerMessageBus = new ContainerMessageBus();
      ApplicationRepository repository = new ApplicationRepository();
      repository.add(new Application('rules'));
      repository.add(new Application('admin'));
      SessionManager sessionManager = new SessionManager(containerMessageBus);
      ApplicationManager appManager = new ApplicationManager(containerMessageBus, sessionManager);
      SimpleMessenger messenger = new SimpleMessenger(sessionManager, containerMessageBus);
      GadgetMessageProcessor <SimpleGadgetEvents> messageHandler = new GadgetMessageProcessor(eventBus, messenger); 
     
      test('receiving resume message', () {
        
        bool processed = false;
        eventBus.on.resumeAppRequest((AppCommandEvent ev) {
          Expect.isTrue(ev is AppCommandEvent);
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
        eventBus.on.suspendAppRequest((AppCommandEvent ev){
          Expect.isTrue(ev is AppCommandEvent);
          print('suspend requested');
          processed = true;
        });
        Map data = {'name': 'Admin', 'action': 'suspend'};
        DataHandler handler = messenger.mockHandler;
        handler(data);
        Expect.isTrue(processed);
      });
      
      test('send loaded message to container', () {
        appManager.startAppInstance(new Application('rules'));
        bool processed = false;
        containerMessageBus.on.appLoaded((AppStatusEvent ev){
          print('------------- ${ev.session.app.name}');
          Expect.isTrue(ev is AppStatusEvent);
          Expect.equals('rules', ev.session.app.name);
          processed = true;
        });
        
       messenger.sendContainerMessage('{"session":"rules-0", "app":"rules", "status":"loaded" }');
       Expect.isTrue(processed);
      });
      
      test('send ' , () {
        
      });
    });
    
   
  }  
}
