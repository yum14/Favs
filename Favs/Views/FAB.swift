//
//  FAB.swift
//  Favs
//
//  Created by yum on 2020/10/21.
//

import SwiftUI

struct FAB: View {
    
    var backgroundColor: Color = .blue
    var imageSymbolName: String = "plus"
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topLeading) {
                Image(systemName: self.imageSymbolName)
                    .foregroundColor(.white)
                    .font(.title)
            }
        }
        .frame(width: 64, height: 64, alignment: .center)
        .background(backgroundColor)
        .cornerRadius(.greatestFiniteMagnitude)
        .shadow(color: Color.black.opacity(0.3),
                radius: 5,
                x: 3,
                y: 3)
        
    }
}

struct FAB_Previews: PreviewProvider {
    static var previews: some View {
        FAB(action: {})
    }
}
