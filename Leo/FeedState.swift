//
//  FeedState.swift
//  Leo
//
//  Created by Adam Fanslau on 10/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

extension FeedState : JSONSerializable {
    func json() -> JSON {
        return [
            "card_states" : CardState.json(cardStates)
        ]
    }
}

class FeedState : NSObject {
    var cardStates: [CardState] = []

    convenience init(cardStates: [CardState]) {
        self.init()
        self.cardStates = cardStates
    }

    required convenience init?(json: JSON) {
        guard let cardStatesJSON = json["card_states"] as? [JSON] else { return nil }
        let cardStates = CardState.initMany(jsonArray: cardStatesJSON)

        self.init(cardStates: cardStates)
    }
}

