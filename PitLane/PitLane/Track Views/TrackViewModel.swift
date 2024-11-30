//
//  TrackViewModel.swift
//  PitLane
//
//  Created by Tyanna on 11/30/24.
//

import Foundation
import Combine

class TrackViewModel: ObservableObject {
    @Published private(set) var trackData = [Race]()
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchTracks() {
        isLoading = true
        let url = URL(string: "https://ergast.com/api/f1/current.json")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                // Debug print the raw response
                print("Response received")
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }
                
                // Print raw JSON data for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response:\n\(jsonString)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: TrackResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Data loading completed successfully")
                case .failure(let error):
                    print("Failed to load data: \(error)")
                    print("Error description: \(error.localizedDescription)")
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .dataCorrupted(let context):
                            print("Data corrupted: \(context)")
                        case .keyNotFound(let key, let context):
                            print("Key '\(key)' not found: \(context)")
                        case .typeMismatch(let type, let context):
                            print("Type mismatch for type '\(type)': \(context)")
                        case .valueNotFound(let type, let context):
                            print("Value of type '\(type)' not found: \(context)")
                        @unknown default:
                            print("Unknown decoding error")
                        }
                    }
                    self.error = error
                }
                self.isLoading = false
            }, receiveValue: { response in
                print("Successfully decoded response")
                print("Number of races: \(response.MRData.RaceTable.Races.count)")
                self.trackData = response.MRData.RaceTable.Races
            })
            .store(in: &cancellables)
    }
}
