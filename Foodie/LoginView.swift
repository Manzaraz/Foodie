//
//  LoginView.swift
//  Foodie
//
//  Created by Christian Manzaraz on 05/03/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth



struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @State private var isValidEmail = false
    @State private var isValidPassword = false
    
    @FocusState private var focusField: Field?
    
    
    var body: some View {
        ZStack {
            Color("launchScreenBg")
                .ignoresSafeArea()
            
            VStack {
                Image("logoIcon")
                    .resizable()
                    .scaledToFit()
                    
                Group {
                    TextField("email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .focused($focusField, equals: .email)
                        .onSubmit { focusField = .password }
                        .onChange(of: email) {
                            enableButtons()
                            isValidEmail = validateEmail(email)
                        }
                    
                    if !email.isEmpty && !isValidEmail {
                        Text("Invalid email address")
                            .foregroundStyle(.red)
                            .font(.subheadline)
                    }
                        
                    SecureField("password", text: $password)
                        .submitLabel(.done)
                        .focused($focusField, equals: .password)
                        .onSubmit { focusField = nil }
                        .onChange(of: password) {
                            enableButtons()
                            isValidPassword = validatePassword(password)
                        }
                    
                    if !password.isEmpty && !isValidPassword {
                        Text("Password must have more than 6 characters and have a lowercase and uppercase letter and a number")
                            .foregroundStyle(.red)
                            .font(.subheadline)
                    }
                }
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 2)
                }
                
                HStack (spacing: 30) {
                    Button("Sign Up") {
                        register()
                    }
                    
                    Button("Log In") {
                        login()
                        
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.foodie)
                .font(.title)
                .padding(.top)
                .disabled(buttonDisabled)
                
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    launchScreenManager.dismiss()
                }
            }
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    
                }
            }
        }
    }
}


#Preview {
    LoginView()
        .environmentObject(LaunchScreenManager())
}


extension LoginView {
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("😡SIGNUP ERROR: \(error.localizedDescription)")
                alertMessage = "😡SIGNUP ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎Registration Success!")
                // TODO: Load ListView
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("😡LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "😡LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎Login Success!")
                // TODO: Load ListView
            }
        }
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,12}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return passwordTest.evaluate(with: password)
    }
    
    func enableButtons() {
        buttonDisabled = !(isValidEmail && isValidPassword)
    }
}
