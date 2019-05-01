/// The information captured about a function necessary to call it
/// from the binary interface.
public struct FunctionInformation {
  let inputs: [String]
  let output: String?
  let typeErasedFunction: ([Any]) -> Any?
  
  fileprivate init(
    inputs: [String],
    output: String?,
    typeErasedFunction: @escaping ([Any]) -> Any
  ) {
    self.inputs = inputs
    self.output = output
    self.typeErasedFunction = typeErasedFunction
  }
}

// Possible way of handling function calls:
// we wrap closures we're given in closures of the same type

private func describeInputs<X>(_ type: X.Type) -> String {
  let description = String(describing: X.self)
  if description.first == "(" && description.last == ")" {
    return String(description.dropFirst().dropLast())
  }
  return description
}

private func describeOutput<X>(_ type: X.Type) -> String {
  return String(describing: X.self)
}

public func functionInformation(
  for f: @escaping () -> Void
) -> FunctionInformation {
  return FunctionInformation(
    inputs: [],
    output: nil
  ) { 
    (inputs: [Any]) -> Any in 
    f()
    return ()
  }
}

public func functionInformation<Input>(
  for f: @escaping (Input) -> Void
) -> FunctionInformation {
  return FunctionInformation(
    inputs: tokenize(inputSignature: describeInputs(Input.self)),
    output: nil
  ) {
    (inputs: [Any]) -> Any in
    let args = inputs.tuple as! Input
    f(args)
    return ()
  }
}

public func functionInformation<Ret>(
  for f: @escaping () -> Ret
) -> FunctionInformation {
  return FunctionInformation(
    inputs: [],
    output: describeOutput(Ret.self)
  ) { 
    (inputs: [Any]) -> Any in 
    return f()
  }
}

public func functionInformation<Input, Ret>(
  for f: @escaping (Input) -> Ret
) -> FunctionInformation {
  return FunctionInformation(
    inputs: tokenize(inputSignature: describeInputs(Input.self)),
    output: describeOutput(Ret.self)
  ) { 
    (inputs: [Any]) -> Any in
    let args = inputs.tuple as! Input
    return f(args)
  }
}

// TODO -- Turn this into a gyb and generate these out to some reasonable amount
// of expected possible inputs. Hopefully no reasonble framework would
// be designed to take more than that amount of arguments.