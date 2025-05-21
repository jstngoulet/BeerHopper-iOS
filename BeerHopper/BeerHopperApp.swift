//
//  BeerHopperApp.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//

import SwiftUI
import NetworkingAPI

@main
struct BeerHopperApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardTabView()
                .onOpenURL { url in
                    AuthProvider.handleSignIn(from: url)
                }
                .onAppear {
                    
                    GooglePassportProvider.configure(
                        "871905328220-0damoj4rs1oaf62lq2ibm225664q6ntp.apps.googleusercontent.com" as NSString
                    )
                    
                    Task {
                        do {
                            try await AuthProvider.restorePreviousSession()
                        } catch {
                            print("Not signed in: \(error.localizedDescription)")
                        }
                    }
                }
        }
    }
}

#Preview {
    DashboardTabView()
}
