//
//  LoginMethodSelectionPage.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 25/03/22.
//

import SwiftUI
import Web3Auth
import AlertToast

struct LoginMethodSelectionPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var authManager:AuthManager
    @EnvironmentObject var web3AuthManager:Web3AuthManager
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State var isExpanded = false
    @State var showError = false
    @State var showSuccess = false
    @State var isLoggedIn = false
    @State var userInfo:Web3AuthState?{
        didSet{
            guard let safeuser = userInfo else{return}
            authManager.saveUser(user: .init(privKey: safeuser.privKey, ed25519PrivKey: safeuser.ed25519PrivKey, userInfo: .init(name: safeuser.userInfo.name, profileImage: safeuser.userInfo.profileImage, typeOfLogin: safeuser.userInfo.typeOfLogin, aggregateVerifier: safeuser.userInfo.aggregateVerifier, verifier: safeuser.userInfo.verifier, verifierId: safeuser.userInfo.verifierId, email: safeuser.userInfo.email)))
            isLoggedIn.toggle()
        }
    }
    @State var errorMessage = ""
    var arr1: [Web3AuthProvider] = [
        .GOOGLE,.FACEBOOK,.TWITTER,.DISCORD]
    var arr2: [Web3AuthProvider] = [.LINE,.REDDIT,.APPLE,.FACEBOOK,.TWITCH]
    var arr3 : [Web3AuthProvider] = [.GITHUB,.LINKEDIN,.KAKAO]
    @State var userEmail:String = ""
    var body: some View {
        ScrollView{
        VStack{
            HStack(alignment: .center,spacing: 10){
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .tint(.black)
                        .frame(width: 18, height: 18, alignment: .center)
                }
                .padding(.leading,-15)

                VStack(spacing:5){
                    Text("Welcome onboard")
                        .font(.custom(POPPINSFONTLIST.Bold, size: 24))
                    Text("Select how you would like to continue")
                        .foregroundColor(.gray)
                        .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                }
                .padding(.top,40)
            }
            .frame(height: 115, alignment: .center)
            .frame(maxWidth:.infinity)
            .background(.white)
            HStack{
            VStack(alignment:.leading){
            Text("Continue with")
                    .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
        }
            .padding(.leading,53)
            .padding(.bottom,10)
                Spacer()
            }
          
        .padding(.top,100)
            VStack(alignment: .leading,spacing: 16){
                HStack{
                    ForEach(arr1, id: \.self) { category in
                            Button(action: {
                                login(category)
                            }, label: {
                                Image(category.img)
                                    .frame(width: 48, height: 48, alignment: .center)
                                    .background(.white)
                                    .cornerRadius(24)
                                    
                            })
                            .frame(width: 48, height: 48, alignment: .center)
                    }
                        Button(action: {
                            dropDownTap()
                        }, label: {
                            Image(isExpanded ? "dropUp" : "dropDown")
                                .tint(.gray)
                                .frame(width: 48, height: 48, alignment: .center)
                                .background(.white)
                                .cornerRadius(24)

                        })
                        .frame(width: 48, height: 48, alignment: .center)
                }
                HStack{
                    ForEach(arr2, id: \.self) { category in
    
                            Button(action: {
                                login(category)
                            }, label: {
                                Image(category.img)
                                    .frame(width: 48, height: 48, alignment: .center)
                                    .background(.white)
                                    .cornerRadius(24)
                                    
                            })
                            .frame(width: 48, height: 48, alignment: .center)
                                            }
                            }
                .frame(height: isExpanded ? 48 : 0)
                .opacity(isExpanded ? 1 : 0)
                HStack{
                    ForEach(arr3, id: \.self) { category in
                            Button(action: {
                                login(category)
                            }, label: {
                                Image(category.img)
                                    .frame(width: 48, height: 48, alignment: .center)
                                    .background(.white)
                                    .cornerRadius(24)
                                    
                            })
                            .frame(width: 48, height: 48, alignment: .center)
                                            }
                            }
                .frame(height: isExpanded ? 48 : 0)
                .opacity(isExpanded ? 1 : 0)
            }
            Divider()
                .background(.gray)
                .frame(width:300, alignment: .center)
                .padding(.bottom, 24)
            
            VStack(alignment: .leading, spacing: 30){
                VStack(alignment: .leading, spacing: 24){
            Text("Email")
                .foregroundColor(.init(.labelColor()))
                .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                
            TextField("Email", text: $userEmail)
                    .autocapitalization(.none)
                    .padding(.leading,10)
                    .padding(.trailing,10)
                    .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .frame(width: 308, height: 48, alignment: .center)
                                .foregroundColor(.white)
                    )
                   
                    
                }
                Button(action: {
                    loginWithEmail()
                }, label: {
                    Text("Continue with Email")
                        .frame(width: 308, height: 48, alignment: .center)
                        .foregroundColor(.gray)
                        .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                        .background(.white)
                        .cornerRadius(24)
                })
               
            }
            .padding(.leading,50)
            .padding(.trailing,50)
           
                
        
           
        }
        .offset(y: -keyboardResponder.currentHeight * 0.9)
        .alert(isPresented: self.$showSuccess) {
            Alert(
                           title: Text("Username: \(userInfo?.userInfo.name ?? "")"),message: Text("PrivKey: \(userInfo?.privKey ?? "")")
                       )
               }
        .toast(isPresenting: $showError, duration: 2, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .error(.red), title: errorMessage, style: .style(backgroundColor: .white))
        }
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)
    .background(Color(uiColor: .bkgColor()))
    .ignoresSafeArea()
    }
    
    func initEnv(){
        
    }
        
    
    func dropDownTap(){
        isExpanded.toggle()
    }
    
     func loginWithEmail(){
         if userEmail.invalidEmail(){
            errorMessage = "Invalid Email"
             showError.toggle()
        }
        else{
            let extraOptions = ExtraLoginOptions(display: nil, prompt: nil, max_age: nil, ui_locales: nil, id_token_hint: nil, login_hint: userEmail, acr_values: nil, scope: nil, audience: nil, connection: nil, domain: nil, client_id: nil, redirect_uri: nil, leeway: nil, verifierIdField: nil, isVerifierIdCaseSensitive: nil)
            web3AuthManager.auth.login(.init(loginProvider: Web3AuthProvider.EMAIL_PASSWORDLESS.rawValue, extraLoginOptions:extraOptions)) { result in
                switch result{
                case .success(let model):
                    print(model)
                    userInfo = model
                case .failure(let error):
                    print(error)
                    errorMessage = error.localizedDescription
                    showError.toggle()
                }
            }
        }
        
    }
    
    func dismissBtn(){
        
    }
       
   
    
    func login(_ provider: Web3AuthProvider?) {
        web3AuthManager.auth.login(.init(loginProvider: provider?.rawValue)) {
            result in
                switch result{
                case .success(let model):
                    userInfo = model
                case .failure(let error):
                    print(error)
                    errorMessage = error.localizedDescription
                    showError.toggle()
                }
        }
    }
}

struct LoginMethodSelectionPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginMethodSelectionPage()
    }
}
