
/* container level application managemend*/

interface ManagesApplications default ApplicationManager {
  void startApplication(Application application);
  void closeApplication(Application application);
  AppStatus queryAppStatus(Application application);
}


class SessionManager {
  ContainerMessageBus _containerMessageBus;
  AppContainerView _view;
  
  SessionManager(ContainerMessageBus this._containerMessageBus, AppContainerView this._view) {
    _containerMessageBus.on.appStartRequest((AppCommandEvent event) {
        this._view.openApp(event.app);
      });
    }
}

class ApplicationManager {
  ContainerMessageBus _containerMessageBus;
  
  ApplicationManager(ContainerMessageBus this._containerMessageBus);
  
  void startApplication(Application app) {
    _containerMessageBus.requestAppStart(app);
  }
  
  void closeApplication(Application app) {
    _containerMessageBus.requestAppClose(app);
  }
  
  AppStatus queryAppStatus(Application application) {
    print('application ${application.name} has status ...');
  }
}