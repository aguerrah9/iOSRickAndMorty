//
//  CharacterDetalle.swift
//  RickMorty
//
//  Created by Alejandro Guerra Hernandez on 02/10/24.
//

import SwiftUI

struct CharacterDetalle: View {
  var character: CharacterDetail?
  @Binding var searchText: String
  @Environment(\.dismiss) var dismiss
  
    var body: some View {
        ScrollView {
            VStack {
                Text("")
                    .navigationTitle( "# \(character?.id ?? 0) \(character?.name ?? "Detail")").lineLimit(2)
                    .toolbar {
                        let shareString = """
                        Name: \(character?.name ?? "")
                        Status: \(character?.status ?? "")
                        Species: \(character?.species ?? "")
                        Type: \(character?.type ?? "")
                        Gender: \(character?.gender ?? "")
                        Origin: \(character?.origin.name ?? "")
                        Location: \(character?.location.name ?? "")
                        """
                        ShareLink(item: shareString) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                
                characterImage(url: character?.image ?? "", anchor: 254).padding().shadow(radius: 8, x: 5, y:5)
                
                Text("Status: \(character?.status ?? "")").padding(.bottom)
                Text("Species: \(character?.species ?? "")").padding(.bottom)
                Text("Type: \(character?.type ?? "")").padding(.bottom)
                Text("Gender: \(character?.gender ?? "")").padding(.bottom)
                Text("Origin: \(character?.origin.name ?? "")").padding(.bottom)
                Text("Location: \(character?.location.name ?? "")").padding(.bottom)
                
                Text("Episodes")
                Text(character?.episode.map{
                    "\($0.split(separator: "/").last ?? "")"
                }.joined(separator:", ") ?? "")
            }
            
        }
    }
  
}
