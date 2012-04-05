#import('dart:html');
#import ('../testing/dartest/dartest.dart');
#import ('../testing/unittest/unittest_dartest.dart');
#import('../Container/Container.dart');
#import('../AppStore/Application.dart');
#import('../commons/Commons.dart');
#source('AppManagerTest.dart');
#source('SessionManagerTest.dart');

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
        Expect.isNotNull(appStatus.app);
        Expect.isNotNull(appStatus.app.name);
        Expect.equals('rules', appStatus.app.name);
      });
      
      eventBus.appLoaded(new Application('rules'));
    });
    
    
    
    test('start-app action ', () {
      ContainerMessageBus eventBus = new ContainerMessageBus();
      eventBus.on.appStartRequest((appEvent){
        Expect.isTrue(appEvent is AppCommandEvent);
        Expect.isNotNull(appEvent);
        Expect.isNotNull(appEvent.topic);
        Expect.equals(AppAction.START, appEvent.topic); 
        Expect.isNotNull(appEvent.app);
        Expect.isNotNull(appEvent.app.name);
        Expect.equals('Cps', appEvent.app.name);
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
       HandleRegistration registration = eventBus.on.appCloseRequest((even ) {
         received = true;
       }).handlerRegistration;
       
      registration.remove();
       eventBus.requestAppClose(new Application('Rules'));
       Expect.isFalse(received);   
     }); 
     
     test('test multiple handlers ', () {
      ContainerMessageBus eventBus = new ContainerMessageBus();
      int eventCount = 0;
      HandleRegistration appLoadedHandlerregistration = eventBus.on.appLoaded((event) {
        Expect.isNotNull(event);
        eventCount++;
      }).handlerRegistration;
      
      HandleRegistration appStartRequestHandler = eventBus.on.appStartRequest((event) {
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
    
    group('app repository', () {
      ApplicationRepository repository = new ApplicationRepository.fromJson('[{"name":"rules"}, '
        '{"name": "admin"}]');
      test('app repository as collection', () {
       Expect.isNotNull(repository[0]);
       Expect.isNotNull(repository[1]);
      });
      
      test('app repository events', () {
        ContainerMessageBus eventBus = new ContainerMessageBus();
      eventBus.on.appRepositoryLoaded((appEvent) {
        Expect.isNotNull(appEvent.apps[0]);
        Expect.equals('rules', appEvent.apps[0].name);
      });
      eventBus.appRepositoryProvided(repository);
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
  new AppManagerTest().run();
  new SessionManagerTest().run();
  new DARTest().run();
}
