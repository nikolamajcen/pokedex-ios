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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        changeCaptureState(turnOn: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false
        changeCaptureState(turnOn: false)
    }
    
    private func configureVideoCapture() {
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
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
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
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
        QRCodeFrameView?.layer.borderColor = UIColor.flatMint().cgColor
        QRCodeFrameView?.layer.borderWidth = 2
        view.addSubview(QRCodeFrameView!)
    }
    
    fileprivate func changeCaptureState(turnOn: Bool) {
        if captureSession?.isRunning != turnOn {
            if turnOn == true {
                view.sendSubview(toBack: self.QRCodeFrameView!)
                DispatchQueue.global(qos: .background).async {
                    self.captureSession?.startRunning()
                }
            } else {
                DispatchQueue.global(qos: .background).async {
                    self.captureSession?.stopRunning()
                }
            }
        }
    }
    
    fileprivate func readQRCode(value: String) {
        guard let jsonValue = Mapper<Pokemon>.parseJSONStringIntoDictionary(JSONString: value) else {
            self.showAlert(type: .Failure,
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
        
        let pokemon = Mapper<Pokemon>().map(JSON: jsonValue)
        savePokemonToPokedex(pokemon: pokemon!)
    }
    
    fileprivate func savePokemonToPokedex(pokemon: Pokemon) {
        let manager = DatabaseManager()
        if manager.addPokemon(pokemon: pokemon) == .Success {
            showAlert(type: .Success, title: "Captured \(pokemon.name)!",
                      message: "", image: UIImage(named: pokemon.getListImageName()))
        } else {
            showAlert(type: .Success, title: "\(pokemon.name) already captured!",
                      message: "", image: UIImage(named: pokemon.getListImageName()))
        }
    }
    
    fileprivate func showAlert(type: CaptureStatus, title: String, message: String, image: UIImage!) {
        let appearance = SCLAlertView.SCLAppearance (
            // kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 18)!,
            kWindowWidth: 280.0,
            showCloseButton: false
        )
        let captureAlert = SCLAlertView(appearance: appearance)
        
        captureAlert.addButton("OK") { [unowned self] in
            self.changeCaptureState(turnOn: true)
        }
        
        if type == .Success {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 260, height: 100))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            captureAlert.customSubview = imageView
            captureAlert.showSuccess(title, subTitle: message)
        } else {
            captureAlert.showError(title, subTitle: message)
        }
    }
}

extension PokemonScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        DispatchQueue.global(qos: .background).async {
            self.captureSession!.stopRunning()
            DispatchQueue.main.async(execute: { [unowned self] in
                if let metadataObject = metadataObjects.first {
                    let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
                    
                    if readableObject.type == AVMetadataObjectTypeQRCode {
                        let barCodeObject = self.videoPreviewLayer?
                            .transformedMetadataObject(for: metadataObject as! AVMetadataMachineReadableCodeObject)
                            as! AVMetadataMachineReadableCodeObject
                        
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        self.QRCodeFrameView?.frame = barCodeObject.bounds;
                        self.view.bringSubview(toFront: self.QRCodeFrameView!)
                        
                        if metadataObject.stringValue != nil {
                            self.readQRCode(value: metadataObject.stringValue)
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
