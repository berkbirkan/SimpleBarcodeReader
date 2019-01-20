//
//  ViewController.swift
//  SimplebarcodeReader
//
//  Created by berk birkan on 18.01.2019.
//  Copyright © 2019 Turansoft. All rights reserved.
//

import UIKit
import Gallery
import Firebase

class ViewController: UIViewController, GalleryControllerDelegate{
    var barcodesarray = [VisionBarcode]()
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
      //  let sv = UIViewController.displaySpinner(onView: self.view)
        for image in images{
            image.resolve { (deneme) in
                let format = VisionBarcodeFormat.all
                let barcodeOptions = VisionBarcodeDetectorOptions(formats: format)
                
                var vision = Vision.vision()
                let barcodeDetector = vision.barcodeDetector(options: barcodeOptions)
                
                let imagevision = VisionImage(image: deneme!)
                
                barcodeDetector.detect(in: imagevision) { features, error in
                    guard error == nil, let features = features, !features.isEmpty else {
                        // ...
                        return
                    }
                    self.barcodesarray = features
                    // ...
                }
                
                for barcode in self.barcodesarray {
                    let corners = barcode.cornerPoints
                    
                    let displayValue = barcode.displayValue
                    let rawValue = barcode.rawValue
                    
                    let valueType = barcode.valueType
                    switch valueType {
                    case .wiFi:
                        let ssid = barcode.wifi!.ssid
                        let password = barcode.wifi!.password
                        let encryptionType = barcode.wifi!.type
                        let resultwifi = "SSID: " + ssid! + " Password: " + password!
                        self.dismiss(animated: true, completion: nil)
                        
                        let alert = UIAlertController(title: "Result", message: resultwifi, preferredStyle: UIAlertController.Style.alert)
                        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                        alert.addAction(okbutton)
                        alert.addAction(UIAlertAction(title: "Share", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                            print("you have pressed the share button")
                            let activityVC = UIActivityViewController(activityItems: [resultwifi], applicationActivities: nil)
                            activityVC.popoverPresentationController?.sourceView = self.view
                            self.present(activityVC, animated: true, completion: nil)
                        }))
                       // UIViewController.removeSpinner(spinner: sv)
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    case .URL:
                        let title = barcode.url!.title
                        let url = barcode.url!.url
                       // self.makealert(title: "Result", message: "URL: " + url!, share: false)
                        let urlresult = "url: " + url!
                        self.dismiss(animated: true, completion: nil)
                        let alert = UIAlertController(title: "Result", message: urlresult, preferredStyle: UIAlertController.Style.alert)
                        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                        alert.addAction(okbutton)
                        alert.addAction(UIAlertAction(title: "Share", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                            print("you have pressed the share button")
                            let activityVC = UIActivityViewController(activityItems: [urlresult], applicationActivities: nil)
                            activityVC.popoverPresentationController?.sourceView = self.view
                            self.present(activityVC, animated: true, completion: nil)
                        }))
                      //  UIViewController.removeSpinner(spinner: sv)
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    default:
                        // See API reference for all supported value types
                        let defaultvalue = barcode.displayValue
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        
                        self.dismiss(animated: true, completion: nil)
                        let alert = UIAlertController(title: "Result", message: defaultvalue, preferredStyle: UIAlertController.Style.alert)
                        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                        alert.addAction(okbutton)
                        alert.addAction(UIAlertAction(title: "Share", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                            print("you have pressed the share button")
                            let activityVC = UIActivityViewController(activityItems: [defaultvalue], applicationActivities: nil)
                            activityVC.popoverPresentationController?.sourceView = self.view
                            self.present(activityVC, animated: true, completion: nil)
                        }))
                    //    UIViewController.removeSpinner(spinner: sv)
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                        
                    }
                }

                
                
                
            }
        }
        //UIViewController.removeSpinner(spinner: sv)
       // self.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        let alert = UIAlertController(title: "Error", message: "You cant scan barcode in video.", preferredStyle: UIAlertController.Style.alert)
        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okbutton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        print("light box")
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func cameratextbutton(_ sender: UIButton) {
        let gallery = GalleryController()
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
    }
    
    
    @IBAction func camerabutton(_ sender: UIButton) {
        let gallery = GalleryController()
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    


}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

