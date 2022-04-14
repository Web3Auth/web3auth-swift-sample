//
//  QRCodeView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 11/04/22.
//

import SwiftUI
import CodeScanner
struct QRCodeAlert: View {
    var message: String
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
                        Text(message)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .font(.custom(POPPINSFONTLIST.Regular, size: 14))
                            .lineLimit(nil)
                            .foregroundColor(.gray)
                        Image(uiImage: generateQRCode(message: message))
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
                .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 250, idealHeight: 250, maxHeight: 600, alignment: .top).scaledToFit()
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
        QRCodeAlert(message: "key", isPresenting: .constant(true))
        QRCodeScannerExampleView()
    }
}
