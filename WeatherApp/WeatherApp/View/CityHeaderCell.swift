//
//  CityHeaderCell.swift
//  WeatherApp
//
//  Created by Ramamoorthy on 28/04/23.
//

import UIKit

class CityHeaderCell: UITableViewCell {
    
    
    @IBOutlet weak var humidityBtn: CustomButton!
    @IBOutlet weak var pressureBtn: CustomButton!
    @IBOutlet weak var rainChanceBtn: CustomButton!
    @IBOutlet weak var windBtn: CustomButton!
    @IBOutlet weak var weatherTypeLbl: CustomLabel!
    @IBOutlet weak var tepmLbl: CustomLabel!
    @IBOutlet weak var climateImg: UIImageView!
    @IBOutlet weak var dateLbl: CustomLabel!
    @IBOutlet weak var cityLbl: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindCell(data: BookMarked) {
        cityLbl.text = data.name
        let temperatureInCelsius = (data.temperature) - 273.15
        self.tepmLbl.text = "\(temperatureInCelsius.roundedString(to: 0))°"  
        weatherTypeLbl.text = data.type?.capitalized
       
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateStyle = .full
        let dateString = dayTimePeriodFormatter.string(from: (data.date ?? Date()))
        dateLbl.text = dateString

        let windSpeed = (data.wind * 3600/1000).roundedString(to: 0)
        self.windBtn.setTitle("\(windSpeed) km/hr", for: .normal)
        
        self.pressureBtn.setTitle("\(data.pressure.roundedString(to: 0)) mbar", for: .normal)
        self.humidityBtn.setTitle("\(data.humidity.roundedString(to: 0))%", for: .normal)
        self.rainChanceBtn.setTitle("\((data.rainChance * 100).roundedString(to: 0))%", for: .normal)
        
        climateImg.image = UIImage(systemName: data.image ?? "cloud")?.withRenderingMode(.alwaysOriginal)
        climateImg.contentMode = .scaleAspectFit
    }
    
}
