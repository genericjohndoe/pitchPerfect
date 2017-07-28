//
//  RecordSoundsViewController.swift
//  pitchPerfect
//
//  Created by joel johnson on 5/2/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(false)
        // Do any additional setup after loading the view, typically from a nib.
    }
   
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(false)
        audioRecorder.stop()
        let audiosession = AVAudioSession.sharedInstance()
        try! audiosession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder : AVAudioRecorder, successfully flag : Bool){
        if flag {
        performSegue(withIdentifier: "stopRecording", sender:audioRecorder.url)
        }else{
            let controller = UIAlertController()
            controller.title = "Sorry"
            controller.message = "Recording was not successful"
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { action in self.dismiss(animated: true, completion: nil)
            }
            
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(_ record: Bool){
        recordingLabel.text = record ? "Recording in progress" : "Tap to Record"
        stopRecordingButton.isEnabled = record
        recordingButton.isEnabled = !record
    }
}

