class EventsTest {

  EventsTest() {
  }

  void run() {
    
    write("Start event testing");
    test('event bus instantiation', () {
      SimpleEventBus bus = new SimpleEventBus();
      Expect.isNotNull(bus);
    });
    
    test('add event handler', () {
      SimpleEventBus bus = new SimpleEventBus();
      bus.on.genericEvent().add((event) {
        
      });
      
    });
    
    test('test message broadcasting', () {
      SimpleEventBus bus = new SimpleEventBus();
      bus.on.genericEvent().add((event) {
        Expect.isTrue(true);
      });
      
      bus.dispatch(new GenericEvent());
    });
  }

  void write(String message) {
    document.query('#status').innerHTML = message;
  }
}

class TopicEventBusTest {
  void run()  {
    test('topic intantiation' , () {
      TopicEventBus topic = new TopicEventBus();
      Expect.isNotNull(topic);
    });
    
    test('add topic handler', () {
      TopicEventBus topic = new TopicEventBus();
      
      topic.on.topicEvent('rules', (event) {
        Expect.equals('rules', event.topic);
      });
      
      topic.on.topicEvent('cps', (event) {
        Expect.equals('cps', event.topic);
      });
      
      topic.dispatch(new TopicEvent('rules'));
      topic.dispatch(new TopicEvent('cps'));
    });
    
    
  }
}