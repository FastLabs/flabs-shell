#library('messenger');
#import('dart:html');
#import('dart:json');

typedef DataHandler(Map map);

class Messenger {

  void sendMessage(String destination, String content) {
    IFrameElement element = document.query(destination);
    element.contentWindow.postMessage(content, '*');
  }

  
  void listen(DataHAndler handler) {
    window.on.message.add((MessageEvent event) {
      Map parsed = JSON.parse(content);
      handler(parsed);
    });
  }
}
