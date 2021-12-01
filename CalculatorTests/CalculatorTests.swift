//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Marcin Obolewicz on 24/11/2021.
//

import XCTest
import Combine
@testable import Calculator

final class CalculatorTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    private func publisher<T>(with value: T) -> AnyPublisher<T?, Never> {
        Just<T?>(value)
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
    
    func testAddition() {
        
        let firstValuePublisher = publisher(with: -1.0)
        let secondValuePublisher = publisher(with: 0.0)
        let operationPublisher = publisher(with: Operation.addition)
        
        let viewModel = CalculatorViewModel(
            service: ShiftsServiceMock(),
            firstValuePublisher: firstValuePublisher,
            secondValuePublisher: secondValuePublisher,
            operationPublisher: operationPublisher
        )
        XCTAssertEqual(viewModel.equation, "-1+0")
        
        viewModel.validationPublisher
            .sink { value in
                XCTAssertEqual(value, true)
            }
            .store(in: &cancellables)
    }
    
    func testSubtraction() {
        
        let firstValuePublisher = publisher(with: 1.0)
        let secondValuePublisher = publisher(with: 0.0)
        let operationPublisher = publisher(with: Operation.subtraction)
        
        let viewModel = CalculatorViewModel(
            service: ShiftsServiceMock(),
            firstValuePublisher: firstValuePublisher,
            secondValuePublisher: secondValuePublisher,
            operationPublisher: operationPublisher
        )
        XCTAssertEqual(viewModel.equation, "1-0")
        
        viewModel.validationPublisher
            .sink { value in
                XCTAssertEqual(value, true)
            }
            .store(in: &cancellables)
    }
    
    func testMultiplication() {
        
        let firstValuePublisher = publisher(with: 3.0)
        let secondValuePublisher = publisher(with: -2.0)
        let operationPublisher = publisher(with: Operation.multiplication)
        
        let viewModel = CalculatorViewModel(
            service: ShiftsServiceMock(),
            firstValuePublisher: firstValuePublisher,
            secondValuePublisher: secondValuePublisher,
            operationPublisher: operationPublisher
        )
        XCTAssertEqual(viewModel.equation, "3*-2")
        
        viewModel.validationPublisher
            .sink { value in
                XCTAssertEqual(value, true)
            }
            .store(in: &cancellables)
    }
    
    func testDivisionByZero() {
        
        let firstValuePublisher = publisher(with: 0.0)
        let secondValuePublisher = publisher(with: 1.0)
        let operationPublisher = publisher(with: Operation.division)
        
        let viewModel = CalculatorViewModel(
            service: ShiftsServiceMock(),
            firstValuePublisher: firstValuePublisher,
            secondValuePublisher: secondValuePublisher,
            operationPublisher: operationPublisher
        )
        XCTAssertEqual(viewModel.equation, "0/1")
        
        viewModel.validationPublisher
            .sink { value in
                XCTAssertEqual(value, true)
            }
            .store(in: &cancellables)
    }
    
    func testDivision() {
        
        let firstValuePublisher = publisher(with: 1.0)
        let secondValuePublisher = publisher(with: 0.0)
        let operationPublisher = publisher(with: Operation.division)
        
        let viewModel = CalculatorViewModel(
            service: ShiftsServiceMock(),
            firstValuePublisher: firstValuePublisher,
            secondValuePublisher: secondValuePublisher,
            operationPublisher: operationPublisher
        )
        XCTAssertEqual(viewModel.equation, "1/0")
        
        viewModel.validationPublisher
            .sink { value in
                XCTAssertEqual(value, false)
            }
            .store(in: &cancellables)
        
        viewModel.fetchResult()
            .sink(receiveCompletion: { completion in
                guard case .finished = completion else {
                    XCTFail()
                    return
                }
            }, receiveValue: { value in
                XCTAssertEqual(value, "result")
            })
            .store(in: &cancellables)
    }
}

struct ShiftsServiceMock: ShiftsServiceProtocol {
    func request(equation: String) -> AnyPublisher<String, Error> {
        Just<String>("result")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
