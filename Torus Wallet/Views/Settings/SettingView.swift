//
//  SettingView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 07/11/22.
//

import SwiftUI

struct SettingView: View {
    @State var networkExpanded = false
    @State var themeModeExpanded = false
    @StateObject var vm: SettingVM
    @State var type: ThemeModes = .lightMode
    var body: some View {
        NavigationView {
            if #available(iOS 16.0, *) {
                SettingFormView(vm: vm, networkExpanded: $networkExpanded, themeModeExpanded: $themeModeExpanded)
                    .scrollContentBackground(.hidden)
                    .background(Color.bkgColor())
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
            } else {
                SettingFormView(vm: vm, networkExpanded: $networkExpanded, themeModeExpanded: $themeModeExpanded)
                    .background(Color.bkgColor())
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.large)
                    .onAppear { // ADD THESE AFTER YOUR FORM VIEW
                        UITableView.appearance().backgroundColor = .clear
                    }
                    .onDisappear { // CHANGE BACK TO SYSTEM's DEFAULT
                        UITableView.appearance().backgroundColor = .systemGroupedBackground
                    }
            }

        }
    }
}
    struct SettingView_Previews: PreviewProvider {
        static var previews: some View {
            SettingView(vm: .init(blockchainManager: DummyBlockchainManager()))
            SettingFormView(vm: .init(blockchainManager: DummyBlockchainManager()), networkExpanded: .constant(false), themeModeExpanded: .constant(false))
        }
    }

    struct SettingFormView: View {
        @StateObject var vm: SettingVM
        @Binding var networkExpanded:Bool
        @Binding var themeModeExpanded:Bool
        var body: some View {
            Form {
                Section(header: Text("Personal Info")
                    .font(.custom(POPPINSFONTLIST.Regular, size: 14))) {
                            Text(vm.user.userInfo.email)
                        .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                    }
                    .listRowBackground(Color.whiteGrayColor())
                Section{
                    DisclosureGroup(isExpanded: $networkExpanded, content: {
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
                                    networkExpanded = false
                                }
                            }

                        }
                        .listRowBackground(Color.whiteGrayColor())
                    }) {
                        Text(vm.blockchain.name)
                            .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                    }
                        DisclosureGroup(isExpanded: $themeModeExpanded, content: {
                            List(ThemeModes.allCases) { val in
                                HStack {
                                    Text(val.name)
                                        .font(.custom(POPPINSFONTLIST.Regular, size: 14))
                                    Spacer()
                                }
                                .background(Color.whiteGrayColor())
                                .onTapGesture {
                                    withAnimation {
                                        vm.changeThemeMode(val: val)
                                        themeModeExpanded = false
                                    }
                                }

                            }
                            .listRowBackground(Color.whiteGrayColor())
                        }) {
                            Text(vm.themeMode.name)
                                .font(.custom(DMSANSFONTLIST.Regular, size: 16))
                        }

                }
                    .listRowBackground(Color.whiteGrayColor())
                Section {
                    Button {
                        vm.logout()
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

enum ThemeModes: CaseIterable, Hashable,Identifiable {
    var id: String { UUID().uuidString }
    case lightMode
    case darkMode
    case system

    var name: String {
        switch self {
        case .lightMode:
            return "Light Mode"
        case .darkMode:
            return "Dark Mode"
        case .system:
            return "System"
        }
    }
}
