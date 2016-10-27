//
//  CardCell.swift
//  Leo
//
//  Created by Adam Fanslau on 10/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

class CardCell : UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var button: UIButton?

    public var cardState: CardState? {
        didSet {
            render()
        }
    }

    class func nib() -> UINib {
        return UINib(nibName: String(describing: CardCell.self), bundle: nil)
    }


    public func buttonTapped(sender: UIButton) {
        let index = sender.tag
        guard let cardState = cardState else { return }
        if index >= cardState.buttonActions.count { return }

        let action = cardState.buttonActions[index]
        ActionHandler.handle(action: action)
    }

    public func render() {

        titleLabel?.text = cardState?.title

        if let buttonAction = cardState?.buttonActions.first {
            button?.setTitle(buttonAction.displayName, for: .normal)
            button?.tag = 0
            button?.removeTarget(nil, action: nil, for: .touchUpInside)
            button?.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
        }
    }
}
