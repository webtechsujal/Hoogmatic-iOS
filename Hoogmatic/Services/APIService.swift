import Foundation

public class APIService {
    public static let shared = APIService()
    
    private let baseURL = "https://connector.hoogmatic.in/index.php"
    
    private init() {}
    
    public func fetchSsoHistory(userId: Int, token: String, completion: @escaping (Result<[SsoHistoryItem], Error>) -> Void) {
        guard var components = URLComponents(string: baseURL) else {
            completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid base URL"])))
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "path", value: "insurance"),
            URLQueryItem(name: "method", value: "sso_history_json"),
            URLQueryItem(name: "user_id", value: "\(userId)"),
            URLQueryItem(name: "token", value: token)
        ]
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid query parameters"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        
        if !token.isEmpty {
            request.setValue("login_token=\(token); Path=/; Domain=.hoogmatic.in", forHTTPHeaderField: "Cookie")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "APIService", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(SsoHistoryResponse.self, from: data)
                completion(.success(decodedResponse.data ?? []))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func performSsoLogin(fullName: String, email: String, mobile: String, userId: Int, token: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard var components = URLComponents(string: baseURL) else {
            completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid base URL"])))
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "path", value: "insurance"),
            URLQueryItem(name: "method", value: "ssoLogin")
        ]
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "APIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10.0
        
        let bodyParameters = [
            "full_name=\(fullName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")",
            "email=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")",
            "mobile=\(mobile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")",
            "user_id=\(userId)",
            "login_token=\(token.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        ]
        
        let postString = bodyParameters.joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if !token.isEmpty {
            request.setValue("login_token=\(token); Path=/; Domain=.hoogmatic.in", forHTTPHeaderField: "Cookie")
        }
        
        // Custom URLSessionDelegate to intercept HTTP 302 redirect location
        let delegate = SsoRedirectHandlerDelegate { redirectURL in
            completion(.success(redirectURL))
        }
        
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 302 || httpResponse.statusCode == 301), let location = httpResponse.allHeaderFields["Location"] as? String, let redirectURL = URL(string: location) {
                completion(.success(redirectURL))
                return
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Fallback default redirect URL
            let fallbackURL = URL(string: "https://connector.hoogmatic.in/index.php?path=insurance&method=sso")!
            completion(.success(fallbackURL))
        }
        task.resume()
    }
}

private class SsoRedirectHandlerDelegate: NSObject, URLSessionTaskDelegate {
    private let onRedirect: (URL) -> Void
    private var hasHandled = false
    
    init(onRedirect: @escaping (URL) -> Void) {
        self.onRedirect = onRedirect
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        if !hasHandled, let url = request.url {
            hasHandled = true
            onRedirect(url)
        }
        completionHandler(nil) // Stop automatic session redirect handling
    }
}
