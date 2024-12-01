//
//  DriversViewModel.swift
//  PitLane
//
//  Created by Tyanna on 11/27/24.
//

import Foundation

import Combine

class DriversViewModel: ObservableObject {
    
    @Published private(set) var driverData = [DriversModel]()
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchDrivers() {
        isLoading = true
        let url = URL(string: "https://ergast.com/api/f1/2024/drivers.json")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                // Print raw JSON data for debugging
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Raw JSON response:\n\(jsonString)")
                }
                return data
            }
            .decode(type: DriverResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to load data: \(error.localizedDescription)")
                    self.error = error
                }
                self.isLoading = false
            }, receiveValue: { response in
                print("Decoded response: \(response)")
                self.driverData = response.MRData.DriverTable.drivers
            })
            .store(in: &cancellables)
    }
}
