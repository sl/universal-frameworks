/// Split a function's input signature into a list of the name of its argument
/// types.
///
/// Example:
/// (Int, String, (Float, Bool) -> MyType, Test) =>
/// ["Int", "String", "(Float, Bool) -> MyType", "Test"]
func tokenize(inputSignature signature: String) -> [String] {
  var result: [String] = []
  var accumulated = ""
  
  var parenDepth = 0
  var justAccumulated = false
  for char in signature {
    if justAccumulated && char == " " {
      justAccumulated = false
      continue
    }
    justAccumulated = false
    
    
    if char == "," && parenDepth == 0 {
      assert(!accumulated.isEmpty)
      result.append(accumulated)
      accumulated = ""
      justAccumulated = true
      continue
    }
    
    if char == "(" { parenDepth += 1 }
    if char == ")" { parenDepth -= 1 }
    
    accumulated.append(char)
  }
  result.append(accumulated)
  return result
}