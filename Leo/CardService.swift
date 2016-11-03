//
//  CardService.swift
//  Leo
//
//  Created by Adam Fanslau on 10/27/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

class CardService : LEOModelService {

    let endpointName = APIEndpointRouteCards

    class func service(policy: LEOCachePolicy = LEOCachePolicy()) -> CardService {
        return CardService(cachePolicy: policy)
    }

//    MARK: service methods

    func getCards(completion: (([Card]?, NSError?)->())?) -> LEOPromise {
        return cachedService.get(endpointName, params: [:]) {
            jsonResponse, error in

            guard let completion = completion else { return }

            guard let jsonResponse = jsonResponse as? JSON else {
                completion(nil, error as NSError?)
                return
            }

            guard let cardsJSON = jsonResponse["cards"] as? [JSON] else {
                completion(nil, error as NSError?)
                return
            }

            let cards = Card.initMany(cardsJSON)

            completion(cards, error as NSError?)
        }
    }

    func getFeedState() -> FeedState?  {
        // TODO: probably should use a different endpoint here
        guard let json = cachedService.get(endpointName, params: [:]) as? [String : Any] else { return nil }
        guard let cardsJSON = json["cards"] as? [JSON] else { return nil }
        let currentStatesJSON = cardsJSON.map({ return $0["current_state"] })

        let result = FeedState(json: ["card_states" : currentStatesJSON])
        return result
    }

    func getCurrentState(cardID: Int) -> CardState?  {
        return cardsEndpoint(cardID: cardID, stateID: nil)
    }

    func updateCard(cardID: Int, stateID: String) {
        updateCard(cardID: cardID, stateID: stateID, isLoading: nil)
    }

    func updateCard(cardID: Int, stateID: String?, isLoading: Bool?) {
        guard let cardStates = getFeedState()?.cardStates else { return }
        if cardID >= cardStates.count { return }

        var params = [
            "card_id": cardID
        ] as [String : Any]
        if let isLoading = isLoading { params["is_loading"] = isLoading }
        if let stateID = stateID { params["state_id"] = stateID }

        cachedService.put(endpointName, params: params)
    }

    func deleteCard(cardID: Int) {
        guard let cardStates = getFeedState()?.cardStates else { return }
        if cardID >= cardStates.count { return }

        cachedService.destroy(endpointName, params: ["card_id": cardID])
    }

    func deleteContentCard(contentID: Int, completion:LEODictionaryErrorBlock?) -> LEOPromise {

        // TODO: generalize content cards on backend to use the same endpoint/structure

        return cachedService.destroy(APIEndpointCards, params: ["id": contentID], completion: completion)
    }

    func cardsEndpoint(cardID: Int?, stateID: String?) -> CardState? {

        // NOTE: wish there was a better way for this

        var params: [String : Any] = [:]

        if let cardID = cardID {
            params["card_id"] = cardID
        }

        if let stateID = stateID {
            params["state_id"] = stateID
        }

        guard let json = cachedService.get(
            endpointName,
            params: params
            ) as? [String : Any] else { return nil }
        return CardState(json: json)
    }
}
