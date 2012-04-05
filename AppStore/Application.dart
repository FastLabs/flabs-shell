#library('application');
#import('dart:json');
#import('../commons/Commons.dart');

/**
*  Incapsulates the infromation about a application
*/
class Application implements Taggable <String> {
  String _name;
  String description;
  TagContainer<String> _tags; 
  Map<String, String> _parameters; // not sure if this is required, mai be required to store genric info such as icon, help info, 
  //but may be better if this will have separte attributes in the class as i cannot see now to have many of such parameters
  AppLauncher _launcher;
  Application(this._name) {}
  
  String get name() => _name;
  AppLauncher get launcher() => _launcher;
  
  String operator [] (String name) => _parameters[name];
  
  void tagIt(String tag){
   if(_tags == null) {
     _tags = new TagContainer();
   }
   _tags.tagIt(tag);
  }
  
  void removeTag(String tag) {
    if(_tags != null) {
      _tags.removeTag(tag);
    }
  }
  
  bool isTagged(String hasTag) {
    if(_tags != null) {
      return _tags.isTagged(hasTag);
    }
    return false;
  }
}


class AppSession {
  String _sessionId;
  Application _app;
  
  AppSession(this._sessionId, this._app);
  
  String get id () => _sessionId;
  Application get app () => _app;
  
}




//TODO: must decide if the launcher is only url related or is the
// abstraction used for a particular application with its start parameters: url, shortcut and attributes

// launcher may represent only the url, and attributes are application specific?
class AppLauncher {
  String _url;
  String get url() => _url;
  Map<String, String> _attributes; 
  String shortcut;
  
  AppLauncher (this._url);
  
  String operator [] (String attrName) => _attributes != null? _attributes[attrName]: null;
    
}

 class AppMessage <T>{
  String _from;
  String _to;
  T _payload;
  AppMessage(String this._from, String this._to, T this._payload);
  
}
 
 class AppStatusMessage extends AppMessage<String> {
   AppStatusMessage.loading(String from, String to):super(from, to, AppStatus.LOADING);
 }
  

interface AppAction  {
  static final String START = 'start';
  static final String CLOSE = 'close';
  static final String ROUTE = 'route';
  static final String SUSPEND = 'suspend';
  static final String RESUME = 'resume';
  static final String INIT = 'init';
}
 
interface AppStatus  {
  static final String LOADING = 'loading';
  static final String LOADED = 'loaded';
  static final String PROCESSED = 'processed';
  static final String ERROR = 'error';
}
//TODO: remove this
class AppEventBus {
  
  void loading() {
    
  }
  
  void done() {
    
  }
  
  void loaded(){
    
  }
}

class ApplicationRepository implements Collection<Application> {
  List<Application> _applications;
  
  ApplicationRepository():this._applications = [];
  
  ApplicationRepository.fromJson(String json):this._applications = [] {
    List applicationList = JSON.parse(json);
    applicationList.forEach((map)=>_appFromMap(map));   
  }
  
  void add (Application app) {
    this._applications.add(app);
  }
  
  void _appFromMap(Map fields) {
   Application app = new Application(fields['name']);
   app.description = fields['description'];
   var launcherFields = fields['launcher'];
   if(launcherFields != null) {
     app._launcher = _launcherFromMap(launcherFields);
   }
   _applications.add(app);
  }
  
  AppLauncher _launcherFromMap(Map fields) {
    var url = fields['url'];
    if(url != null) {
      AppLauncher launcher = new AppLauncher(url);
      launcher.shortcut = fields['shortcut'];
      launcher._attributes = fields['attributes'];
      return launcher;
    }
    return null;
    
  }
  
  int get length() {
    if(_applications != null) {
      return _applications.length;
    }
    return 0;
  }
  
  bool isEmpty() => this.length == 0;
  bool some(bool f(Application app)) => _applications.some(f);
  bool every(bool f(Application app)) => _applications.every(f);
  Collection <Application> filter(bool f(Application app)) => _applications.filter(f);
  Collection map(f(Application app)) => _applications.map(f);
  
  void forEach(void f(Application app)) => _applications.forEach(f);
  Iterator <Application> iterator()=>_applications.iterator();
  
  Application operator [] (var id) { 
    if(id is int) {
     return _applications[id];
    } else {
      for(var app in _applications) {
        if(app.name == id) {
          return app;
        }
      }
      
    }
    return null;
  }
}

 

interface MessageBroadcaster <T> default AppMessageBroadcaster<T> {
  MessageBroadcaster(Application owner);
  void sendMessage(String destination, T payload);
  void statusMessage(AppStatus status);
}

/*class AppBroadcasterEvents extends AbstractMessageBroker {
  
  EventSet containerEvent(GenericEventListener handler) {
    add(handler);
    return this;
  }
  void dispatch(GenericEvent event) {
    
  }
}*/
/**
default implementation for the message broadcaster
*/
class AppMessageBroadcaster <T> implements MessageBroadcaster<T>{
  Application _owner;
  //AppBroadcasterEvents _on;
  
  AppMessageBroadcaster(Application this._owner){
    
  }
  
  void sendMessage(String destination, T payload) {
    
  }
  
  void statusMessage(AppStatus message) {
    
  }
  //AppBroadcasterEvents get() =>_on;
}



/**Message that delivers the status information to the container*/

//TODO: separate the status messages from the command messages
class AppStatusEvent extends ContainerEvent <String>{
  
  final AppSession _session;
  
  const AppStatusEvent.loaded(AppSession this._session): super(AppStatus.LOADED);
  const AppStatusEvent.loading(AppSession this._session): super(AppStatus.LOADING);
  const AppStatusEvent.processed(AppSession this._session): super(AppStatus.PROCESSED);
  
  AppSession get session() => _session;
  String get status() => topic;
  
  Map fields() {
    Map data = {};
    data['app'] = session.app.name; 
    data['status'] = status;
    return data;
  }
}



class AppCommandEvent extends ContainerEvent<String> {
  final AppSession _session;
  const AppCommandEvent.suspend(AppSession this._session): super(AppAction.SUSPEND);
  const AppCommandEvent.resume(AppSession this._session): super(AppAction.RESUME);
  const AppCommandEvent.init(AppSession this._session): super(AppAction.INIT);
  const AppCommandEvent.start(AppSession this._session): super(AppAction.START);
  const AppCommandEvent.close(AppSession this._session): super(AppAction.CLOSE);
  
  String get command() => topic;
  AppSession get session() => _session;
}

/**A message that contain routing information*/
class RouteMessageEvent extends ContainerEvent<String> {
  Application _source;
  Application _destination;
  String _payload;
  
  RouteMessageEvent(Application this._source, Application this._destination, [String this._payload]): super(AppAction.ROUTE);
  
  String get payload() => _payload;
  Application get source() => _source;
  Application get destination() => _destination;
  
}


