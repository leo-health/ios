//
//  ConversationService.swift
//  Leo
//
//  Created by Adam Fanslau on 10/30/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

class ConversationService : LEOModelService {

    static let endpointName = APIEndpointConversations

//    MARK: Factories
    public class func cacheOnly() -> ConversationService {
        let policy = LEOCachePolicy.cacheOnly()
        return service(policy: policy)
    }

    public class func service(policy: LEOCachePolicy = LEOCachePolicy()) -> ConversationService {
        return ConversationService(cachePolicy: policy)
    }

//    MARK: service methods

    public func getConversation(completion: ((Conversation?, NSError?)->Void)?) -> LEOPromise {
        return cachedService.get(ConversationService.endpointName, params: [:]) {
            jsonResponse, error in

            guard let completion = completion else { return }

            guard let jsonResponse = jsonResponse as? JSON else {
                completion(nil, error as NSError?)
                return
            }

            let conversation = Conversation(jsonDictionary: jsonResponse)

            completion(conversation, error as NSError?)
        }
    }

    public func getConversation() -> Conversation? {
        guard let json = cachedService.get(
            ConversationService.endpointName,
            params: [:]
            ) as? [String : Any] else { return nil }
        return Conversation(jsonDictionary: json)
    }
}
