//
//  CategoryDetailView.swift
//  Favs
//
//  Created by yum on 2020/10/18.
//

import SwiftUI
import RealmSwift

struct CategoryDetailView: View {
    var id: String? = ""
    @State private var inputName: String = ""
    @ObservedObject var categoryStore = CategoryStore.shared
    @State var firstAppear = true
    @Environment(\.presentationMode) var presentationMode
    @State var isInitialCategory: Bool = false
    
    var body: some View {
        Form {
            TextField("カテゴリ名を入力してください", text: $inputName, onCommit: {
                if !inputName.isEmpty {
                    guard let target = categoryStore.categoryList.first(where: { $0.id == self.id }) else {
                        return
                    }
                    let editCategory = FavCategory(id: target.id, name: self.inputName, displayName: self.inputName, order: target.order, createdAt: target.createdAt)
                    categoryStore.update(editCategory)
                } else {
                    inputName = self.categoryStore.categoryList.first(where: { $0.id == self.id })!.displayName
                }
            })
            .autocapitalization(.none)
            .foregroundColor(isInitialCategory ? Color.secondary : Color.primary)
            .disabled(isInitialCategory)
            
        }
        .navigationBarTitle(Text("カテゴリの編集"))
        .navigationBarItems(trailing: Button(action: {
            guard let target = categoryStore.categoryList.first(where: { $0.id == self.id }) else {
                return
            }
            let editCategory = FavCategory(id: target.id, name: self.inputName, displayName: self.inputName, isInitial: target.isInitial, order: target.order, createdAt: target.createdAt)
            categoryStore.update(editCategory)
            
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("完了")
        }
        .disabled(self.inputName.isEmpty)
        )
        .onAppear() {
            if !self.firstAppear {
                return
            }
            
            guard let category = self.categoryStore.categoryList.first(where: { $0.id == self.id }) else {
                return
            }
            
            self.inputName = category.displayName
            self.isInitialCategory = category.isInitial
            
            
            self.firstAppear.toggle()
        }
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let categories = [
            FavCategory(id: "a", name: "趣味", displayName: "趣味", order: 0),
            FavCategory(id: "b", name: "勉強", displayName: "勉強", order: 1),
            FavCategory(id: "c", name: "料理", displayName: "料理", order: 2)
        ]
        let categoryStoreMock = CategoryStore(categories: categories)
        
        return NavigationView {
            CategoryDetailView(id: "a", categoryStore: categoryStoreMock)
        }
    }
}
