
#import('dart:html');
#import('../commons/Messenger.dart');
class Frame2 {
  
}

void main() {
  DivElement element = document.query('#frame2');
  element.innerHTML = 'frame 2 started';
  
  Messenger messenger = new Messenger();
  //messenger.listen();
 
}