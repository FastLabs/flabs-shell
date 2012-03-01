class MockMessageBroadcaster implements MessageBroadcaster <RuleAppMessage> {
  Application _owner;
  
  MockMessageBroadcaster (Application this._owner);
  void statusMessage(AppStatus message) {
    
  }
  
  void sendMessage(String destination, RuleAppMessage message) {
    print('${destination} ${message.artifact}');
  }
}

class AppInstanceTest {
  void run() {
    
    test('Application instantiation',() {
      Application application = new Application('Rules');
      Expect.equals(application.name, 'Rules');
      
    });
    
    test('Message broadcaster instantiation', () {
      Application application = new Application('Rules');
      Expect.isNotNull(application);
      MessageBroadcaster<RuleAppMessage> ruleAppBroadcaster = new MessageBroadcaster<RuleAppMessage>(application);
      Expect.isNotNull(ruleAppBroadcaster);       
      
    });
    
    test('broadcasting messages',  () {
      Application application = new Application('Rules');
      MockMessageBroadcaster broadcaster = new MockMessageBroadcaster(application);
      broadcaster.sendMessage('cps', new RuleAppMessage('Guidelines/Account'));
            
    });
    
    test('app status', () {
      AppStatus s = AppStatus.LOADING;
      Expect.equals('loaded', s.toString());
      AppStatus s1 = AppStatus.LOADED;
      Expect.isTrue(s.hashCode() == s1.hashCode());
      Expect.isTrue(s == s1);
    });
    
    test('app action instantiation', () {
      AppAction action = AppAction.START;
      Expect.isNotNull(action);
      AppAction action1 = AppAction.CLOSE;
      Expect.isNotNull(action1);  
    });
    
    test('app action hashcode', () {
      Expect.isTrue(AppAction.START.hashCode() != AppAction.CLOSE.hashCode());
    });
    
  }
  
}
