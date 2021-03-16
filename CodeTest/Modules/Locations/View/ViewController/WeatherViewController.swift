//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {

    private var controller: WeatherController!
    var spinnerView : SpinnerViewController?

    //MARK:Controller ceration function
    static func create(controller: WeatherController) -> WeatherViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let viewController = storyboard.instantiateInitialViewController() as! WeatherViewController

        viewController.controller = controller
        return viewController
    }

    //MARK:Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.bind(view: self)
        setup()
    }

    //MARK:Internal funtions
    @objc
    func addLocationView() {
        let viewController = InputWeatherViewController.create()
        let navigationSpinner = UINavigationController(rootViewController: viewController)
        navigationSpinner.modalPresentationStyle = .custom
        viewController.delegateWeatherView = self
        self.present(navigationSpinner, animated: true, completion: {})
    }

    func addLocation(location : String?, weatherName : String?, temprature : Int?) {
        if let location = location, let weatherName = weatherName, let temprature = temprature {
            self.controller.addLocation(locationName: location, weatherStatus: weatherName, temprature: temprature)
        }
    }

    //MARK:Private funtions
    private func showSpinner() {
        self.spinnerView  = SpinnerViewController(nibName:AppConstants.ViewController.kSpinnerViewController,bundle:nil)
        let navigationSpinner = UINavigationController(rootViewController: spinnerView!)
        navigationSpinner.modalPresentationStyle = .custom
        self.present(navigationSpinner, animated: false, completion: {})
    }

    private func hideSpinner(_ completionHandler: @escaping () -> Void) {
            if let _ = self.spinnerView {
                    self.spinnerView?.dismiss(animated: false, completion: {
                        completionHandler()
                    })
                    self.spinnerView = nil
            }
    }

    private func setup() {
        title = AppConstants.ViewController.weatherViewTitle
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocationView))
    }

}

//MARK:WeatherView delegates
extension WeatherViewController: WeatherView {

    func showEntries() {
        tableView.reloadData()
    }

    func displayError(error : Error) {
        let alertController = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }

    func showLoading() {
        self.showSpinner()
    }

    func hideLoading() {
        self.hideSpinner {}
    }

    func appendEntry(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: .fade)
        self.tableView.endUpdates()
    }

    func deleteEntry(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [indexPath], with: .fade)
        self.tableView.endUpdates()
    }
}

//MARK:Tableviw delegates
extension WeatherViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as! LocationTableViewCell

        let entry = controller.locations[indexPath.row]
        cell.setup(entry)

        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            // delete the item here
            self.controller.deleteLocation(index: indexPath.row)
            completionHandler(true)
        }
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        } else {
            deleteAction.title = "Delete"
        }
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
}
