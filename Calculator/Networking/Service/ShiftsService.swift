//
//  ShiftsService.swift
//  CodingChallenge
//
//  Created by Marcin Obolewicz on 06/11/2021.
//

import Foundation
import Combine

protocol ShiftsServiceProtocol {
    func request(equation: String) -> AnyPublisher<String, Error>
}

struct ShiftsService: ShiftsServiceProtocol {
    var networker: NetworkerProtocol

    func request(equation: String) -> AnyPublisher<String, Error> {
        let endpoint = Endpoint.shifts(with: equation)

        return networker.get(
            url: endpoint.url
        )
    }
}
