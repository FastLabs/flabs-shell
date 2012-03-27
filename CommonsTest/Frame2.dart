
#import('dart:html');
class Frame2 {
  
}

void main() {
  DivElement element = document.query('#frame2');
  element.innerHTML = 'frame 2 started';
  window.on.message.add((MessageEvent event) {
    print(event.data);
  });
}