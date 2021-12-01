//
//  ResultViewController.swift
//  Calculator
//
//  Created by Marcin Obolewicz on 24/11/2021.
//

import UIKit

final class ResultViewController: UIViewController {
    @IBOutlet private weak var resultLabel: UILabel!
    private var result: String?
    
    func setup(with result: String) {
        self.result = result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = result
    }
}
