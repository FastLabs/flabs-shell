
class AppRepositoryTest {
  void run() {
   group('', () {
     
    test('just application', () {
      ApplicationRepository repository = new ApplicationRepository.fromJson('[{"name":"Rules"}, {"name":"Admin"}]');
      Application app = repository.applications[0];
      Expect.isNotNull(app);
      Expect.equals('Rules', app.name);
      Expect.isNull(app.launcher);
    });
    
    test('launcher', () {
      var data = '[{"name": "Rules", "launcher": {"url":"http://apprepo.com"}}, '
        '{"name": "Admin"}]';  
      ApplicationRepository repository = new ApplicationRepository.fromJson(data);
      Application app0 = repository.applications[0];
      Expect.isNotNull(app0);
      Expect.equals('Rules', app0.name);
      Expect.isNotNull(app0.launcher);
      Expect.equals('http://apprepo.com', app0.launcher.url); 
    });
    
   });
  }
}
