
class MessengerTest {
  void run() {
    Messenger m = new Messenger();
    
    String message = '{"status": "loaded", "application" : "rules"'
      '}';
    m.sendMessage('#frame2', message);
    print('done');
  }
}