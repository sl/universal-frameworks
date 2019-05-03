import XCTest
@testable import CrossLanguageFramework

final class FunctionInformationTests: XCTestCase {
  class MyClass {
    var closureSetInt = 0
    var closureSetString = ""
    func noArg() {}
    func noArgRet() -> Bool { return true }
    func oneArg(a: Int) {}
    func oneArgRet(a: Int) -> Bool { return true }
    func twoArg(a: Int, b: String) {}
    func twoArgRet(a: Int, b: String) -> Bool { return true }
    func higherOrder(f: (Int) -> ((String) -> Bool)) {}
    func nasty(f: (Int, String) -> Bool, a: Int) -> Bool { return true }
    func prints(a: Int, b: String) -> Bool {
      closureSetInt = a
      closureSetString = b
      return true
    }
  }
  
  var myClass = MyClass()
  
  func testInputOutputSignature() {    
    let noArg = FunctionInformation(
      for: myClass.noArg,
      withName: "MyClass.noArg"
    )
    XCTAssertEqual([], noArg.inputs)
    XCTAssertEqual(nil, noArg.output)
    
    let twoArgRet = FunctionInformation(
      for: myClass.twoArgRet,
      withName: "MyClass.twoArgRet"
    )
    XCTAssertEqual(["Int", "String"], twoArgRet.inputs)
    XCTAssertEqual("Bool", twoArgRet.output)
    
    
    let higherOrder = FunctionInformation(
      for: myClass.higherOrder,
      withName: "MyClass.higherOrder"
    )
    XCTAssertEqual(["(Int) -> (String) -> Bool"], higherOrder.inputs)
    XCTAssertEqual(nil, higherOrder.output)
    
    let nasty = FunctionInformation(
      for: myClass.nasty,
      withName: "MyClass.nasty"
    )
    XCTAssertEqual(["(Int, String) -> Bool", "Int"], nasty.inputs)
    XCTAssertEqual("Bool", nasty.output)
  }
  
  func testCallTypeErasedFunction() {
    let deducedPrints = FunctionInformation(
      for: myClass.prints,
      withName: "MyClass.prints"
    )
    XCTAssertEqual(0, myClass.closureSetInt)
    XCTAssertEqual("", myClass.closureSetString)
    let result = deducedPrints.typeErasedFunction([1, "hello world"]) as! Bool
    XCTAssert(result, "failed to correctly call type erased function")
    XCTAssertEqual(1, myClass.closureSetInt)
    XCTAssertEqual("hello world", myClass.closureSetString)
  }

  static var allTests = [
    ("testInputOutputSignature", testInputOutputSignature),
    ("testCallTypeErasedFunction", testCallTypeErasedFunction)
  ]
}
