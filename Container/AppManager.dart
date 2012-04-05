
/* container level application managemend*/

interface ManagesApplications default ApplicationManager {
  void startApplication(Application application);
  void closeApplication(Application application);
  AppStatus queryAppStatus(Application application);
}

class SessionManager {
  ContainerMessageBus _containerMessageBus;
  AppContainerView _view;
  
  Map<String, List<AppSession>> _sessions;
  
  SessionManager(ContainerMessageBus this._containerMessageBus, AppContainerView this._view): _sessions = {} {
    
    _containerMessageBus.on.appStartRequest((AppCommandEvent event) {
      AppSession session = _registerAppSession(event.app);
        this._view.openApp(session);
      });
    }
  
  List<AppSession> getSessions (String appId) {
    return _sessions[appId];
  }
  
  AppSession _registerAppSession(Application app) {
    var appSessions = _sessions[app.name];
    if(appSessions == null) {
      appSessions = [];
      _sessions[app.name] = appSessions;
    }
    int position = appSessions.length;
    var session = new AppSession('${app.name}-${position}', app);
    appSessions.add(session);
    return session;
  }
}

//TODO: application should work with app session so to close an applicaiton i must have session information
class ApplicationManager {
  ContainerMessageBus _containerMessageBus;
  
  ApplicationManager(ContainerMessageBus this._containerMessageBus);  
  
  void startAppInstance(Application app) {
    _containerMessageBus.requestAppStart(app);
  }
  
  
  void closeAppInstance(AppSession appInstance) {
    
    //_containerMessageBus.requestAppClose(app);
  }
}