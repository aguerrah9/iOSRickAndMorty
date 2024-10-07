//
//  CustomAsyncView.swift
//  RickMorty
//
//  Created by Alejandro Guerra Hernandez on 02/10/24.
//

import SwiftUI

func characterImage(url: String, anchor: CGFloat = 64) -> some View {
    /*if #available(iOS 15.0, *) {
        return AsyncImage(url: URL(string: url)) { phase in
            let anchor:CGFloat = 64
            if let image = phase.image {
                image
                    .frame( width: anchor, height: anchor )
            } else if phase.error != nil {
                Image(systemName: "questionmark.square.dashed")
                    .frame( width: anchor, height: anchor )
            } else {
                ProgressView()
                    .frame( width: anchor, height: anchor )
            }
        }
    } else {*/
        // Fallback on earlier versions
        return ImageView(urlString: url)
            .frame(width: anchor, height: anchor)
    //}
  
}
