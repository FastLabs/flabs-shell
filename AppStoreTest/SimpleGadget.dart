
//a simple message event, the payload is string
class SimpleMessageEvent extends GadgetMessageEvent<String> {
  SimpleMessageEvent(payload):super(payload);
}

// demo class of a gadget specific event handler
class SimpleGadgetEvents extends GadgetEvents <SimpleMessageEvent> {
  TopicHandler <String, MessageHandler<SimpleMessageEvent>> _simpleMessageHandlers;
  
  SimpleGadgetEvents () : this._simpleMessageHandlers = new TopicHandler();
  
  SimpleGadgetEvents message(MessageHandler<SimpleMessageEvent> handler) {
    this.handlerRegistration = _simpleMessageHandlers.add(GadgetMessageEvent.MESSAGE_PORT, handler);
    return this;
  }
}
//gadget event bus
class SimpleGadgetEventBus extends GadgetEventBus<SimpleGadgetEvents> {
  
  SimpleGadgetEventBus(Application app):super(new SimpleGadgetEvents(), app);
  
  void dispatchMessage(SimpleMessageEvent message) {
    on._simpleMessageHandlers.dispatch(message);
  }
}


class SimpleMessenger implements Messenger {
  
  DataHandler mockHandler;
  
  ContainerMessageProcessor _containerMessageHandler;
  
  SimpleMessenger(ApplicationRepository repository, ContainerMessageBus containerMessageBus):
    this._containerMessageHandler = new ContainerMessageProcessor(repository ,containerMessageBus);
  
  
  void sendAppMessage(String destination) {
    print(destination);
  }
  void sendContainerMessage(String content) {
    Map data = JSON.parse(content);
    _containerMessageHandler.handle(data);
  }
  void listen(DataHandler handler) {
    this.mockHandler = handler;
  }
}