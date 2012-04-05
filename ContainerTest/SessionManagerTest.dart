class MockView implements AppContainerView {
  void openApp(AppSession session) {
    print('${session.app.name} loaded');
  }
}


class SessionManagerTest {
 void run() {
   group('session id allocation', () {
     Application app = new Application('Admin');
     ContainerMessageBus _messageBus = new ContainerMessageBus();
     AppContainerView _view = new MockView();
     SessionManager _sessionManager = new SessionManager(_messageBus, _view);
     ApplicationManager _manager = new ApplicationManager(_messageBus);
     
     test('simple session', () {
       _manager.startApp(app);
       List<AppSession> sessions = _sessionManager.getSessions(app.name);
       Expect.isNotNull(sessions);
       Expect.equals(1, sessions.length);
     });
     
     
   });
 } 
}
