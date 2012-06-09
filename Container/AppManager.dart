
/* container level application managemend*/

interface ManagesApplications default ApplicationManager {
  void startApplication(Application application);
  void closeApplication(Application application);
  AppStatus queryAppStatus(Application application);
}

class SessionManager {
  ContainerMessageBus _containerMessageBus;
  
  Map<String, List<AppSession>> _sessions;
  
  SessionManager(ContainerMessageBus this._containerMessageBus): _sessions = {} {
    
    /*_containerMessageBus.on.appStartRequest((AppCommandEvent event) {
      AppSession session = _registerAppSession(event.session);
        this._view.openApp(session);
      });*/
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


class ApplicationManager {
  ContainerMessageBus _containerMessageBus;
  SessionManager _sessionManager;
  
  ApplicationManager(ContainerMessageBus containerMessageBus) :
    this._containerMessageBus = containerMessageBus,
    this._sessionManager = new SessionManager(containerMessageBus);  
  
  void startAppInstance(Application app) {
    _containerMessageBus.appStartRequested(_sessionManager._registerAppSession(app));
  }
  
  
  void closeAppInstance(AppSession appInstance) {
    _containerMessageBus.requestAppClose(appInstance);
  }
  
  void activateSession(AppSession appInstance) {
    
  }
  //TODO: this is temporar solution, check the messenger
  SessionManager  get sessionManager () => _sessionManager;
}