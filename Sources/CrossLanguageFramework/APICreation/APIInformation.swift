/// Information about an exposed API type
public struct APIInformation {
  let includes: [ExposableInformation]
  
  public init() {
    includes = []
  }
  
  private init(_ includes: [ExposableInformation]) {
    self.includes = includes
  }
  
  public func include<T>(
    field: T,
    as name: String
  ) -> APIInformation {
    return APIInformation(
      includes + [
        .field(
          FieldInformation(
            name: name,
            type: String(describing: T.self),
            value: field
          )
        )
      ]
    )
  }
  
  public func include(
    function: @escaping () -> Void,
    as name: String
  ) -> APIInformation {
    return APIInformation(
      includes + [
        .function(
          FunctionInformation(
            for: function,
            withName: name
          )
        )
      ]
    )
  }
  
  public func include<Input>(
    function: @escaping (Input) -> Void,
    as name: String
  ) -> APIInformation {
    return APIInformation(
      includes + [
        .function(
          FunctionInformation(
            for: function,
            withName: name
          )
        )
      ]
    )
  }
  
  public func include<Ret>(
    function: @escaping () -> Ret,
    as name: String
  ) -> APIInformation {
    return APIInformation(
      includes + [
        .function(
          FunctionInformation(
            for: function,
            withName: name
          )
        )
      ]
    )
  }
  
  public func include<Input, Ret>(
    function: @escaping (Input) -> Ret,
    as name: String
  ) -> APIInformation {
    return APIInformation(
      includes + [
        .function(
          FunctionInformation(
            for: function,
            withName: name
          )
        )
      ]
    )
  }
  
}

/// Information about an exposed function or field
enum ExposableInformation {
  case function(FunctionInformation)
  case field(FieldInformation)
}