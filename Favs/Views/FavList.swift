//
//  FavList.swift
//  Favs
//
//  Created by ゆう on 2020/12/27.
//

import SwiftUI
import RealmSwift

struct FavList: View {
    var categoryId: String?
    @State private var favSelection = 0
    @Binding var selectedFav: Fav
    @Binding var isLongTapped: Bool
    @Binding var isWebViewActive: Bool
    @ObservedObject var favStore = FavStore.shared
    @Environment(\.editMode) var editMode
    @Binding var scrollViewProxy: ScrollViewProxy?
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                if self.getFavs(categoryId: self.categoryId, favs: self.favStore.favs.map { $0 }).count > 0 {
                    
                    SwiftUI.List {
                        ForEach(self.favStore.favs.indices, id: \.self) { index in
                            if self.categoryId == nil || self.categoryId == self.favStore.favs[index].category {
                                LinkRowView(url: self.favStore.favs[index].url,
                                            title: self.favStore.favs[index].dispTitle,
                                            imageUrl: self.favStore.favs[index].imageUrl)
                                    .onTapGesture {
                                        self.selectedFav = self.favStore.favs[index]
                                        self.isWebViewActive.toggle()
                                    }
                                    .onLongPressGesture {
                                        self.selectedFav = self.favStore.favs[index]
                                        self.isLongTapped = true
                                    }
                                    .id(index)
                            }
                        }
                        .onMove { indices, newOffset in
                            self.favStore.move(fromOffsets: indices, toOffset: newOffset)
                        }
                        .onDelete(perform: editMode?.wrappedValue.isEditing ?? false ? { indexSet in
                            self.favStore.delete(atOffsets: indexSet)
                        } : nil)
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
        let favs = [
            Fav(id: "a", url: "https://apple.com", order: 0, category: "category1", dispTitle: "title1", imageUrl: ""),
            Fav(id: "b", url: "https://apple.com", order: 1, category: "category1", dispTitle: "title2", imageUrl: ""),
            Fav(id: "c", url: "https://apple.com", order: 2, category: "category1", dispTitle: "title3", imageUrl: "")
        ]
        let favStoreMock = FavStore(favs: favs)
        
        FavList(categoryId: favs.first!.category, selectedFav: .constant(favs.first!), isLongTapped: .constant(false), isWebViewActive: .constant(false), favStore: favStoreMock, scrollViewProxy: .constant(nil))
    }
}
