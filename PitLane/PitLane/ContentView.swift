//
//  ContentView.swift
//  PitLane
//
//  Created by Tyanna on 11/27/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            HomepageView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            DriverListView()
                .tabItem {
                    Label("Drivers", systemImage: "person.2.fill")
                }
            
            TrackListView()
                .tabItem {
                    Label("Tracks", systemImage: "map.fill")
                }
            
            ChampionshipStandingsView()
                .tabItem {
                    Label("Standings", systemImage: "chart.bar.fill")
                }
        }
        .accentColor(.red)
    }
}
