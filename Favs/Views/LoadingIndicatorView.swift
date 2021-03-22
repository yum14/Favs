//
//  LodingIndicatorView.swift
//  Favs
//
//  Created by yum on 2020/12/20.
//

import SwiftUI

struct LoadingIndicatorView: View {
    let isLoading: Bool
    @State private var isAnimating = false
    private let animation = Animation.linear(duration: 1).repeatForever(autoreverses: false)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Loading中に画面をタップできないようにするためのほぼ透明なLayer
                Color(.black)
                    .opacity(0.01)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .disabled(self.isLoading)
                Circle()
                    .trim(from: 0, to: 0.6)
                    .stroke(AngularGradient(gradient: Gradient(colors: [.gray, .white]), center: .center),
                            style: StrokeStyle(
                                lineWidth: 8,
                                lineCap: .round,
                                dash: [0.1, 16],
                                dashPhase: 8))
                    .frame(width: 48, height: 48)
                    .rotationEffect(.degrees(self.isAnimating ? 360 : 0))
                    
                    .onAppear() {
                        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                            self.isAnimating = true
                        }
                    }
                    .onDisappear() {
                        self.isAnimating = false
                    }
            }
            // Loading中だけLoading画面が表示されるようにする。
            .hidden(!self.isLoading)
        }
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatorView(isLoading: true)
    }
}
