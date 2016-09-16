
//
//  ViewController.swift
//  ReadersRecommend
//
//  Created by Olivia Murphy on 9/15/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var captureDevice: AVCaptureDevice!
    var captureDeviceInput: AVCaptureDeviceInput!
    var captureDeviceOutput: AVCaptureMetadataOutput!
    var capturePreviewLayer: AVCaptureVideoPreviewLayer!
    var alertController: UIAlertController!
    
    private var allowedTypes = [AVMetadataObjectTypeUPCECode,
                                AVMetadataObjectTypeCode39Code,
                                AVMetadataObjectTypeCode39Mod43Code,
                                AVMetadataObjectTypeEAN13Code,
                                AVMetadataObjectTypeEAN8Code,
                                AVMetadataObjectTypeCode93Code,
                                AVMetadataObjectTypeCode128Code,
                                AVMetadataObjectTypePDF417Code,
                                AVMetadataObjectTypeQRCode,
                                AVMetadataObjectTypeAztecCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor.blackColor()
        
        captureSession = AVCaptureSession()
        
        do {
            // get the default device and use auto settings
            captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            try captureDevice.lockForConfiguration()
            captureDevice.exposureMode = AVCaptureExposureMode.ContinuousAutoExposure
            captureDevice.whiteBalanceMode = AVCaptureWhiteBalanceMode.ContinuousAutoWhiteBalance
            captureDevice.focusMode = AVCaptureFocusMode.ContinuousAutoFocus
            if captureDevice.hasTorch {
                captureDevice.torchMode = AVCaptureTorchMode.Auto
            }
            captureDevice.unlockForConfiguration()
            
            // add the input/output devices
            captureSession.beginConfiguration()
            captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
            }
            
            // AVCaptureMetadataOutput is how we can determine
            captureDeviceOutput = AVCaptureMetadataOutput()
            captureDeviceOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            if captureSession.canAddOutput(captureDeviceOutput) {
                captureSession.addOutput(captureDeviceOutput)
                captureDeviceOutput.metadataObjectTypes = captureDeviceOutput.availableMetadataObjectTypes
            }
            captureSession.commitConfiguration()
        }
        catch {
            displayAlert("Error", message: "Unable to set up the capture device.")
        }
        
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer.frame = self.view.layer.bounds
        capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(capturePreviewLayer)
        
        //captureSession.startRunning();
        
        //captureSession.startRunning();
    }
    
    func failed() {
        let alertController = UIAlertController(title: "", message:
            "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)

        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if alertController != nil {
            return
        }
        
        if metadataObjects != nil && metadataObjects.count > 0 {
            if let machineReadableCode = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                // get the barcode string
                let type = machineReadableCode.type
                let barcode = machineReadableCode.stringValue
                
                // display the barcode in an alert
                let title = "Barcode"
                let message = "Type: \(type)\nBarcode: \(barcode)"
                displayAlert(title, message: message)
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.alertController = nil
        })
        alertController.addAction(dismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}