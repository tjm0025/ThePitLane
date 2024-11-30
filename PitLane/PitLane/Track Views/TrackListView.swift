//
//  TrackListView.swift
//  PitLane
//
//  Created by Tyanna on 11/27/24.
//

import SwiftUI


struct TrackListView: View {
    @StateObject private var viewModel = TrackViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.trackData) { race in
                                    NavigationLink {
                                        TrackDetailView(race: race)
                                    } label: {
                                        TrackRowView(race: race)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.vertical, 20)
                        }
                    }
                }
            }
            .navigationTitle("Race Calendar")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .refreshable {
                viewModel.fetchTracks()
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.error != nil },
                set: { if !$0 { viewModel.error = nil } }
            )) {
                Button("Retry") {
                    viewModel.fetchTracks()
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            }
        }
        .onAppear {
            viewModel.fetchTracks()
        }
    }
}

struct TrackRowView: View {
    let race: Race
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(race.raceName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(race.Circuit.Location.country)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.systemGray))
                }
                
                Spacer()
                
                Text(formatDate(race.date))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(.systemGray))
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: 0.1))
        )
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: date)
    }
}

struct TrackDetailView: View {
    let race: Race
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Race Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(race.raceName)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("\(race.Circuit.Location.locality), \(race.Circuit.Location.country)")
                        .font(.system(size: 18))
                        .foregroundColor(Color(.systemGray))
                }
                
                // Circuit Info
                VStack(alignment: .leading, spacing: 16) {
                    Text("Circuit Information")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        TrackInfoRow(label: "Circuit Name", value: race.Circuit.circuitName)
                        TrackInfoRow(label: "Location", value: "\(race.Circuit.Location.locality), \(race.Circuit.Location.country)")
                        TrackInfoRow(label: "Coordinates", value: "Lat: \(race.Circuit.Location.lat), Long: \(race.Circuit.Location.long)")
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(white: 0.1))
                )
                
                // Race Schedule
                VStack(alignment: .leading, spacing: 16) {
                    Text("Race Weekend Schedule")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 16) {
                        if let fp1 = race.FirstPractice {
                            TrackSessionRow(name: "First Practice", session: fp1)
                        }
                        if let fp2 = race.SecondPractice {
                            TrackSessionRow(name: "Second Practice", session: fp2)
                        }
                        if let fp3 = race.ThirdPractice {
                            TrackSessionRow(name: "Third Practice", session: fp3)
                        }
                        if let sprint = race.Sprint {
                            TrackSessionRow(name: "Sprint", session: sprint)
                        }
                        if let qualifying = race.Qualifying {
                            TrackSessionRow(name: "Qualifying", session: qualifying)
                        }
                        TrackSessionRow(name: "Race", date: race.date, time: race.time)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(white: 0.1))
                )
                
                Link(destination: URL(string: race.url)!) {
                    HStack {
                        Text("View on Wikipedia")
                            .font(.system(size: 16, weight: .medium))
                        Image(systemName: "link")
                    }
                    .foregroundColor(.red)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TrackInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
            Spacer()
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct TrackSessionRow: View {
    let name: String
    var date: String
    var time: String
    
    init(name: String, session: Session) {
        self.name = name
        self.date = session.date
        self.time = session.time
    }
    
    init(name: String, date: String, time: String) {
        self.name = name
        self.date = date
        self.time = time
    }
    
    var body: some View {
        HStack {
            Text(name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(formatDateTime(date: date, time: time))
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
        }
    }
    
    private func formatDateTime(date: String, time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        guard let datetime = dateFormatter.date(from: "\(date)T\(time)") else {
            return "\(date) \(time)"
        }
        
        dateFormatter.dateFormat = "MMM d - HH:mm"
        return dateFormatter.string(from: datetime)
    }
}


