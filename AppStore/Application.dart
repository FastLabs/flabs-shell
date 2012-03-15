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
}
 
interface AppStatus  {
  static final String LOADING = 'loading';
  static final String LOADED = 'loaded';
}

class AppEventBus {
  
  void loading() {
    
  }
  
  void done() {
    
  }
  
  void loaded(){
    
  }
}


interface ManagesApplications default ApplicationManager {
  void startApplication(Application application);
  void closeApplication(Application application);
  AppStatus queryAppStatus(Application application);
}

class ApplicationRepository implements Iterator<Application> {
  List<Application> applications;
  
  ApplicationRepository():this.applications = [];
  
  ApplicationRepository.fromJson(String json):this.applications = [] {
    List applicationList = JSON.parse(json);
    applicationList.forEach((map)=>_appFromMap(map));   
  }
  
  void addApplication (Application app) {
    this.applications.add(app);
  }
  
  void _appFromMap(Map fields) {
   Application app = new Application(fields['name']);
   app.description = fields['description'];
   var launcherFields = fields['launcher'];
   if(launcherFields != null) {
     app._launcher = _launcherFromMap(launcherFields);
   }
   applications.add(app);
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
  
  bool hasNext() {
    return true;
  }
  Application next(){
    return null;
  }
  
  Application operator [] (String name) {
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

class ApplicationManager {
  
  void startApplication(Application application) {
    print('application ${application.name} started');
  }
  
  void closeApplication(Application application) {
    print('application ${application.name} stoped');
  }
  
  AppStatus queryAppStatus(Application application) {
    print('application ${application.name} has status ...');
  }
  
}
