//
//  FavList.swift
//  Favs
//
//  Created by yum on 2020/12/27.
//

import SwiftUI
import RealmSwift

struct FavList: View {
    var contents: [LinkContent]
    var createActionSheet: ((LinkContent) -> ActionSheet)?
    var onTapGesture: (LinkContent) -> Void = {_ in }
    var onMove: ((IndexSet, Int) -> Void)?
    var onDelete: ((IndexSet) -> Void)?
    
    @Binding var scrollViewProxy: ScrollViewProxy?
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                if self.contents.count > 0 {
                    SwiftUI.List {
                        ForEach(self.contents.indices, id: \.self) { index in
                            LinkRowView(content: self.contents[index],
                                        createActionSheet: self.createActionSheet,
                                        onTapGesture: self.onTapGesture)
                                .id(index)
                        }
                        .onMove(perform: self.onMove)
                        .onDelete(perform: self.onDelete)
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
    
    func getFavs(categoryId: String?, favs: [Fav]) -> [Fav] {
        guard let category = categoryId else {
            return favs
        }
        
        return favs.filter({ $0.category == category }).map { $0 }
    }
}

struct FavList_Previews: PreviewProvider {
    static var previews: some View {
        let contents = [
            LinkContent(id: "a", url: "https://apple.com", title: "title1", imageUrl: ""),
            LinkContent(id: "b", url: "https://apple.com", title: "title2", imageUrl: ""),
            LinkContent(id: "c", url: "https://apple.com", title: "title3", imageUrl: "")
        ]
        
        FavList(contents: contents, scrollViewProxy: .constant(nil))
    }
}
