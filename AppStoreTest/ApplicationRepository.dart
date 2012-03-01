
testJsonReader() {
  ApplicationRepository repository = new ApplicationRepository.fromJson('[{"name":"Rules"}, {"name":"Admin"}]');
  applicationConstructor();
}

applicationConstructor() {
  Application application = new Application._fromMap(null);
}