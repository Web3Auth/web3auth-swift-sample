////
////  SwiftUIView.swift
////  OpenLoginKeyViewer
////
////  Created by Dhruv Jaiswal on 24/03/22.
////
//
//
//import SwiftUI
//import MobileCoreServices
//import AlertToast
//import CoreImage.CIFilterBuiltins
//
// let providers: [OpenLoginProvider?] = [
//    .APPLE,
//    .GOOGLE,
//    .FACEBOOK,
//    .REDDIT,
//    .DISCORD,
//    .TWITCH,
//    .LINE,
//    .GITHUB,
//    .KAKAO,
//    .LINKEDIN,
//    .TWITTER,
//    .WEIBO,
//    .WECHAT,
//    .EMAIL_PASSWORDLESS,
//    nil
//]
//
//
//extension Optional: Identifiable where Wrapped == OpenLoginProvider {
//    var humanDisplayName: String {
//        if self == nil {
//            return "Any"
//        } else if self == .EMAIL_PASSWORDLESS {
//            return "Passwordless login with email"
//        } else {
//            return "\(self!)".capitalized
//        }
//    }
//    public var id: some Hashable {
//        humanDisplayName
//    }
//    
//    var alwaysShow: Bool {
//        switch self {
//        case .APPLE, .GOOGLE, nil:
//            return true
//        default:
//            return false
//        }
//    }
//}
//
//enum DisplayState {
//    case result
//    case error
//    case loading
//    case nothing
//}
//
//func ResultLine(_ title: String, _ content: String?) -> some View {
//    HStack(alignment: .top) {
//        Text(title).font(.body).fontWeight(.medium)
//        Spacer()
//        Text(content == nil ? "N/A" : content!).lineLimit(1)
//    }
//}
//
//struct ContentViewss: View {
//    @State var loginResult: OpenLoginState? = nil
//    @State var errorText: String = ""
//    @State var displayState: DisplayState = .nothing
//    @State var showAllProviders: Bool = false
//    @State var showCopySuccessToast: Bool = false
//    @State var showPrivateKeyQRCode: Bool = false
//    
//    
//    
//    
//    @Environment(\.defaultMinListRowHeight) var defaultMinListRowHeight: CGFloat
//    var resultRowHeight: CGFloat {
//        get {
//            defaultMinListRowHeight - 10
//        }
//    }
//    
//    
//    @Environment(\.colorScheme) var colorScheme
//    
//    var body: some View {
//        ZStack {
//            NavigationView {
//                List {
//                    if displayState != .nothing {
//                        Section(header: Text("Result")) {
//                            if displayState == .loading {
//                                ProgressView()
//                            }
//                            if displayState == .result, let result = loginResult {
//                                HStack(alignment: .center) {
//                                    if let imageUrl = result.userInfo.profileImage {
//                                        AsyncImage(url: URL(string: imageUrl),
//                                                   content: { image in
//                                            image
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .frame(maxWidth: 100)
//                                        },
//                                                   placeholder: {
//                                            ProgressView()
//                                        }).padding(5)
//                                    }
//                                    VStack {
//                                        HStack(alignment: .center) {
//                                            Text("Private Key").font(.body).fontWeight(.medium)
//                                            Spacer()
//                                            Button {
//                                                UIPasteboard.general.string = result.privKey
//                                                showCopySuccessToast = true
//                                            } label: {
//                                                Image(systemName: "doc.on.clipboard")
//                                            }
//                                            .buttonStyle(BorderlessButtonStyle())
//                                            Spacer()
//                                            Button {
//                                                showPrivateKeyQRCode = true
//                                            } label: {
//                                                Image(systemName: "qrcode")
//                                            }
//                                            .buttonStyle(BorderlessButtonStyle())
//                                        }
//                                        .frame(height: resultRowHeight)
//                                        if let info = result.userInfo {
//                                            Divider()
//                                            ResultLine("Name", info.name)
//                                                .frame(height: resultRowHeight)
//                                            Divider()
//                                            ResultLine("Login Type", info.typeOfLogin)
//                                                .frame(height: resultRowHeight)
//                                        }
//                                    }
//                                }
//                                
//                            }
//                            if displayState == .error, let txt = errorText {
//                                ResultLine("Error Message", txt)
//                            }
//                        }
//                    } else {
//                        Text("Please select one of the providers below to Sign in and retrieve the Web3Auth (formerly OpenLogin) Key.")
//                    }
//                    Section(header: HStack(alignment: .top) {
//                        Text("Login Providers")
//                        Spacer()
//                        Button {
//                            showAllProviders = !showAllProviders
//                        } label: {
//                            Text(showAllProviders ? "Less" : "More")
//                        }
//                    }) {
//                        ForEach(providers) { provider in
//                            if showAllProviders || provider.alwaysShow {
//                                Button {
//                                    login(provider)
//                                } label: {
//                                    Text(provider.humanDisplayName)
//                                }
//                            }
//                        }
//                    }
//                }
//                .animation(.easeInOut, value: showAllProviders)
//                .navigationBarTitleDisplayMode(.inline)                .toolbar {
//                    ToolbarItem(placement: .principal) {
//                        if colorScheme == .dark {
//                            Image("web3auth-banner-dark")
//                                .resizable()
//                                .scaledToFit()
//                                .padding(.vertical, 10)
//                        }else{
//                            Image("web3auth-banner")
//                                .resizable()
//                                .scaledToFit()
//                                .padding(.vertical, 10)
//                        }
//                    }
//                }
//            }.toast(isPresenting: $showCopySuccessToast, duration: 2, tapToDismiss: true) {
//                AlertToast(displayMode: .banner(.pop), type: .regular, title: "Private key copied")
//            }
//            if showPrivateKeyQRCode, let key = loginResult?.privKey {
//                QRCodeAlert(message: key, isPresenting: $showPrivateKeyQRCode)
//            }
//        }.animation(.easeInOut, value: showPrivateKeyQRCode)
//        // popover example: https://stackoverflow.com/questions/59650462/swiftui-how-do-i-display-a-view-as-a-pop-up-on-top-of-the-current-view-blurred
//    }
//    
//    func login(_ provider: OpenLoginProvider?) {
//        OpenLogin.webAuth().login(provider: provider) {
//            switch $0 {
//            case .success(let result):
//                loginResult = result
//                displayState = .result
//            case .failure(let error):
//                errorText = "\(error)"
//                displayState = .error
//            }
//        }
//        displayState = .loading
//    }
//    
//    
//}
//
//struct QRCodeAlert: View {
//    var message: String
//    @Binding var isPresenting: Bool
//    
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color.gray)
//                .opacity(0.5)
//                .ignoresSafeArea()
//            VStack {
//                Spacer()
//                HStack {
//                    VStack() {
//                        Text("Private Key").fontWeight(.bold).padding(.all, 20).foregroundColor(.black)
//                        
//                        Image(uiImage: generateQRCode(message: message))
//                            .interpolation(.none)
//                            .resizable()
//                            .scaledToFit()
//                            .padding(10)
//                            .overlay(
//                                Image("web3auth-logo")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 40, height: 40)
//                            )
//                        
//                        
//                        
//                    }
//                }
//                .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 250, idealHeight: 250, maxHeight: 600, alignment: .top).scaledToFit()
//                .background(RoundedRectangle(cornerRadius: 27).fill(Color.white.opacity(1)))
//                Spacer()
//            }
//        }.onTapGesture {
//            self.isPresenting = false
//        }
//        
//    }
//}
//
//func generateQRCode(message: String) -> UIImage {
//    let ciContext = CIContext()
//    let filter = CIFilter.qrCodeGenerator()
//    
//    filter.message = Data(message.utf8)
//    filter.correctionLevel = "H"
//    
//    if let outputImage = filter.outputImage {
//        if let cgimg = ciContext.createCGImage(outputImage, from: outputImage.extent) {
//            return UIImage(cgImage: cgimg)
//        }
//    }
//    
//    return UIImage(systemName: "xmark.circle") ?? UIImage()
//}
//
//let mockloginResultData = "{\"privKey\":\"2a608b0d367486f928f1dfbe64fb3736164495846dcf76cf7808cb9a446ee5b7\",\"userInfo\":{\"email\":\"jrfkiufrjr@privaterelay.appleid.com\",\"name\":\"John Taka\",\"profileImage\":\"https://i0.wp.com/cdn.auth0.com/avatars/jt.png\",\"aggregateVerifier\":\"tkey-auth0-apple\",\"verifier\":\"torus\",\"verifierId\":\"apple|001559.ecbeb28036c070fd3255a5b837ee7fbc.0454\",\"typeOfLogin\":\"apple\"}}"
//
//struct ContentViewss_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach(ColorScheme.allCases, id: \.self) {
//             ContentViewss(loginResult: try! JSONDecoder().decode(OpenLoginState.self, from: mockloginResultData.data(using: .utf8)!), displayState: .result).preferredColorScheme($0)
//        }
//    }
//}
//
//
