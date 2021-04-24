//
//  TableCell.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit


protocol TableCell {
    func configureCell(with viewModel: TableCellViewModel)
    func bindViewModel()
    func unbindViewModel()
}

extension TableCell {
    var selectedBgView: UIView {
        let view = UIView.init()
        view.backgroundColor = .darkGray
        return view
    }
}
