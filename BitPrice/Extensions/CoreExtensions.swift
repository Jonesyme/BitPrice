//
//  CoreExtentions.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    func toShortString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}

extension String {
    func parseDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else {
            assertionFailure("Unable to parse date from string")
            return Date()
        }
        return date
    }
}

extension UITableView {
    public func register(nibName: String) {
        register(nibName: nibName, withReuseCellIdentifier: nibName)
    }
    public func register(nibName: String, withReuseCellIdentifier: String) {
        let nib = UINib(nibName: nibName, bundle: .main)
        register(nib, forCellReuseIdentifier: withReuseCellIdentifier)
    }
}

extension UITableViewCell {
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

extension UIView {
    func edgeConstraints(to view: UIView, margin: CGFloat = 0) -> [NSLayoutConstraint] {
        return [
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: margin),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin)
        ]
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

