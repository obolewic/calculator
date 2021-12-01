//
//  SpinnerViewController.swift
//  Calculator
//
//  Created by Marcin Obolewicz on 25/11/2021.
//

import UIKit

final class SpinnerViewController: UIViewController {
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension UIViewController {
    func showSpinnerView() -> SpinnerViewController {
        let spiner = SpinnerViewController()
        addChild(spiner)
        spiner.view.frame = view.frame
        view.addSubview(spiner.view)
        spiner.didMove(toParent: self)
        return spiner
    }
    
    func removeSpinerView(spiner: SpinnerViewController?) {
        spiner?.willMove(toParent: nil)
        spiner?.view.removeFromSuperview()
        spiner?.removeFromParent()
    }
}
