//
//  ViewController.swift
//  Scribe
//
//  Created by c.uraga on 2016/09/13.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit
import Speech
import AVFoundation


class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    var audioPlayer: AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
        audioPlayer.delegate = self
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        activitySpinner.stopAnimating()
        activitySpinner.isHidden = true
    }
    func requestSpeechAuth(){
        SFSpeechRecognizer.requestAuthorization {authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                if let path = Bundle.main.url(forResource: "carly", withExtension: "mp3") {
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        self.audioPlayer = sound
                        sound.play()
                        
                    } catch {
                        print("error")
                    }
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recognizer?.recognitionTask(with: request) {(result, error) in
                        if let error = error {
                            print("There was a problem: \(error)")
                        }
                        else {
                            self.textView.text = result?.bestTranscription.formattedString
                        }
                    }
                
                }
                
            }
        }
    }

    
    @IBAction func playAudio(_ sender: AnyObject) {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        requestSpeechAuth()
    }
    
    
    
}

