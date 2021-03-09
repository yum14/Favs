//
//  FavDetail.swift
//  Favs
//
//  Created by ゆう on 2020/11/17.
//

import SwiftUI
import RealmSwift

struct FavDetailView: View {
    var id: String
    @State var url: String = ""
    @State var title: String = ""
    @State var categorySelection: Int = 0
    @State var firstAppear = true
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var favStore = FavStore.shared
    @ObservedObject var categoryStore = CategoryStore.shared
    
    var body: some View {
        
        let categoryItems = getCategoryItems(categories: self.categoryStore.categoryList.map { $0 })

        Form {
            Section {
                HStack {
                    TextField("URLを入力してください", text: $url)
                        .autocapitalization(.none)
                        .foregroundColor(.secondary)
                        .disabled(true)
                }
            }
            Section {
                HStack {
                    TextField("タイトルを入力してください", text: $title)
                        .autocapitalization(.none)
                }
                Picker(selection: $categorySelection,
                       label: Text("カテゴリ")) {
                    ForEach(0 ..< categoryItems.count) {
                        Text(categoryItems[$0].displayName)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .onAppear {
            if !self.firstAppear {
                return
            }
            guard let fav = self.favStore.favs.first(where: { $0.id == self.id }) else {
                return
            }
            
            self.url = fav.url
            self.title = fav.dispTitle
            
            if let initialCategorySelection =  categoryItems.firstIndex(where: { $0.id == fav.category }) {
                
                self.categorySelection = initialCategorySelection
            } else {
                self.categorySelection = 0
            }
            self.firstAppear.toggle()
        }
        .navigationBarTitle(Text("ブックマークの編集"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            
            // update
            guard let fav = self.favStore.favs.first(where: { $0.id == self.id }) else {
                return
            }
            self.favStore.update(id: fav.id,
                                 dispTitle: self.title,
                                 category: categoryItems[self.categorySelection].id,
                                 order: fav.order)
            
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("完了")
        }
        .disabled(self.title.isEmpty))
    }
    
    func getCategoryItems(categories: [FavCategory]) -> [CategoryListItem] {
        var items: [CategoryListItem] = [CategoryListItem(id: "", displayName: "カテゴリなし")]
        items.append(contentsOf: categories.filter({ !$0.isInitial }).map { CategoryListItem(id: $0.id, displayName: $0.displayName) })
        
        return items
    }
}

struct FavDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let favs = [
            Fav(id: "a", url: "https://apple.com", order: 0, category: "category1", dispTitle: "title1", imageUrl: ""),
            Fav(id: "b", url: "https://apple.com", order: 1, category: "category1", dispTitle: "title2", imageUrl: ""),
            Fav(id: "c", url: "https://apple.com", order: 2, category: "category1", dispTitle: "title3", imageUrl: "")
        ]
        let favStoreMock = FavStore(favs: favs)
        
        let categories = [
            FavCategory(id: "category1", name: "趣味", displayName: "趣味", order: 0),
        ]
        let categoryStoreMock = CategoryStore(categories: categories)
        
        return NavigationView {
            FavDetailView(id: "a", favStore: favStoreMock, categoryStore: categoryStoreMock)
        }
    }
}
