import Foundation

public class CliWrapper {
    var PERCY_SERVER_ADDRESS = "http://percy.cli:5338";
    
    public func healthcheck() -> Bool {
        var ret = false
        let url = URL(string: PERCY_SERVER_ADDRESS + "/percy/healthcheck")
        guard let requestUrl = url else { return false }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let sem = DispatchSemaphore.init(value: 0)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            defer { sem.signal() }
            if let error = error {
                Log.error(msg: "Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                Log.debug(msg: "Healthcheck statusCode: \(response.statusCode)")
                ret = true
            }
        })
        task.resume()
        sem.wait()

        if (ret == false) {
            Log.info(msg: "Percy CLI is not running, disabling screenshots.")
        }

        return ret
    }
    
    
    
    public func postScreenshot(name: String, tag: [String: Any], tiles: [Tile]) throws -> [String: Any] {
        var ret = [String: Any]()
        let url = URL(string: PERCY_SERVER_ADDRESS + "/percy/comparison")!
        
        let parameters: [String: Any] = ["name": name, "tag": tag, "tiles": Tile.getTileJSON(tiles: tiles), "clientInfo": "XCUI", "environmentInfo": "XCUI"]
        
        let session = URLSession.shared
        let sem = DispatchSemaphore.init(value: 0)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            Log.error(msg: error.localizedDescription)
            return ret
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            if let error = error {
                Log.error(msg:"Post Request Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                Log.error(msg: "Invalid Response received from the server")
                return
            }
            
            guard let responseData = data else {
                Log.error(msg: "nil Data received from the server")
                return
            }
            
            do {
                Log.debug(msg: "Comparison post response: " + String(decoding: responseData, as: UTF8.self))
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                    ret = jsonResponse
                } else {
                    Log.error(msg: "data maybe corrupted or in wrong format")
                    throw URLError(.badServerResponse)
                }
            } catch let error {
                Log.error(msg: error.localizedDescription)
            }
        }

        task.resume()
        sem.wait()

        if (ret.isEmpty) {
            throw AppPercyError.postScreenshotError("Failed to post screenshot")
        }

        return ret
    }
}
