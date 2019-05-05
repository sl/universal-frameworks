public protocol UniversalAPI {  
  var includes: APIInformation { get }
}

public func expose<T : UniversalAPI>(_ api: T) {
  APIHost.instance.add(api: api.includes)
}

struct APIHost {
  static var instance: APIHost = APIHost()
  
  internal var exposedAPIs: [APIInformation]
  
  private init() {
    exposedAPIs = []
  }
  
  fileprivate mutating func add(api: APIInformation) {
    exposedAPIs.append(api)
  }
}