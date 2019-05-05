import XCTest
@testable import CrossLanguageFramework

final class APIInformationTests: XCTestCase {
  struct Wow : Equatable {}
  
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
    
    let aNumber = 3
    let bNumber = 7
    let myWow = Wow()
    
    var includes: APIInformation {
      return APIInformation()
        .include(function: noArg, as: "noArg")
        .include(function: twoArgRet, as: "twoArgRet")
        .include(function: higherOrder, as: "higherOrder")
        .include(function: nasty, as: "nasty")
        .include(function: prints, as: "prints")
        .include(field: aNumber, as: "aNumber")
        .include(field: bNumber, as: "bNumber")
        .include(field: myWow, as: "myWow")
    }
  }
  
  var myClass = MyClass()
  
  func testAPIInformation() {
    let expo = myClass.includes.includes
  
    if case let .function(noArg) = expo[0] {
      XCTAssertEqual([], noArg.inputs)
      XCTAssertEqual(nil, noArg.output)
    } else {
      XCTFail("noArg was not function")
    }
    
    
    if case let .function(twoArgRet) = expo[1] {
      XCTAssertEqual(["Int", "String"], twoArgRet.inputs)
      XCTAssertEqual("Bool", twoArgRet.output)
    } else {
      XCTFail("twoArgRet was not a function")
    }
    
    
    if case let .function(higherOrder) = expo[2] {
      XCTAssertEqual(["(Int) -> (String) -> Bool"], higherOrder.inputs)
      XCTAssertEqual(nil, higherOrder.output)
    } else {
      XCTFail("higherOrder was not a function")
    }
    
    if case let .function(nasty) = expo[3] {
      XCTAssertEqual(["(Int, String) -> Bool", "Int"], nasty.inputs)
      XCTAssertEqual("Bool", nasty.output)
    } else {
      XCTFail("nasty was not a function")
    }

    if case let .field(aNumber) = expo[5] {
      XCTAssertEqual(aNumber.value as! Int, 3)
      XCTAssertEqual(aNumber.name, "aNumber")
      XCTAssertEqual(aNumber.type, "Int")
    } else {
      XCTFail("aNumber was not a field")
    }
    
    if case let .field(bNumber) = expo[6] {
      XCTAssertEqual(bNumber.value as! Int, 7)
      XCTAssertEqual(bNumber.name, "bNumber")
      XCTAssertEqual(bNumber.type, "Int")
    } else {
      XCTFail("bNumber was not a field")
    }
    
    if case let .field(myWow) = expo[7] {
      XCTAssertEqual(myWow.value as! Wow, Wow())
      XCTAssertEqual(myWow.name, "myWow")
      XCTAssertEqual(myWow.type, "Wow")
    } else {
      XCTFail("myWow was not a field")
    }
  }
  
  static var allTests = [
    ("testAPIInformation", testAPIInformation),
  ]
}
