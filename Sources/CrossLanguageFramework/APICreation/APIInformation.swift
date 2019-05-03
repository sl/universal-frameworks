struct APIInformation {
  init<APIWrapper>(describing wrapper: APIWrapper) {
    let mirror = Mirror(reflecting: wrapper)
    for case let (label?, value) in mirror.children {
      print(label, value)
    }
  }
}