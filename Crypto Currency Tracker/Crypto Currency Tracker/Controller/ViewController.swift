//
//  ViewController.swift
//  Crypto Currency Tracker
//
//  Created by Petar Iliev on 8/4/22.
//

import UIKit

class ViewController: UIViewController  {
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}

// MARK: UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow: Int, forComponent component: Int) -> String {
        return coinManager.currencyArray[titleForRow]
    }
}

// MARK: UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
}

// MARK: CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCurrency(currency: String, rate: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.bitcoinLabel.text = rate
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
