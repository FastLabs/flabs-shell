// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#library('dartest');

//#import('dart:dom');
#import('dart:html');
#import('../unittest/unittest_dartest.dart');


#source('css.dart');

interface Elements {
  Element get containerDiv();
  Element get mainElem();
  Element get testBody();
  Element get testsRunElem();
  Element get testsFailedElem();
  Element get testsErrorsElem();
  Element get orange();
  Element get red();
  Element get green();
  Element get coverageBody();
  Element get covPreElem();
  Element get covTableBody();
}

class AppElements implements Elements {
  Element containerDiv;
  Element mainElem;
  Element testBody;
  Element testsRunElem;
  Element testsFailedElem;
  Element testsErrorsElem;
  Element orange;
  Element red;
  Element green;
  Element coverageBody;
  Element covPreElem;
  Element covTableBody;
}


/** DARTest provides a library to run tests in the app. */
class DARTest{
  AppElements _inAppElements, _fullAppElements, _appElements;
  Window _runnerWindow;

  DARTest() { 
    _runnerWindow = window;
    dartestLogger = _log;
    _inAppElements = new AppElements();
    _appElements = _inAppElements;
    DARTestCss.inject(document, true);
  }
  
  void run() {
    _renderMain();
    _createResultsTable();
  }

  void _log(String message) {
    _runnerWindow.console.log(message);
  }
  
  /** Create the results table after loading tests. */
  void _createResultsTable() {
    _log('Creating results table');
    TableElement table = new Element.tag('table');
    table.classes.add('dt-results');
    HeadElement head = new Element.tag('thead');
    head.innerHTML = '<tr><th>ID <th>Description <th>Result';
    table.elements.add(head);
    TableSectionElement body = new Element.tag('tbody');
    body.id = 'dt-results-body';
    tests.forEach((final t) {
      TableRowElement testDetailRow = 
        new Element.tag('tr');
      testDetailRow.id = 'dt-test-${t.id}';
      _addTestDetails(t, testDetailRow);
      body.elements.add(testDetailRow);
      
      TableRowElement testMessageRow = 
        new Element.tag('tr');
      testMessageRow.id = 'dt-detail-${t.id}';
      testMessageRow.classes.add('dt-hide');
      body.elements.add(testMessageRow);
    });
    
    table.elements.add(body);
    
    if(_appElements.testBody != null) {
      _appElements.testBody.elements.add(table);
    }
  }

  /** Update the results table for test. */
  void _updateResultsTable(TestCase t, Window domWin) {
    TableRowElement row = document.query('#dt-test-${t.id}');
    row.classes.add('dt-result-row');
    row.innerHTML = ''; // Remove all children as we will re-populate them
    _addTestDetails(t, row);
    
    TableRowElement details = document.query('#dt-detail-${t.id}');
    details.elements.add(_getTestStats(t, domWin));
    
    row.on.click.add( (event ) {
      if(details.classes.contains ('dt-hide')) {
        details.classes.clear();
      } else {
        details.classes.add('dt-hide');
      }
    });
  } 
  
  /** Escape HTML special chars. */
  String _escape(String str) {
    str = str.replaceAll('&','&amp;');
    str = str.replaceAll('<','&lt;');
    str = str.replaceAll('>','&gt;');
    str = str.replaceAll('"','&quot;');
    str = str.replaceAll("'",'&#x27;');
    str = str.replaceAll('/','&#x2F;');
    return str;
  }
  
  /** Get test results as table cells. */
  void _addTestDetails(TestCase t, TableRowElement row) {
    TableCellElement testId = new Element.tag('td');
    testId.text = '${t.id}';
    row.elements.add(testId);
    
    TableCellElement testDesc = new Element.tag('td');
    testDesc.text = t.description;
    row.elements.add(testDesc);
    
    TableCellElement testResult = new Element.tag('td');
    String result = (t.result == null) ? 'none' : _escape(t.result);
    testResult.classes.add('dt-$result');
    testResult.title = '${_escape(t.message)}';
    testResult.text = result.toUpperCase();
    row.elements.add(testResult);
  }
  
  TableCellElement _getTestStats(TestCase t, Window domWin) {
    TableCellElement tableCell = new Element.tag('td');
    tableCell.colSpan = 3;
    
    if(t.message != '') {
      SpanElement messageSpan = new Element.tag('span');
      messageSpan.text = t.message;
      tableCell.elements.add(messageSpan);
      tableCell.elements.add(new Element.tag('br'));
    }
    if(t.stackTrace != null) {
      PreElement stackTacePre = new Element.tag('pre');
      stackTacePre.text = t.stackTrace;
    }
    
    SpanElement durationSpan = new Element.tag('span');
    durationSpan.text = 'took ${_printDuration(t.runningTime)}';
    tableCell.elements.add(durationSpan);
    
    return tableCell;
  }
  
  /** Update the UI after running test. */
  void _updateDARTestUI(TestCase test_) {
    _updateResultsTable(test_, window);
    if(_runnerWindow != window) {
      _updateResultsTable(test_, _runnerWindow);
    }
    
    if(test_.result != null) {
      _log('  Result: ${test_.result.toUpperCase()} ${test_.message}');
    }
    if(test_.runningTime != null) {
      _log('  took ${_printDuration(test_.runningTime)}');
    }
    _updateStatusProgress(_appElements);
    if(_runnerWindow != window) {
      _updateStatusProgress(_inAppElements);
    }
  }
  
  void _updateStatusProgress(AppElements elements) {
    // Update progressbar
    var pPass = 
      ((testsRun - testsFailed - testsErrors) / tests.length) * 100;
    elements.green.style.width = '$pPass%';
    var pFailed = pPass + (testsFailed / tests.length) * 100;
    elements.red.style.width = '$pFailed%';
    var pErrors = pFailed + (testsErrors / tests.length) * 100;
    elements.orange.style.width = '$pErrors%';

    // Update status
    elements.testsRunElem.text = testsRun.toString();
    elements.testsFailedElem.text = testsFailed.toString();
    elements.testsErrorsElem.text = testsErrors.toString();
  }
  
  String _printDuration(Duration timeDuration) {
    StringBuffer out = new StringBuffer();
    if(timeDuration.inDays > 0) {
      out.add('${timeDuration.inDays} days ');
    }
    if(timeDuration.inHours > 0) {
      out.add('${timeDuration.inHours} hrs ');
    }
    if(timeDuration.inMinutes > 0) {
      out.add('${timeDuration.inMinutes} mins ');
    }
    if(timeDuration.inSeconds > 0) {
      out.add('${timeDuration.inSeconds} s ');
    }
    if(timeDuration.inMilliseconds > 0 || out.length == 0) {
      out.add('${timeDuration.inMilliseconds} ms');
    }
    return out.toString();
  }

  /** Populates the floating div with controls and toolbar. */
  DivElement _renderMain() {
    DivElement containerDiv = new Element.tag('div');
    containerDiv.classes.add('dt-container');
    _appElements.containerDiv = containerDiv;
    
    // Add the test controls
    DivElement mainElem = new Element.tag('div');
    mainElem.classes.add('dt-main');
    _appElements.mainElem = mainElem;
    
    _showTestControls();
    
    // Create header to hold window controls
    if(_runnerWindow == window) {
      DivElement headDiv = new Element.tag('div');
      headDiv.classes.add('dt-header');
      headDiv.innerHTML = 'DARTest: In-App View';
      ImageElement close = new Element.tag('img');
      close.classes.add('dt-header-close');
      close.on.click.add((event) {
        containerDiv.classes.add('dt-hide');
      });
     
      ImageElement pop = new Element.tag('img');
      pop.classes.add('dt-header-pop');
      pop.on.click.add((event)=> _dartestMaximize());
      
      ImageElement minMax = new Element.tag('img');
      minMax.classes.add( 'dt-header-min');
      minMax.on.click.add((event) {
        if (mainElem.classes.contains('dt-hide')) {
          mainElem.classes.remove('dt-hide');
          mainElem.classes.add('dt-show');
          minMax.classes.add('dt-header-min');
        } else {
          if (mainElem.classes.contains('dt-show')) {
            mainElem.classes.remove('dt-show');
          }
          mainElem.classes.add('dt-hide');
          minMax.classes.add('dt-header-max');
        }
      });
      
      
      headDiv.elements.add(close);
      headDiv.elements.add(pop);
      headDiv.elements.add(minMax);
      
      containerDiv.elements.add(headDiv);
    }

    DivElement tabDiv = new Element.tag('div');
    tabDiv.classes.add('dt-tab');
    UListElement tabList = new Element.tag('ul');
    LIElement testingTab = new Element.tag('li');
    LIElement coverageTab = new Element.tag('li');
    testingTab.classes.add('dt-tab-selected');
    testingTab.text = 'Testing';
    testingTab.on.click.add((event){
      _showTestControls();
      _changeTabs(testingTab, coverageTab);
    });
    
    tabList.elements.add(testingTab);
    coverageTab.text = 'Coverage';
    coverageTab.on.click.add((event){
      _showCoverageControls();
      _changeTabs(coverageTab, testingTab);
    });
    
    tabList.elements.add(coverageTab); 
    tabDiv.elements.add(tabList);
    containerDiv.elements.add(tabDiv);
    
    if(_runnerWindow != window) {
      DivElement popIn = new Element.tag('div');
      popIn.classes.add('dt-minimize');
      popIn.innerHTML = 'Pop In &#8690;';
      popIn.on.click.add((event) => _dartestMinimize());
      containerDiv.elements.add(popIn);
    }  
    containerDiv.elements.add(mainElem);
    _runnerWindow.document.body.elements.add(containerDiv);
  }
  
  void _changeTabs(LIElement clickedTab, LIElement oldTab) {
    oldTab.classes.clear();
    clickedTab.classes.add('dt-tab-selected');
  }
  
  void _showTestControls() {
    DivElement testBody = _appElements.testBody;
    if(testBody == null) {
      testBody = new Element.tag('div');
      _appElements.testBody = testBody;
    
      // Create a toolbar to hold action buttons
      DivElement toolDiv = new Element.tag('div');
      toolDiv.classes.add( 'dt-toolbar');
      ButtonElement runBtn = new Element.tag('button');
      runBtn.innerHTML = '&#9658;';
      runBtn.title = 'Run Tests';
      runBtn.classes.add('dt-button dt-run');
      runBtn.on.click.add((event) {
        _log('Running tests');
        updateUI = _updateDARTestUI;
        runDartests();
      });
      toolDiv.elements.add(runBtn);
      ButtonElement exportBtn = new Element.tag('button');
      exportBtn.innerHTML = '&#8631;';
      exportBtn.title = 'Export Results';
      exportBtn.classes.add('dt-button dt-run');
      exportBtn.on.click.add((event) {
        _log('Exporting results');
        _exportTestResults();
      });
      
      toolDiv.elements.add(exportBtn);
      testBody.elements.add(toolDiv);
      
      // Create a datalist element for showing test status
      DListElement statList = new Element.tag('dl');
      statList.classes.add('dt-status');
      Element runsDt = new Element.tag('dt');
      runsDt.text = 'Runs:';
      statList.elements.add(runsDt);
      Element testsRunElem = new Element.tag('dd');
      _appElements.testsRunElem = testsRunElem;
      testsRunElem.text = testsRun.toString();
      statList.elements.add(testsRunElem);
  
      Element failDt = new Element.tag('dt');
      failDt.text = 'Failed:';
      statList.elements.add(failDt);
      Element testsFailedElem = new Element.tag('dd');
      _appElements.testsFailedElem = testsFailedElem;
      testsFailedElem.text = testsFailed.toString();
      statList.elements.add(testsFailedElem);
  
      Element errDt = new Element.tag('dt');
      errDt.text = 'Errors:';
      statList.elements.add(errDt);
      Element testsErrorsElem = new Element.tag('dd');
      _appElements.testsErrorsElem = testsErrorsElem;
      testsErrorsElem.text = testsErrors.toString();
      statList.elements.add(testsErrorsElem);  
      testBody.elements.add(statList);
      
      // Create progressbar and add red, green, orange bars
      DivElement progressDiv = new Element.tag('div');
      progressDiv.classes.add('dt-progressbar');
      progressDiv.innerHTML = "<span style='width:100%'></span>";
      
      SpanElement orange = new Element.tag('span');
      _appElements.orange = orange;
      orange.classes.add('orange');
      progressDiv.elements.add(orange);
  
      SpanElement red = new Element.tag('span');
      _appElements.red = red;
      red.classes.add('red');
      progressDiv.elements.add(red);
      
      SpanElement green = new Element.tag('span');
      _appElements.green = green;
      green.classes.add('green');
  
      progressDiv.elements.add(green);
      testBody.elements.add(progressDiv);
      
      DivElement hiddenElem = new Element.tag('div');
      hiddenElem.classes.add('dt-hide');
      hiddenElem.innerHTML = 
        "<a id='dt-export' download='test_results.csv' href='#' />";
      testBody.elements.add(hiddenElem);
      
      if(_appElements.mainElem != null) {
        _appElements.mainElem.elements.add(testBody);
      }
    }
    
    // Show hide divs
    _show(_appElements.testBody);
    _hide(_appElements.coverageBody);
  } 
  
  void _showCoverageControls() {
    DivElement coverageBody = _appElements.coverageBody;
    if(coverageBody == null) {
      coverageBody = new Element.tag('div');
      _appElements.coverageBody = coverageBody;
      
      PreElement covPreElem = new Element.tag('pre');
      _appElements.covPreElem = covPreElem;
      coverageBody.elements.add(covPreElem);
      
      TableElement covTable = new Element.tag('table');
      covTable.classes.add('dt-results');
      TableSectionElement head = new Element.tag('thead');
      head.innerHTML = '<tr><th>Unit <th>Function <th>Statement <th>Branch';
      covTable.elements.add(head);
      TableSectionElement covTableBody = new Element.tag('tbody');
      _appElements.covTableBody = covTableBody;
      covTableBody.id = 'dt-results-body';
      covTable.elements.add(covTableBody);
      coverageBody.elements.add(covTable);
      
      if(_appElements.mainElem != null) {
        _appElements.mainElem.elements.add(coverageBody);
      }
    }
    _show(_appElements.coverageBody);
    _hide(_appElements.testBody);

    _appElements.covPreElem.text = getCoverageSummary();
    
    // Coverage table has unit names and integers and won't have special chars
    _appElements.covTableBody.innerHTML = getCoverageDetails();
  }
  
  void _show(Element show) {
    if(show != null) {
      if(show.classes.contains('dt-hide')) {
        show.classes.remove('dt-hide');
      }
      show.classes.add('dt-show');
    }
  }
  
  void _hide(Element hide) {
    if(hide != null) {
      if(hide.classes.contains('dt-show')) {
        hide.classes.remove('dt-show');
      }
      hide.classes.add('dt-hide');
    }
  }

  void _dartestMaximize() {
    _hide(_appElements.containerDiv);
    _runnerWindow = window.open('', 'dartest-window', 
      DARTestCss._fullAppWindowFeatures);
    _runnerWindow.document.title = 'Dartest';
    _fullAppElements = new AppElements();
    _appElements = _fullAppElements;
    DARTestCss.inject(_runnerWindow.document, false);
    run();
    if(testsRun > 0) {
      tests.forEach((final t) => _updateDARTestUI(t));
    }
  }
  
  void _dartestMinimize() {
    _runnerWindow.close();
    _runnerWindow = window;
    _appElements = _inAppElements;
    _show(_appElements.containerDiv);
  }

  void _exportTestResults() {
    String csvData = getTestResultsCsv();
    _log(csvData);
    AnchorElement exportLink = _runnerWindow.document.query('#dt-export');
    
    /** Bug: Can't instantiate WebKitBlobBuilder
     *  If this bug is fixed, we can remove the urlencode and lpad function.
     *
     *  WebKitBlobBuilder bb = new WebKitBlobBuilder();
     *  bb.append(csvData);
     *  Blob blob = bb.getBlob('text/plain;charset=${document.characterSet}');
     *  exportLink.href = window.webkitURL.createObjectURL(blob);
     **/
    
    exportLink.href = 'data:text/csv,' + _urlencode(csvData);
    
    //MouseEvent ev = document.createEvent("MouseEvents");
    //ev.initMouseEvent("click", true, false, window, 0, 0, 0, 0, 0
     //   , false, false, false, false, 0, null);
    //exportLink.dispatchEvent(ev);
    
  }

  static String _urlencode(String s) {
    StringBuffer out = new StringBuffer();
    for(int i = 0; i < s.length; i++) {
      int cc = s.charCodeAt(i);
      if((cc >= 48 && cc <= 57) || (cc >= 65 && cc <= 90) || 
          (cc >= 97 && cc <= 122)) {
        out.add(s[i]);
      } else {
        out.add('%${_lpad(cc.toRadixString(16),2).toUpperCase()}');
      }
    }
    return out.toString();
  }

  static String _lpad(String s, int n) {
    if(s.length < n) {
      for(int i = 0; i < n - s.length; i++) {
        s = '0'+s;
      }
    }
    return s;
  }
}
