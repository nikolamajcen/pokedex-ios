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
            showAlert(type: .Failure,
                      title: "Scanner Error",
                      message: "You are not able to start QR code scanner.",
                      image: nil)
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession!.canAddOutput(metadataOutput)) {
            captureSession!.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            showAlert(type: .Failure,
                      title: "Scanner Error",
                      message: "You are not able to start QR code scanner.",
                      image: nil)
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
    
    private func changeCaptureState(turnOn turnOn: Bool) {
        if captureSession?.running != turnOn {
            if turnOn == true {
                view.sendSubviewToBack(self.QRCodeFrameView!)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.captureSession?.startRunning()
                })
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.captureSession?.stopRunning()
                })
            }
        }
    }
    
    private func readQRCode(value: String) {
        guard let jsonValue = Mapper<Pokemon>.parseJSONDictionary(value) else {
            showAlert(type: .Failure,
                      title: "Incompatible QR code",
                      message: "Please scan codes from provided site to catch pokemons.",
                      image: nil)
            return
        }
        
        guard let _ = jsonValue["id"] as! Int?, let _ = jsonValue["name"] as! String? else {
            showAlert(type: .Failure,
                      title: "Incompatible QR code",
                      message: "Please scan codes from provided site to catch pokemons.",
                      image: nil)
            return
        }
        
        let pokemon = Mapper<Pokemon>().map(jsonValue)
        savePokemonToPokedex(pokemon!)
    }
    
    private func savePokemonToPokedex(pokemon: Pokemon) {
        let manager = DatabaseManager()
        if manager.addPokemon(pokemon) == .Success {
            showAlert(type: .Success, title: "Captured \(pokemon.name)!",
                      message: "", image: UIImage(named: pokemon.getListImageName()))
        } else {
            showAlert(type: .Success, title: "\(pokemon.name) already captured!",
                      message: "", image: UIImage(named: pokemon.getListImageName()))
        }
    }
    
    private func showAlert(type type: CaptureStatus, title: String, message: String, image: UIImage!) {
        let appearance = SCLAlertView.SCLAppearance (
            kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 18)!,
            kWindowWidth: 280.0,
            showCloseButton: false
        )
        let captureAlert = SCLAlertView(appearance: appearance)
        
        captureAlert.addButton("OK") { [unowned self] in
            self.changeCaptureState(turnOn: true)
        }
        
        if type == .Success {
            let imageView = UIImageView(frame: CGRectMake(0, 0, 260, 100))
            imageView.image = image
            imageView.contentMode = .ScaleAspectFit
            captureAlert.customSubview = imageView
            captureAlert.showSuccess(title, subTitle: message)
        } else {
            captureAlert.showError(title, subTitle: message)
        }
    }
}

extension PokemonScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.captureSession!.stopRunning()
            dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                if let metadataObject = metadataObjects.first {
                    let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
                    
                    if readableObject.type == AVMetadataObjectTypeQRCode {
                        let barCodeObject = self.videoPreviewLayer?
                            .transformedMetadataObjectForMetadataObject(metadataObject as! AVMetadataMachineReadableCodeObject)
                            as! AVMetadataMachineReadableCodeObject
                        
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        self.QRCodeFrameView?.frame = barCodeObject.bounds;
                        self.view.bringSubviewToFront(self.QRCodeFrameView!)
                        
                        if metadataObject.stringValue != nil {
                            self.readQRCode(metadataObject.stringValue)
                        } else {
                            self.showAlert(type: .Failure,
                                title: "Incompatible QR code",
                                message: "Please scan codes from provided site to catch pokemons.",
                                image: nil)
                        }
                    }
                }
            })
        }
    }
}