//
//  LinkRowView.swift
//  Favs
//
//  Created by yum on 2020/12/26.
//

import SwiftUI

struct LinkRowView: View {
    var content: LinkContent
    var createActionSheet: ((LinkContent) -> ActionSheet)?
    var onTapGesture: (LinkContent) -> Void = {_ in }
    
    @State private var isActionSheetActive: Bool = false
    private let rowHeight: CGFloat = 76
    
    var body: some View {
        HStack(spacing: 0) {
            ImageUrlView(url: self.content.imageUrl)
                .scaledToFill()
                .frame(width: rowHeight * 16/9, height: self.rowHeight, alignment: .center)
                .clipped()
                .cornerRadius(2)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(self.content.title)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .padding(.vertical, 4)
                        .padding(.leading)
                        .padding(.trailing, 4)
                    Spacer()
                }
                Spacer()
                HStack(spacing: 0) {
                    Spacer()
                    Text(URLHelper.getDomain(self.content.url))
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .padding(.horizontal)
                }
                .padding(.bottom, 4)
            }
            .frame(height: rowHeight)
        }
        .background(Color.systemBackground)
        
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

struct LinkRowView_Previews: PreviewProvider {
    static var previews: some View {
        LinkRowView(content: LinkContent(id: "", url: "https://www.google.co.jp", title: "Google", imageUrl: ""))
    }
}
