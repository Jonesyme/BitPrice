//
//  WebSession.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import Foundation

//
// MARK: - WebService Endpoint Protocol
//


/// Override this protocol to define a new web-service endpoint
public protocol EndpointProtocol {
    var scheme: WebSession.RequestScheme { get }
    var requestMethod: WebSession.RequestMethod { get }
    var host: String { get }
    var path: String { get }
    var params: [URLQueryItem] { get }
}


//
// MARK: - General-Purpose WebSession
//
public class WebSession {

    public enum RequestMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }

    public enum RequestScheme: String {
        case HTTP
        case HTTPS
    }

    public enum Response<T: Decodable> {
        case success(T)
        case error(WebSession.WSError)
    }
    
    public enum WSError: Error {
        case urlFormat
        case unknown
        case badResponse(Int)
        case network(Error)
        case parser(Error)
        
        public var localizedDescription: String {
            switch self {
            case .urlFormat: return "Unable to generate request"
            case .unknown: return "Unknown error"
            case .badResponse(let code): return "Bad response: \(code)"
            case .network(let error): return "Networking error: " + error.localizedDescription
            case .parser(let error): return "Parsing error: \(error)"
            }
        }
    }

    public typealias CompletionHandler<T:Decodable> = (WebSession.Response<T>) -> Void
    
    lazy private var session: URLSession = {
        var configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 20
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    private func generateRequest(_ endpoint: EndpointProtocol) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme.rawValue
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.params
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.requestMethod.rawValue
        return request
    }

    internal func decode<T:Decodable>(_ data: Data, targetType: T.Type) -> WebSession.Response<T> {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            return .error(WSError.parser(error))
        }
    }
    
    /// Invoke a remote web-service endpoint
    /// - Returns: URLSessionDataTask so the calling function may cancel the request
    @discardableResult public func request<T:Decodable>(_ endpoint: EndpointProtocol, responseType: T.Type, callback: @escaping WebSession.CompletionHandler<T>) -> URLSessionDataTask? {
        var task: URLSessionDataTask? = nil
        guard let request = generateRequest(endpoint) else { callback(.error(WSError.urlFormat)); return task }
        task = session.dataTask(with: request) { data, response, error in
            if let errorMessage = error { callback(.error(WSError.network(errorMessage))); return }
            guard let httpResponse = response as? HTTPURLResponse, let data = data else { callback(.error(WSError.unknown)); return }
            guard httpResponse.statusCode == 200 else { callback(.error(WSError.badResponse(httpResponse.statusCode))); return }
            let decoded = self.decode(data, targetType: T.self)
            switch decoded {
            case .success(let result):
                callback(.success(result))
            case .error(let error):
                callback(.error(error))
            }
        }
        task?.resume()
        return task
    }
    
}

