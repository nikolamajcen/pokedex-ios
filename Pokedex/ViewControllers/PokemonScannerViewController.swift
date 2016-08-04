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
import SCLAlertView

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
        changeCaptureState(turnOn: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        tabBarController?.tabBar.hidden = false
        changeCaptureState(turnOn: false)
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
            showAlert(type: CaptureStatus.Failure,
                      title: "Scanner Error",
                      message: "You are not able to start QR code scanner.")
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession!.canAddOutput(metadataOutput)) {
            captureSession!.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            showAlert(type: CaptureStatus.Failure,
                      title: "Scanner Error",
                      message: "You are not able to start QR code scanner.")
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
            showAlert(type: CaptureStatus.Failure,
                      title: "Incompatible QR code",
                      message: "Please scan codes from provided site to catch pokemons.")
            return
        }
        
        guard let _ = jsonValue["id"] as! Int?, let _ = jsonValue["name"] as! String? else {
            showAlert(type: CaptureStatus.Failure,
                      title: "Incompatible QR code",
                      message: "Please scan codes from provided site to catch pokemons.")
            return
        }
        
        let pokemon = Mapper<Pokemon>().map(jsonValue)
        showAlert(type: CaptureStatus.Success,
                  title: "Captured \(pokemon!.name!)",
                  message: "\(pokemon!.name!) is now available in Pokedex.")
    }
    
    private func showAlert(type type: CaptureStatus, title: String, message: String) {
        let appearance = SCLAlertView.SCLAppearance (showCloseButton: false)
        let captureAlert = SCLAlertView(appearance: appearance)
        
        captureAlert.addButton("OK") {
            self.changeCaptureState(turnOn: true)
        }
        
        if type == CaptureStatus.Success {
            captureAlert.showSuccess(title, subTitle: message)
        } else {
            captureAlert.showError(title, subTitle: message)
        }
    }
    
    private func changeCaptureState(turnOn turnOn: Bool) {
        if captureSession?.running != turnOn {
            dispatch_async(dispatch_get_main_queue(), {
                if turnOn == true {
                    self.view.sendSubviewToBack(self.QRCodeFrameView!)
                    self.captureSession?.startRunning()
                } else {
                    self.captureSession?.stopRunning()
                }
            })
        }
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
                    showAlert(type: CaptureStatus.Failure,
                              title: "Incompatible QR code",
                              message: "Please scan codes from provided site to catch pokemons.")
                }
            }
        }
    }
}