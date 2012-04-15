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
  
  void _commandIs(AppCommandEvent event, String status) {
    Expect.isNotNull(event);
    Expect.isNotNull(event.session);
    Expect.isNotNull(event.session.app);
    Expect.isNotNull(event.command);
    Expect.equals(event.command, status);
  }

  void run() {
    
    group ('contaner messaging', () {
      Application rulesApp = new Application('rules');
      Application cpsApp = new Application('Cps');
      ContainerMessageBus eventBus = new ContainerMessageBus();
    
    test('load-app action ', () {
      Expect.isNotNull(eventBus);
      bool processed = false;
      HandleRegistration handler = eventBus.on.appLoaded((AppStatusEvent appStatus) {
        Expect.isNotNull(appStatus);
        Expect.isNotNull(appStatus.topic);
        Expect.equals(AppStatus.LOADED, appStatus.topic);
        Expect.isNotNull(appStatus.session.app);
        Expect.isNotNull(appStatus.session.app.name);
        Expect.equals('rules', appStatus.session.app.name);
        processed = true;
      }).handlerRegistration;
      AppSession session = new AppSession('unu', rulesApp);
      eventBus.appLoaded(session);
      handler.remove();
      Expect.isTrue(processed);
    });
    
    
    
    test('start-app action ', () {
      Expect.isNotNull(eventBus);
      bool processed = false;
      HandleRegistration handle = eventBus.on.appStartRequest((appEvent){
        Expect.isTrue(appEvent is AppCommandEvent);
        Expect.isNotNull(appEvent);
        
        Expect.isNotNull(appEvent.topic);
        Expect.equals(AppAction.START, appEvent.topic); 
        Expect.isNotNull(appEvent.session.app);
        Expect.isNotNull(appEvent.session.app.name);
        Expect.equals('Cps', appEvent.session.app.name);
        processed = true;
      }).handlerRegistration;
      AppSession session = new AppSession('doi', cpsApp);
      eventBus.appStartRequested(session);
      Expect.isTrue(processed);
      handle.remove();
    });
    
    test('resume application with view activation', () {
      Expect.isNotNull(eventBus);
      AppSession session = new AppSession('sapte', rulesApp);
      bool processed = false;
      HandleRegistration handler = eventBus.on.appResumeRequest((AppCommandEvent event, [var parameter = false]) {
        processed = true;
        Expect.isTrue(parameter);
        Expect.isNotNull(event);
        Expect.isNotNull(event.session);
        Expect.isNotNull(event.session.app);
        Expect.equals('rules', event.session.app.name);
      }).handlerRegistration;
      
      eventBus.requestAppResume(session, true);
      Expect.isTrue(processed);
      handler.remove();
      
    });
    
    test('resume application without view activation', () {
      Expect.isNotNull(eventBus);
      AppSession session = new AppSession('opt', rulesApp);
      bool processed = false;
      
      HandleRegistration handler = eventBus.on.appResumeRequest((AppCommandEvent event, [var parameter = false]) {
        processed = true;
        Expect.isFalse(parameter);
        
      }).handlerRegistration;
      eventBus.requestAppResume(session, false);
      Expect.isTrue(processed);
      handler.remove();
    });
    
    test('suspend application instance', () {
      Expect.isNotNull(eventBus);
      AppSession session = new AppSession('nine', rulesApp);
      bool processed = false;
      HandleRegistration handler = eventBus.on.appSuspendRequest((AppCommandEvent event) {
        processed = true;  
        _commandIs(event, AppAction.SUSPEND);
        Expect.equals(event.session.app.name, 'rules');
        
      }).handlerRegistration;
      
      eventBus.requestAppSuspend(session);
      Expect.isTrue(processed);
      
    });
    
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
      Application rulesApp = new Application('rules');
      ContainerMessageBus eventBus = new ContainerMessageBus();
      
      test('obtain handler registration', () {
        Expect.isNotNull(eventBus);  
        eventBus.on.appCloseRequest((event){
          Expect.isNotNull(event);    
        });
        
        Expect.isNotNull(eventBus.on.handlerRegistration);
        AppSession session = new AppSession('unu', rulesApp);
        eventBus.requestAppClose(session);
      });
      
     test('remove handler', () {
       Expect.isNotNull(eventBus);
       bool received = false;
       HandleRegistration registration = eventBus.on.appCloseRequest((even ) {
         received = true;
       }).handlerRegistration;
       
      registration.remove();
       eventBus.requestAppClose(new AppSession('unu', rulesApp));
       Expect.isFalse(received);   
     }); 
     
     test('test multiple handlers ', () {
      Expect.isNotNull(eventBus);
      int eventCount = 0;
      HandleRegistration appLoadedHandlerregistration = eventBus.on.appLoaded((event) {
        Expect.isNotNull(event);
        eventCount++;
      }).handlerRegistration;
      
      HandleRegistration appStartRequestHandler = eventBus.on.appStartRequest((event) {
        Expect.isNotNull(event);
        eventCount++;
      }).handlerRegistration;
      
      
      eventBus.appLoaded(new AppSession('unu', rulesApp));
      eventBus.appStartRequested(new AppSession('doi', new Application('admin')) );
      
      Expect.equals(2, eventCount);
      eventBus.appLoaded(new AppSession ('trei', new Application('roles')));
      Expect.equals(3, eventCount);
      appLoadedHandlerregistration.remove();
      eventBus.appLoaded(new AppSession('patru', new Application('users')));
      Expect.equals(3, eventCount);
      
      eventBus.appStartRequested(new AppSession('cinci', new Application('pricing')));
      Expect.equals(4, eventCount);
      appStartRequestHandler.remove();
      eventBus.appStartRequested(new AppSession ('sase', new Application('pricing')));
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
