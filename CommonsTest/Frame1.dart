#import('dart:html');
class Frame1 {
  
}

void main() {
  DivElement element = document.query('#frame1');
  element.innerHTML = 'frame 1 started';
  window.on.message.add((MessageEvent event) {
    print(event.data);
  });
}
