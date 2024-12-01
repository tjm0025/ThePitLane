//
//  TrackModel.swift
//  PitLane
//
//  Created by Tyanna on 11/30/24.
//

import Foundation

struct TrackResponse: Codable {
    let MRData: TrackMRData
}

struct TrackMRData: Codable {
    let xmlns: String
    let series: String
    let url: String
    let limit: String
    let offset: String
    let total: String
    let RaceTable: RaceTable
}

struct RaceTable: Codable {
    let season: String
    let Races: [Race]
}

struct Race: Codable, Identifiable {
    let season: String
    let round: String
    let url: String
    let raceName: String
    let Circuit: Circuit
    let date: String
    let time: String
    let FirstPractice: Session?  // Made optional
    let SecondPractice: Session? // Made optional
    let ThirdPractice: Session?  // Made optional
    let Qualifying: Session?     // Made optional
    let Sprint: Session?         // Added Sprint session
    
    var id: String { round }
}

struct Circuit: Codable {
    let circuitId: String
    let url: String
    let circuitName: String
    let Location: Location
}

struct Location: Codable {
    let lat: String
    let long: String
    let locality: String
    let country: String
}

struct Session: Codable {
    let date: String
    let time: String
}
