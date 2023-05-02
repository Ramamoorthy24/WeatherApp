//
//  HomeCardCell.swift
//  WeatherApp
//
//  Created by Ramamoorthy on 28/04/23.
//

import UIKit

class HomeCardCell: UITableViewCell {
    
    
    @IBOutlet weak var lowLbl: CustomLabel!
    @IBOutlet weak var highLbl: UILabel!
    @IBOutlet weak var climateLbl: CustomLabel!
    @IBOutlet weak var degLbl: CustomLabel!
    @IBOutlet weak var timeLbl: CustomLabel!
    @IBOutlet weak var nameLbl: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
        
    func bindCell(data: BookMarked,isImperial: Bool)   {
        
        nameLbl.text = data.name
        let temperature = isImperial ? data.temperature.getFahrenheit(valueInKelvin: data.temperature) : data.temperature.getCelsius(valueInKelvin: data.temperature)
        self.degLbl.text = "\(temperature.roundedString(to: 0))°"
        climateLbl.text = data.type?.capitalized
       
        let hTemp = isImperial ? data.high.getFahrenheit(valueInKelvin: data.high) : data.high.getCelsius(valueInKelvin: data.high)
        self.highLbl.text = "H:\(hTemp.roundedString(to: 0))°"
        let lTemp = isImperial ? data.low.getFahrenheit(valueInKelvin: data.low) : data.low.getCelsius(valueInKelvin: data.low)
        self.lowLbl.text = "L:\(lTemp.roundedString(to: 0))°"
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"

        let dateString = dayTimePeriodFormatter.string(from: data.date ?? Date())
        timeLbl.text = dateString

    }
}
