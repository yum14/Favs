//
//  ImageUrlView.swift
//  Favs
//
//  Created by ゆう on 2020/10/21.
//

import SwiftUI

struct ImageUrlView: View {
    // 元は40にしてた
    var imageSize: CGFloat
    @ObservedObject var remoteImageModel: RemoteImageModel
    
    init(url: String?, imageSize: CGFloat = 32) {
        remoteImageModel = RemoteImageModel(imageUrl: url)
        self.imageSize = imageSize
    }
    
    var body: some View {
        Group {
            
            if let remoteImage = remoteImageModel.displayImage {
                Image(uiImage: remoteImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ZStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: self.imageSize))
                        .foregroundColor(.white)
                }
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity,
                       alignment: .center)
//                .background(Color.secondary)
                .background(Color("ImageBackground"))
            }
        }
    }
}

struct ImageUrlView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUrlView(url: "")
            .frame(CGSize(width: 300, height: 200))
    }
}
