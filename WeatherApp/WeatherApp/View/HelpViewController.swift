//
//  HelpViewController.swift
//  WeatherApp
//
//  Created by Ramamoorthy on 02/05/23.
//

import UIKit
import WebKit

class HelpViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = Bundle.main.url(forResource: "howtoUse", withExtension: "html") {
            webView.load(URLRequest(url: url))
        }
        webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let textSize = 300
        let javascript = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%'"
        webView.evaluateJavaScript(javascript) { (response, error) in
            print()
        }
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
