//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Marcin Obolewicz on 25/11/2021.
//

import Foundation
import Combine

enum Operation: Int {
    case addition, subtraction, multiplication, division
    
    var title: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "-"
        case .multiplication: return "*"
        case .division: return "/"
        }
    }
}

final class CalculatorViewModel {
    let service: ShiftsServiceProtocol
    @Published var equation: String?
    let firstValuePublisher: AnyPublisher<Double?, Never>
    let secondValuePublisher: AnyPublisher<Double?, Never>
    let operationPublisher: AnyPublisher<Operation?, Never>
    let validationPublisher: AnyPublisher<Bool, Never>
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        service: ShiftsServiceProtocol,
        firstValuePublisher: AnyPublisher<Double?, Never>,
        secondValuePublisher: AnyPublisher<Double?, Never>,
        operationPublisher: AnyPublisher<Operation?, Never>
    ) {
        self.service = service
        self.firstValuePublisher = firstValuePublisher
        self.secondValuePublisher = secondValuePublisher
        self.operationPublisher = operationPublisher
        
        validationPublisher = Publishers.CombineLatest(operationPublisher, secondValuePublisher)
            .map { $0 != .division || $1 != 0 }
            .eraseToAnyPublisher()
        
        Publishers.CombineLatest3(firstValuePublisher, operationPublisher, secondValuePublisher)
            .map { (firstValue, operatorSign, secondValue) -> String? in
                guard let firstValue = firstValue,
                      let operatorSign = operatorSign,
                      let secondValue = secondValue else {
                          return nil
                      }
                return String(Int(firstValue)) + operatorSign.title + String(Int(secondValue))
            }
            .eraseToAnyPublisher()
            .assign(to: &$equation)
    }
    
    func fetchResult() -> AnyPublisher<String, Error> {
        guard let equation = equation else {
            return AnyPublisher(Fail<String, Error>(error: APIError.invalidEquation))
                .eraseToAnyPublisher()
        }

        return service.request(equation: equation)
    }
}
