#import('dart:html');
#import('../Container/Container.dart');
#import('../AppStore/Application.dart');
#source('GadgetView.dart');

class ContainerView implements AppContainerView {
  
  ContainerMessageBus _messageBus;
  ApplicationRepository _appRepository;
  ApplicationManager _appManager;
  SessionManager _sessionManager;

  ContainerView():
    _messageBus = new ContainerMessageBus() {
    _appManager = new ApplicationManager(_messageBus);
    _sessionManager = new SessionManager(_messageBus, this);
   }

  void openApp(AppSession session) {
    
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
