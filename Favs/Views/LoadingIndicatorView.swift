//
//  LodingIndicatorView.swift
//  Favs
//
//  Created by yum on 2020/12/20.
//

import SwiftUI

struct LoadingIndicatorView: View {
    let isLoading: Bool
    var lineWidth: CGFloat = 8
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Loading中に画面をタップできないようにするためのほぼ透明なLayer
                Color(.black)
                    .opacity(0.01)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .disabled(self.isLoading)
                IndicatorView(lineWidth: self.lineWidth)
                    .frame(width: 48, height: 48)
            }
            // Loading中だけLoading画面が表示されるようにする。
            .hidden(!self.isLoading)
        }
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatorView(isLoading: true, lineWidth: 8)
    }
}
