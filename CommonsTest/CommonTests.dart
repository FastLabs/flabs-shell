#import('../testing/dartest/dartest.dart');
#import('../testing/unittest/unittest_dartest.dart');
#import('dart:html');
#import('dart:json');
#import('../commons/Commons.dart');

#source('EventTest.dart');
#source('JSONSerilizerTest.dart');

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
  //new CommonTests().run();
  new JSONSerilizerTest().run();
  new DARTest().run();
  
}
