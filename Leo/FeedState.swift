//
//  FeedState.swift
//  Leo
//
//  Created by Adam Fanslau on 10/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation


public class Card : NSObject {
    let cardType: String
    let associatedData: Any? // TODO: type safety
    let states: [CardState]
    var currentState: CardState

    // Why must I still do this...
    init(cardType: String, associatedData: Any?, states: [CardState], currentState: CardState) {
        self.cardType = cardType
        self.associatedData = associatedData
        self.states = states
        self.currentState = currentState

        super.init()
    }

    func setCurrentState(stateType: String) {
        guard let state = states.first(where: { state in
            return state.cardStateType == stateType
        }) else { return }
        currentState = state
    }
    // ????: should Immutability be a goal here?
    // this would be much easier if cards and states were a single object... no mutation necessary
}

public class CardState : NSObject {
    let cardStateType: String
    let title: String
    let tintedHeader: String
    let body: String
    let footer: String
    let buttonActions: [Action]

    init(
        cardStateType: String,
        title: String,
        tintedHeader: String,
        body: String,
        footer: String,
        buttonActions: [Action]
        ) {
        self.cardStateType = cardStateType
        self.title = title
        self.tintedHeader = tintedHeader
        self.body = body
        self.footer = footer
        self.buttonActions = buttonActions

        super.init()
    }
}

public class FeedState : NSObject {
    public static let changeNotificationName = "FeedState-changed"

    static var cards: [Card] = [] {
        didSet {
            notifyObservers()
        }
    }

    public class func updateCard(
        at index: Int,
        withStateType stateType: String
    ) {
        if index >= cards.count { return }
        cards[index].setCurrentState(stateType: stateType)

        // does this update the array? structs are passed by value
        notifyObservers()
    }

    private class func notifyObservers() {
        NotificationCenter.default.post(
            Notification(name: Notification.Name(changeNotificationName))
        )
    }
}

