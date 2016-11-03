//
//  Card.swift
//  Leo
//
//  Created by Adam Fanslau on 10/27/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

class Card : NSObject, JSONSerializable {
    let cardID: Int
    let cardType: String
    var currentState: CardState
    let states: [CardState]

    // TODO: how to handle associatedData? subclasses?

    required convenience init?(json: JSON) {
        guard let cardID = json["card_id"] as? Int else { return nil }
        guard let cardType = json["card_type"] as? String else { return nil }
        guard let currentStateJSON = json["current_state"] as? JSON else { return nil }
        guard let statesJSON = json["states"] as? [JSON] else { return nil }
        guard let currentState = CardState(json: currentStateJSON) else { return nil }
        let states = CardState.initMany(jsonArray: statesJSON)

        self.init(
            cardID: cardID,
            cardType: cardType,
            currentState: currentState,
            states: states
        )
    }

    // TODO: find a way to use swift protocol features in combination with objc
    static func json(_ objects: [Card]) -> [JSON] {
        return objects.map({$0.json()})
    }

    static func initMany(_ jsonArray: [JSON]) -> [Card] {
        return jsonArray.flatMap({ Card(json: $0) })
    }

    func json() -> JSON {
        return [
            "card_id": cardID,
            "card_type": cardType,
            "current_state": currentState.json(),
            "states": CardState.json(states)
        ]
    }

    init(
        cardID: Int,
        cardType: String,
        currentState: CardState, 
        states: [CardState]
        ) {
        self.cardID = cardID
        self.cardType = cardType
        self.currentState = currentState
        self.states = states
        super.init()
    }

    func setCurrentState(stateType: String) {
        guard let state = states.first(where: { state in
            return state.cardStateType == stateType
        }) else { return }
        currentState = state
    }
}
