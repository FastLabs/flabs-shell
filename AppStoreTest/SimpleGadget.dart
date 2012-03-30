
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
  
  GadgetMessageHandler<ContainerEvent> _serverMessageHandler;
  
  SimpleMessenger(ContainerMessageBus containerMessageBus): this._serverMessageHandler = new GadgetMessageHandler<ContainerMessageBus>(containerMessageBus);
  
  
  void sendAppMessage(String destination) {
    print(destination);
  }
  void sendContainerMessage(String content) {
    print(content);
   // Expect.fail('Not yet implemented');
  }
  void listen(DataHandler handler) {
    this.mockHandler = handler;
  }
}