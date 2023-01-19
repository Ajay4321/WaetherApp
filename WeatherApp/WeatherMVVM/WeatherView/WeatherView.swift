//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Ajay Awasthi on 19/01/23.
//

import UIKit

class WeatherView: UIView {
    
    lazy var activityIndicationView = ActivityIndicatorView(style: .medium)
    let tableView = UITableView(frame: .zero, style: .plain)
    
    lazy var country: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var city: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var region: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var dateTime: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var myStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
        
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        let subviews = [myStack,activityIndicationView,tableView]
        
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func startLoading() {
       activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    
    func finishLoading() {
        activityIndicationView.stopAnimating()
    }
    
    func setupDataBinding(weatherData: WeatherModel) {
        
        country.text = "Country : \(String(describing: weatherData.location.country!))"
        city.text = "City : \(String(describing: weatherData.location.name!))"
        region.text = "Region : \(String(describing: weatherData.location.region!))"
        dateTime.text = "Date : \(getFormattedDate(string: weatherData.location.localtime!))"
    }
//
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            myStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            myStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            myStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 70),
            myStack.heightAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: myStack.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo:bottomAnchor),
            
            activityIndicationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicationView.heightAnchor.constraint(equalToConstant: 50),
            activityIndicationView.widthAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    private func setUpViews() {
        myStack.addArrangedSubview(country)
        myStack.addArrangedSubview(city)
        myStack.addArrangedSubview(region)
        myStack.addArrangedSubview(dateTime)
    }
}
