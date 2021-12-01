//
//  Endpoint+shifts.swift
//  CodingChallenge
//
//  Created by Marcin Obolewicz on 06/11/2021.
//

import Foundation

extension Endpoint {
    static func shifts(with equation: String) -> Self {
        return Endpoint(
            queryItems: [
                URLQueryItem(name: "expr", value: equation)
            ]
        )
    }
}
