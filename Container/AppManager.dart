
/* container level application managemend*/

interface ManagesApplications default ApplicationManager {
  void startApplication(Application application);
  void closeApplication(Application application);
  AppStatus queryAppStatus(Application application);
}


class SessionManager {
  ContainerMessageBus _containerMessageBus;
  
  SessionManager(ContainerMessageBus this._containerMessageBus) {
    
    _containerMessageBus.on.appStartRequest((ContainerEvent event) {
      event.
    });
    }
}

class ApplicationManager {
  ContainerMessageBus _containerMessageBus;
  
  ApplicationManager(ContainerMessageBus this._containerMessageBus);
  
  void startApplication(Application app) {
    _containerMessageBus.requestAppStart(app);
  }
  
  void closeApplication(Application application) {
    print('application ${application.name} stoped');
  }
  
  AppStatus queryAppStatus(Application application) {
    print('application ${application.name} has status ...');
  }
}