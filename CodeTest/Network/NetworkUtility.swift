//
//  NetworkUtility.swift
//  CodeTest
//
//  Created by Usman Ansari on 15/03/21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation

enum Method: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

enum RequestType {
    case fetchLocations
    case addLocation
    case deleteLocation
}

enum RequestError: Error {
    case invalidURL, noHTTPResponse, http(status: Int)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noHTTPResponse:
            return "Not a HTTP response."
        case .http(let status):
            return "HTTP error: \(status)."
        }
    }
}

struct Constants {
    static var successCode = 200
    static var failureCodes: CountableRange<Int> = 400..<499
    static var timeoutOut = 5.0
    static var kApiKey = "X-Api-Key"
}
