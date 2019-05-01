/// The information captured about a function necessary to call it
/// from the binary interface.
public struct FunctionInformation {
  let inputs: [String]
  let output: String?
  let typeErasedFunction: ([Any]) -> Any?
  
  fileprivate init(
    inputs: [String],
    output: String?,
    typeErasedFunction: @escaping ([Any]) -> Any?
  ) {
    self.inputs = inputs
    self.output = output
    self.typeErasedFunction = typeErasedFunction
  }
}

// Possible way of handling function calls:
// we wrap closures we're given in closures of the same type

private func describe<X>(_ type: X.Type) -> String {
  return String(describing: X.self)
}

public func deduceFunctionInformation(
  for f: @escaping () -> Void
) -> FunctionInformation {
  print("input: <NONE>")
  print("output: <NONE>")
  return FunctionInformation(
    inputs: [],
    output: nil
  ) { 
    (inputs: [Any]) -> Any? in 
    f()
    return nil
  }
}

public func deduceFunctionInformation<Input>(
  for f: @escaping (Input) -> Void
) -> FunctionInformation {
  print("input:", Input.self)
  print("output: <NONE>")
  return FunctionInformation(
    inputs: [describe(Input.self)],
    output: nil
  ) {
    (inputs: [Any]) -> Any? in
    let args = inputs.tuple as! Input
    f(args)
    return nil
  }
}

public func deduceFunctionInformation<Ret>(
  for f: @escaping () -> Ret
) -> FunctionInformation {
  print("input: <NONE>")
  print("output:", Ret.self)
  return FunctionInformation(
    inputs: [],
    output: describe(Ret.self)
  ) { 
    (inputs: [Any]) -> Any? in 
    return f()
  }
}

public func deduceFunctionInformation<Input, Ret>(
  for f: @escaping (Input) -> Ret
) -> FunctionInformation {
  print("input:", Input.self)
  print("output:", Ret.self)
  return FunctionInformation(
    inputs: [describe(Input.self)],
    output: describe(Ret.self)
  ) { 
    (inputs: [Any]) -> Any? in
    let args = inputs.tuple as! Input
    return f(args)
  }
}

// TODO -- Turn this into a gyb and generate these out to some reasonable amount
// of expected possible inputs. Hopefully no reasonble framework would
// be designed to take more than that amount of arguments.