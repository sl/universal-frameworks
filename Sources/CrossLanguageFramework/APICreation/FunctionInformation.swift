/// The information captured about a function necessary to call it
/// from the binary interface.
public struct FunctionInformation {
  let name: String
  let inputs: [String]
  let output: String?
  let typeErasedFunction: ([Any]) -> Any?
  
  fileprivate init(
    for name: String, 
    inputs: [String],
    output: String?,
    typeErasedFunction: @escaping ([Any]) -> Any
  ) {
    self.name = name
    self.inputs = inputs
    self.output = output
    self.typeErasedFunction = typeErasedFunction
  }
  
  init(
    for f: @escaping () -> Void,
    withName name: String
  ) {
    self.init(
      for: name,
      inputs: [],
      output: nil
    ) { 
      (inputs: [Any]) -> Any in 
      f()
      return ()
    }
  }
  
  init<Input>(
    for f: @escaping (Input) -> Void,
    withName name: String
  ) {
    self.init(
      for: name,
      inputs: tokenize(inputSignature: describeInputs(Input.self)),
      output: nil
    ) {
      (inputs: [Any]) -> Any in
      let args = inputs.tuple as! Input
      f(args)
      return ()
    }
  }
  
  init<Ret>(
    for f: @escaping () -> Ret,
    withName name: String
  ) {
    self.init(
      for: name,
      inputs: [],
      output: describeOutput(Ret.self)
    ) { 
      (inputs: [Any]) -> Any in 
      return f()
    }
  }
  
  init<Input, Ret>(
    for f: @escaping (Input) -> Ret,
    withName name: String
  ) {
    self.init(
      for: name,
      inputs: tokenize(inputSignature: describeInputs(Input.self)),
      output: describeOutput(Ret.self)
    ) { 
      (inputs: [Any]) -> Any in
      let args = inputs.tuple as! Input
      return f(args)
    }
  }
  
  var isVoid: Bool {
    return output != nil
  }
}

/// Get the type signature of the input types of the function
private func describeInputs<X>(_ type: X.Type) -> String {
  let description = String(describing: X.self)
  if description.first == "(" && description.last == ")" {
    return String(description.dropFirst().dropLast())
  }
  return description
}

/// Get the type signature of the output type of the function
private func describeOutput<X>(_ type: X.Type) -> String {
  return String(describing: X.self)
}