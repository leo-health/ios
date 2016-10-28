//
//  CardState.swift
//  Leo
//
//  Created by Adam Fanslau on 10/27/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

class CardState : NSObject, JSONSerializable {
    static let changeNotificationName = "CardState-changed"

    // TODO: Boilerplate reduction, code generation?

    let cardStateType: String
    let color: UIColor = .purple // TODO: pull from json
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

    required convenience init?(json: JSON) {

        guard let cardStateType = json["card_state_type"] as? String else { return nil }
        guard let title = json["title"] as? String else { return nil }
        guard let tintedHeader = json["tinted_header"] as? String else { return nil }
        guard let body = json["body"] as? String else { return nil }
        guard let footer = json["footer"] as? String else { return nil }
        guard let buttonActionsJSON = json["button_actions"] as? [JSON] else { return nil }

        let buttonActions = Action.initMany(jsonArray: buttonActionsJSON)

        self.init(cardStateType: cardStateType,
                  title: title,
                  tintedHeader: tintedHeader,
                  body: body,
                  footer: footer,
                  buttonActions: buttonActions)
    }

    public func json() -> [String : Any] {

      return [
        "card_state_type": cardStateType,
        "title": title,
        "tinted_header": tintedHeader,
        "body": body,
        "footer": footer,
        "button_actions": Action.json(buttonActions)
      ]

//        // For optional members
//        var json = [String:Any]()
//
//        if let cardStateType = cardStateType {
//            json["card_state_type"] = cardStateType
//        }
//        if let title = title {
//            json["title"] = title
//        }
//        if let tintedHeader = tintedHeader {
//            json["tinted_header"] = tintedHeader
//        }
//        if let body = body {
//            json["body"] = body
//        }
//        if let footer = footer {
//            json["footer"] = footer
//        }
//        if let buttonActions = buttonActions {
//            json["button_actions"] = buttonActions
//        }
//        return json
    }
}
