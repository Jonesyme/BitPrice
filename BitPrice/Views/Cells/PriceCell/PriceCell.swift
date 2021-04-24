//
//  PriceCell.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit


class PriceCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var loadingIdicator: UIActivityIndicatorView!
    
    private var viewModel: PriceCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = selectedBgView
        viewModel?.isLoading.value = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        unbindViewModel()
    }
}


extension PriceCell: TableCell {

    func configureCell(with viewModel: TableCellViewModel) {
        guard let viewModel = viewModel as? PriceCellViewModel else { return }
        self.viewModel = viewModel
        bindViewModel()
    }

    func bindViewModel() {
        viewModel?.isLoading.addObserver { [weak self] (isLoading) in
            if isLoading {
                self?.priceLabel.isHidden = true
                self?.loadingIdicator.startAnimating()
            } else {
                self?.loadingIdicator.stopAnimating()
                self?.priceLabel.isHidden = false
            }
        }
        viewModel?.priceRecord.addObserver { [weak self] (priceRecord) in
            self?.dateLabel.text = priceRecord?.date.toShortString()
            self?.priceLabel.attributedText = priceRecord?.attributedPriceString()
        }
    }
    
    func unbindViewModel() {
        viewModel?.isLoading.removeObserver()
        viewModel?.priceRecord.removeObserver()
    }

}
