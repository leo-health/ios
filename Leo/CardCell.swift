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
    @IBOutlet private weak var bodyLabel: TTTAttributedLabel?
    @IBOutlet private weak var footerLabel: UILabel?
    @IBOutlet private weak var buttonContainerView: UIView?
    @IBOutlet private weak var buttonStack: UIStackView?

    var attributedLabelDelegate: LEOFeedCellDelegate!
    var cardState: CardState!

    func requiredConfigure(cardState: CardState, attributedLabelDelegate: TTTAttributedLabelDelegate) {
        self.cardState = cardState
        bodyLabel?.delegate = attributedLabelDelegate
        render()
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
        footerLabel?.textColor = .leo_gray185()
        footerLabel?.font = .leo_bold12()

        buttonContainerView?.backgroundColor = .clear
    }

    private func render() {
        contentView.backgroundColor = .leo_gray227()

        renderActivityIndicatorView()
        renderIconImageView()
        renderTitleLabel()
        renderTintedHeaderLabel()
        renderBodyLabel()
        renderFooterLabel()
        renderButtonView()
    }

    private func renderActivityIndicatorView() {
        guard let shouldBeLoading = cardState?.isLoading else { return }
        guard let isLoading = activityIndicatorView?.isAnimating else { return }
        if !isLoading && shouldBeLoading {
            activityIndicatorView?.startAnimating()
        }
    }

    private func renderIconImageView() {
        iconImageView?.image = cardState?.icon?.image
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
        let color: UIColor = cardState?.color ?? .leo_gray124()
        let text = cardState?.body

        let linkAttributes = [
            NSForegroundColorAttributeName: color,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
            NSUnderlineColorAttributeName: color
        ] as [String : Any]

        bodyLabel?.linkAttributes = linkAttributes;
        bodyLabel?.inactiveLinkAttributes = linkAttributes;
        bodyLabel?.activeLinkAttributes = linkAttributes;
        bodyLabel?.enabledTextCheckingTypes =
            ([.link, .date, .phoneNumber] as [NSTextCheckingResult.CheckingType])
                .map{$0.rawValue}.reduce(0, |)
        bodyLabel?.text = text
    }

    private func renderFooterLabel() {
        footerLabel?.text = cardState?.footer
    }

    private func renderButtonView() {

        guard let buttonStack = buttonStack else { return }
        guard let cardState = cardState else { return }

        // add if needed, configure buttons
        var index = 0
        while index < cardState.buttonActions.count {

            let action = cardState.buttonActions[index]
            let button = getOrCreateButton(index: index, stackView: buttonStack)
            configure(button: button, index: index, action: action)
            index += 1
        }

        // remove extra arranged subviews if needed
        while index < buttonStack.arrangedSubviews.count {

            let view = buttonStack.arrangedSubviews[index]
            buttonStack.removeArrangedSubview(view)
            view.removeFromSuperview()
            index += 1
        }
    }

    private func getOrCreateButton(index: Int, stackView: UIStackView) -> UIButton {

        if index < stackView.arrangedSubviews.count {
            return stackView.arrangedSubviews[index] as! UIButton
        }

        let button = UIButton()
        stackView.addArrangedSubview(button)
        return button
    }

    private func configure(button: UIButton, index: Int, action: Action) {

        button.setTitleColor(cardState?.color, for: .normal)
        button.titleLabel?.font = .leo_medium12()
        button.setTitle(action.displayName, for: .normal)
        button.tag = index
        button.removeTarget(nil, action: nil, for: .touchUpInside)
        button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
    }

    @objc private func buttonTapped(sender: UIButton) {
        let index = sender.tag
        guard let cardState = cardState else { return }
        if index >= cardState.buttonActions.count { return }

        let action = cardState.buttonActions[index]
        ActionHandler.handle(action: action)
    }
}
