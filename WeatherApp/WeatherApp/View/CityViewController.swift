//
//  CityViewController.swift
//  WeatherApp
//
//  Created by Ramamoorthy on 28/04/23.
//

import UIKit
import CoreData

class CityViewController: UIViewController {
    
    var weatherData : BookMarked!
    @IBOutlet weak var tblVw: UITableView!
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCell()
        getDailyForecast()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CityViewController {
    func registerCell() {
        tblVw.register(UINib(nibName: cityCellHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cityCellHeaderIdentifier)
        tblVw.register(UINib(nibName: daysCellIdentifier, bundle: nil), forCellReuseIdentifier: daysCellIdentifier)
    }
    
    func getDailyForecast() {
        if let vm = viewModel, let data = weatherData {
            vm.getDailyForecast(lat: data.latitude, long: data.longitude)
            vm.bindDailyForecastToController = {
                DispatchQueue.main.async {
                    self.tblVw.reloadSections(IndexSet(integer: 1), with: .automatic)
                }
            }
        }
    }
}
extension CityViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            if let _ = viewModel.dailyForecast {
                return viewModel.dailyForecast.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cityCellHeaderIdentifier, for: indexPath) as? CityHeaderCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            if let _ = weatherData {
                cell.bindCell(data: weatherData)
            }
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: daysCellIdentifier, for: indexPath) as? DaysForecastCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            if let vm = viewModel  {
                cell.bindCell(data: vm.dailyForecast[indexPath.row])
            }
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? UITableView.automaticDimension : 60
    }
    
}

