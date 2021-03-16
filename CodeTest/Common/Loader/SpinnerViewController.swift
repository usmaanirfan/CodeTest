//
//  SpinnerViewController.swift
//  CodeTest
//
//  Created by Usman Ansari on 16/03/21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
    // MARK:
    // MARK: Outlets -
    //View:- To show error view for showing only spinner.
    @IBOutlet weak var spinner: UIImageView!
    @IBOutlet weak var spinnerContainer: UIView!

    // MARK:
    // MARK: Initializer Methods -
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "SpinnerViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {

    }
    // MARK:
    // MARK: Lifecycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinnerContainer.layer.cornerRadius = 6
        self.spinnerContainer.isHidden = false
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startSpinning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopSpinning()
    }

    // MARK:
    // MARK: Private Methods -
    private func startSpinning() {
        self.spinner.startSpinning(rotationFromValue: AppConstants.SpinnerValues.rotationFromValue, rotaionToValue: AppConstants.SpinnerValues.rotationToValue, rotationDuration: AppConstants.SpinnerValues.rotationDuration, rotationRepeatCount: HUGE)
    }

    private func stopSpinning() {
        self.spinner.stopSpinning()
    }
}

extension UIImageView{
      /// Description: Method to spin any imageview in clockwise directions
      func startSpinning(rotationFromValue : Any = 0.0,rotaionToValue : Any = AppConstants.SpinnerValues.rotationToValue, rotationDuration : CFTimeInterval = AppConstants.SpinnerValues.rotationDuration, rotationRepeatCount : Float = HUGE) {
          let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
          rotateAnimation.fromValue = rotationFromValue
          rotateAnimation.toValue = rotaionToValue
          rotateAnimation.duration = rotationDuration
          rotateAnimation.repeatCount = rotationRepeatCount
          self.layer.add(rotateAnimation, forKey: "transform.rotation")
      }
    /// Description : Method to stop spinning animation by removing all animations
    func stopSpinning() {
        self.layer.removeAnimation(forKey: "transform.rotation")
    }

    // Extension to change the image tint color.
    func changeImageColor( color:UIColor) -> UIImage?
    {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        tintColor = color
        return self.image
    }
}
