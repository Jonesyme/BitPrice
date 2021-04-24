//
//  LivePriceCell.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit


class LivePriceCell: UITableViewCell {
    
    public static let fontSize: CGFloat = 28.0
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var loadingIdicator: UIActivityIndicatorView!
    
    private var viewModel: LivePriceCellViewModel?
    
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


extension LivePriceCell: TableCell {
    
    func configureCell(with viewModel: TableCellViewModel) {
        guard let viewModel = viewModel as? LivePriceCellViewModel else { return }
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
            self?.priceLabel.attributedText = priceRecord?.attributedPriceString(fontSize: LivePriceCell.fontSize)
        }
    }
    
    func unbindViewModel() {
        viewModel?.isLoading.removeObserver()
        viewModel?.priceRecord.removeObserver()
    }

}
