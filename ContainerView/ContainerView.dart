#import('dart:html');
#import('../Container/Container.dart');
#import('../AppStore/Application.dart');

class ContainerView {
  
  ContainerMessageBus _messageBus;
  ApplicationRepository _appRepository;

  ContainerView():
    _messageBus = new ContainerMessageBus() {
    _messageBus.on.appStartRequest((AppStatusEvent event) {
      write('Application started: ${event.application.name}');
    });
  }

  void run() {
    Application app = new Application('Rules');
    _messageBus.requestAppStart(app);
  }

  void write(String message) {
    document.query('#status').innerHTML = message;
  }
}

void main() {
  new ContainerView().run();
}
