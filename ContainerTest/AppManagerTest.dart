class MockContainerView implements AppContainerView{
  void openApp(AppSession app) {
    
  }
}

class AppManagerTest {
  
  void run() {
    group('test application manager', () {
      Application app = new Application('Admin');  
      ContainerMessageBus _containerBus = new ContainerMessageBus();
      SessionManager _sessionManager = new SessionManager(_containerBus);
      ApplicationManager _appManager = new ApplicationManager(_containerBus, _sessionManager);
      
      test('start application', () {
        bool processed = false;
        _containerBus.on.appStartRequest((AppCommandEvent event) {
          Expect.isNotNull(event);
          Expect.isTrue(event is AppCommandEvent);
          Expect.isNotNull(event.session.app);
          Expect.equals(AppAction.START, event.command);
          Expect.equals('Admin', event.session.app.name);
          processed = true;
        });
        _appManager.startAppInstance(app);
        Expect.isTrue(processed);
      });
      
      test('close application', () {
        bool processed = false;
        _containerBus.on.appCloseRequest((AppCommandEvent ev) {
          Expect.isNotNull(ev);
          Expect.isTrue(ev is AppCommandEvent);
          Expect.isNotNull(ev.session.app);
          Expect.isNotNull(ev.command);
          Expect.equals(AppAction.CLOSE, ev.command);
          Expect.equals('unu', ev.session.id);
          Expect.equals('Admin', ev.session.app.name);
          processed= true;
        });
        AppSession session = new AppSession('unu', app);
        _appManager.closeAppInstance(session);
        Expect.isTrue(processed);
      });
    });
  }  
}
