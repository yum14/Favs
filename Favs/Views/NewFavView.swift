
//  NewFavView.swift
//  Favs
//
//  Created by yum on 2020/11/05.
//

import SwiftUI
import RealmSwift

struct NewFavView: View {
    @State var newUrl: String = ""
    @State var newTitle: String = ""
    @State var categorySelection: Int = 0
    @State var createButtonDisabled = true
    @State var titleDisabled = true
    @State var firstAppear = true
    @State var titleFirstAppear = true
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var pageInfoObserver = PageInfoObserver(selector: WebAccessSelector())
    @ObservedObject var favStore = FavStore.shared
    @ObservedObject var categoryStore = CategoryStore.shared
    @State var title: String = ""
    
    var categoryId: String?
    
    var body: some View {
        let categoryItems = getCategoryItems(categories: self.categoryStore.categoryList.map { $0 })
        
        NavigationView {
            ZStack {
                Form {
                    Section {
                        HStack {
                            TextField("URLを入力してください", text: $newUrl, onCommit:  {
                                if let url = URL(string: newUrl) {
                                    self.pageInfoObserver.get(url: url)
                                }
                            })
                            .autocapitalization(.none)
                            .disabled(self.pageInfoObserver.pageInfo != nil)
                            .foregroundColor(self.pageInfoObserver.pageInfo != nil ? Color.secondary : Color.primary)
                        }
                    }
                    
                    if let pageInfo = self.pageInfoObserver.pageInfo, !self.pageInfoObserver.isLoading {
                        Section {
                            HStack {
                                TextField("タイトルを入力してください", text: $title)
                                    .autocapitalization(.none)
                            }
                            .onAppear() {
                                // カテゴリ選択から戻ったときに再度titleに取得値が設定されないように制御する
                                if self.titleFirstAppear {
                                    self.title = !pageInfo.dispTitle.isEmpty ? pageInfo.dispTitle : "タイトルなし"
                                    self.titleFirstAppear.toggle()
                                }
                            }
                            Picker(selection: $categorySelection, label: Text("カテゴリ")) {
                                ForEach(0 ..< categoryItems.count) {
                                    Text(categoryItems[$0].displayName)
                                }
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                
                // インジケータ
                if self.pageInfoObserver.isLoading {
                    LoadingIndicatorView(isLoading: self.pageInfoObserver.isLoading)
                }
                
            }
            .onAppear {
                if self.firstAppear {
                    self.newUrl = ""
                    self.categorySelection = 0
                    self.firstAppear.toggle()
                    
                    if self.categoryId == nil {
                        self.categorySelection = 0
                    } else {
                        self.categorySelection = categoryItems.firstIndex(where: { $0.id == self.categoryId }) ?? 0
                    }
                }
            }
            .navigationBarTitle(Text("新しいブックマーク"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(Color("NavigationBarItem"))
                    .font(.title3)
                    .padding(.vertical)
                
            }, trailing: Button(action: {
                
                // pageが読み込めない場合でも作成は行いたいためpageInfoはguardとしない
                self.favStore.add(url: self.newUrl,
                                  category: categoryItems[self.categorySelection].id,
                                  comment: "",
                                  dispTitle: self.title,
                                  dispDescription: self.pageInfoObserver.pageInfo?.dispDescription ?? "",
                                  imageUrl: self.pageInfoObserver.pageInfo?.imageUrl ?? "",
                                  titleOnHeader: self.pageInfoObserver.pageInfo?.titleOnHeader ?? "",
                                  ogTitle: self.pageInfoObserver.pageInfo?.ogTitle ?? "",
                                  ogDescription: self.pageInfoObserver.pageInfo?.ogDescription ?? "",
                                  ogType: self.pageInfoObserver.pageInfo?.ogType ?? "",
                                  ogUrl: self.pageInfoObserver.pageInfo?.ogUrl ?? "",
                                  ogImage: self.pageInfoObserver.pageInfo?.ogImage ?? "",
                                  fbAppId: self.pageInfoObserver.pageInfo?.fbAppId ?? "",
                                  twitterCard: self.pageInfoObserver.pageInfo?.twitterCard ?? "",
                                  twitterSite: self.pageInfoObserver.pageInfo?.twitterSite ?? "",
                                  twitterCreator: self.pageInfoObserver.pageInfo?.twitterCreator ?? "",
                                  descriptionOnHeader: self.pageInfoObserver.pageInfo?.descriptionOnHeader ?? "",
                                  thumbnail: self.pageInfoObserver.pageInfo?.thumbnail ?? "")
                
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("作成")
                    .padding(.vertical)
            }
            .disabled(self.title.isEmpty))
        }
    }
    
    func getCategoryItems(categories: [FavCategory]) -> [CategoryListItem] {
        var items: [CategoryListItem] = [CategoryListItem(id: "", displayName: "カテゴリなし")]
        items.append(contentsOf: categories.filter({ !$0.isInitial }).map { CategoryListItem(id: $0.id, displayName: $0.displayName) })
        
        return items
    }
}

struct NewFavView_Previews: PreviewProvider {
    static var previews: some View {
        let favStoreMock = FavStore(favs: [])
        
        let categories = [
            FavCategory(name: "趣味", displayName: "趣味", order: 0),
            FavCategory(name: "勉強", displayName: "勉強", order: 1),
            FavCategory(name: "料理", displayName: "料理", order: 2)
        ]
        let categoryStoreMock = CategoryStore(categories: categories)
        
        let pageInfoObserver = PageInfoObserver(selector: WebAccessSelector())
        pageInfoObserver.pageInfo = PageInfo(url: "https://apple.com", dispTitle: "Title1")
        
        return NewFavView(newUrl: pageInfoObserver.pageInfo!.url,
                          newTitle: pageInfoObserver.pageInfo!.dispTitle,
                          categorySelection: 0,
                          pageInfoObserver: pageInfoObserver,
                          favStore: favStoreMock,
                          categoryStore: categoryStoreMock)
    }
}
