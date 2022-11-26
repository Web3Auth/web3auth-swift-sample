//
//  QRCodeView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 11/04/22.
//

import SwiftUI
import CodeScanner
struct QRCodeAlert: View {
    var publicAddres: String
    @Binding var isPresenting: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray)
                .opacity(0.5)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    VStack{
                        Text("Your Public Address")
                            .font(.custom(POPPINSFONTLIST.Bold, size: 18))
                        Button {
                            UIPasteboard.general.string = publicAddres
                            HapticGenerator.shared.hapticFeedbackOnTap(style: .light)
                        } label: {
                            HStack(alignment: .firstTextBaseline){
                            Text(publicAddres)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .font(.custom(POPPINSFONTLIST.Regular, size: 14))
                                .lineLimit(nil)
                                .foregroundColor(.gray)
                                Image("copy")
                                    .frame(width: 16, height: 16, alignment: .center)
                            }
                        }

                        
                        Image(uiImage: generateQRCode(message: publicAddres))
                            .interpolation(.none)
                            .resizable()
                            .frame(width: 200, height: 200, alignment: .center)
                            .scaledToFit()
                            .padding(10)
                            .overlay(
                                Image("web3auth-logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            )

                    }
                }
                .padding()
                .frame(width: 300, height: 350, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 27).fill(Color.white.opacity(1)))
                Spacer()
            }
        }.onTapGesture {
            self.isPresenting = false
        }

    }
}



struct QRCodeScannerExampleView: View {
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?

    var body: some View {
        VStack(spacing: 10) {

            Button("Scan Code") {
                isPresentingScanner = true
            }

            Text("Scan a QR code to begin")
        }
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(codeTypes: [.qr]) { response in
                if case let .success(result) = response {
                    scannedCode = result.string
                    isPresentingScanner = false
                }
            }
        }
    }
}

func generateQRCode(message: String) -> UIImage {
    let ciContext = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    filter.message = Data(message.utf8)
    filter.correctionLevel = "H"

    if let outputImage = filter.outputImage {
        if let cgimg = ciContext.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
    }

    return UIImage(systemName: "xmark.circle")!
}


struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeAlert(publicAddres: "0x1776e71Bb1956c46D9bBA247cd979B1c887dE633", isPresenting: .constant(true))
        QRCodeScannerExampleView()
    }
}
