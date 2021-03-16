//
//  URLSessionProtocol.swift
//  CodeTest
//
//  Created by Usman Ansari on 15/03/21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation
import Foundation
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
