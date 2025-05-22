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
    // Initialize the AuthProvider with both providers
    private let authProvider = AuthProvider(providers: [
        GooglePassportProvider.shared,
        InternalPassportProvider.shared
    ])
    
    var body: some Scene {
        WindowGroup {
            DashboardTabView()
                .onOpenURL { url in
                    Task {
                        await authProvider.handleSignIn(from: url)
                    }
                }
                .onAppear {
                    Task {
                        if let clientID = ProcessInfo.processInfo.environment["CLIENT_ID"] {
                            await GooglePassportProvider.configure(clientID)
                        }
                        
                        do {
                            try await authProvider.restorePreviousSession()
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
