//
//  FavDetail.swift
//  Favs
//
//  Created by yum on 2020/11/17.
//

import SwiftUI
import RealmSwift

struct FavDetailView: View {
    var id: String
    @State var url: String = ""
    @State var title: String = ""
    @State var categorySelection: Int = 0
    @State var firstAppear = true
    @State var reloadAlertPresented = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var favStore = FavStore.shared
    @ObservedObject var categoryStore = CategoryStore.shared
    @ObservedObject var pageInfoObserver = PageInfoObserver(selector: WebAccessSelector())
    @State var pageReloaded = false
    
    var body: some View {
        
        let categoryItems = getCategoryItems(categories: self.categoryStore.categoryList.map { $0 })
        
        ZStack {
            Form {
                Section {
                    HStack(spacing: 0) {
                        TextField("URLを入力してください", text: $url)
                            .autocapitalization(.none)
                            .foregroundColor(.secondary)
                            .disabled(true)
                    }
                }
                
                if !self.pageInfoObserver.isLoading {
                    Section {
                        HStack {
                            TextField("タイトルを入力してください", text: $title)
                                .autocapitalization(.none)
                                .onAppear {
                                    if self.pageReloaded {
                                        if let pageInfo = self.pageInfoObserver.pageInfo {
                                            self.title = !pageInfo.dispTitle.isEmpty ? pageInfo.dispTitle : "タイトルなし"
                                        }
                                    }
                                }
                        }
                        Picker(selection: $categorySelection,
                               label: Text("カテゴリ")) {
                            ForEach(0 ..< categoryItems.count) {
                                Text(categoryItems[$0].displayName)
                            }
                        }
                    }
                    
                    Section {
                        ZStack {
                            HStack(spacing: 0) {
                                Spacer()
                                Button("再読み込み") {
                                    self.reloadAlertPresented.toggle()
                                }
                                .frame(alignment: .center)
                                .alert(isPresented: $reloadAlertPresented) {
                                    Alert(title: Text("WEBページを再度読み込みますか？"),
                                          message: Text("入力したタイトルが上書きされます。またサムネイル画像が更新されます。"),
                                          primaryButton: .cancel(),
                                          secondaryButton: .destructive(Text("再読み込み")) {
                                            
                                            // reload
                                            self.pageInfoObserver.get(url: URL(string: self.url)!)
                                          })
                                }
                                .disabled(pageReloaded)
                                Spacer()
                            }
                            
                            if self.pageReloaded {
                                CountDownIndicatorView(lineWidth: 4, font: .body, count: 10, onStopped: {
                                    self.pageReloaded.toggle()
                                })
                                .background(Color("Main"))
                            }
                        }
                    }
                    .listRowBackground(Color("Main"))
                    .foregroundColor(.white)
                    .font(.subheadline, weight: .bold)
                }
                
            }
            .listStyle(GroupedListStyle())
            
            // インジケータ
            if self.pageInfoObserver.isLoading {
                LoadingIndicatorView(isLoading: self.pageInfoObserver.isLoading)
                    .onDisappear {
                        self.pageReloaded = true
                    }
            }
        }
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
            
            // pageが読み込めない場合でも更新は行いたいためpageInfoはguardとしない
            self.favStore.update(id: fav.id,
                                 url: self.url,
                                 category: categoryItems[self.categorySelection].id,
                                 dispTitle: self.title,
                                 dispDescription: self.pageInfoObserver.pageInfo?.dispDescription,
                                 imageUrl: self.pageInfoObserver.pageInfo?.imageUrl,
                                 titleOnHeader: self.pageInfoObserver.pageInfo?.titleOnHeader,
                                 ogTitle: self.pageInfoObserver.pageInfo?.ogTitle,
                                 ogDescription: self.pageInfoObserver.pageInfo?.ogDescription,
                                 ogType: self.pageInfoObserver.pageInfo?.ogType,
                                 ogUrl: self.pageInfoObserver.pageInfo?.ogUrl,
                                 ogImage: self.pageInfoObserver.pageInfo?.ogImage,
                                 fbAppId: self.pageInfoObserver.pageInfo?.fbAppId,
                                 twitterCard: self.pageInfoObserver.pageInfo?.twitterCard,
                                 twitterSite: self.pageInfoObserver.pageInfo?.twitterSite,
                                 twitterCreator: self.pageInfoObserver.pageInfo?.twitterCreator,
                                 descriptionOnHeader: self.pageInfoObserver.pageInfo?.descriptionOnHeader,
                                 thumbnail: self.pageInfoObserver.pageInfo?.thumbnail)
            
            
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("完了")
                .padding(.vertical)
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
            //            FavDetailView(id: "a", favStore: favStoreMock, categoryStore: categoryStoreMock, reloadIndicatorVisible: true)
            FavDetailView(id: "a", favStore: favStoreMock, categoryStore: categoryStoreMock )
                .environmentObject(TimerHolder())
        }
    }
}
