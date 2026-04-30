//
//  BeerHopperApp.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//

import SwiftUI

@main
struct BeerHopperApp: App {
    @StateObject
    private var compositionRoot: AppCompositionRoot

    init() {
        self._compositionRoot = StateObject(wrappedValue: AppCompositionRoot())
    }

    var body: some Scene {
        WindowGroup {
            AppShellView(
                router: self.compositionRoot.router,
                sessionStore: self.compositionRoot.sessionStore
            )
                .onOpenURL { url in
                    self.compositionRoot.open(url)
                }
        }
    }
}

#Preview {
    AppShellView(
        router: AppRouter(),
        sessionStore: AppSessionStore(initialState: .signedOut)
    )
}
