//
//  APIError.swift
//  CodingChallenge
//
//  Created by Marcin Obolewicz on 06/11/2021.
//

import Foundation

enum APIError: Swift.Error {
    case invalidEquation
    case parsingFailure
    case unexpectedResponse
}
