#library('messenger');
#import('dart:html');
#import('dart:json');


typedef DataHandler(Map map);

 class MessageProcessor {
  abstract void handle(Map messageAttributes);
}

interface Messenger default WindowMessenger {
  void sendAppMessage(String destination);
  void sendContainerMessage(String content);
  void listen(DataHandler handler);
} 

class WindowMessenger implements Messenger {

  void sendAppMessage(String destination, String content) {
    IFrameElement element = document.query(destination);
    element.contentWindow.postMessage(content, '*');
  }
  
  void sendContainerMessage(String content) {
    if(window != window.parent) {
      window.parent.postMessage(content, '*');
    }
  }

  
  void listen(DataHandler handler) {
    window.on.message.add((MessageEvent event) {
      Map parsed = JSON.parse(content);
      handler(parsed);
    });
  }
}
