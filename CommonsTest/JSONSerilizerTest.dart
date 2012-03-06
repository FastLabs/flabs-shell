
class SerializeMe {
  String id;
  String data;
  
  SerializeMe.withData(String this.id, [String this.data]);
  SerializeMe();
  
  //int get id() => _id;
  //String get data()=>_data;
}

class JSONSerilizerTest {
  void run() {
    test('json serialization test' , () {
      
      Map<String, String> data = {'id': '1', 'data': 'some'};
      print (JSON.stringify(data));
    });    
  }  
}
