//
//  DriverListView.swift
//  PitLane
//
//  Created by Tyanna on 11/27/24.
//

import SwiftUI

struct DriverListView: View {
    @StateObject var viewModel = DriversViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let error = viewModel.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                } else if viewModel.driverData.isEmpty {
                    Text("No drivers available")
                } else {
                    List(viewModel.driverData) { driver in
                        NavigationLink(destination: DriverDetailView(driver: driver)) {
                            DriverRowView(driver: driver)
                        }
                    }
                }
            }
            .navigationTitle("2024 Drivers")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .onAppear {
                viewModel.fetchDrivers()
            }
        }
    }
}

struct DriverRowView: View {
    let driver: DriversModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(driver.givenName) \(driver.familyName)")
                .font(.headline)
                .foregroundColor(.red)
                
            Text("Driver Number: \(driver.permanentNumber)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct DriverDetailView: View {
    let driver: DriversModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Driver Card Section
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(driver.permanentNumber))
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(driver.givenName)
                                .font(.title3)
                                .foregroundColor(.gray)
                            
                            Text(driver.familyName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(driver.nationality)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            // Team would need to be added to your model
                            Text("Red Bull Racing") // Example team
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                        
                        Spacer()
                        
                        // Driver Image
                        Image("driver_\(driver.permanentNumber)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            // Fallback if image doesn't exist
                            .onAppear {
                                // You might want to add error handling here
                            }
                    }
                }
                .padding(20)
                .background(Color(hex: "1E1E1E"))
                .cornerRadius(15)
                .shadow(radius: 5)
                
                // Stats Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Statistics")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        StatBox(title: "Points", value: "255")
                        StatBox(title: "Wins", value: "19")
                        StatBox(title: "Podiums", value: "21")
                    }
                }
                .padding(20)
                .background(Color(hex: "1E1E1E"))
                .cornerRadius(15)
                
                // Additional Info
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(label: "Code", value: driver.code)
                    InfoRow(label: "Date of Birth", value: driver.dateOfBirth)
                    Link("Wikipedia Profile", destination: URL(string: driver.url)!)
                        .font(.headline)
                        .foregroundColor(.red)
                }
                .padding(20)
                .background(Color(hex: "1E1E1E"))
                .cornerRadius(15)
            }
            .padding()
        }
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "2A2A2A"))
        .cornerRadius(10)
    }
}

// Helper for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}


#Preview {
    let mockDriver = DriversModel(
        id: "max_verstappen",
        permanentNumber: "1",
        code: "VER",
        url: "https://en.wikipedia.org/wiki/Max_Verstappen",
        givenName: "Max",
        familyName: "Verstappen",
        dateOfBirth: "1997-09-30",
        nationality: "Dutch"
    )
    return DriverDetailView(driver: mockDriver)
}

#Preview {
    let mockDriver = DriversModel(
        id: "max_verstappen",
        permanentNumber: "1",
        code: "VER",
        url: "https://en.wikipedia.org/wiki/Max_Verstappen",
        givenName: "Max",
        familyName: "Verstappen",
        dateOfBirth: "1997-09-30",
        nationality: "Dutch"
    )
    return DriverRowView(driver: mockDriver)
}

#Preview {
    DriverListView()
}
