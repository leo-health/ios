//
//  CardCell.swift
//  Leo
//
//  Created by Adam Fanslau on 10/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

extension Selector {
    static let
}

class CardCell : UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var button: UIButton?

    class func nib() -> UINib {
        return UINib(nibName: String(describing: CardCell.self), bundle: nil)
    }

    public func configure(cardState: CardState) {

        titleLabel?.text = cardState.title

        if let buttonAction = cardState.buttonActions.first {
            button?.setTitle(buttonAction.displayName, for: .normal)
            button?.addTarget(self, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
        }


    }
}
