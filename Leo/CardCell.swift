//
//  CardCell.swift
//  Leo
//
//  Created by Adam Fanslau on 10/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

// TODO: unwrap this into a UIView, then simply render it in a tableViewCell. Goal: so we can use cards in messaging bubbles

// TODO: unread state / notification response

class CardCell : UITableViewCell {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView?
    @IBOutlet private weak var iconImageView: UIImageView?
    @IBOutlet private weak var topBorderLine: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var tintedHeaderLabel: UILabel?
    @IBOutlet private weak var bodyLabel: UILabel?
    @IBOutlet private weak var footerLabel: UILabel?
    @IBOutlet private weak var buttonContainerView: UIView?
    @IBOutlet private weak var button: UIButton?

    public var cardState: CardState? {
        didSet {
            render()
        }
    }

    class func nib() -> UINib {
        return UINib(nibName: String(describing: CardCell.self), bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Constant styling goes here, state dependencies go in render methods below
        activityIndicatorView?.hidesWhenStopped = true

        titleLabel?.font = .leo_medium19()

        tintedHeaderLabel?.backgroundColor = .clear
        tintedHeaderLabel?.font = .leo_bold12()

        bodyLabel?.backgroundColor = .clear
        bodyLabel?.font = .leo_regular15()
        bodyLabel?.textColor = .leo_gray124()

        footerLabel?.backgroundColor = .clear

        buttonContainerView?.backgroundColor = .clear
    }

    public func buttonTapped(sender: UIButton) {
        let index = sender.tag
        guard let cardState = cardState else { return }
        if index >= cardState.buttonActions.count { return }

        let action = cardState.buttonActions[index]
        ActionHandler.handle(action: action)
    }

    public func render() {

        contentView.backgroundColor = UIColor.leo_gray227()

        renderIconImageView()
        renderTitleLabel()
        renderTintedHeaderLabel()
        renderBodyLabel()
        renderFooterLabel()
        renderButtonView()
    }

    private func renderIconImageView() {
//        iconImageView?.image = cardState?.icon
    }

    private func renderTopBorderLine() {
        topBorderLine?.backgroundColor = cardState?.color
    }

    private func renderTitleLabel() {
        titleLabel?.backgroundColor = .clear
        titleLabel?.text = cardState?.title
    }

    private func renderTintedHeaderLabel() {
        tintedHeaderLabel?.textColor = cardState?.color
        tintedHeaderLabel?.text = cardState?.tintedHeader
    }

    private func renderBodyLabel() {

        // TODO: TTAttributedLabel

        bodyLabel?.text = cardState?.body
    }

    private func renderFooterLabel() {
        footerLabel?.text = cardState?.footer
    }

    private func renderButtonView() {

        if let buttonAction = cardState?.buttonActions.first {
            button?.tintColor = cardState?.color
            button?.setTitle(buttonAction.displayName, for: .normal)
            button?.tag = 0
            button?.removeTarget(nil, action: nil, for: .touchUpInside)
            button?.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
        }
    }
}
