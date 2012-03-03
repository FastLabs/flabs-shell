#import('../testing/dartest/dartest.dart');
#import('../testing/unittest/unittest_dartest.dart');
#import('dart:html');
#import('../commons/Commons.dart');

#source('EventTest.dart');

class CommonTests {

  CommonTests() {
  }

  void run() {
    write("Common libraries test");
    new EventsTest().run();
  }

  void write(String message) {
    document.query('#status').innerHTML = message;
  }
}

void main() {
  new CommonTests().run();
  new DARTest().run();
  
}
