import XCTest
@testable import CrossLanguageFramework

final class CrossLanguageFrameworkTests: XCTestCase {
  struct MyStruct {
    func noArg() {}
    func noArgRet() -> Bool { return true }
    func oneArg(a: Int) {}
    func oneArgRet(a: Int) -> Bool { return true }
    func twoArg(a: Int, b: String) {}
    func twoArgRet(a: Int, b: String) -> Bool { return true }
    func higherOrder(f: (Int) -> Bool) {}
    func nasty(f: (Int, String) -> Bool, a: Int) -> Bool { return true }
    func prints(a: Int, b: String) -> Bool {
      print(a)
      print(b)
      return true
    }
  }
  
  let myStruct = MyStruct()
  
  func testDeduceFunctionInformation() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    
    let deduced = deduceFunctionInformation(for: myStruct.twoArgRet)
    let deduced2 = deduceFunctionInformation(for: myStruct.higherOrder)
    let deduced3 = deduceFunctionInformation(for: myStruct.nasty)
    
    let deducedPrints = deduceFunctionInformation(for: myStruct.prints)
    let result = deducedPrints.typeErasedFunction([1, "hello world"]) as! Bool
    XCTAssert(result, "failed to correctly call type erased function")
  }

  static var allTests = [
    ("testDeduceFunctionInformation", testDeduceFunctionInformation),
  ]
}
