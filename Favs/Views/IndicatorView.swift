//
//  IndicatorView.swift
//  Favs
//
//  Created by yum on 2021/03/28.
//

import SwiftUI

struct IndicatorView: View {
    var lineWidth: CGFloat
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.6)
            .stroke(AngularGradient(gradient: Gradient(colors: [.gray, .white]), center: .center),
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round,
                        dash: [0.1, 16],
                        dashPhase: 8))
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
}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            IndicatorView(lineWidth: 4)
                .frame(width: 80, height: 80)
        }
    }
}
