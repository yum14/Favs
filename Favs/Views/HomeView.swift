//
//  HomeView.swift
//  Favs
//
//  Created by yum on 2020/10/16.
//

import SwiftUI
import Parchment
import RealmSwift

struct HomeView: View {
    @State private var isSheetActive = false
    @State private var selectedFav: Fav = Fav()
    @State private var presentationType: PresentationType = PresentationType.new
    @ObservedObject var favStore = FavStore.shared
    @ObservedObject var categoryStore = CategoryStore.shared
    private let viewStateStore = ViewStateStore.shared
    @State private var isActionSheetActive = false
    @State private var isWebViewActive = false
    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentationMode
    @State private var isDeitaiViewActiveOnSheet = false
    @State private var scrollViewProxy: ScrollViewProxy?
    
    var categoryId: String?
    @Binding var displayMode: DisplayMode
    
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
                NavigationLink(
                    destination: Group {
                        if editMode?.wrappedValue.isEditing ?? false {
                            FavDetailView(id: self.selectedFav.id)
                        } else {
                            WebViewWrapper(url: self.selectedFav.url)
                                .navigationBarTitle(URLHelper.getDomain(self.selectedFav.url), displayMode: .inline
                                )
                        }
                    },
                    isActive: $isWebViewActive
                ) { EmptyView() }

                // アクションシートからの起動用
                NavigationLink(
                    destination:
                        FavDetailView(id: self.selectedFav.id),
                        isActive: $isDeitaiViewActiveOnSheet
                ) { EmptyView() }
                
                if let category = self.categoryStore.categoryList.first(where: { $0.id == self.categoryId }) {
                    if self.displayMode == .card {
                        FavCardList(categoryId: category.isInitial ? nil : self.categoryId,
                                    selectedFav: $selectedFav,
                                    isLongTapped: $isActionSheetActive,
                                    isWebViewActive: $isWebViewActive,
                                    scrollViewProxy: $scrollViewProxy)
                    } else {
                        FavList(categoryId: category.isInitial ? nil : self.categoryId,
                                selectedFav: $selectedFav,
                                isLongTapped: $isActionSheetActive,
                                isWebViewActive: $isWebViewActive,
                                scrollViewProxy: $scrollViewProxy)
                            .padding(.top)
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
        .actionSheet(isPresented: $isActionSheetActive) {
            ActionSheet(title: Text(self.selectedFav.url), buttons: [
                .default(Text("共有")) {
                    self.presentationType = .share
                    self.isSheetActive = true
                },
                .default(Text("編集")) {
                    self.isDeitaiViewActiveOnSheet = true
                },
                .cancel()
            ])
        }
        .sheet(isPresented: $isSheetActive) {
            switch self.presentationType {
            case .new:
                NewFavView(categoryId: self.categoryId)
            case .share:
                ShareSheet(activityItems: [self.selectedFav.url])
            }
        }
        .navigationBarItems(
            leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color("NavigationBarItem"))
            }
            .padding(.trailing),
            center: Button(action: {
                withAnimation {
                    self.scrollViewProxy?.scrollTo(0, anchor: .top)
                }
            }) {
                Text(self.getNavigationBarTitle(categories: self.categoryStore.categoryList, categoryId: self.categoryId))
                    .foregroundColor(Color("NavigationBarItem"))
            },
            trailing:
                HStack {
                    if editMode?.wrappedValue.isEditing ?? false {
                        Button(action: {
                            withAnimation {
                                self.editMode?.wrappedValue = .inactive
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color("NavigationBarItem"))
                        }
                    } else {
                        
                        Button(action: {
                            self.presentationType = .new
                            self.isSheetActive = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(Color("NavigationBarItem"))
                        }
                        
                        if self.displayMode == .list && self.favStore.favs.count > 0 {
                            Button(action: {
                                withAnimation {
                                    self.editMode?.wrappedValue = .active
                                }
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(Color("NavigationBarItem"))
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationView {
            HomeView(displayMode: .constant(HomeView.DisplayMode.list))
        }
    }
}
