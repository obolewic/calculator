//
//  Networker.swift
//  CodingChallenge
//
//  Created by Marcin Obolewicz on 06/11/2021.
//

import Foundation
import Combine

protocol NetworkerProtocol: AnyObject {
    func get(
        url: URL
    ) -> AnyPublisher<String, Error>
}

final class Networker: NetworkerProtocol {
    func get(
        url: URL
    ) -> AnyPublisher<String, Error> {
        let  request = URLRequest(url: url)

        return URLSession.shared.dataTaskPublisher(for: request)
            .map {
                $0.data
            }
            .tryMap { data -> String in
                String(decoding: data, as: UTF8.self)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
