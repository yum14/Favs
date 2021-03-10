//
//  LinkCard.swift
//  Favs
//
//  Created by yum on 2020/10/16.
//

import SwiftUI

struct LinkCardView: View {
    var url: String
    var title: String
    var imageUrl: String
    var width: CGFloat
    
    @State var isWebViewActive = false
    @State var isActionSheetActive = false
    @State var maxWidth: CGFloat = 0
    @State private var geometryWidth: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ImageUrlView(url: imageUrl, imageSize: 40)
                .scaledToFill()
                .frame(width: self.width, height: self.width * 9/16, alignment: .center)
                .clipped()
            VStack {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .height(40)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(URLHelper.getDomain(url))
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .padding(.top, 8)
            .padding(.bottom)
            .padding(.horizontal)
        }
        .width(self.width)
        .background(Color.systemBackground)
        .cornerRadius(4)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 2, y: 2)
    }
}

struct LinkCardView_Previews: PreviewProvider {
    static var previews: some View {
        LinkCardView(url: "https://www.google.co.jp",
                     title: "Google",
                     imageUrl: "",
                     width: UIScreen.main.bounds.width)
    }
}
