//
//  Extension.swift
//  WeatherApp
//
//  Created by Ajay Awasthi on 19/01/23.
//

import UIKit

func getFormattedDate(string: String) -> String{
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd yyyy HH:mm:ss a"
    
    let date: Date? = dateFormatterGet.date(from: string)
    
    return dateFormatter.string(from: date!);
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
