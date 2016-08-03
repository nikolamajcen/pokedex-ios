//
//  PokemonScannerViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 03/08/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import AVFoundation
import ObjectMapper

class PokemonScannerViewController: UIViewController {

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var QRCodeFrameView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideoCapture()
        initializeVideoPreviewLayer()
        initializeQRCodeFrame()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.hidden = true
        if captureSession?.running == false {
            captureSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        tabBarController?.tabBar.hidden = false
        if captureSession?.running == true {
            captureSession?.stopRunning()
        }
    }
    
    private func configureVideoCapture() {
        view.backgroundColor = UIColor.blackColor()
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession!.canAddInput(videoInput)) {
            captureSession!.addInput(videoInput)
        } else {
            showAlert(title: "Scanner Error", message: "You are not able to start QR code scanner.")
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession!.canAddOutput(metadataOutput)) {
            captureSession!.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            showAlert(title: "Scanner Error", message: "You are not able to start QR code scanner.")
            return
        }
    }
    
    private func initializeVideoPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!);
        videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill;
        videoPreviewLayer!.frame = view.layer.bounds;
        view.layer.addSublayer(videoPreviewLayer!);
    }
    
    private func initializeQRCodeFrame() {
        QRCodeFrameView = UIView()
        QRCodeFrameView?.layer.borderColor = UIColor.flatMintColor().CGColor
        QRCodeFrameView?.layer.borderWidth = 2
        view.addSubview(QRCodeFrameView!)
    }
    
    private func readQRCode(value: String) {
        guard let jsonValue = Mapper<Pokemon>.parseJSONDictionary(value) else {
            showAlert(title: "QR Code Error",
                      message: "Incompatible QR code. Please scan codes from provided site to catch pokemons")
            return
        }
        
        guard let _ = jsonValue["id"] as! Int?, let _ = jsonValue["name"] as! String? else {
            showAlert(title: "QR Code Error",
                      message: "Incompatible QR code. Please scan codes from provided site to catch pokemons")
            return
        }
        
        let pokemon = Mapper<Pokemon>().map(jsonValue)
        showCaptureDetails(pokemon!)
    }
    
    private func showCaptureDetails(pokemon: Pokemon) {
        print("Captured \(pokemon.name!)")
    }
    
    private func showAlert(title title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.view.sendSubviewToBack(self.QRCodeFrameView!)
            if self.captureSession?.running == false {
                self.captureSession?.startRunning()
            }
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension PokemonScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession!.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
            
            if readableObject.type == AVMetadataObjectTypeQRCode {
                let barCodeObject = videoPreviewLayer?
                    .transformedMetadataObjectForMetadataObject(metadataObject as! AVMetadataMachineReadableCodeObject)
                        as! AVMetadataMachineReadableCodeObject
                
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                QRCodeFrameView?.frame = barCodeObject.bounds;
                view.bringSubviewToFront(QRCodeFrameView!)
                
                if metadataObject.stringValue != nil {
                    readQRCode(metadataObject.stringValue)
                } else {
                    showAlert(title: "QR Code Error",
                              message: "Incompatible QR code. Please scan codes from provided site to catch pokemons")
                }
            }
        }
    }
}