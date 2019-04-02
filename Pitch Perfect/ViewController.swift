//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Debidutt Prasad on 31/03/2019.
//  Copyright © 2019 Bot Consultancy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        
        configureUI(state: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode:.default,options: [])
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        
        configureUI(state: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender:Any?.self)
        }else{
            print("recording was not successful")
        }
    }
    
    func configureUI(state:Bool){
        if state {
            recordingLabel.text = "Recording in Progress"
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        }else{
            recordingLabel.text = "Tap to Record"
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let viewController = segue.destination as! PlaySoundsViewController
            viewController.recordedAudioURL = audioRecorder.url
        }
    }
}

