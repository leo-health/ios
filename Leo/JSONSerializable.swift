//
//  JSONSerializable.swift
//  Leo
//
//  Created by Adam Fanslau on 10/27/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

typealias JSON = [String : Any]

protocol JSONSerializable {
    func json() -> JSON
    init?(json: JSON)
}

extension JSONSerializable {
    static func json(_ objects: [JSONSerializable]) -> [JSON] {
        return objects.map({object in object.json()})
    }

    static func initMany(jsonArray: [JSON]) -> [Self] {
        return jsonArray
            .map({ Self(json: $0) })
            .filter({ $0 != nil })
            .map({ $0! })
        // ????: what's the desired functionality here? should the entire method fail if the internal init fails?
    }
}
