#library('application');
#import('dart:json');
#import('../commons/Commons.dart');


/**
* I imutable class that incapsulates the infromation about a application
*/
class Application {
  String _name;
  String _url;
  
  Map<String, String> _parameters;
  
  Application(this._name, [this._url]) {}
  
  Application._fromMap(Map<String, String> values) {
    _name = values['name'];
    _url = values['url'];
  }
  
  String get name() => _name;
  String get url() => _url;
  
  String operator [] (String name) => _parameters[name];
}

 class AppMessage <T>{
  String _from;
  String _to;
  T _payload;
  AppMessage(String this._from, String this._to, T this._payload);
  
}
 
 class AppStatusMessage extends AppMessage<AppStatus> {
   AppStatusMessage.loading(String from, String to):super(from, to, AppStatus.LOADING);
 }
  

interface AppAction  {
  static final String START = 'start';
  static final String CLOSE = 'close';
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
  
  ApplicationRepository.fromJson(String json) {
    
    var applicationList = JSON.parse(json);
    for(var applicationMap in applicationList) {
      Application  application = new Application._fromMap(applicationMap);
      print(application.name);
    }
    
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
