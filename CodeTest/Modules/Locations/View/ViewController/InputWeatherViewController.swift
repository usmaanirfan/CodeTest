//
//  InputWeatherViewController.swift
//  CodeTest
//
//  Created by Usman Ansari on 16/03/21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

class InputWeatherViewController: UIViewController {

    private var controller: WeatherController!
    @IBOutlet weak var theTextfieldLocation: UITextField!
    @IBOutlet weak var theTextfieldWeather: UITextField!
    @IBOutlet weak var theTextfieldTemprature: UITextField!
    weak var delegateWeatherView : WeatherViewController?
    var selectedWeather : String?
    let weatherPicker = UIPickerView()

    //MARK:Controller ceration function
    static func create() -> InputWeatherViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "InputWeatherViewController") as! InputWeatherViewController
        return viewController
    }

    //MARK:Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherPicker.delegate = self
        theTextfieldWeather.inputView = weatherPicker
        theTextfieldLocation.delegate = self
        theTextfieldWeather.delegate = self
        theTextfieldTemprature.delegate = self
        setup()
    }

    //MARK:Internal funtions
    @objc
    func addLocation() {
        if let location = theTextfieldLocation.text, location.isEmpty == false,  let weather = selectedWeather, weather.isEmpty == false, let temprature =  theTextfieldTemprature.text,temprature.isEmpty == false {
            self.dismiss(animated: true) {
                self.delegateWeatherView?.addLocation(location: location, weatherName: weather, temprature: Int(temprature))
            }
        }
    }

    @objc
    func goBack() {
        self.dismiss(animated: true) {

        }
    }

    //MARK:Private funtions
    private func setup() {
        title = AppConstants.ViewController.weatherDetailTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(goBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addLocation))
    }


}

//MARK:Extension fot picker, textfield delegates
extension InputWeatherViewController : UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AppConstants.ViewController.weatherPickerData.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AppConstants.ViewController.weatherPickerData[row].1
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        theTextfieldWeather.text = AppConstants.ViewController.weatherPickerData[row].1
        selectedWeather = AppConstants.ViewController.weatherPickerData[row].0
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == theTextfieldWeather {
           return false
        }
        return true
    }
}
