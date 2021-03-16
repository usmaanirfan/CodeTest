//
//  URLSessionMock.swift
//  CodeTestTests
//
//  Created by Usman Ansari on 16/03/21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation
@testable import CodeTest

class URLSessionMock: URLSessionProtocol {
    func dataTask(with reuest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        var filePath : String?
        if reuest.httpMethod == Method.get.rawValue {
            if let path = Bundle.main.path(forResource: "MockWeatherList", ofType: "json") {
                filePath = path
            }
        } else if reuest.httpMethod == Method.post.rawValue{
            if let path = Bundle.main.path(forResource: "WeatherDetail", ofType: "json") {
                filePath = path
            }
        }
        else if reuest.httpMethod == Method.delete.rawValue{
            if let path = Bundle.main.path(forResource: "WeatherDelete", ofType: "json") {
                filePath = path
            }
        }
        if (filePath != nil ||  reuest.httpMethod == Method.delete.rawValue) {
            do {
                let response = HTTPURLResponse(url: reuest.url!, statusCode: 200,
                                               httpVersion: nil, headerFields: nil)!
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath!), options: .mappedIfSafe)
                defer { completionHandler(data, response, nil) }
            } catch {
                // handle error
            }
        }
        return URLSessionDataTaskMock()
    }

}
