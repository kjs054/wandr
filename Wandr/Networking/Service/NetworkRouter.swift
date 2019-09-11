//
//  NetworkRouter.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/29/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
