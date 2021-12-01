//
//  Endpoint.swift
//  CodingChallenge
//
//  Created by Marcin Obolewicz on 06/11/2021.
//

import Foundation

struct Endpoint {
    var queryItems: [URLQueryItem] = []
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.mathjs.org"
        components.path = "/v4"
        components.queryItems = queryItems
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")
        
        guard let url = components.url else {
            preconditionFailure("URL components failure: \(components)")
        }
        return url
    }
}
