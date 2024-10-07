//
//  ViewModel.swift
//  RickMorty
//
//  Created by Alejandro Guerra Hernandez on 02/10/24.
//

import Foundation
import UIKit

struct dataManager {
  func loadData(urlString: String) async -> Response? {
    var response: Response
    guard let url = URL(string: urlString) else {
      print("URL inválida")
      return nil
    }
    var characters = [CharacterDetail]()
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      
      guard let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) else {
        print("Couldnt decode")
        return nil
      }
      let results = decodedResponse.results
      response = decodedResponse
      
      for character in results {
        //print(pokemon.url)
        if let char = await CharacterAPI().loadDetail(urlString: character.url) {
            characters.append(char)
        }
      }
      
      response.results = characters
      
    } catch {
      print("información inválida")
      return nil
    }
    return response
  }
}

struct CharacterAPI {
  func loadDetail(urlString: String) async -> CharacterDetail? {
    
    guard let url = URL(string: urlString) else {
      print("URL inválida")
      return nil
    }
    
    var characterDetail: CharacterDetail? = nil
    
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      
      guard let decodedResponse = try? JSONDecoder().decode(CharacterDetail.self, from: data) else {
        print("Couldnt decode")
        return nil
      }
      characterDetail = decodedResponse
      
    } catch {
      print("información inválida")
      return nil
    }
    
    return characterDetail
  }
}

class ImageViewModel: ObservableObject {
    @Published var image: UIImage?

    private var imageCache: NSCache<NSString, UIImage>?

    init(urlString: String?) {
        loadImage(urlString: urlString)
    }

    private func loadImage(urlString: String?) {
        guard let urlString = urlString else { return }

        if let imageFromCache = getImageFromCache(from: urlString) {
            self.image = imageFromCache
            return
        }

        loadImageFromURL(urlString: urlString)
    }

    private func loadImageFromURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error ?? "unknown error")
                return
            }

            guard let data = data else {
                print("No data found")
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard let loadedImage = UIImage(data: data) else { return }
                self?.image = loadedImage
                self?.setImageCache(image: loadedImage, key: urlString)
            }
        }.resume()
    }

    private func setImageCache(image: UIImage, key: String) {
        imageCache?.setObject(image, forKey: key as NSString)
    }

    private func getImageFromCache(from key: String) -> UIImage? {
        return imageCache?.object(forKey: key as NSString) as? UIImage
    }
}
