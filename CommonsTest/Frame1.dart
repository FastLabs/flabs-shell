#import('dart:html');

//TODO: here I will define the message handler class that extends the gadget event bus
class Frame1 {
  
}

void main() {
  DivElement element = document.query('#frame1');
  element.innerHTML = 'frame 1 started';
  window.on.message.add((MessageEvent event) {
    print(event.data);
  });
}
