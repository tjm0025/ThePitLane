//
//  DriverModel.swift
//  PitLane
//
//  Created by Tyanna on 11/27/24.
//

import Foundation

struct DriverResponse: Codable {
    let MRData: MRData
}

struct MRData: Codable {
    let DriverTable: DriverTable 
}

struct DriverTable: Codable {
    let season: String
    let drivers: [DriversModel]
    
    enum CodingKeys: String, CodingKey {
        case season
        case drivers = "Drivers"
    }
}

struct DriversModel: Codable, Identifiable {
    let id: String
    let permanentNumber: String
    let code: String
    let url: String
    let givenName: String
    let familyName: String
    let dateOfBirth: String
    let nationality: String
    
    enum CodingKeys: String, CodingKey {
        case id = "driverId"
        case permanentNumber
        case code
        case url
        case givenName
        case familyName
        case dateOfBirth
        case nationality
    }
}
