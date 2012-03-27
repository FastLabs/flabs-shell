#library('messenger');
#import('dart:html');

class MessageHandler {
  void handle();
}

class Messenger {
  void sendMessage() {
    IFrameElement element = document.query('#frame1');
    IFrameElement element2 = document.query('#frame2');    
    element.contentWindow.postMessage('Hello', '*');
    element2.contentWindow.postMessage('Hello1', '*');
  }  
}