//
//  FavList.swift
//  Favs
//
//  Created by yum on 2020/10/16.
//

import SwiftUI

struct FavCardList: View {
    var contents: [LinkContent]
    var createActionSheet: ((LinkContent) -> ActionSheet)?
    var onTapGesture: (LinkContent) -> Void = {_ in }
    @Binding var scrollViewProxy: ScrollViewProxy?
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                if self.contents.count > 0 {
                    GeometryReader { geometry in
                        SwiftUI.List {
                            ForEach(self.contents.indices, id: \.self) { index in
                                HStack {
                                    Spacer()
                                    LinkCardView(content: self.contents[index],
                                                 width: geometry.size.width * 0.86,
                                                 createActionSheet: self.createActionSheet,
                                                 onTapGesture: self.onTapGesture)
                                        .padding(.vertical, UIDevice.current.userInterfaceIdiom != .pad ? 6 : 16)
                                    Spacer()
                                }
                                .id(index)
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
            .onAppear {
                self.scrollViewProxy = proxy
            }
        }
    }
}

struct FavCardList_Previews: PreviewProvider {
    static var previews: some View {
        let contents = [
            LinkContent(id: "a", url: "https://apple.com", title: "title1", imageUrl: ""),
            LinkContent(id: "b", url: "https://apple.com", title: "title2", imageUrl: ""),
            LinkContent(id: "c", url: "https://apple.com", title: "title3", imageUrl: "")
        ]

        FavCardList(contents: contents, scrollViewProxy: .constant(nil))
    }
}
