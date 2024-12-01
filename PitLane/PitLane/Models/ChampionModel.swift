//
//  ChampionModel.swift
//  PitLane
//
//  Created by Tyanna on 11/30/24.
//

import Foundation

struct ChampionshipResponse: Codable {
    let MRData: ChampionshipMRData
}

struct ChampionshipMRData: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit: String
    let offset: String
    let total: String
    let StandingsTable: StandingsTable
}

struct StandingsTable: Codable {
    let season: String
    let StandingsLists: [StandingsList]
}

struct StandingsList: Codable {
    let season: String
    let round: String
    let DriverStandings: [DriverStanding]
}

struct DriverStanding: Codable, Identifiable {
    let position: String
    let positionText: String
    let points: String
    let wins: String
    let Driver: Driver
    let Constructors: [Constructor]
    
    var id: String { position }
}

struct Driver: Codable {
    let driverId: String
    let permanentNumber: String
    let code: String
    let url: String
    let givenName: String
    let familyName: String
    let dateOfBirth: String
    let nationality: String
}

struct Constructor: Codable {
    let constructorId: String
    let url: String
    let name: String
    let nationality: String
}
