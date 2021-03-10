//
//  ContentView.swift
//  Favs
//
//  Created by yum on 2020/10/15.
//

import SwiftUI

struct ContentView: View {
    private let viewStateStore = ViewStateStore.shared
    private let sharedFavObserver = SharedFavObserver()
    
    init() {
        UINavigationBar.appearance().barTintColor = UIColor(Color("NavigationBar"))
        UINavigationBar.appearance().tintColor = UIColor(Color("NavigationBarItem"))
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color("NavigationBarItem"))]
    }
    
    var body: some View {
        NavigationView {
            // NavigationView下にEditButtonとEditMode変更とかやるとEditModeが変更されないという現象が起こる。
            // ここのVStack挟むと動くようになる。
            // おそらくバグなので、なぜ解決するかは不明。階層数か？
            VStack {
                CategoryView(initialViewState: self.getInitialViewState())
            }
        }
        .accentColor(Color("Main"))
    }
    
    func getInitialViewState() -> ViewState? {
        let state = self.viewStateStore.get()
        return state.category.utf8.count > 0 ? state : nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
