//
//  SimpleCameraController.swift
//  SimpleCamera
//
//  Created by Simon Ng on 16/10/2019.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class SimpleCameraController: UIViewController {

    @IBOutlet var cameraButton:UIButton!
    
    let captureSession = AVCaptureSession()
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice!
    var stillImageOutput: AVCapturePhotoOutput!
    var stillImage: UIImage?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var toggleCameraGestureRecognizer = UISwipeGestureRecognizer()
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action methods
    
    @IBAction func capture(sender: UIButton) {
        
        // Set photo
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    // MARK: - Segues
    
    @IBAction func unwindToCameraView(segue: UIStoryboardSegue) {
    
    }
    
    private func configure() {
        // Default capture session by high resolution
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        // Use front facing camera to take photos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        for device in deviceDiscoverySession.devices {
            if device.position == .back {
                backFacingCamera = device
            } else if device.position == .front{
                frontFacingCamera = device
            }
        }
        
        currentDevice = backFacingCamera
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else { return }
        
        // Configure capture still image to output session
        stillImageOutput = AVCapturePhotoOutput()
        
        // Configure input and output session
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(stillImageOutput)
        
        // Provide camera to preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        // Move camera button to the front
        view.bringSubviewToFront(cameraButton)
        captureSession.startRunning()
        
        // Switch camera recognizer
        toggleCameraGestureRecognizer.direction = .up
        toggleCameraGestureRecognizer.addTarget(self, action: #selector(toggleCamera))
        view.addGestureRecognizer(toggleCameraGestureRecognizer)
        
        // ZoomIn the recognizer
        zoomInGestureRecognizer.direction = .right
        zoomInGestureRecognizer.addTarget(self, action: #selector(zoomIn))
        view.addGestureRecognizer(zoomInGestureRecognizer)
        
        // ZoomOut the recognizer
        zoomOutGestureRecognizer.direction = .left
        zoomOutGestureRecognizer.addTarget(self, action: #selector(zoomOut))
        view.addGestureRecognizer(zoomOutGestureRecognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue.destinationViewController to get new view controller
        // Send selected objects to new view controller
        if segue.identifier == "showPhoto" {
            let photoViewController = segue.destination as! PhotoViewController
            photoViewController.image = stillImage
        }
    }
    
    @objc func toggleCamera() {
        captureSession.beginConfiguration()
        
        // Change device according to current camera
        guard let newDevice = (currentDevice?.position == AVCaptureDevice.Position.back) ? frontFacingCamera : backFacingCamera else { return }
        
        // Delete all input from session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        // Change to new input
        let cameraInput: AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice)
        } catch {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentDevice = newDevice
        captureSession.commitConfiguration()
    }
    
    @objc func zoomIn() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor < 5.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func zoomOut() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
}
extension SimpleCameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return
        }
        
        // Get photo from picture representation
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        stillImage = UIImage(data: imageData)
        performSegue(withIdentifier: "showPhoto", sender: self)
    }
}
