//
//  CardService.swift
//  Leo
//
//  Created by Adam Fanslau on 10/27/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

class CardService : LEOModelService {

    static let endpointName = APIEndpointRouteCards

//    MARK: Factories
    public class func cacheOnly() -> CardService {
        let policy = LEOCachePolicy.cacheOnly()
        return service(policy: policy)
    }

    public class func service(policy: LEOCachePolicy = LEOCachePolicy()) -> CardService {
        return CardService(cachePolicy: policy)
    }

//    MARK: service methods

    public func getFeedState() -> FeedState?  {
        // probably should use a different endpoint here
        guard let json = cachedService.get(CardService.endpointName, params: [:]) as? [String : Any] else { return nil }
        guard let cardsJSON = json["cards"] as? [JSON] else { return nil }
        let currentStatesJSON = cardsJSON.map({ return $0["currentState"] })

        return FeedState(json: ["card_states" : currentStatesJSON])
    }

    public func getCardState(cardID: Int, stateID: String) -> CardState?  {
        return cardsEndpoint(cardID: cardID, stateID: stateID)
    }

    public func getCurrentState(cardID: Int) -> CardState?  {
        return cardsEndpoint(cardID: cardID, stateID: nil)
    }

    public func updateCard(cardID: Int, stateID: String) {
        guard let cardStates = getFeedState()?.cardStates else { return }
        if cardID >= cardStates.count { return }

        cachedService.put(CardService.endpointName, params: [
            "cardID": cardID,
            "stateID": stateID
            ]
        )
    }

    public func cardsEndpoint(cardID: Int?, stateID: String?) -> CardState? {

        // NOTE: wish there was a better way for this

        var params: [String : Any] = [:]

        if let cardID = cardID {
            params["cardID"] = cardID
        }

        if let stateID = stateID {
            params["stateID"] = stateID
        }

        guard let json = cachedService.get(
            CardService.endpointName,
            params: params
            ) as? [String : Any] else { return nil }
        return CardState(json: json)
    }
}
