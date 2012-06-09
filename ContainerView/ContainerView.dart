#import('dart:html');
#import('../Container/Container.dart');
#import('../AppStore/Application.dart');
#source('GadgetView.dart');

class ContainerView implements AppContainerView {
  
  ContainerMessageBus _messageBus;
  ApplicationRepository _appRepository;
  ApplicationManager _appManager;

  ContainerView():
    _messageBus = new ContainerMessageBus() {
    _messageBus.on.appStartRequest((ev)=>openApp(ev.session.app));
    _appManager = new ApplicationManager(_messageBus);
    _appRepository = new ApplicationRepository();
    _initAppRepository();
    _render();
    
   }
  
  void _initAppRepository() {
    _appRepository.add(new Application('Admin'));
    _appRepository.add(new Application('Pricing'));
  }
  
  void _render() {
    DivElement container = document.query('.nav-list');
    
    _appRepository.forEach((Application app) {
      Element listElement = new Element.tag('li');
      AnchorElement hashElement = new Element.tag('a');
      hashElement.text = app.name;
      hashElement.href = '#';
      hashElement.on.click.add((event) {
        window.alert('clicked');
      });
      listElement.elements.add(hashElement);
     container.elements.add(listElement);
    });
  }

  void openApp(AppSession session) {
    IFrameElement iframe = new Element.tag('iframe');
    DivElement container = document.query('#container');
  }

  void run() {
    //Application app = new Application('Rules');
    ///_messageBus.requestAppStart(app);
  }

  void write(String message) {
    document.query('#status').innerHTML = message;
  }
}

void main() {
  new ContainerView().run();
}
