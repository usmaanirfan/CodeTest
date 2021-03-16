//
//  NetworkClient.swift
//  CodeTest
//
//  Created by Usman Ansari on 15/03/21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation
class NetworkClient : NetworkClientInterface {

    typealias APIResult<T> = (Result<T, Error>) -> Void
    var session: URLSessionProtocol
    private var task: URLSessionDataTask?

    required init(session: URLSessionProtocol) {
        self.session = session
    }

    func makeHttpRequest<T:Decodable>(dataType: T.Type, requestType : RequestType, requestModel : RequestModel, completionHandler: @escaping APIResult<T>) {
        guard let request = try? prepareURLRequest(with: requestType, requestModel: requestModel) else {
            let error = RequestError.invalidURL
            completionHandler(.failure(error))
            return
        }
        self.task = self.session.dataTask(with: request) { data, response, error in
            self.processResponse(response, data: data, error: error) { result in
                switch result {
                 case .success(let data):
                    do {
                        let decodedJSON: T = try JSONDecoder().decode(T.self, from: data)
                            completionHandler(.success(decodedJSON))
                    } catch let error{
                        if requestType == RequestType.deleteLocation {
                            completionHandler(.success("" as! T))
                        } else {
                            completionHandler(.failure(error))
                        }
                    }
                 case .failure(let error):
                        completionHandler(.failure(error))
                }
            }
        }
        self.task?.resume()
    }

    private func prepareURLRequest(with requestType : RequestType, requestModel : RequestModel) throws -> URLRequest {
        switch requestType {
        case RequestType.fetchLocations:
            var urlRequest = URLRequest(url: requestModel.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: Constants.timeoutOut)
            urlRequest.addValue(requestModel.apiKey, forHTTPHeaderField: Constants.kApiKey)
            urlRequest.httpMethod = Method.get.rawValue
            return urlRequest
        case RequestType.addLocation:
            var urlRequest = URLRequest(url: requestModel.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: Constants.timeoutOut)
            urlRequest.addValue(requestModel.apiKey, forHTTPHeaderField: Constants.kApiKey)
            urlRequest.httpMethod = Method.post.rawValue
            if let body = requestModel.body, JSONSerialization.isValidJSONObject(body) {
                let data = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                urlRequest.httpBody = data
            }
            return urlRequest
        case RequestType.deleteLocation:
            var urlRequest = URLRequest(url: requestModel.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: Constants.timeoutOut)
            urlRequest.addValue(requestModel.apiKey, forHTTPHeaderField: Constants.kApiKey)
            urlRequest.httpMethod = Method.delete.rawValue
            return urlRequest
        }
    }

    private func processResponse(_ response: URLResponse?, data: Data?, error: Error?, completionHandler: (Result<Data, Error>) -> Void) {
        if let error = error {
            completionHandler(.failure(error))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            completionHandler(.failure(RequestError.noHTTPResponse))
            return
        }
        let statusCode = httpResponse.statusCode
        if statusCode == Constants.successCode {
            completionHandler(.success(data!))
        } else if Constants.failureCodes.contains(statusCode) {
            completionHandler(.failure(RequestError.http(status: statusCode)))
        } else {
            // Server returned response with status code different than expected `successCodes`.
            let info = [
                NSLocalizedDescriptionKey: "Request failed with code \(statusCode)",
                NSLocalizedFailureReasonErrorKey: "Wrong handling logic, wrong endpoing mapping or backend bug."
            ]
            let error = NSError(domain: "NetworkService", code: 0, userInfo: info)
            completionHandler(.failure(error))
        }
    }
}
