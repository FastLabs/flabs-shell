/*class MockMessageBroadcaster implements MessageBroadcaster <RuleAppMessage> {
  Application _owner;
  
  MockMessageBroadcaster (Application this._owner);
  void statusMessage(AppStatus message) {
    
  }
  
  void sendMessage(String destination, RuleAppMessage message) {
    print('${destination} ${message.artifact}');
  }
}*/

class AppInstanceTest {
  void run() {
    
    test('Application instantiation',() {
      Application application = new Application('Rules');
      Expect.equals(application.name, 'Rules');
      
    });
    
    test('Message broadcaster instantiation', () {
      /*Application application = new Application('Rules');
      Expect.isNotNull(application);
      MessageBroadcaster<RuleAppMessage> ruleAppBroadcaster = new MessageBroadcaster<RuleAppMessage>(application);
      Expect.isNotNull(ruleAppBroadcaster);       
      */
    });
  group('tag application', () {
    
    test(' check tag exists', () {
      Application app = new Application('Rules');
      app.tagIt('engine');
      Expect.isTrue(app.hasTag('engine'));
      
    });
    
    test('tag does not exist', () {
      Application app = new Application('Rules');
      app.tagIt('engine');
      Expect.isFalse(app.hasTag('admin'));
    });
    
  });
    
    test('broadcasting messages',  () {
      /*Application application = new Application('Rules');
      MockMessageBroadcaster broadcaster = new MockMessageBroadcaster(application);
      broadcaster.sendMessage('cps', new RuleAppMessage('Guidelines/Account'));
      */      
    });
    
  }
  
}
