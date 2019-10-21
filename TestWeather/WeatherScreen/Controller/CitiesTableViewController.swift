//
//  ViewController.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 15.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import UIKit
import RealmSwift

class CitiesTableViewController: UITableViewController {
    
    var choosenCities = [String]()
    
    let savedCities = RealmManager.sharedInstance.get(of: Weather.self)
    
    private let refreshing: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return refreshControl
    }()
    
    private var footerView = FooterLoading()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = footerView
        tableView.refreshControl = refreshing
        self.tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: CityTableViewCell.cellId)
    }
    
    private func getData() {
        
        if choosenCities.count > 0 {
            for city in choosenCities {
                footerView.showLoader()
                NetworkWeatherFetcher.shared.fetchWeather(for: city) { [unowned self] (cityWeather, error) in
                    guard error == nil else {
                        self.footerView.hideLoader()
                        return }
                    
                    let currentWeather = RealmConverter.shared.convertModel(cityWeather!)
                    RealmManager.sharedInstance.add(currentWeather)
                    self.footerView.hideLoader()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Cities"
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addCity))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func refreshAction(_ sender: UIRefreshControl) {
        
        if savedCities.count == 0 {
            sender.endRefreshing()
        }
        
        for city in savedCities {
            let weather = city as! Weather
            NetworkWeatherFetcher.shared.fetchWeather(for: weather.cityName) { [unowned self] (cityWeather, error) in
                guard error == nil else { return }
                let currentWeather = RealmConverter.shared.convertModel(cityWeather!)
                RealmManager.sharedInstance.updateData(wtih: currentWeather)
                
                self.tableView.reloadData()
                sender.endRefreshing()
            }
        }
        
    }
    
    @objc private func addCity() {
        let vc = AddCityViewController()
        vc.delegate = self
        choosenCities = []
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Добавьте город нажав на кнопку справа"
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.cellId) as! CityTableViewCell
        
        let city = savedCities[indexPath.row] as! Weather
        
        cell.fillCell(city)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return savedCities.count > 0 ? 0 : 250
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (_, _, success) in
            
            RealmManager.sharedInstance.delete(self.savedCities[indexPath.row])
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            success(true)
        })
        
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


extension CitiesTableViewController: UpdateChoosenCitiesDelegate {
    
    func didChooseCity(_ id: String) {
        choosenCities.append(id)
    }
    
}
