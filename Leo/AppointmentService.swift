//
//  AppointmentService.swift
//  Leo
//
//  Created by Adam Fanslau on 10/31/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

import Foundation

class AppointmentService : LEOModelService {

    static let endpointName = APIEndpointAppointments

    public class func service(policy: LEOCachePolicy = LEOCachePolicy()) -> AppointmentService {
        return AppointmentService(cachePolicy: policy)
    }

    //    MARK: service methods

    public func cancel(appointmentID: String, completion: ((NSError?)->Void)?) -> LEOPromise {
        return cachedService.destroy(AppointmentService.endpointName, params: ["id":appointmentID]) {
            _, error in

            guard let completion = completion else { return }
            completion(error as NSError?)
        }
    }

    public func getAppointment(appointmentID: String, completion: ((Appointment?, NSError?)->Void)?) -> LEOPromise {
        return cachedService.get(AppointmentService.endpointName, params: ["appointment_id":appointmentID]) {
            jsonResponse, error in

            guard let completion = completion else { return }

            guard let jsonResponse = jsonResponse as? JSON else {
                completion(nil, error as NSError?)
                return
            }

            let appointment = Appointment(jsonDictionary: jsonResponse)

            completion(appointment, error as NSError?)
        }
    }

    public func getAppointment(appointmentID: String) -> Appointment? {
        guard let json = cachedService.get(
            AppointmentService.endpointName,
            params: ["appointment_id":appointmentID]
            ) as? [String : Any] else { return nil }
        return Appointment(jsonDictionary: json)
    }
}
