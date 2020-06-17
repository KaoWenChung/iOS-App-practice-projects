//
//  SimpleVideoCamController.swift
//  SimpleVideoCam
//
//  Created by Simon Ng on 17/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class SimpleVideoCamController: UIViewController {

    @IBOutlet var cameraButton:UIButton!
    let captureSession = AVCaptureSession()
    var currentDevice: AVCaptureDevice!
    var videoFileOutput: AVCaptureMovieFileOutput!
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var isRecording = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action methods
    
    @IBAction func unwindToCamera(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func capture(sender: AnyObject) {
        
        if !isRecording {
            isRecording = true
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: { () -> Void in
                self.cameraButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }, completion: nil)
            
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = URL(fileURLWithPath: outputPath)
            videoFileOutput?.startRecording(to: outputFileURL, recordingDelegate: self)
        } else {
            isRecording = true
            
            UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: { () -> Void in
                self.cameraButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
            cameraButton.layer.removeAllAnimations()
            videoFileOutput?.stopRecording()
        }
    }

    private func configure() {
        // Default session by high resolution
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // Use back camera to take video
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        currentDevice = device
        
        // Get input source
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else { return }
        
        // Set session of video capture
        videoFileOutput = AVCaptureMovieFileOutput()
        
        // Set session of input and output
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(videoFileOutput)
        
        // Provide camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        // Take camera button to the front
        view.bringSubviewToFront(cameraButton)
        captureSession.startRunning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playVideo" {
            let videoPlayerViewController = segue.destination as! AVPlayerViewController
            let videoFileURL = sender as! URL
            videoPlayerViewController.player = AVPlayer(url: videoFileURL)
        }
    }
}

extension SimpleVideoCamController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            print(error ?? "")
            return
        }
        
        performSegue(withIdentifier: "playVideo", sender: outputFileURL)
    }
}


