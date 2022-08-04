//
//  CoinManager.swift
//  Crypto Currency Tracker
//
//  Created by Petar Iliev on 8/4/22.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(currency: String, rate: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "C3A3969D-1FF0-4984-BF25-3E6F825FE29E"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let URLString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: URLString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if (error != nil) {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    let stringData = String(data: safeData, encoding: .utf8)
                    let rate = parseJSON(safeData)
                    let roundedRate = String(format: "%.2f", rate!)
                    self.delegate?.didUpdateCurrency(currency: currency, rate: roundedRate)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate
            return rate
        } catch {
            print(error)
            return nil
        }
    }
    
}

