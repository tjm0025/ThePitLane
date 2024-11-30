//
//  ChampionshipStandingsView.swift
//  PitLane
//
//  Created by Tyanna on 11/27/24.
//

import SwiftUI

struct ChampionshipStandingsView: View {
    @StateObject private var viewModel = ChampionshipViewModel()
    
    var body: some View {
        ZStack {
            // Background color
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Title
                VStack(spacing: 8) {
                    Text("Standings")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("2024 Driver Championship")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(.systemGray))
                        .tracking(1.5)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)
                
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.championshipData) { standing in
                                StandingRowView(standing: standing)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .refreshable {
                        viewModel.fetchChampionship()
                    }
                }
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.error != nil },
            set: { if !$0 { viewModel.error = nil } }
        )) {
            Button("Retry") {
                viewModel.fetchChampionship()
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Unknown error")
        }
        .onAppear {
            viewModel.fetchChampionship()
        }
    }
}

struct StandingRowView: View {
    let standing: DriverStanding
    
    var body: some View {
        HStack(spacing: 16) {
            // Championship Position
            Text(standing.position)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 40)
            
            // Driver Details
            VStack(alignment: .leading, spacing: 4) {
                Text("\(standing.Driver.givenName) \(standing.Driver.familyName)")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(standing.Constructors.first?.name ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
            }
            
            Spacer()
            
            // Points & # of Wins
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(standing.points) PTS")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                if standing.wins != "0" {
                    Text("\(standing.wins) wins")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.systemGray))
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: 0.1))
        )
    }
}

// Preview
struct ChampionshipStandingsView_Previews: PreviewProvider {
    static var previews: some View {
        ChampionshipStandingsView()
    }
}
