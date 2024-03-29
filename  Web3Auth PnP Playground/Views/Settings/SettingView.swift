//
//  SettingView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 07/11/22.
//

import SwiftUI

struct SettingView: View {
    @State var networksExpanded = false
    @State var themeExpanded = false
    @State var languageExpanded: Bool = false
    @StateObject var vm: SettingVM

    var body: some View {
        return NavigationView {
            if #available(iOS 16.0, *) {
                SettingFormView(vm: vm, networksExpanded: $networksExpanded, themeExpanded: $themeExpanded, languageExpanded: $languageExpanded)
                    .scrollContentBackground(.hidden)
                    .background(Color.bkgColor())
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
            } else {
                SettingFormView(vm: vm, networksExpanded: $networksExpanded, themeExpanded: $themeExpanded, languageExpanded: $languageExpanded)
                    .background(Color.bkgColor())
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                    }
                    .onDisappear {
                        UITableView.appearance().backgroundColor = .systemGroupedBackground
                    }
            }
        }
    }
}
    struct SettingView_Previews: PreviewProvider {
        static var previews: some View {
            SettingView(vm: .init(blockchainManager: DummyBlockchainManager()))
            SettingFormView(vm: .init(blockchainManager: DummyBlockchainManager()), networksExpanded: .constant(false), themeExpanded: .constant(false), languageExpanded: .constant(false))
        }
    }

    struct SettingFormView: View {
        @ObservedObject var vm: SettingVM
        @Binding var networksExpanded: Bool
        @Binding var themeExpanded: Bool
        @Binding var languageExpanded: Bool
        @EnvironmentObject var tabVM: TabViewModel
        var body: some View {
            Form {
                Section(header: Text("Personal Info")
                    .font(.custom(POPPINSFONTLIST.Regular, size: 14))) {
                            Text(vm.user.userInfo.email)
                        .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                    }
                    .listRowBackground(Color.whiteGrayColor())
                Section(header: Text("Networks")
                    .font(.custom(POPPINSFONTLIST.Regular, size: 14))) {
                    DisclosureGroup(isExpanded: $networksExpanded, content: {
                        List(BlockchainEnum.allCases) { val in
                            HStack {
                                Text(val.name)
                                    .font(.custom(POPPINSFONTLIST.Regular, size: 14))
                                Spacer()
                            }
                            .background(Color.whiteGrayColor())
                            .onTapGesture {
                                withAnimation {
                                    vm.changeBlockchain(val: val)
                                    networksExpanded = false
                                }
                            }

                        }
                        .listRowBackground(Color.whiteGrayColor())
                    }) {
                        Text(vm.blockchain.name)
                            .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                    }
                }
                    .listRowBackground(Color.whiteGrayColor())
                Section {
                    Button {
                        vm.logout()
                        tabVM.selectedTab = 0

                    } label: {
                        Text("Logout")
                            .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                            .foregroundColor(.red)
                    }
                }
                .listRowBackground(Color.whiteGrayColor())
            }
        }
    }
