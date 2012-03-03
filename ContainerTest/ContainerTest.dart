#import('dart:html');
#import ('../testing/dartest/dartest.dart');
#import ('../testing/unittest/unittest_dartest.dart');
#import('../Container/Container.dart');
#import('../AppStore/Application.dart');

class ContainerTest {

  ContainerTest() {
  }

  void run() {
    write("Run container tests");
    
    test('test instantiation',() {
      ContainerMessageBus eventBus = new ContainerMessageBus();
      Expect.isNotNull(eventBus);
    });
    
    test('load-app action ', () {
      ContainerMessageBus eventBus = new ContainerMessageBus();
      eventBus.on.appLoaded((appStatus) {
        Expect.isNotNull(appStatus);
        Expect.isNotNull(appStatus.topic);
        Expect.equals(AppStatus.LOADED, appStatus.topic);
        Expect.isNotNull(appStatus.application);
        Expect.isNotNull(appStatus.application.name);
        Expect.equals('rules', appStatus.application.name);
      });
      
      eventBus.appLoaded(new Application('rules'));
    });
    
    
    
    test('start-app action ', () {
      ContainerMessageBus eventBus = new ContainerMessageBus();
      eventBus.on.appStartRequest((appEvent){
        Expect.isNotNull(appEvent);
        Expect.isNotNull(appEvent.topic);
        Expect.equals(AppAction.START, appEvent.topic); 
        Expect.isNotNull(appEvent.application);
        Expect.isNotNull(appEvent.application.name);
        Expect.equals('Cps', appEvent.application.name);
      });
      eventBus.requestAppStart(new Application('Cps'));
    });
    
    
    group('message routing' , () {
      
      Application rulesApp = new Application('Rules');
      Application adminApp = new Application('Admin');
      
      
      test('route message action', () {
        ContainerMessageBus eventBus = new ContainerMessageBus();
        eventBus.on.route((RouteMessageEvent event) {
          Expect.isNotNull(event);
          Expect.isNotNull(event.source);
          Expect.isNotNull(event.destination);
          Expect.isNotNull(event.source.name);
          Expect.isNotNull(event.destination.name);
          Expect.equals('Rules', event.source.name);
          Expect.equals('Admin', event.destination.name);
          Expect.isNotNull(event.payload);
          Expect.equals('Hello from rules', event.payload);
      });
      eventBus.routeMessage(rulesApp, adminApp, 'Hello from rules');
    });
    
    test('route empty payload action', () {
      ContainerMessageBus eventBus = new ContainerMessageBus();
      eventBus.on.route((RouteMessageEvent event) {
        Expect.isNotNull(event);
        Expect.isNotNull(event.source);
        Expect.isNotNull(event.destination);
        Expect.isNull(event.payload);
        });
      eventBus.routeMessage(rulesApp, adminApp);
       });
    
    });
    
  }
  
  
  void _validateAppStatus () {
    
  }

  void write(String message) {
    document.query('#status').innerHTML = message;
  }
}

void main() {
  new ContainerTest().run();
  new DARTest().run();
}
