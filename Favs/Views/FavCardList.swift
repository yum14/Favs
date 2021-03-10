//
//  FavList.swift
//  Favs
//
//  Created by yum on 2020/10/16.
//

import SwiftUI

struct FavCardList: View {
    var categoryId: String?
    @State private var favSelection = 0
    @Binding var selectedFav: Fav
    @Binding var isLongTapped: Bool
    @ObservedObject var favStore = FavStore.shared
    @Binding var isWebViewActive: Bool
    @Binding var scrollViewProxy: ScrollViewProxy?
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                let favs = self.getFavs(categoryId: self.categoryId, favs: self.favStore.favs.map { $0 })
                
                if favs.count > 0 {
                    
                    SwiftUI.List {
                        
                        ForEach(favs.indices, id: \.self) { index in
                            LinkCardView(url: favs[index].url,
                                         title: favs[index].dispTitle,
                                         imageUrl: favs[index].imageUrl,
                                         width: UIScreen.main.bounds.width * 0.9)
                                .padding(.vertical, 8)
                                .onTapGesture {
                                    self.favSelection = index
                                    self.selectedFav = favs[index]
                                    self.isWebViewActive.toggle()
                                }
                                .onLongPressGesture {
                                    self.favSelection = index
                                    self.selectedFav = favs[index]
                                    self.isLongTapped = true
                                }
                                .id(index)
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
    
    func getFavs(categoryId: String?, favs: [Fav]) -> [Fav] {
        guard let category = categoryId else {
            return favs
        }
        
        return favs.filter({ $0.category == category })
    }
}


struct FavCardList_Previews: PreviewProvider {
    static var previews: some View {
        let favs = [
            Fav(id: "a", url: "https://apple.com", order: 0, category: "category1", dispTitle: "title1", imageUrl: ""),
            Fav(id: "b", url: "https://apple.com", order: 1, category: "category1", dispTitle: "title2", imageUrl: ""),
            Fav(id: "c", url: "https://apple.com", order: 2, category: "category1", dispTitle: "title3", imageUrl: "")
        ]
        let favStoreMock = FavStore(favs: favs)
        
        FavCardList(categoryId: favs.first!.category, selectedFav: .constant(favs[0]), isLongTapped: .constant(false), favStore: favStoreMock, isWebViewActive: .constant(false), scrollViewProxy: .constant(nil))
        
    }
}
