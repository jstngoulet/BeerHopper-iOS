//
//  InternalGoogleSignInButton.swift
//  NetworkingAPI
//
//  Created by Justin Goulet on 5/21/25.
//

import SwiftUI
import GoogleSignInSwift

final class InternalGoogleSignInButtonModel: ObservableObject {
    
    public enum InternalGoogleSignInError: LocalizedError {
        case unableToObtainController
    }
    
    let tokenCallback: @MainActor (Result<Token, Error>) -> Void
    
    var parentController: UIViewController?
    
    init(
        tokenCallback: @Sendable @escaping (Result<Token, Error>) -> Void,
        parentController: UIViewController? = nil
    ) {
        self.tokenCallback = tokenCallback
        self.parentController = parentController
    }
    
    deinit {
        parentController = nil
    }
    
    @MainActor
    func handleSignIn() {
        guard let parentController,
              parentController.isViewLoaded,
              parentController.view.window != nil
        else {
            tokenCallback(
                .failure(
                    InternalGoogleSignInError.unableToObtainController
                )
            )
            return
        }
        
        Task {
            do {
                let loginResult = try await GooglePassportProvider.handleSignInButton(
                    from: parentController
                )
                
                //  If we get the token, return it
                await MainActor.run {
                    tokenCallback(.success(loginResult))
                }
            } catch {
                //  Canmap to our own error, if we wish
                await MainActor.run {
                    tokenCallback(.failure(error))
                }
            }
        }
    }
}

/// A reusable SwiftUI Google Sign-In button that handles view controller resolution and
/// initiates the sign-in flow using `GooglePassportProvider`.
/// This component abstracts away the GoogleSignIn configuration and flow logic,
/// allowing consumers to simply embed it in their SwiftUI views and receive a Token.
///
/// Example usage:
/// ```swift
/// InternalGoogleSignInButton { result in
///     switch result {
///     case .success(let token):
///         // Use token
///     case .failure(let error):
///         // Handle error
///     }
/// }
/// ```
public struct InternalGoogleSignInButton: View {
    
    let style: GoogleSignInButtonStyle
    let scheme: GoogleSignInButtonColorScheme
    let state: GoogleSignInButtonState
    
    @StateObject
    private var viewModel: InternalGoogleSignInButtonModel
    
    /// Initializes the sign-in button with style, scheme, and state customization.
    /// Use this initializer when you already have access to a resolved UIViewController.
    ///
    /// - Parameters:
    ///   - style: The visual style of the button (standard, icon, etc.)
    ///   - scheme: The color scheme of the button (light or dark)
    ///   - state: The interactive state of the button (normal, pressed, disabled)
    ///   - parentController: A UIViewController to present from (must be visible)
    ///   - tokenCallback: A closure called with the result of the sign-in flow.
    init(
        style: GoogleSignInButtonStyle = .standard,
        scheme: GoogleSignInButtonColorScheme = .light,
        state: GoogleSignInButtonState = .normal,
        parentController: UIViewController,
        tokenCallback: @Sendable @escaping (Result<Token, Error>) -> Void
    ) {
        self.style = style
        self.scheme = scheme
        self.state = state
        self._viewModel = StateObject(
            wrappedValue: InternalGoogleSignInButtonModel(
                tokenCallback: tokenCallback,
                parentController: parentController
            )
        )
    }
    
    /// Initializes the sign-in button using default visual settings.
    /// This version attempts to resolve the presenting UIViewController at runtime.
    ///
    /// - Parameter tokenCallback: A closure called with the result of the sign-in flow.
    public init(
        tokenCallback: @Sendable @escaping (Result<Token, Error>) -> Void
    ) {
        style = .icon
        scheme = .light
        state = .normal
        self._viewModel = StateObject(
            wrappedValue: InternalGoogleSignInButtonModel(
                tokenCallback: tokenCallback,
                parentController: nil
            )
        )
    }
    
    /// The view body for the sign-in button. Internally binds the button tap
    /// to the sign-in handler and embeds a hidden `ViewControllerResolver` to locate
    /// a valid `UIViewController` for presentation.
    public var body: some View {
        GoogleSignInButton(
            viewModel: GoogleSignInButtonViewModel(
                scheme: scheme,
                style: style,
                state: state
            )
        ) { viewModel.handleSignIn() }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
            .frame(minWidth: 42, minHeight: 42)
            .frame(width: 42, height: 42, alignment: .center)
            .clipped()
            .background(Color.red.opacity(0.2))
            .background(
                ViewControllerResolver(onResolve: { controller in
                    self.viewModel.parentController = controller
                })
                .frame(width: 0, height: 0)
                .hidden()
            )
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black, lineWidth: 1)
            }
    }
    
}
