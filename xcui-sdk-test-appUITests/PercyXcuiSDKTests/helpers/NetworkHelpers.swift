import Foundation
import Hippolyte

class NetworkHelpers {
    
    static func start(requests: [StubRequest]) {
        for request in requests {
            Hippolyte.shared.add(stubbedRequest: request)
        }
        Hippolyte.shared.start()
    }
    
    static func stubHealthcheck(success: Bool = true) -> StubRequest {
        let responseCode = success ? 204 : 500
        let response = StubResponse.Builder()
            .stubResponse(withStatusCode: responseCode)
            .build()
        // The request that will match this URL and return the stub response
        let request = StubRequest.Builder()
            .stubRequest(withMethod: .GET, url: URL(string: "http://percy.cli:5338/percy/healthcheck")!)
            .addResponse(response)
            .build()
        return request
    }
    
    static func stubPostComparison(success: Bool = true) -> StubRequest {
        let responseCode = success ? 200 : 500
        let response = StubResponse.Builder()
            .stubResponse(withStatusCode: responseCode)
            .addBody("{\"link\": \"https://some-link\"}".data(using: .utf8)!)
            .build()
        // The request that will match this URL and return the stub response
        let request = StubRequest.Builder()
            .stubRequest(withMethod: .POST, url: URL(string: "http://percy.cli:5338/percy/comparison")!)
            .addResponse(response)
            .build()
        return request
    }
    
    static func stop() {
        Hippolyte.shared.stop()
    }
}
