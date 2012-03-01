
class KeyTest { 
  
  void run() {
    test('generic key instaintiation', () {
      Key<String> key1 = new Key<String>('hello'); 
      Expect.isNotNull(key1);
      Expect.equals('hello', key1.toString());
    });
    
    test('test key hashcode', () {
      Key<String> key1 = new Key<String>('hello');
      Key<String> key2 = new Key<String>('hello');
      Expect.equals(key1, key2);
      
    });
  }

}
