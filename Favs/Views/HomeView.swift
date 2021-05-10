//
//  HomeView.swift
//  Favs
//
//  Created by yum on 2020/10/16.
//

import SwiftUI
import SwiftUIX
import Parchment
import RealmSwift

struct HomeView: View {
    var categoryId: String?
    @Binding var displayMode: DisplayMode
    
    @State private var selectedLink: LinkContent = LinkContent()
    @State private var presentationType: PresentationType = PresentationType.new
    @ObservedObject private var favStore = FavStore.shared
    @ObservedObject private var categoryStore = CategoryStore.shared
    private let viewStateStore = ViewStateStore.shared
    
    @State private var isActionSheetActive = false
    @State private var isSheetActive = false
    @State private var isWebViewActive = false
    @Environment(\.editMode) private var editMode
    @Environment(\.presentationMode) private var presentationMode
    @State private var isDetailViewActiveOnSheet = false
    @State private var scrollViewProxy: ScrollViewProxy?
    
    enum PresentationType {
        case new
        case share
    }
    enum DisplayMode: String {
        case list
        case card
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                // これがないと↓のタップ時の画面遷移直後にこの画面に戻ってきてしまう・・
                // CategoryViewでは発生せず。どこからかのバージョンでこうなってしまったと思われる。
                // 原因不明。とりあえず暫定対応。
                NavigationLink("") {
                    EmptyView()
                }
                
                // Tap時の画面遷移
                NavigationLink(
                    destination: Group {
                        if editMode?.wrappedValue.isEditing ?? false {
                            FavDetailView(id: self.selectedLink.id)
                                .environmentObject(TimerHolder())
                        } else {
                            WebViewWrapper(url: self.selectedLink.url)
                        }
                    },
                    isActive: $isWebViewActive
                ) { EmptyView() }
                
                // アクションシートからの画面遷移
                NavigationLink(
                    destination:
                        FavDetailView(id: self.selectedLink.id)
                        .environmentObject(TimerHolder()),
                    isActive: $isDetailViewActiveOnSheet
                ) { EmptyView() }
                
                if let category = self.categoryStore.categoryList.first(where: { $0.id == self.categoryId }) {
                    if self.displayMode == .card {
                        
                        FavCardList(contents: createContentsByCategory(category: category, favs: self.favStore.favs.map {$0}),
                                    createActionSheet: self.createActionSheet,
                                    onTapGesture: self.onLinkTapGesture,
                                    scrollViewProxy: self.$scrollViewProxy)
                    } else {
                        FavList(contents: createContentsByCategory(category: category, favs: self.favStore.favs.map {$0}),
                                createActionSheet: self.createActionSheet,
                                onTapGesture: self.onLinkTapGesture,
                                onMove: self.onMove,
                                onDelete: self.onDelete,
                                scrollViewProxy: self.$scrollViewProxy)
                    }
                }
            }
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    FAB(backgroundColor: Color("Main"),
                        imageSymbolName: "arrow.triangle.2.circlepath") {
                        withAnimation {
                            self.editMode?.wrappedValue = .inactive
                            self.displayMode = self.displayMode == .card ? .list : .card
                            
                            let newState = ViewState(category: self.categoryId ?? "", displayMode: self.displayMode.rawValue)
                            self.viewStateStore.update(newState)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                }
            }
        }
        .onAppear {
            let newState = ViewState(category: self.categoryId ?? "", displayMode: self.displayMode.rawValue)
            self.viewStateStore.update(newState)
        }
        .sheet(isPresented: $isSheetActive) {
            switch self.presentationType {
            case .new:
                NewFavView(categoryId: self.categoryId)
            case .share:
                ShareSheet(activityItems: [self.selectedLink.url])
            }
        }
        // TODO: navigationBarItemは非推奨であるためそのうちtoolbarに変更する。FontWeightが効かなかったので現状はnavigationBarItemで実装
        .navigationBarItems(
            leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color("NavigationBarItem"))
                    .font(.title3)
                    .padding(.trailing)
            },
            center: Button(action: {
                withAnimation {
                    self.scrollViewProxy?.scrollTo(0, anchor: .top)
                }
            }) {
                // iPadの場合に1つ前の表示したテキストの長さからWidthが拡張してくれない（バグ？）
                // よって明示的にwidthを設定しておく
                Text(self.getNavigationBarTitle(categories: self.categoryStore.categoryList, categoryId: self.categoryId))
                    .foregroundColor(Color("NavigationBarItem"))
                    .font(.body, weight: .bold)
                    .lineLimit(1)
                    .frame(width: UIScreen.main.bounds.size.width * 0.55)
            },
            trailing:
                HStack {
                    if editMode?.wrappedValue.isEditing ?? false {
                        Button(action: {
                            withAnimation {
                                self.editMode?.wrappedValue = .inactive
                            }
                        }) {
                            Text("完了")
                                .fontWeight(.bold)
                                .foregroundColor(Color("NavigationBarItem"))
                                .padding(.vertical)
                        }
                    } else {
                        Button(action: {
                            self.presentationType = .new
                            self.isSheetActive = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(Color("NavigationBarItem"))
                                .font(.title3)
                                .padding(.vertical)
                        }
                        
                        if self.displayMode == .list && self.favStore.favs.count > 0 {
                            Button(action: {
                                withAnimation {
                                    self.editMode?.wrappedValue = .active
                                }
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(Color("NavigationBarItem"))
                                    .font(.title3)
                                    .padding(.vertical)
                            }
                        }
                    }
                },
            displayMode: .inline)
        
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
    
    func getNavigationBarTitle(categories: RealmSwift.List<FavCategory>, categoryId: String?) -> String {
        guard let category = categoryId else {
            return ""
        }
        
        return categories.first(where: { $0.id == category })?.displayName ?? ""
    }
    
    
    func onLinkTapGesture(content: LinkContent) -> Void {
        self.selectedLink = content
        self.isWebViewActive = true
    }
    
    func createActionSheet(content: LinkContent) -> ActionSheet {
        return ActionSheet(title: Text(content.url), buttons: [
            .default(Text("編集")) {
                self.selectedLink = content
                self.isDetailViewActiveOnSheet = true
            },
            .default(Text("共有")) {
                self.selectedLink = content
                self.presentationType = .share
                self.isSheetActive = true
            },
            .cancel()
        ])
    }
    
    func createContentsByCategory(category: FavCategory, favs: [Fav]) -> [LinkContent] {
        let filtered = category.isInitial ? favs : favs.filter({ $0.category == category.id })
        
        return filtered.map { LinkContent(id: $0.id, url: $0.url, title: $0.dispTitle, imageUrl: $0.imageUrl) }
    }
    
    func onMove(from: IndexSet, to: Int) -> Void {
        self.favStore.move(fromOffsets: from, toOffset: to)
    }
    
    func onDelete(at: IndexSet) -> Void {
        self.favStore.delete(atOffsets: at)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationView {
            HomeView(displayMode: .constant(HomeView.DisplayMode.list))
        }
    }
}
