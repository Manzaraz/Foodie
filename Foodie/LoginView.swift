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
    @State private var showPassword = false
    @State private var presentSheet = false
    
    @FocusState private var focusField: Field?
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [ Color(.systemBackground), Color(.screenBg).opacity(0.4), Color(.screenBg)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            
            VStack {
                Image("logoIcon")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.accent)
                    
                Group {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .frame(maxHeight: 40, alignment: .center)
                            .foregroundStyle(Color(.fieldBg))
                        
                        HStack {
                            Image(systemName: "pencil.and.scribble")
                                .foregroundStyle(Color.accentColor)
                                .font(.system(.subheadline, weight: .bold))
                                .padding()
                            
                            TextField("Enter your email", text: $email)
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
                        }
                    }
                    
                    if !email.isEmpty && !isValidEmail {
                        Text("Invalid email address")
                            .foregroundStyle(Color(.systemYellow))
                            .font(.subheadline)
                    }
                        
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.fieldBg)
                            .frame(maxHeight: 40, alignment: .center)
                        
                        HStack {
                            if !showPassword {
                                Spacer()
                            }
                            
                            RoundedRectangle(cornerRadius: showPassword ? 25.0 : 50.0)
                                .frame(maxWidth: showPassword ? .infinity : 0, maxHeight: showPassword ? 65 : 40, alignment: .center)
                                .animation(.linear(duration: 0.2), value: showPassword)
                                .padding(.trailing, showPassword ? 0 : 12)
                        }
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundStyle(Color.accentColor)
                                .font(.system(.subheadline, weight: .bold))
                                .padding()
                            
                            if showPassword {
                                TextField("Write your password", text: $password)
                                    .foregroundStyle(Color.accentColor)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .submitLabel(.done)
                                    .focused($focusField, equals: .password)
                                    .onSubmit { focusField = nil }
                                    .onChange(of: password) {
                                        enableButtons()
                                        isValidPassword = validatePassword(password)
                                    }
                            } else {
                                SecureField("Write your password", text: $password)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .submitLabel(.done)
                                    .focused($focusField, equals: .password)
                                    .onSubmit { focusField = nil }
                                    .onChange(of: password) {
                                        enableButtons()
                                        isValidPassword = validatePassword(password)
                                    }
                            }
                            
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye" : "eye.slash")
                                    .foregroundStyle(Color.accentColor)
                                    .font(.system(.subheadline, weight: .bold))
                                    .padding(.trailing)
                            }

                        }
                    }
                    
                    if !password.isEmpty && !isValidPassword {
                        Text("Password must have more than 6 characters and have a lowercase and uppercase letter and a number")
                            .foregroundStyle(Color(.systemYellow))
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                    }
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
                .tint(.accent)
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
            .onAppear() {
                if Auth.auth().currentUser != nil { // If we're logged in...
                    print("😉Already Logged")
                    presentSheet = true
                }
            }
            .fullScreenCover(isPresented: $presentSheet) {
                ListView()
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
                presentSheet = true
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
                presentSheet = true
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
