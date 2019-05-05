import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(CrossLanguageFrameworkTests.allTests),
    testCase(FunctionalInformationTests.allTests),
    testCase(APIInformationTests.allTests),
    testCase(UniversalAPITests.allTests)
  ]
}
#endif
