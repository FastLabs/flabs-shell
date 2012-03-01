#import('dart:html');
#import ('../testing/dartest/dartest.dart');
#import ('../testing/unittest/unittest_dartest.dart');
#import('../AppStore/Application.dart');
#source('ApplicationRepository.dart');
#source('AppInstance.dart');

void main() {
 /* TableElement table = new Element.tag('table');
  TableCellElement testId = new Element.tag('td');
  TableRowElement row = new Element.tag('tr');
  table.classes.add('my-class');
   testId.text ='123';
   row.elements.add(testId);
   table.elements.add(row);
  document.body.elements.add(table);
  */
  
document.query('#status').innerHTML = 'loaded';
  
  new AppInstanceTest().run();
  
  
  new DARTest().run();
  
 /* ApplicationManager appManager = new ApplicationManager();
  
  Application application = new Application('Rules');
  print('-> ${application.name}');
  appManager.startApplication(application);
  
  testJsonReader();*/
}
