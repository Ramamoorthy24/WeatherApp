//
//  DaysForecastCell.swift
//  WeatherApp
//
//  Created by Ramamoorthy on 28/04/23.
//

import UIKit

class DaysForecastCell: UITableViewCell {

    @IBOutlet weak var dayLbl: CustomLabel!
    @IBOutlet weak var tempLbl: CustomLabel!
    @IBOutlet weak var climateBtn: CustomButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindCell(data: List) {
        let temperatureInCelsius = (data.main.temp ?? 0) - 273.15
        self.tempLbl.text = "\(temperatureInCelsius.roundedString(to: 0))°"
        self.climateBtn.setTitle(data.weather.first?.main, for: .normal)
        self.climateBtn.setImage(UIImage(systemName: data.weather.first?.iconImage ?? "cloud")?.withRenderingMode(.alwaysOriginal), for: .normal)
        dayLbl.text = data.dt.dayDateMonth
        dayLbl.textColor = .white
    }
    
}
