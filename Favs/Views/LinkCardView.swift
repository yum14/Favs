//
//  LinkCard.swift
//  Favs
//
//  Created by yum on 2020/10/16.
//

import SwiftUI

struct LinkCardView: View {
    var content: LinkContent
    var width: CGFloat
    var createActionSheet: ((LinkContent) -> ActionSheet)?
    var onTapGesture: (LinkContent) -> Void = {_ in }
    
    @State private var isActionSheetActive: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ImageUrlView(url: self.content.imageUrl, imageSize: 40)
                .scaledToFill()
                .frame(width: self.width, height: self.width * 9/16, alignment: .center)
                .clipped()
            VStack {
                HStack {
                    Text(self.content.title)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .height(40)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(URLHelper.getDomain(self.content.url))
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
        
        // iPadの場合、ActionSheetは吹き出しになるため、行に対して設定しないと表示場所がおかしくなる
        // よってこのActionSheetはこのView内部で指定する
        .actionSheet(isPresented: self.$isActionSheetActive) {
            guard let createActionSheet = self.createActionSheet else {
                return ActionSheet(title: Text(""))
            }
            return createActionSheet(self.content)
        }
        .onTapGesture {
            self.onTapGesture(self.content)
        }
        .onLongPressGesture {
            self.isActionSheetActive = true
        }
    }
}

struct LinkCardView_Previews: PreviewProvider {
    static var previews: some View {
        LinkCardView(content: LinkContent(id: "", url: "https://www.google.co.jp", title: "Google", imageUrl: ""),
                     width: UIScreen.main.bounds.width)
    }
}
