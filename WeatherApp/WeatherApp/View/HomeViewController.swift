    //
    //  ViewController.swift
    //  WeatherApp
    //
    //  Created by Ramamoorthy on 28/04/23.
    //

    import UIKit
    import CoreLocation
    import CoreData

    class HomeViewController: UIViewController {
        
        @IBOutlet weak var tblVw: UITableView!
        @IBOutlet weak var settingBtn: UIBarButtonItem!
        
        let locationManager = LocationManager.sharedInstance
        var long:Double?
        var lat:Double?
        private var homeViewModel : HomeViewModel!
        var list = [BookMarked]()
        var showImperial = false
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            homeViewModel = HomeViewModel()
            setupDropdownMenu()
            registerCell()
            enableLocation()
            getBookMarked()
            if #available(iOS 13.0, *) {
                navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            } else {
                navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            }
        }
        
        @IBAction func act_Help(_ sender: Any) {
            performSegue(withIdentifier: helpVCIdentifier, sender: self)
        }
    }
    extension HomeViewController {
        func registerCell() {
            tblVw.register(UINib(nibName: homeCellIdentifier, bundle: nil), forCellReuseIdentifier: homeCellIdentifier)
        }
        func enableLocation() {
            self.locationManager.delegate = self
            if locationManager.authStatusLocation() == .notDetermined {
                locationManager.startLocationService()
            }else if(locationManager.authStatusLocation() == .restricted || locationManager.authStatusLocation() == .denied){
                self.showAlertWithOptions(message: locationPermissionMessage, options: "Ok") { (option) in
                    switch(option) {
                    case 0: break
                    case 1:
                        if let url = URL(string:UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    default:
                        break
                    }
                }
            }else{
                if(locationManager.locationManager != nil ) {
                    locationManager.locationManager.stopUpdatingLocation()
                    locationManager.locationManager.startUpdatingLocation()
                }else {
                    locationManager.startLocationService()
                }
            }
        }
        func checkLocation(){
            if locationManager.isEnableLocation(){
                if let location = self.locationManager.locationDetail  {
                    self.lat = location?.coordinate.latitude
                    self.long = location?.coordinate.longitude
                    getTodayWeather()
                }
            }else{
                self.lat = DefaultLocation.coordinate.latitude
                self.long = DefaultLocation.coordinate.longitude
            }
        }
        
        func getTodayWeather() {
            homeViewModel.getTodayWeather(lat: lat ?? DefaultLocation.coordinate.latitude, long: long ?? DefaultLocation.coordinate.longitude)
            homeViewModel.bindTodayWeatherToController = {
                if let data = self.homeViewModel.weatherData {
                    DispatchQueue.main.async {
                        self.handleBookMarked(data: data)
                    }
                }
            }
        }
        
        func getBookMarked() {
            let savedFetch: NSFetchRequest<BookMarked> = BookMarked.fetchRequest()
            let sortByDate = NSSortDescriptor(key: #keyPath(BookMarked.date), ascending: false)
            savedFetch.sortDescriptors = [sortByDate]
            do {
                let managedContext = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
                let results = try managedContext.fetch(savedFetch)
                list = results
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
        }
        
        func handleBookMarked(data: TodayWeatherData) {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
            let newBookMark = BookMarked(context: managedContext)
            newBookMark.setValue(homeViewModel.cityName, forKey: #keyPath(BookMarked.name))
            newBookMark.setValue(data.main?.tempMax ?? 0, forKey: #keyPath(BookMarked.high))
            newBookMark.setValue(data.main?.tempMin ?? 0, forKey: #keyPath(BookMarked.low))
            newBookMark.setValue(data.coord?.lat ?? 0, forKey: #keyPath(BookMarked.latitude))
            newBookMark.setValue(data.coord?.lon ?? 0, forKey: #keyPath(BookMarked.longitude))
            newBookMark.setValue(Date(timeIntervalSince1970: TimeInterval(data.dt ?? 0)), forKey: #keyPath(BookMarked.date))
            newBookMark.setValue(data.weather?.first?.type, forKey: #keyPath(BookMarked.type))
            newBookMark.setValue(data.main?.temp ?? 0, forKey: #keyPath(BookMarked.temperature))
            newBookMark.setValue(data.weather?.first?.iconImage ?? "", forKey: #keyPath(BookMarked.image))
            newBookMark.setValue(data.wind?.speed, forKey: #keyPath(BookMarked.wind))
            newBookMark.setValue(data.main?.humidity, forKey: #keyPath(BookMarked.humidity))
            newBookMark.setValue(data.main?.pressure, forKey: #keyPath(BookMarked.pressure))
            newBookMark.setValue(data.pop, forKey: #keyPath(BookMarked.rainChance))
            
            self.list.insert(newBookMark, at: 0)
            AppDelegate.sharedAppDelegate.coreDataManager.saveContext()
            self.tblVw.reloadData()
        }
        
        func setupDropdownMenu() {
            let metricItem = UIAction(title: metric, image: UIImage(systemName: !showImperial ? "checkmark.circle" : "")) { (action) in
                self.showImperial = false
                self.setupDropdownMenu()
                self.tblVw.reloadData()
            }
            
            let imperialItem = UIAction(title: imperial, image: UIImage(systemName: showImperial ? "checkmark.circle" : "")) { (action) in
                self.showImperial = true
                self.setupDropdownMenu()
                self.tblVw.reloadData()
            }
            
            let reset = UIAction(title: resetBookMark, image: UIImage(systemName: "bookmark.fill")) { (action) in
                self.showAlertWithOptions(message: wantToReset, options: "Yes","Cancel") { option in
                    if option == 0 {
                        self.resetBookMarked()
                        self.list.removeAll()
                        AppDelegate.sharedAppDelegate.coreDataManager.saveContext()
                        self.tblVw.reloadData()
                    }
                }
            }
            
            let menu = UIMenu(title: "Settings", options: .displayInline, children: [metricItem , imperialItem , reset])
            
            let navItems = [UIBarButtonItem(image:  UIImage(systemName: "gear"), menu: menu)]
            self.navigationItem.rightBarButtonItems = navItems
            
        }
        
        func resetBookMarked() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookMarked")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                    do {
                        try AppDelegate.sharedAppDelegate.coreDataManager.managedContext.execute(batchDeleteRequest)
                    } catch {
                        print("Detele all data in \(0) error :", error)
                    }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == addLocationVCIdentifier {
                let mapVC = segue.destination as? AddLocationMapVC
                mapVC?.delegate = self
            }else if segue.identifier == cityVCIdentifier {
                let cityVC = segue.destination as? CityViewController
                cityVC?.weatherData = sender as? BookMarked
                cityVC?.viewModel = self.homeViewModel
            }
        }
    }
    extension HomeViewController {
        
        @IBAction func act_Settings(_ sender: Any) {
            
        }
        
        @IBAction func act_AddLocation(_ sender: Any) {
            performSegue(withIdentifier: addLocationVCIdentifier, sender: self)
        }
    }
    extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return list.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: homeCellIdentifier, for: indexPath) as? HomeCardCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.bindCell(data: list[indexPath.row],isImperial: showImperial)
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: cityVCIdentifier, sender: list[indexPath.row])
        }
        
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
                AppDelegate.sharedAppDelegate.coreDataManager.managedContext.delete(self.list[indexPath.row])
                self.list.remove(at: indexPath.row)
                AppDelegate.sharedAppDelegate.coreDataManager.saveContext()
                self.tblVw.deleteRows(at: [indexPath], with: .automatic)
                complete(true)
            }
            deleteAction.image = UIImage(systemName: "trash.fill")?.withTintColor(.red)
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        }
    }
    extension HomeViewController: AddLocationMapDelegate,LocationManagerDelegate {
        func didAddedNewLocation(location: CLLocationCoordinate2D) {
            lat = location.latitude
            long = location.longitude
            self.getTodayWeather()
        }
        
        func locationDidAuthorized() {
            if list.count == 0 {
                self.checkLocation()
            }
        }
        
        func locationDidDenied() {
            
        }
    }
