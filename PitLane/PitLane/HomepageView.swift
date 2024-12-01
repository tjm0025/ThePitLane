//
//  HomepageView.swift
//  PitLane
//
//  Created by Tyanna on 11/28/24.
//

import SwiftUI

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageSystemName: String
    let timestamp: String
}

struct HomepageView: View {
    //state for the countdown timer
    @State private var timeRemaining: TimeInterval = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //News Items from Formula 1.com
        let newsItems = [
            NewsItem(
                title: "Ocon and Alpine boss praise Abby Pulling",
                subtitle: "F1 Academy driver looks to seal F1 Academy title",
                imageSystemName: "trophy.fill",
                timestamp: "2h ago"
            ),
            NewsItem(
                title: "Mick Schumacher leaves Mercedes",
                subtitle: "Mercedes-AMG confirms depature",
                imageSystemName: "doc.text.fill",
                timestamp: "4h ago"
            ),
            NewsItem(
                title: "It's Race Week",
                subtitle: "5 storylines we're excited for ahead of the Qatar GP",
                imageSystemName: "car.fill",
                timestamp: "6h ago"
            )
        ]
    
    //Next race date (Qatar GP)
    let nextRaceDate: Date = {
        var components = DateComponents()
        components.year = 2024
        components.month = 12
        components.day = 1
        components.hour = 10
        components.minute = 0
        components.second = 0
        
        //set to CST
        let timeZone = TimeZone(identifier: "America/Chicago")!
        components.timeZone = timeZone
        
        let calendar = Calendar.current
        return calendar.date(from: components) ?? Date()
        
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                //Title
                Text("PitLane")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                //Race info
                VStack(spacing: 16) {
                    Text("Next Race")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(.systemGray))
                        .tracking(1.5)
                    
                    Text("Round 22")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("Qatar")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Formula 1 Qatar Airways Qatar Grand Prix 2024")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 16)
                    .fill(Color(white: 0.1)))
                .padding(.horizontal)
                
                //Countdown Timer
                VStack(spacing: 8) {
                    HStack(spacing: 16) {
                        TimeComponent(value: Int(timeRemaining) / 86400, unit: "Days")
                        TimeComponent(value: (Int(timeRemaining) % 86400) / 3600, unit: "Hours")
                        TimeComponent(value: ((Int(timeRemaining) % 86400) % 3600) / 60, unit: "Minutes")
                        TimeComponent(value: ((Int(timeRemaining) % 86400) % 3600) % 60, unit: "Seconds")
                    }
                    
                    Text("December 1, 2024 - 10:00 AM CST")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.systemGray))
                        .padding(.top, 8)
                }
                //News Feed Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Latest News")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ForEach(newsItems) { item in
                        NewsItemView(item: item)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 90)
                
            }

        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            updateTimeRemaining()
        }
        .onReceive(timer) { _ in
            updateTimeRemaining()
        }
    }
    
    private func updateTimeRemaining() {
        timeRemaining = nextRaceDate.timeIntervalSinceNow
        if timeRemaining < 0 {
            timeRemaining = 0
        }
    }
}

struct TimeComponent: View {
    let value: Int
    let unit: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 32, weight: .bold))
                .monospacedDigit()
                .foregroundColor(.white)
            Text(unit)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(.systemGray))
        }
        .frame(width: 72)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: 0.1))
        )
    }
}

struct NewsItemView: View {
    let item: NewsItem
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: item.imageSystemName)
                .font(.system(size: 24))
                .foregroundColor(.red)
                .frame(width: 40, height: 40)
                .background(Color(white: 0.1))
                .clipShape(Circle())
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(item.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                
                Text(item.timestamp)
                    .font(.system(size: 12))
                    .foregroundColor(Color(.systemGray2))
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .foregroundColor(Color(.systemGray))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding()
        .background(Color(white: 0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    HomepageView()
}
