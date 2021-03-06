//
//  CategoryView.swift
//  Favs
//
//  Created by yum on 2020/12/28.
//

import SwiftUI

struct CategoryView: View {
    @Environment(\.editMode) var editMode
    @ObservedObject var favStore = FavStore.shared
    @ObservedObject var categoryStore = CategoryStore.shared
    @State private var selectedCategory: FavCategory?
    @State private var isNavigationActive: Bool = false
    @State private var isFirstResponder = false
    @State private var isNewRowActive = false
    @State private var newCategoryText: String = ""
    @State private var editButtonDisabled = false
    @State var firstAppear = true
    @State var displayMode: HomeView.DisplayMode = .list
    @State var isDeleteAlertPresented = false
    let initialViewState: ViewState?
    
    var body: some View {
        VStack {
            NavigationLink(destination:
                            Group {
                                if editMode?.wrappedValue.isEditing ?? false {
                                    CategoryDetailView(id: self.selectedCategory?.id)
                                } else {
                                    HomeView(categoryId: self.selectedCategory?.id, displayMode: $displayMode)
                                }
                            },
                           isActive: $isNavigationActive) {
                EmptyView()
            }
            
            let categories = self.categoryStore.categoryList.map { $0 }
            
            SwiftUI.List {
                ForEach(categories, id: \.self) { category in
                    HStack {
                        Text(category.displayName)
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .onTapGesture {
                        self.selectedCategory = category
                        self.isNavigationActive = true
                    }
                }
                .onMove { indices, newOffset in
                    self.categoryStore.move(fromOffsets: indices, toOffset: newOffset)
                }
                .onDelete(perform: editMode?.wrappedValue.isEditing ?? false ? { indexSet in
                    guard let category = self.categoryStore.categoryList.enumerated().first(where: { $0.offset == indexSet.first! }) else {
                        return
                    }
                    
                    if category.element.isInitial {
                        self.isDeleteAlertPresented.toggle()
                        return
                    }
                    
                    // ??????????????????????????????Fav?????????????????????????????????????????????
                    self.favStore.favs.filter({ $0.category == category.element.id })
                        .sorted(by: { $0.order < $1.order }).forEach({
                            let maxOrder = self.favStore.favs.max(by: { $0.order < $1.order })
                            
                            self.favStore.update(id: $0.id, order: maxOrder != nil ? maxOrder!.order + 1 : 0, category: "", dispTitle: $0.dispTitle)
                        })
                    
                    // ???????????????????????????
                    self.categoryStore.delete(atOffsets: indexSet)
                } : nil)
                .alert(isPresented: $isDeleteAlertPresented) {
                    Alert(title: Text("\"?????????\"????????????????????????"))
                }
                
                if self.isNewRowActive {
                    CustomTextField("?????????????????????",
                                    text: $newCategoryText,
                                    isFirstResponder: self.isFirstResponder,
                                    onCommit: {
                                        if self.isNewRowActive && !self.newCategoryText.isEmpty {
                                            self.categoryStore.add(name: self.newCategoryText)
                                        }
                                        self.isNewRowActive.toggle()
                                        self.editButtonDisabled = false
                                    })
                        .autocapitalization(.none)
                        .padding()
                }
                
                
                if !(self.editMode?.wrappedValue.isEditing != nil && self.editMode?.wrappedValue.isEditing == true) {
                    
                    Button(action: {
                        self.isNewRowActive = true
                        self.isFirstResponder = true
                        self.newCategoryText = ""
                        self.editButtonDisabled = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("??????")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(Color("Accent"))
                    }
                    .padding()
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .listStyle(InsetListStyle())
        }
        .onAppear {
            if !self.firstAppear {
                return
            }
            
            if let initialViewState = self.initialViewState {
                if let category = self.categoryStore.categoryList.first(where: { $0.id == initialViewState.category }) {
                    self.selectedCategory = category
                } else {
                    self.selectedCategory = self.categoryStore.categoryList.first(where: { $0.isInitial })!
                }
                self.displayMode = initialViewState.displayMode == HomeView.DisplayMode.card.rawValue ? HomeView.DisplayMode.card : HomeView.DisplayMode.list
                
                self.isNavigationActive = true
            } else {
                // ???????????????????????????????????????
                if let category = self.categoryStore.categoryList.first(where: { $0.isInitial }) {
                    self.selectedCategory = category
                }
                self.displayMode = .list
            }
            
            self.firstAppear.toggle()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarItems(trailing:
                                HStack {
                                    if editMode?.wrappedValue.isEditing ?? false {
                                        Button(action: {
                                            withAnimation {
                                                self.editMode?.wrappedValue = .inactive
                                            }
                                        }) {
                                            Text("??????")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color("NavigationBarItem"))
                                                .padding(.vertical)
                                        }
                                    } else {
                                        Button(action: {
                                            withAnimation {
                                                self.editMode?.wrappedValue = .active
                                            }
                                        }) {
                                            Image(systemName: "square.and.pencil")
                                                .foregroundColor(!self.editButtonDisabled ? Color("NavigationBarItem") : Color.secondary)
                                                .font(.title3)
                                                .padding(.vertical)
                                        }
                                        .disabled(self.editButtonDisabled)
                                    }
                                })
        .navigationBarTitle(Text("????????????"), displayMode: .inline)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let categories = [
            FavCategory(name: "??????", displayName: "??????", order: 0),
            FavCategory(name: "??????", displayName: "??????", order: 1),
            FavCategory(name: "??????", displayName: "??????", order: 2)
        ]
        let categoryStoreMock = CategoryStore(categories: categories)
        
        NavigationView {
            CategoryView(categoryStore: categoryStoreMock, initialViewState: nil)
        }
    }
}
