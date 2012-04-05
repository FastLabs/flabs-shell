class MockContainerView implements AppContainerView{
  void openApp(Application app) {
    
  }
}

class AppManagerTest {
  
  void run() {
    group('test application manager', () {
      Application app = new Application('Admin');  
      ContainerMessageBus _containerBus = new ContainerMessageBus();
      ApplicationManager _appManager = new ApplicationManager(_containerBus);
      
      test('start application', () {
        bool processed = false;
        _containerBus.on.appStartRequest((AppCommandEvent event) {
          Expect.isNotNull(event);
          Expect.isTrue(event is AppCommandEvent);
          Expect.isNotNull(event.app);
          Expect.equals(AppAction.START, event.command);
          Expect.equals('Admin', event.app.name);
          processed = true;
        });
        _appManager.startApp(app);
        Expect.isTrue(processed);
      });
      
      test('close application', () {
        bool processed = false;
        _containerBus.on.appCloseRequest((AppCommandEvent ev) {
          Expect.isNotNull(ev);
          Expect.isTrue(ev is AppCommandEvent);
          Expect.isNotNull(ev.app);
          Expect.isNotNull(ev.command);
          Expect.equals(AppAction.CLOSE, ev.command);
          Expect.equals('Admin', ev.app.name);
          processed= true;
        });
        
        _appManager.closeApp(app);
        Expect.isTrue(processed);
      });
    });
  }  
}
