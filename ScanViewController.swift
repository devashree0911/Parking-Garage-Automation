import UIKit
import AVFoundation
class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
   //MARK: - Variables
   var captureSession : AVCaptureSession!
   var previewLayer : AVCaptureVideoPreviewLayer!
   var qrCodeFrameView:UIView?
   var codeString : String?
    override func viewDidLoad() {
       super.viewDidLoad()
       captureSession = AVCaptureSession()
       guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
       let videoInput: AVCaptureDeviceInput
       do {
           videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
       } catch {
           return
       }
       if (captureSession.canAddInput(videoInput)) {
                  captureSession.addInput(videoInput)
              } else {
                  failed()
                  return
              }
       let metadataOutput = AVCaptureMetadataOutput()
              if (captureSession.canAddOutput(metadataOutput)) {
                  captureSession.addOutput(metadataOutput)
                  metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                  metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
              } else {
                  failed()
                  return
              }
       previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
       previewLayer.frame = view.layer.bounds
       previewLayer.videoGravity = .resizeAspectFill
       view.layer.addSublayer(previewLayer)
       print("here")
       captureSession.startRunning()
       qrFrameSetup()
   } 
   override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          if (captureSession?.isRunning == false) {
              captureSession.startRunning()
          }
      } 
      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          if (captureSession?.isRunning == true) {
              captureSession.stopRunning()
          }
      }
//MARK: - Function
 func failed() {
     let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
     ac.addAction(UIAlertAction(title: "OK", style: .default))
     present(ac, animated: true)
     captureSession = nil
 }
  //MARK: - Delegate function
      func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
          captureSession.stopRunning()
          if let metadataObject = metadataObjects.first {
              guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
              let barCodeObject = previewLayer?.transformedMetadataObject(for: readableObject)
              qrCodeFrameView?.frame = barCodeObject!.bounds
              guard let stringValue = readableObject.stringValue else { return }
              AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
              found(code: stringValue)
          }          
          dismiss(animated: true)
      }
   func found(code: String){       
       print(code)
       codeString = code
       performSegue(withIdentifier: "goToGotSlot", sender: self)       
   }   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "goToGotSlot"{
           let destinationVC = segue.destination as! ParkViewController
        destinationVC.slotString = codeString           
       }
   }  
    func qrFrameSetup() {
           // Initialize QR Code Frame to highlight the QR code
           qrCodeFrameView = UIView()           
           if let qrCodeFrameView = qrCodeFrameView {
               qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
               qrCodeFrameView.layer.borderWidth = 4
               qrCodeFrameView.frame = view.layer.bounds
               view.addSubview(qrCodeFrameView)
               view.bringSubviewToFront(qrCodeFrameView)
           }
       }       
       override var prefersStatusBarHidden: Bool {
           return true
       }      
       override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .portrait
       }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           let touchPoint = touches.first! as UITouch
           let screenSize = previewLayer.bounds.size
           let focusPoint = CGPoint(x: touchPoint.location(in: view).y / screenSize.height, y: 1.0 - touchPoint.location(in: view).x / screenSize.width)
           if let device = AVCaptureDevice.default(for: .video) {
               do {
                   try device.lockForConfiguration()
                   if device.isFocusPointOfInterestSupported {
                       device.focusPointOfInterest = focusPoint
                       device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                   }
                   if device.isExposurePointOfInterestSupported {
                       device.exposurePointOfInterest = focusPoint
                       device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                   }
                   device.unlockForConfiguration()                   
               } catch {
                   // Handle errors here
               }
           }
       }
   }
