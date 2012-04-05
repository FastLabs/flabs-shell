
/* container level application managemend*/

interface ManagesApplications default ApplicationManager {
  void startApplication(Application application);
  void closeApplication(Application application);
  AppStatus queryAppStatus(Application application);
}

class AppSession {
  String _sessionId;
  Application _app;
  
  AppSession(this._sessionId, this._app);
  
  String get sessionId () => _sessionId;
  Application get app () => _app;
  
}


class SessionManager {
  ContainerMessageBus _containerMessageBus;
  AppContainerView _view;
  
  Map<String, List<AppSession>> _sessions;
  
  SessionManager(ContainerMessageBus this._containerMessageBus, AppContainerView this._view): _sessions = {} {
    
    _containerMessageBus.on.appStartRequest((AppCommandEvent event) {
      
      _registerAppSession(event.app);
      
        this._view.openApp(event.app);
      });
    }
  
  List<AppSession> getSessions (String appId) {
    return _sessions[appId];
  }
  
  void _registerAppSession(Application app) {
    var appSessions = _sessions[app.name];
    if(appSessions == null) {
      appSessions = [];
      _sessions[app.name] = appSessions;
    }
    int position = appSessions.length;
    var session = new AppSession('${app.name}-${position}', app);
    appSessions.add(session);
  }
}

//TODO: application should work with app session so to close an applicaiton i must have session information
class ApplicationManager {
  ContainerMessageBus _containerMessageBus;
  
  ApplicationManager(ContainerMessageBus this._containerMessageBus);
  
  void startApp(Application app) {
    _containerMessageBus.requestAppStart(app);
  }
  
  void closeApp(Application app) {
    _containerMessageBus.requestAppClose(app);
  }
}