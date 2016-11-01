//
//  SurveyService.swift
//  Leo
//
//  Created by Adam Fanslau on 10/31/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

class SurveyService : LEOModelService {

    let endpointName = APIEndpointSurveys

    //    MARK: Factories
    class func cacheOnly() -> SurveyService {
        let policy = LEOCachePolicy.cacheOnly()
        return service(policy: policy)
    }

    class func service(policy: LEOCachePolicy = LEOCachePolicy()) -> SurveyService {
        return SurveyService(cachePolicy: policy)
    }

    //    MARK: service methods
    func getSurvey(id: String) -> Survey? {
        guard let surveyJSON = cachedService.get(endpointName, params: ["id" : id]) as? JSON else { return nil }
        let response = Survey(json: surveyJSON)

        return response
    }
}
