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
    
    test('load-app status ', () {
      ContainerMessageBus eventBus = new ContainerMessageBus();
      eventBus.on.appLoaded((appStatus) {
        Expect.isNotNull(appStatus);
        Expect.isNotNull(appStatus.status);
        Expect.equals(LOADED, appStatus.status);
        Expect.isNotNull(appStatus.application);
        Expect.isNotNull(appStatus.application.name);
        Expect.equals('rules', appStatus.application.name);
      });
      
      eventBus.appLoaded(new Application('rules'));
    });
    
    
    
    test('start-app status', () {
      ContainerMessageBus eventBus = new ContainerMessageBus();
      eventBus.on.appStartRequest((appEvent){
        Expect.isNotNull(appEvent);
        Expect.isNotNull(appEvent.status);
        Expect.equals(START, appEvent.status); 
        Expect.isNotNull(appEvent.application);
        Expect.isNotNull(appEvent.application.name);
        Expect.equals('Cps', appEvent.application.name);
      });
      eventBus.requestAppStart(new Application('Cps'));
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
