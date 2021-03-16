//
//  NetworkClientInterface.swift
//  CodeTest
//
//  Created by Usman Ansari on 16/03/21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation
protocol NetworkClientInterface {
    typealias APIResult<T> = (Result<T, Error>) -> Void
    var session: URLSessionProtocol { get set }
    init(session: URLSessionProtocol)
    func makeHttpRequest<T:Decodable>(dataType: T.Type, requestType : RequestType, requestModel : RequestModel, completionHandler: @escaping APIResult<T>)
}
