//
//  ViewController.swift
//  Loquela
//
//  Created by Daniel Duan on 3/23/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

// AR KIT
import UIKit
import SceneKit
import ARKit

// COREML
import CoreML
import Vision

// TEXT TO SPEECH
import AVFoundation

protocol MyProtocol {
    func createTranslated3DText(englishWord: String, newWord: String, languageCode: String, language: String)
}

class ARViewController: UIViewController, ARSCNViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,MyProtocol {
    
     var delegate: MyProtocol?

    @IBOutlet var sceneView: ARSCNView!
    
    // COREML VARIABLES + AR VARIABLES
    var mostAccuratePrediction = ""
    let serialQueue = DispatchQueue(label: "serialQueue")
    var requests = [VNRequest]()
    var location3D: ARHitTestResult?
    var textNodeParent = SCNNode()

    
    // STOOPID VARIABLES
    var chosenObject = ""
    
    var englishWord = ""
    var translatedWord = ""
    var lanugage = ""
        
    // IMAGEPICKER
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SCENE
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        
        //IMAGE PICKER
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        // VISION
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading Core ML Model Failed.")
        }
        let request = VNCoreMLRequest(model: model, completionHandler: classificationCompletionHandler)
        request.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        requests = [request]
        coreMLLoop()
    }
    
    //MARK: - COREML/VISION METHODS
    func classificationCompletionHandler(request: VNRequest, error: Error?) {
        // Error present
        if error != nil {
            return
        }
        guard let results = request.results else {
            return
        }
        
        let predictions = results[0...1]
            .flatMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:"- %.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        // store the most accurate result
        DispatchQueue.main.async {
            var object = predictions.components(separatedBy: "-")[0]
            object = object.components(separatedBy: ",")[0]
            self.mostAccuratePrediction = object
        }
        
    }
    
    // continuously update CoreMl
    func coreMLLoop() {
        serialQueue.async {
            self.updateML()
            self.coreMLLoop()
        }
    }
    
    func updateML() {
        guard let pixelBuffer: CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage) else {
            return
        }
        
        let ciimage = CIImage(cvPixelBuffer: pixelBuffer!)
        let handler = VNImageRequestHandler(ciImage: ciimage, options: [:])
        do {
            try handler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    //MARK: - ARKIT METHODS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView) {
            
            let results = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = results.first {
                location3D = hitResult
                // delete all previous nodes before creating the new textNode
                sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
                create3DText(at: location3D!, word: mostAccuratePrediction)
                // create the alert pop up
                createAlertView()
            }
            
        }
    }
    
    func create3DText(at hitResult: ARHitTestResult, word wordToCreate: String) {
        
        // CONSTRAINTS
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        // TEXT GEOMETRY
        let textGeometry = SCNText(string: wordToCreate, extrusionDepth: 0.01)
        var font = UIFont(name: "Futura", size: 0.15)
        font = font?.withTraits(traits: .traitBold)
        textGeometry.font = font
        textGeometry.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        textGeometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.2588235294, green: 0.5176470588, blue: 0.9529411765, alpha: 1)
        textGeometry.firstMaterial?.isDoubleSided = true
        textGeometry.chamferRadius = 0.01
        
        
        // NODE
        let (minBound, maxBound) = textGeometry.boundingBox
        let textNode = SCNNode(geometry: textGeometry)
        textNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, Float(textGeometry.extrusionDepth/2))
        textNode.scale = SCNVector3(0.2, 0.2, 0.2)
        
        // PARENT NODE
        textNodeParent.addChildNode(textNode)
        textNodeParent.constraints = [billboardConstraint]
        
        sceneView.scene.rootNode.addChildNode(textNodeParent)
        textNodeParent.position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z
        )
        
        chosenObject = mostAccuratePrediction
    }
    
    func createTranslated3DText(englishWord: String, newWord: String, languageCode: String, language: String) {
        self.translatedWord = newWord
        self.englishWord = englishWord
        self.lanugage = language
        
        // CONSTRAINTS
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        let height = textNodeParent.boundingBox.max.y - textNodeParent.boundingBox.min.y

        // TEXT GEOMETRY
        let textGeometry = SCNText(string: newWord, extrusionDepth: 0.015)
        var font = UIFont(name: "Futura", size: 0.15)
        font = font?.withTraits(traits: .traitBold)
        textGeometry.font = font
        textGeometry.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        textGeometry.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.9450980392, green: 0.3921568627, blue: 0.4352941176, alpha: 1)
        textGeometry.firstMaterial?.isDoubleSided = true


        // NODE
        let (minBound, maxBound) = textGeometry.boundingBox
        let translatedTextNode = SCNNode(geometry: textGeometry)
        translatedTextNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, Float(textGeometry.extrusionDepth/2))
        translatedTextNode.scale = SCNVector3(0.2, 0.2, 0.2)

        // PARENT NODE
        let translatedTextNodeParent = SCNNode()
        translatedTextNodeParent.addChildNode(translatedTextNode)
        translatedTextNodeParent.constraints = [billboardConstraint]

        sceneView.scene.rootNode.addChildNode(translatedTextNodeParent)
        translatedTextNodeParent.position = SCNVector3(
            textNodeParent.worldPosition.x,
            (textNodeParent.worldPosition.y + height),
            textNodeParent.worldPosition.z
        )
        
        // SPEAK
        let utterance = AVSpeechUtterance(string: newWord)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
        createDataModel(enWord: englishWord, trWord: newWord, lan: language, cd: languageCode)
        
    }
    
    
    func createDataModel(enWord: String, trWord: String, lan: String, cd: String) {
        let newWordFlashcard = WordFlashcard()
        newWordFlashcard.englishWord = enWord
        newWordFlashcard.translatedWord = trWord
        newWordFlashcard.languageOfWord = lan
        newWordFlashcard.languageCode = cd

        let targetCode = cd

        //TODO: send data to tab view controller
        let navController = tabBarController!.viewControllers![1] as! UINavigationController
        let vc = navController.topViewController as! LibraryCollectionCollectionViewController

        // appending specific wordFlashCard
        if targetCode == "ar" {
            vc.arabicWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "cs" {
            vc.czechWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "da" {
            vc.danishWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "de" {
            vc.germanWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "el" {
            vc.greekWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "es" {
            vc.spanishWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "fi" {
            vc.finnishWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "fr" {
            vc.frenchWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "he" {
            vc.hebrewWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "hi" {
            vc.hindiWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "hu" {
            vc.hungarianWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "id" {
            vc.indoneisanWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "it" {
            vc.italianWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "ja" {
            vc.japaneseWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "ko" {
            vc.koreanWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "nl" {
            vc.dutchWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "no" {
            vc.norwegianWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "pl" {
            vc.polishWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "pt" {
            vc.portugeseWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "ro" {
            vc.romanianWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "ru" {
            vc.russianWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "sk" {
            vc.slovakWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "sv" {
            vc.swedishWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "th" {
            vc.thaiWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "tr" {
            vc.turkishWordsArray.append(newWordFlashcard)
        }
        else if targetCode == "zh-CN" {
            vc.chineseWordsArray.append(newWordFlashcard)
        }
    }
    
    //MARK: - Pop Up
    func createAlertView() {
        performSegue(withIdentifier: "goToPopup", sender: self)
    }
    
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == "goToPopup" {
            
            let destination = segue.destination as! PopUpViewController
            destination.delegate = self
            destination.objectName = mostAccuratePrediction
        }
     }
 
    
    //MARK: - SETUP METHODS
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

extension UIFont {
    // Based on: https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad
    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
}


