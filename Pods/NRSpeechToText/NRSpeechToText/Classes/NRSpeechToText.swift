//
//  NRSpeechToText.swift
//  NRSpeechToText
//
//  Created by Naveen Rana on 19/03/18.
//

import Foundation
import Speech


@available(iOS 10.0, *)
open class NRSpeechToText {
    
   open static let shared = NRSpeechToText()
    //Private variables
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!//A supported speech recognizer.A speech recognizer recognizes only one language. When you use the default initializer, you get a speech recognizer for the device's current locale, if a recognizer is supported for that locale.
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?//A request to recognize speech provided in audio buffers.For example, to recognize audio from the device's microphone, create a request using the SFSpeechAudioBufferRecognitionRequest class and provide a sequence of in-memory audio buffers.
    private var recognitionTask: SFSpeechRecognitionTask?//A speech recognition task that lets you monitor recognition progress.A speech recognizer returns an SFSpeechRecognitionTask object when it begins recognition. You can use the task object to monitor the progress of speech recognition and cancel it, if necessary.
    private let audioEngine = AVAudioEngine() //The AVAudioEngine class defines a group of connected AVAudioNode objects, known as audio nodes. You use audio nodes to generate audio signals, process them, and perform audio input and output.
    
   public var isRunning: Bool { // check if audio engine is still running.
        get {
            if audioEngine.isRunning {
                return true
            }
            return false
        }
    }
    
   public func stop() { // Stop the audio engine and recognitionRequest end the audio session
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            
        }
        
    }
    
    //Asks the user to grant your app permission to perform speech recognition.
    
   open func authorizePermission(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            
            switch authStatus {
            case .authorized:
                completion(true)
                
            case .denied:
                completion(false)
                print("User denied access to speech recognition")
                
            case .restricted:
                completion(false)
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                completion(false)
                print("Speech recognition not yet authorized")
                
            }
            
        }
    
    }
    //DAddy
    
    public func startRecording(handler: @escaping (_ result: String?, _ isFinal: Bool, _ error: Error?) -> Void) {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false
            
            if result != nil {
                
                isFinal = (result?.isFinal)!
                handler(result?.bestTranscription.formattedString, isFinal, nil)
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                handler(nil, isFinal, error)
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        
    }
}
