//
//  ContentView.swift
//  RickMorty
//
//  Created by Alejandro Guerra Hernandez on 02/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var results = [CharacterDetail]()
    @State private var searchText = ""
    @State private var prevPageUrl: String?
    @State private var nextPageUrl: String?
    @State private var loading: Bool = false
    @State private var currentPage = 0
    @State private var pages:Int = 0
    @State private var totalCharacters = 0

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(searchResults, id: \.id) { item in
                    
                    NavigationLink {
                      CharacterDetalle( character: item, searchText: $searchText )
                    } label: {
                      HStack{
                        
                        characterImage(url: item.image)
                        
                        Text("#\(item.id) \(item.name.capitalized)")
                          .font(.headline)
                      }
                    }
                    .onAppear {
                      print(item.name)
                      if let lastPoke = results.last {
                        if item.name == lastPoke.name && nextPageUrl != nil {
                          Task {
                            if loading == true {
                              return
                            }
                            loading = true
                            await loadList(url: nextPageUrl ?? "")
                          }
                        }
                      }
                    }
                    
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Rick and Morty Characters")
            .toolbar {
                ToolbarItem (placement: .bottomBar) {
                  Text("\(results.count) of \(totalCharacters) characters")
                }
                /*ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }*/
            }
            if loading {
              ProgressView().scaleEffect(4)
            }
        } detail: {
            Text("Select an item")
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        
        .task {
          loading = true
          await loadList(url: "https://rickandmortyapi.com/api/character")
        }
    }
    
    var searchResults: [CharacterDetail] {
        print("searchText",searchText)
      if searchText.isEmpty {
        return results
      } else if Int(searchText) != nil {
          print("numero")
        return results.filter {
          $0.id == Int(searchText)
        }
      } else {
        return results.filter { 
            $0.name.lowercased().contains(searchText.lowercased())
        }
      }
    }
    
    func loadList(url: String) async {
      let response = await dataManager().loadData( urlString: url)
      totalCharacters = response?.info.count ?? 0
      results = results + (response?.results ?? [])
        let calculatePages: Float = Float(response?.info.count ?? 0) / 20
      //currentPage = 1
      pages = Int(ceil(calculatePages))
      //print("pages",pages)
        prevPageUrl = response?.info.prev ?? nil
        nextPageUrl = response?.info.next
      loading = false
      
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

struct ImageView: View {
    @ObservedObject private var imageViewModel: ImageViewModel
    
    init(urlString: String?) {
        imageViewModel = ImageViewModel(urlString: urlString)
    }
    
    var body: some View {
        Image(uiImage: imageViewModel.image ?? UIImage())
            .resizable()
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(urlString: "https://developer.apple.com/news/images/og/swiftui-og.png")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
