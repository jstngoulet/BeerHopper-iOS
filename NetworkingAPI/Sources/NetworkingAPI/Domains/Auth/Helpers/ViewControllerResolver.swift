//
//  ViewControllerResolver.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/21/25.
//



import SwiftUI
import UIKit

/// A SwiftUI-compatible utility for resolving the topmost `UIViewController` currently
/// displayed in the app. This is necessary for presenting UIKit flows (e.g., Google Sign-In)
/// from SwiftUI views that lack direct controller access.
///
/// The resolver uses an invisible background view to determine the controller at runtime
/// and passes it back via the `onResolve` closure.

@MainActor
struct ViewControllerResolver: UIViewControllerRepresentable {
    var onResolve: (UIViewController) -> Void
    
    func makeUIViewController(context: Context) -> ResolverViewController {
        ResolverViewController(onResolve: onResolve)
    }
    
    func updateUIViewController(_ uiViewController: ResolverViewController, context: Context) { }
    
    @MainActor
    class ResolverViewController: UIViewController {
        let onResolve: (UIViewController) -> Void
        
        init(onResolve: @escaping (UIViewController) -> Void) {
            self.onResolve = onResolve
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            DispatchQueue.main.async {
                self.onResolve(self.topMostViewController() ?? self)
            }
        }
    }
}

extension UIViewController {
    /// Traverses the presentation stack to find the top-most visible view controller
    /// from the current context. Useful for identifying the active presenter
    /// when multiple modals or navigation stacks may be in use.
    func topMostViewController() -> UIViewController? {
        var current = self
        while let presented = current.presentedViewController {
            current = presented
        }
        return current
    }
}
