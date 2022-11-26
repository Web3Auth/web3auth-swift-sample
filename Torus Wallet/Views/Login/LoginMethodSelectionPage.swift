//
//  LoginMethodSelectionPage.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 25/03/22.
//

import SwiftUI

struct LoginMethodSelectionPage: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @StateObject var vm: LoginMethodSelectionPageVM

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Continue with")
                            .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))
                            .foregroundColor(.labelColor())
                    }
                    .padding(.leading, 53)
                    .padding(.bottom, 10)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        ForEach(vm.loginRow1Arr, id: \.self) { category in
                            Button(action: {
                                vm.login(category)
                            }, label: {
                                Image(category.img)
                                    .frame(width: 48, height: 48, alignment: .center)
                                    .background(Color.whiteGrayColor())
                                    .cornerRadius(24)

                            })
                            .frame(width: 48, height: 48, alignment: .center)
                        }
                        Button(action: {
                            dropDownTap()
                        }, label: {
                            Image(vm.isRowExpanded ? "dropUp" : "dropDown")
                                .frame(width: 48, height: 48, alignment: .center)
                                .background(Color.whiteGrayColor())
                                .cornerRadius(24)

                        })
                        .frame(width: 48, height: 48, alignment: .center)
                    }
                    HStack {
                        ForEach(vm.loginRow2Arr, id: \.self) { category in

                            Button(action: {
                                vm.login(category)
                            }, label: {
                                Image(category.img)
                                    .frame(width: 48, height: 48, alignment: .center)
                                    .background(Color.whiteGrayColor())
                                    .cornerRadius(24)

                            })
                            .frame(width: 48, height: 48, alignment: .center)
                        }
                    }
                    .frame(height: vm.isRowExpanded ? 48 : 0)
                    .opacity(vm.isRowExpanded ? 1 : 0)
                    HStack {
                        ForEach(vm.loginRow3Arr, id: \.self) { category in
                            Button(action: {
                                vm.login(category)
                            }, label: {
                                Image(category.img)
                                    .frame(width: 48, height: 48, alignment: .center)
                                    .background(Color.whiteGrayColor())
                                    .cornerRadius(24)

                            })
                            .frame(width: 48, height: 48, alignment: .center)
                        }
                    }
                    .frame(height: vm.isRowExpanded ? 48 : 0)
                    .opacity(vm.isRowExpanded ? 1 : 0)
                }
                Divider()
                    .background(Color.gray)
                    .frame(width: 272, alignment: .center)
                    .padding(.bottom, 24)
                    .padding(.top, vm.isRowExpanded ? 16 : -16)

                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Email")
                            .foregroundColor(.init(.labelColor()))
                            .font(.custom(POPPINSFONTLIST.SemiBold, size: 14))

                        TextField("Email", text: $vm.userEmail)
                            .autocapitalization(.none)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .frame(width: 308, height: 48, alignment: .center)
                                    .foregroundColor(Color.dropDownBkgColor())
                            )
                    }
                    Button(action: {
                        vm.loginWithEmail()
                    }, label: {
                        Text("Continue with Email")
                            .frame(width: 308, height: 48, alignment: .center)
                            .foregroundColor(Color.labelColor())
                            .font(.custom(DMSANSFONTLIST.Medium, size: 16))
                            .background(Color.dropDownBkgColor())
                            .cornerRadius(24)
                    })
                }
                .padding(.leading, 50)
                .padding(.trailing, 50)
            }
            .offset(y: -keyboardResponder.currentHeight * 0.9)
            .alert(isPresented: $vm.showError) {
                Alert(title: Text("Error"), message: Text(vm.errorMessage), dismissButton: .cancel(Text("Ok")))
            }
        }
        .navigationBarTitle("Welcome onboard", displayMode: .large)
        .background(Color.bkgColor())
    }

    func dropDownTap() {
        vm.isRowExpanded.toggle()
    }
}

struct LoginMethodSelectionPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginMethodSelectionPage(vm: .init(authManager: .init()))
    }
}
