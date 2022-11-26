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
    @StateObject var vm:LoginMethodSelectionPageVM      
  
    var arr1: [Web3AuthProvider] = [
        .APPLE,.GOOGLE,.FACEBOOK,.TWITTER]
    var arr2: [Web3AuthProvider] = [.LINE,.REDDIT,.DISCORD,.WECHAT,.TWITCH]
    var arr3 : [Web3AuthProvider] = [.GITHUB,.LINKEDIN,.KAKAO]
    var body: some View {
        ScrollView{
        VStack{
            HStack(alignment: .center,spacing: 10){
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("arrow-left")
                        .tint(.black)
                        .frame(width: 18, height: 18, alignment: .center)
                }
                .padding(.leading,-15)
                .padding(.bottom,-10)

                VStack(spacing:0){
                    Text("Welcome onboard")
                        .font(.custom(POPPINSFONTLIST.Bold, size: 24))
                    Text("Select how you would like to continue")
                        .foregroundColor(.gray)
                        .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                }
                .padding(.top,40)
                .padding(.bottom,10)
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
                                vm.login(category)
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
                                vm.login(category)
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
                                vm.login(category)
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
                .frame(width:272, alignment: .center)
                .padding(.bottom, 24)
                .padding(.top,isExpanded ? 16 : -16)
            
            VStack(alignment: .leading, spacing: 30){
                VStack(alignment: .leading, spacing: 24){
            Text("Email")
                .foregroundColor(.init(.labelColor()))
                .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                
                    TextField("Email", text: $vm.userEmail)
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
                    vm.loginWithEmail()
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
        .toast(isPresenting: $vm.showError, duration: 2, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .error(.red), title: vm.errorMessage, style: .style(backgroundColor: .white))
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
    

    
    func dismissBtn(){
        
    }
       
   
    
   
}

struct LoginMethodSelectionPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginMethodSelectionPage( vm: .init(web3AuthManager: .init(network: .mainnet), authManager: AuthManager()))
    }
}
