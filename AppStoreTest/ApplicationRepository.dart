
class AppWrapper {
  Application app;
  AppWrapper(this.app);
}

class AppRepositoryTest {
  void run() {
   group('application repository test', () {
     
     var data = '[{"name": "Rules", "launcher": {"url":"http://apprepo.com"}}, '
       '{"name": "Admin"}]';  
     
    test('just application', () {
      ApplicationRepository repository = new ApplicationRepository.fromJson('[{"name":"Rules"}, {"name":"Admin"}]');
      Application app = repository[0];
      Expect.isNotNull(app);
      Expect.equals('Rules', app.name);
      Expect.isNull(app.launcher);
    });
    
    test('including launcher', () {
      ApplicationRepository repository = new ApplicationRepository.fromJson(data);
      Expect.isFalse(repository.isEmpty());
      Application app0 = repository[0];
      Expect.isNotNull(app0);
      Expect.equals('Rules', app0.name);
      Expect.isNotNull(app0.launcher);
      Expect.equals('http://apprepo.com', app0.launcher.url); 
    });
    
    test('repository iteration', () {
      ApplicationRepository repository = new ApplicationRepository.fromJson(data);
      Expect.isFalse(repository.isEmpty());
      var names = ['Rules', 'Admin'];
      int count = 0;
      repository.forEach((app) {
        Expect.isNotNull(app);
        Expect.equals(names[count++], app.name);
      });
    });
    
    test('empty repository', () {
      ApplicationRepository repository = new ApplicationRepository.fromJson('[]');
      Expect.isNotNull(repository);
      Expect.isTrue(repository.isEmpty());
    });
    
    test('some apps in repository', () {
      ApplicationRepository repository = new ApplicationRepository.fromJson(data);
      Expect.isFalse(repository.isEmpty());
      Expect.isTrue(repository.some((app)=>app.name=='Rules'));
      Expect.isFalse(repository.some((app)=> app.name=='Pricing'));      
    });
    
    test('filter applications', () {
      ApplicationRepository repository = new ApplicationRepository.fromJson(data);
      Expect.isFalse(repository.isEmpty());
      Collection <Application> rules = repository.filter((app)=> app.name == 'Rules');
      Expect.isNotNull(rules);
      Expect.equals(1, rules.length);
    });
    
    test('every application', () {
      ApplicationRepository repository = new ApplicationRepository.fromJson(data);
      Expect.isFalse(repository.isEmpty());
      Expect.isTrue(repository.every((app)=>app is Application));
    });
    
    test('map apps ', () {
      ApplicationRepository repository = new ApplicationRepository.fromJson(data);
      Expect.isFalse(repository.isEmpty());
      Collection wrappers = repository.map((app)=>new AppWrapper(app));
      Expect.isNotNull(wrappers);
      Expect.equals(2, wrappers.length);
      int count = 0;
      for(AppWrapper wrapper in wrappers) {
        Expect.equals(wrapper.app, repository[count++]);
      }
      
    });
    
   });
  }
}
