import Foundation

public class CliWrapper {
    var PERCY_SERVER_ADDRESS = "http://percy.cli:5338";
    
    public func healthcheck() -> Bool {
        var ret = false
        let url = URL(string: PERCY_SERVER_ADDRESS + "/percy/healthcheck")
        guard let requestUrl = url else { return false }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        let sem = DispatchSemaphore.init(value: 0)
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            defer { sem.signal() }
            
            // Check if Error took place
            if let error = error {
                Log.error(msg: "Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                Log.debug(msg: "Healthcheck statusCode: \(response.statusCode)")
                ret = true
            }
        })
        task.resume()
        sem.wait()
        return ret
    }
    
    
    
    public func postScreenshot(name: String, tag: [String: Any], tiles: [Tile]) throws -> [String: Any] {
        var ret = [String: Any]()
        // Create URL
        let url = URL(string: PERCY_SERVER_ADDRESS + "/percy/comparison")!
        
        let parameters: [String: Any] = ["name": name, "tag": tag, "tiles": Tile.getTileJSON(tiles: tiles), "clientInfo": "XCUI", "environmentInfo": "XCUI"]
        
        // create the session object
        let session = URLSession.shared
        let sem = DispatchSemaphore.init(value: 0)
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            // convert parameters to Data and assign dictionary to httpBody of request
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            Log.error(msg: error.localizedDescription)
            return ret
        }
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            if let error = error {
                Log.error(msg:"Post Request Error: \(error.localizedDescription)")
                return
            }
            
            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                Log.error(msg: "Invalid Response received from the server")
                return
            }
            
            // ensure there is data returned
            guard let responseData = data else {
                Log.error(msg: "nil Data received from the server")
                return
            }
            
            do {
                Log.debug(msg: "Comparison post response: " + String(decoding: responseData, as: UTF8.self))
                // create json object from data or use JSONDecoder to convert to Model stuct
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                    ret = jsonResponse
                    // handle json response
                } else {
                    Log.error(msg: "data maybe corrupted or in wrong format")
                    throw URLError(.badServerResponse)
                }
            } catch let error {
                Log.error(msg: error.localizedDescription)
            }
        }
        // perform the task
        task.resume()
        sem.wait()
        
        if (ret.isEmpty) {
            throw AppPercyError.postScreenshotError("Failed to post screenshot")
        }
        
        return ret
    }
}
