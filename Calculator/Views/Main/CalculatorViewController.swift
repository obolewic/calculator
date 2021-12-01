//
//  ViewController.swift
//  Calculator
//
//  Created by Marcin Obolewicz on 24/11/2021.
//

import UIKit
import Combine
import SwiftUI

final class CalculatorViewController: UIViewController {
    
    @IBOutlet private weak var firstValueTitleLabel: UILabel!
    @IBOutlet private weak var firstValueStepper: UIStepper!
    @IBOutlet private weak var operationsSegment: UISegmentedControl!
    @IBOutlet private weak var secondValueTitleLabel: UILabel!
    @IBOutlet private weak var secondValueStepper: UIStepper!
    @IBOutlet private weak var equationLabel: UILabel!
    @IBOutlet private weak var calculateButton: UIButton!
    
    private var spinnerViewController: SpinnerViewController?
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: CalculatorViewModel?
    private let networker = Networker()
    private let service = ShiftsService(networker: Networker())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calculator"
        setupControls()
        setupBindings()
        setupInitialValues()
    }
    
    private func setupBindings() {
        
        let firstValuePublisher = firstValueStepper.publisher(for: .valueChanged)
            .map { ($0 as? UIStepper)?.value }
            .eraseToAnyPublisher()
     
        let secondValuePublisher = secondValueStepper.publisher(for: .valueChanged)
            .map { ($0 as? UIStepper)?.value }
            .eraseToAnyPublisher()
        
        let operationPublisher = operationsSegment.publisher(for: .valueChanged)
            .map { segment -> Operation? in
                if let index = (segment as? UISegmentedControl)?.selectedSegmentIndex {
                    return Operation(rawValue: index)
                }
                return nil
            }
            .eraseToAnyPublisher()
        
        let service = ShiftsService(networker: Networker())
        viewModel = CalculatorViewModel(
            service: service,
            firstValuePublisher: firstValuePublisher,
            secondValuePublisher: secondValuePublisher,
            operationPublisher: operationPublisher
        )
        
        viewModel?.$equation.assign(to: \.text, on: equationLabel)
            .store(in: &cancellables)
        
        viewModel?.validationPublisher
            .sink { [weak self] valid in
                self?.calculateButton.isEnabled = valid
            }
            .store(in: &cancellables)
    }
    
    @IBAction private func calculateButtonAction(_ sender: Any) {
        getResult()
    }
    
    @IBAction func aboutButtonAction(_ sender: Any) {
        let aboutView = AboutView()
        let vc = UIHostingController(rootView: aboutView)
        present(vc, animated: true, completion: nil)
    }
    
    private func setupControls() {
        secondValueStepper.maximumValue = Double.infinity
    }
    
    private func setupInitialValues() {
        firstValueStepper.value = 0
        firstValueStepper.sendActions(for: .valueChanged)
        operationsSegment.selectedSegmentIndex = 0
        operationsSegment.sendActions(for: .valueChanged)
        secondValueStepper.value = 0
        secondValueStepper.sendActions(for: .valueChanged)
    }
    
    private func getResult() {
        spinnerViewController = showSpinnerView()
        viewModel?.fetchResult()
            .sink { [weak self] completion in
                self?.removeSpinerView(spiner: self?.spinnerViewController)
                switch completion {
                case .failure(let error):
                    self?.showPopup(title: "Request Failed", message: error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { [weak self] result in
                self?.showResultView(with: result)
            }
            .store(in: &cancellables)
    }
    
    private func showResultView(with result: String) {
        let vc = ResultViewController()
        vc.setup(with: result)
        navigationController?.pushViewController(vc, animated: true)
    }
}
