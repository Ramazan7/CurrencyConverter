//
//  ViewController.swift
//  CurrencyConverteriOS
//
//  Created by Admin on 15.06.2022.
//

import UIKit

class ViewController: UIViewController {

    var currencyData = [structJson]()

    var rub:Double = 55
    var uzs:Double = 11110
    let formatted = NumberFormatter()
    // form elements
    let mainCurrencyTitle = UILabel()
    let refreshCurrencyButton = UIButton()
    
    let stackviewEnterFields = UIStackView()
    let usdTitle = UILabel()
    let usdField = UITextField()
    let rubTitle = UILabel()
    let rubField = UITextField()
    let uzsTitle = UILabel()
    let uzsField = UITextField()
        
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        settingFormElements()
        addSubviews()
        addConstraints()
        // Do any additional setup after loading the view.
    }
    
    func settingFormElements(){
        
        formatted.numberStyle = .decimal
        formatted.usesGroupingSeparator = true
        
        mainCurrencyTitle.text = "RUB: \(String(format:"%.2f", rub))   UZS \(String(format:"%.2f", uzs))"
        refreshCurrencyButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshCurrencyButton.addTarget(.none, action: #selector(refreshButton), for: .touchUpInside)
        
        stackviewEnterFields.axis = .vertical
        stackviewEnterFields.spacing = 20
        
        usdTitle.text   = "USD"
        rubTitle.text  = "RUB"
        uzsTitle.text   = "UZS"
        
        usdField.keyboardType = .numberPad
        usdField.placeholder = "0"
        usdField.textAlignment = .right
        usdField.addTarget(.none, action: #selector(usdChangeField), for: .editingChanged)
        rubField.keyboardType = .numberPad
        rubField.placeholder = "0"
        rubField.textAlignment = .right
        rubField.addTarget(.none, action: #selector(rubChangeField), for: .editingChanged)
        uzsField.keyboardType = .numberPad
        uzsField.placeholder = "0"
        uzsField.textAlignment = .right
        uzsField.addTarget(.none, action: #selector(uzsChangeField), for: .editingChanged)
        
    }


    func addSubviews(){
        view.addSubview(mainCurrencyTitle)
        view.addSubview(refreshCurrencyButton)
        
        view.addSubview(stackviewEnterFields)
        stackviewEnterFields.addArrangedSubview(usdTitle)
        stackviewEnterFields.addArrangedSubview(usdField)
        stackviewEnterFields.addArrangedSubview(rubTitle)
        stackviewEnterFields.addArrangedSubview(rubField)
        stackviewEnterFields.addArrangedSubview(uzsTitle)
        stackviewEnterFields.addArrangedSubview(uzsField)
    }
    
    func addConstraints(){
        mainCurrencyTitle.translatesAutoresizingMaskIntoConstraints = false
        mainCurrencyTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        mainCurrencyTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        refreshCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        refreshCurrencyButton.topAnchor.constraint(equalTo: mainCurrencyTitle.topAnchor).isActive = true
        refreshCurrencyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        stackviewEnterFields.translatesAutoresizingMaskIntoConstraints = false
        stackviewEnterFields.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackviewEnterFields.topAnchor.constraint(equalTo: mainCurrencyTitle.bottomAnchor, constant: 30).isActive = true
        stackviewEnterFields.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stackviewEnterFields.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -70).isActive = true
    }
    
    @objc func refreshButton(){

        downloadJSON(checkCurrency: "RUB")
        rub = currencyData[0].result
        downloadJSON(checkCurrency: "UZS")
        uzs = currencyData[0].result
        mainCurrencyTitle.text = "RUB: \(String(format:"%.2f", rub))   UZS \(String(format:"%.2f", uzs))"
       // rubTitle.text = String(format:"%.2f",rub)
       // uzsTitle.text = String(format:"%.2f",uzs)

    }
    
    
    @objc func usdChangeField(){
        if let valueUSD = Double(usdField.text!){
        let rubResult = rub * valueUSD
        let uzsResult = uzs * valueUSD
            
           
            rubField.text = formatted.string(from:rubResult as NSNumber)
            uzsField.text = formatted.string(from: uzsResult as NSNumber)
        }
        else {
            usdField.text = ""
            rubField.text = ""
            uzsField.text = ""
        }
    }
        
        @objc func rubChangeField(){
            // delete 0
            
                
            if let valueUSD = Double(rubField.text!){
                
            let usdResult = valueUSD / rub
            let uzsResult = (uzs / rub) * valueUSD
            
            usdField.text = formatted.string(from: usdResult as NSNumber)
            uzsField.text = formatted.string(from: uzsResult as NSNumber)
            }
            else {
                usdField.text = ""
                rubField.text = ""
                uzsField.text = ""
            }
        }
            
            @objc func uzsChangeField(){
                if let valueUSD = Double(uzsField.text!){
                let usdResult = valueUSD / uzs
                let rubResult = (rub / uzs) * valueUSD
                
                usdField.text = formatted.string(from: usdResult as NSNumber)
                rubField.text = formatted.string(from: rubResult as NSNumber)
                }
                else {
                    usdField.text = ""
                    rubField.text = ""
                    uzsField.text = ""
                }
            }
    
    
    
    
    
    
    
    
    func downloadJSON(checkCurrency:String) {
        
        let semaphore = DispatchSemaphore (value: 0)

        let url = "https://api.apilayer.com/exchangerates_data/convert?to=\(checkCurrency)&from=USD&amount=1"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue("Ua5aTsmx620FBfKSF96pnj2U0fsUFnlE", forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
         // print(String(data: data, encoding: .utf8)!)
            do {
                let currencyDataa = try JSONDecoder().decode(structJson.self, from: data)
                self.currencyData = [currencyDataa]
                }catch {
                        print("json Error")
                        }
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
}

