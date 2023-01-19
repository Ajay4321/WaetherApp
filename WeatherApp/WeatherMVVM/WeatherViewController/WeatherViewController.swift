//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Ajay Awasthi on 19/01/23.
//

import UIKit
import Combine

class WeatherViewController: UIViewController {
    
    private typealias DataSource = UITableViewDiffableDataSource<Int, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>
    let weatherData: WeatherModel = WeatherModel(location: Location(name: "", region: "", country: "", lat: 0.0, lon: 0.0, tzID: "", localtimeEpoch: 0, localtime: ""),current: Current(lastUpdatedEpoch: 0, lastUpdated: "", tempC: 0, tempF: 0.0, isDay: 0,condition: Condition(text: "" ,icon: "",code: 0),windMph: 0.0,windKph: 0.0,windDegree: 0, windDir: "", pressureMB: 0, pressureIn: 0.0, precipMm: 0, precipIn: 0, humidity: 0, cloud: 0, feelslikeC: 0.0, feelslikeF: 0.0, visKM: 0, visMiles: 0, uv: 0, gustMph: 0.0, gustKph: 0 ), forecast: Forecast(forecastday: []))
    
    private let viewModel: WeatherViewModel
    private lazy var contentView = WeatherView()
    
    private var dataSource: DataSource!
    
    private var bindings = Set<AnyCancellable>()
    
    init(viewModel: WeatherViewModel = WeatherViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = .white
        setUpTableView()
        configureDataSource()
        setUpBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Mumbai, Jodhpur, Jaipur, Lucknow, Hyderabad
        
        viewModel.fetchWeatherData(forCity: "Lucknow")
    }
    
    
    private func setUpTableView() {
        contentView.tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        contentView.tableView.rowHeight = 90
    }

    
    private func setUpBindings() {

            viewModel.$weatherModel
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] items in
                    self?.updateSections()
                })
                .store(in: &bindings)
            
            let stateValueHandler: (WeatherViewModelState) -> Void = { [weak self] state in
                switch state {
                case .loading:
                    self?.contentView.startLoading()
                case .finishedLoading:
                    self?.contentView.finishLoading()
                case .error(let error):
                    self?.contentView.finishLoading()
                    self?.showError(error)
                }
            }
            
            viewModel.$state
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateValueHandler)
                .store(in: &bindings)

    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.weatherModel.forecast.forecastday)
        dataSource.apply(snapshot, animatingDifferences: true)
        if viewModel.weatherModel.forecast.forecastday.count > 0 {
            contentView.setupDataBinding(weatherData: viewModel.weatherModel)
        }
    }
    
    
}

extension WeatherViewController {
       
    private func configureDataSource() {
        dataSource = DataSource(
            tableView: contentView.tableView,
            cellProvider: {  tableView, indexPath, contact in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: WeatherCell.identifier,
                    for: indexPath
                ) as? WeatherCell
                
                cell?.bind(weatherData: self.viewModel.weatherModel.forecast.forecastday[indexPath.row])
                return cell
            }
            
        )
        
    }
}
