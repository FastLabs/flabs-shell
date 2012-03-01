#library('application');
#import('dart:json');
#import('../events/GenericEvents.dart');


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
   AppStatusMessage.load(String from, String to):super(from, to, new AppStatus('load'));
 }
 
 class RuleAppMessage {
   String _artifact;
   RuleAppMessage([this._artifact]);
   String get artifact() =>  _artifact;
   
 }
 
class Key <T extends Hashable> implements Hashable {
  final T _value;
  const Key(T this._value);
  
  bool operator == (Object other) {
    if(other != null && other is Key<T>) {
      
      return hashCode() == other.hashCode();
    }
    return false;
  }
  
  int hashCode() {
    return _value.hashCode();
  }
  
  String toString() {
    if(_value != null) {
      return _value.toString();
    }
    return '';
  }
} 

class AppAction extends Key<String> {
  static final AppAction START = const AppAction._internal('start');
  static final AppAction CLOSE = const AppAction._internal('close');
  const AppAction._internal(String value):super(value);
}


 
class AppStatus extends Key<String> {
  static final AppStatus LOADING = const AppStatus._internal('loading');
  static final AppStatus LOADED = const AppStatus._internal('app-loaded');
  const AppStatus._internal(String this._status);

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
