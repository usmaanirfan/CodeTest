//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import Foundation

protocol WeatherView : class {
    func showEntries()
    func displayError(error : Error)
    func appendEntry(at index : Int)
    func deleteEntry(at index : Int)
    func showLoading()
    func hideLoading()
}

class WeatherController {
    weak var view: WeatherView?
    let networkRequest : NetworkClientInterface

    public private(set) var locations: [WeatherLocation] = []

    init(networkRequest : NetworkClientInterface) {
        self.networkRequest = networkRequest
    }

    internal func bind(view: WeatherView) {
        self.view = view
        refresh()
    }
}

extension WeatherController {
    func refresh() {
        self.view?.showLoading()
        guard let apiURL = URL(string: EndPointsConfiguration.baseURL + EndPointsConfiguration.locationEndpoint) else {
            let error = RequestError.invalidURL
            DispatchQueue.main.async {
                self.view?.hideLoading()
                self.view?.displayError(error: error)
            }
            return
        }
        let requestModel = RequestModel(apiKey: self.apiKey, url: apiURL)
        self.networkRequest.makeHttpRequest(dataType: LocationsResult.self, requestType: RequestType.fetchLocations, requestModel: requestModel) { result in
            switch result {
            case .success(let item):
                self.locations = item.locations
                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    self.view?.showEntries()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    self.view?.displayError(error : error)
                }
            }
        }

    }

    func addLocation(locationName : String, weatherStatus : String = "SUNNY" , temprature : Int = 20) {
        self.view?.showLoading()
        guard let apiURL = URL(string: EndPointsConfiguration.baseURL + EndPointsConfiguration.locationEndpoint) else {
            let error = RequestError.invalidURL
            DispatchQueue.main.async {
                self.view?.hideLoading()
                self.view?.displayError(error: error)
            }
            return
        }
        let body : [String : Any] = ["name": locationName,"status": weatherStatus,"temperature": temprature]
        let requestModel = RequestModel(body: body, apiKey: self.apiKey, url: apiURL)
        self.networkRequest.makeHttpRequest(dataType: WeatherLocation.self, requestType: RequestType.addLocation, requestModel: requestModel) { result in
            switch result {
            case .success(let item):
                self.locations.append(item)
                if let index = self.getIndexOfItem(locationId: item.id) {
                    DispatchQueue.main.async {
                      self.view?.hideLoading()
                      self.view?.appendEntry(at: index)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    self.view?.displayError(error : error)
                }
            }
        }
    }

    func deleteLocation(index : Int) {
        let locationId = self.locations[index].id
        self.view?.showLoading()
        guard let apiURL = URL(string: EndPointsConfiguration.baseURL + EndPointsConfiguration.locationEndpoint + "/\(locationId)") else {
            let error = RequestError.invalidURL
            DispatchQueue.main.async {
                self.view?.hideLoading()
                self.view?.displayError(error: error)
            }
            return
        }
        let requestModel = RequestModel(apiKey: self.apiKey, url: apiURL)
        self.networkRequest.makeHttpRequest(dataType: String.self, requestType: RequestType.deleteLocation, requestModel: requestModel) { result in
            switch result {
            case .success( _):
                if let index = self.getIndexOfItem(locationId: locationId) {
                    DispatchQueue.main.async {
                    self.locations.remove(at: index)
                    self.view?.hideLoading()
                    self.view?.deleteEntry(at: index)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    self.view?.displayError(error : error)
                }
            }
        }
    }

    func getIndexOfItem(locationId : String)->Int? {
        let index = self.locations.firstIndex{$0.id == locationId} ?? nil
        return index
    }

    private var apiKey: String {
        guard let apiKey = UserDefaults.standard.string(forKey: "API_KEY") else {
            let key = UUID().uuidString
            UserDefaults.standard.set(key, forKey: "API_KEY")
            return key
        }
        return apiKey
    }

}

private struct LocationsResult: Decodable {
    var locations: [WeatherLocation]
}
