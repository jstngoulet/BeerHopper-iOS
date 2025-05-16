//
//  LoginView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import SwiftUI

class LoginViewModel: ObservableObject {
    
    enum LoginStatus {
        case loggedOut
        case authorizing
        case loggedIn
        case authError(Error)
    }
    
    enum LoginRoute: Hashable {
        case home
        case forgotPassword
    }
    
    @Published
    var path: NavigationPath = NavigationPath()
    
    @Published
    var email: String = "" {
        didSet {
            validateFields()
        }
    }
    
    @Published
    var password: String = "" {
        didSet {
            validateFields()
        }
    }
    
    @Published
    var isValidated: Bool = false
    
    func login() async {
        print("Login with \(email), password: \(password)")
        path.append(LoginRoute.home)
    }
    
    func forgotPassword() {
        path.append(LoginRoute.forgotPassword)
    }
    
    private func validateFields() {
        isValidated = isEmailValid() && isPasswordValid()
    }
    
    private func isEmailValid() -> Bool {
        !email.isEmpty
    }
    
    private func isPasswordValid() -> Bool {
        !password.isEmpty
    }
}

struct LoginView: View {
    
    @StateObject
    private var viewModel: LoginViewModel = LoginViewModel()
    
    @State
    private var isSecureTextVisible: Bool = false
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack {
                Spacer()
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(
                        EmailTextFieldStyle(
                            leftIcon: Image(systemName: "person")
                        )
                    )
                
                if isSecureTextVisible {
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(
                            EmailTextFieldStyle(
                                leftIcon: Image(systemName: "unlock")
                            )
                        )
                        .padding(.bottom)
                        .frame(maxWidth: .infinity)
                } else {
                    TextField("Password", text: $viewModel.password)
                        .textFieldStyle(
                            EmailTextFieldStyle(
                                leftIcon: Image(systemName: "lock")
                            )
                        )
                }
                
                Spacer()
                
                Button("Forgot Password") {
                    viewModel.forgotPassword()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(SecondaryButtonStyle())
                
                Button("Login") {
                    Task {
                        await viewModel.login()
                    }
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        isDisabled: !viewModel.isValidated
                    )
                )
                .frame(maxWidth: .infinity)
                .disabled(!viewModel.isValidated)
                
            }
            .padding(.horizontal)
            .navigationDestination(for: LoginViewModel.LoginRoute.self) { route in
                switch route {
                case .home:
                    LazyView {
                        SearchView()
                    }
                case .forgotPassword:
                    LazyView { SearchView() }
                }
            }
        }
    }
    
}

struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
}


#Preview("Base Login") {
    LoginView()
}
