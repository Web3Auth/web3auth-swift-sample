//
//  LoadingView.swift
//  OpenLoginKeyViewer
//
//  Created by Dhruv Jaiswal on 03/11/22.
//

import SwiftUI

struct LoadingView: View {
   var body: some View {
        return VStack {
            Image("web3auth-banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240, height: 42, alignment: .center)
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .ignoresSafeArea()
        .background(Color.systemBlackWhiteColor())
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
