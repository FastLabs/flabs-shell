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
    
    group('handler registration', () {
      test('obtain handler registration', () {
        ContainerMessageBus eventBus = new ContainerMessageBus();
        eventBus.on.appCloseRequest((event){
          Expect.isNotNull(event);    
        });
        
        Expect.isNotNull(eventBus.on.handlerRegistration);
        eventBus.requestAppClose(new Application('rules'));
      });
      
     test('remove handler', () {
       ContainerMessageBus eventBus = new ContainerMessageBus();
       bool received = false;
       HandlerRegistration registration = eventBus.on.appCloseRequest((even ) {
         received = true;
       }).handlerRegistration;
       
      registration.remove();
       eventBus.requestAppClose(new Application('Rules'));
       Expect.isFalse(received);   
     }); 
     
     test('test multiple handlers ', () {
      ContainerMessageBus eventBus = new ContainerMessageBus();
      int eventCount = 0;
      HandlerRegistration appLoadedHandlerregistration = eventBus.on.appLoaded((event) {
        Expect.isNotNull(event);
        eventCount++;
      }).handlerRegistration;
      
      HandlerRegistration appStartRequestHandler = eventBus.on.appStartRequest((event) {
        Expect.isNotNull(event);
        eventCount++;
      }).handlerRegistration;
      
      
      eventBus.appLoaded(new Application('rules'));
      eventBus.requestAppStart(new Application('admin'));
      
      Expect.equals(2, eventCount);
      eventBus.appLoaded(new Application('roles'));
      Expect.equals(3, eventCount);
      appLoadedHandlerregistration.remove();
      eventBus.appLoaded(new Application('users'));
      Expect.equals(3, eventCount);
      
      eventBus.requestAppStart(new Application('pricing'));
      Expect.equals(4, eventCount);
      appStartRequestHandler.remove();
      eventBus.requestAppStart(new Application('pricing'));
      Expect.equals(4, eventCount);
      
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
