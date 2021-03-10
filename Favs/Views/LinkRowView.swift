//
//  LinkRowView.swift
//  Favs
//
//  Created by yum on 2020/12/26.
//

import SwiftUI

struct LinkRowView: View {
    var url: String
    var title: String
    var imageUrl: String
    
    let rowHeight: CGFloat = 76
    
    var body: some View {
        HStack(spacing: 0) {
            ImageUrlView(url: imageUrl)
                .scaledToFill()
                .frame(width: rowHeight * 16/9, height: rowHeight, alignment: .center)
                .clipped()
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .padding(.vertical, 4)
                        .padding(.horizontal)
                    Spacer()
                }
                Spacer()
                HStack(spacing: 0) {
                    Spacer()
                    Text(URLHelper.getDomain(url))
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .padding(.horizontal)
                }
                .padding(.bottom, 4)
            }
            .frame(height: rowHeight)
        }
    }
}

struct LinkRowView_Previews: PreviewProvider {
    static var previews: some View {
        LinkRowView(url: "https://www.google.co.jp",
                    title: "Google",
                    imageUrl: "")
    }
}
