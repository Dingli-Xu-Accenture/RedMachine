//
//  Single+Network.swift
//  RedMachine
//
//  Created by Xu, Terry dingli on 2021/7/22.
//

import Foundation
import RxSwift
import Moya

struct NetworkError: Error {
    let code: Int
    let errorMessage: String
    
    init(code: Int, errorMessage: String?) {
        self.code = code
        if let errorMessage = errorMessage, errorMessage.count > 0 {
            self.errorMessage = errorMessage
        } else {
            self.errorMessage = "Network Error"
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element: Response {
    /// Ensure a request's response is "OK"
    ///
    /// - Returns: Single with the same response
    func checkHttpResponseCodeAndError() -> Single<Element> {
        return map { response in
            if (200..<300).contains(response.statusCode) {
                return response
            } else {
                // Terry TODO: Throw different network Error
                print("Network Error, status Code: \(response.statusCode), errorMessage: \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
                throw NetworkError(code: response.statusCode, errorMessage: HTTPURLResponse.localizedString(forStatusCode: response.statusCode))
            }
        }
    }
    
    /// Attempt parsing json to a given type.
    ///
    /// - Parameters:
    ///   - type: The response data to parse to.
    /// - Returns: Single of parsed types.
    func parse<T: Codable>(type: T.Type) -> Single<T?> {
        return checkHttpResponseCodeAndError()
            .map { response in
            do {
                return try JSONDecoder().decode(type.self, from: response.data)
            } catch {
                throw error
            }
        }
    }
}
