//
//  AddCityViewController.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 16.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import UIKit

protocol UpdateChoosenCitiesDelegate: class {
    func didChooseCity(_ city: String)
}

class AddCityViewController: UITableViewController {
    
    private lazy var footer = FooterLoading()
    private var timer = Timer()
    private var cities = [CityName]()
    var choosenCities = [CityName]()
    let searchController = UISearchController(searchResultsController: nil)
    
    weak var delegate: UpdateChoosenCitiesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = footer
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Type city name here"
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let checkMark = UIImage(named: "Pin")
        let done = UIImage(named: "Done")
        
        let chooseBarButton = UIBarButtonItem(image: done, style: .plain, target: self, action: #selector(buttonAction))
        let locationBarButton = UIBarButtonItem(image: checkMark, style: .plain, target: self, action: #selector(locationAction))
        navigationItem.rightBarButtonItems = [chooseBarButton, locationBarButton]
    }
    
    @objc private func locationAction() {
        let userVC = UserLocationViewController()
        userVC.delegate = self
        
        navigationController?.pushViewController(userVC, animated: true)
    }
    
    @objc private func buttonAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let city = cities[indexPath.row]
        cell.textLabel?.text = city.name + ", " + city.country
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .white
        cell?.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .black
        cell?.backgroundColor = .white
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Find and add a city by clicking on it"
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cities.count == 0 ? 250 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        
        guard let _ = choosenCities.first(where: { $0.name + $0.country == city.name + city.country }) else { //проверка на дубликаты
            delegate?.didChooseCity(String(city.name + "," + city.countryCode ))
            choosenCities.append(city)
            return
        }
    }
}

extension AddCityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchText != "" else {
            self.cities = self.choosenCities
            self.tableView.reloadData()
            return
        }
        
        timer.invalidate()
        footer.showLoader()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
            NetworkCityFetcher.shared.fetchCity(for: searchText) { (city, error) in
                guard city != nil else { return }
                self.cities = city!.data
                self.footer.hideLoader()
                self.tableView.reloadData()
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cities = choosenCities
        tableView.reloadData()
    }
}

extension AddCityViewController: UserDidChooseLocationDelegate {
    
    func addLocation(for city: CityName) {
        choosenCities.append(city)
        cities.append(city)
        delegate?.didChooseCity(String(city.name + "," + city.countryCode ))
        self.tableView.reloadData()
    }
}
