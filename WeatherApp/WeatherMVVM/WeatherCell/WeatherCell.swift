//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Ajay Awasthi on 19/01/23.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    static let identifier = "WeatherDataCell"
    
    lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "VS"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubiews()
        setUpConstraints()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        let subviews = [iconImage,dateLabel,maxTempLabel, minTempLabel]
        subviews.forEach {
            contentView.addSubview($0)
        }
        layer.cornerRadius = 10
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            iconImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            iconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 5),
            
            maxTempLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            maxTempLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 5),
            
            minTempLabel.topAnchor.constraint(equalTo: maxTempLabel.bottomAnchor, constant: 10),
            minTempLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 5)
              
        ])
    }
    
    func bind(weatherData: Forecastday) {
        
        guard let value = weatherData.day?.condition?.icon else {
            return
        }
        let image = value.replacingOccurrences(of: "//", with: "https://")
        iconImage.downloaded(from: image as String)
        
        dateLabel.text = weatherData.date
        
        guard let maxTemp = weatherData.day?.maxtempC else {
            return
        }
        maxTempLabel.text =  "Max Temp : \(String(maxTemp))"
        
        guard let minTemp = weatherData.day?.mintempC else {
            return
        }
        minTempLabel.text = "Min Temp : \(String(minTemp))"
        
        
    }
}
