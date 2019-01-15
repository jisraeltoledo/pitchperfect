//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Alfonso Balbuena on 27/09/18.
//  Copyright © 2018 Vanglar. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate{

  @IBOutlet weak var stopRecordButton: UIButton!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var RecordingLabel: UILabel!
  var audioRecorder : AVAudioRecorder!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    stopRecordButton.isEnabled = false
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  @IBAction func recordAudio(_ sender: Any) {
    RecordingLabel.text = "Recording in progress"
    stopRecordButton.isEnabled = true
    recordButton.isEnabled = false
 
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
    let recordingName = "recordedVoice.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = URL(string: pathArray.joined(separator: "/"))
    print(filePath!)
    
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
    
    try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
    audioRecorder.delegate = self
    audioRecorder.isMeteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
  }
  @IBAction func stopRecording(_ sender: Any) {
    stopRecordButton.isEnabled = false
    recordButton.isEnabled = true
    RecordingLabel.text = "Tap to record"
    audioRecorder.stop()
    let audioSesssion = AVAudioSession.sharedInstance()
    try! audioSesssion.setActive(false)
  }
  
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag {
      performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    }
    else{
      print ("recording was not succsesful")
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("segue",segue.identifier!)
    if segue.identifier == "stopRecording"{
      let playSoundsVC = segue.destination as! PlaySoundsViewController
      let recordedAudioURL = sender as! URL
      print("recordedAudioURL",recordedAudioURL)
      playSoundsVC.recordedAudioURL = recordedAudioURL
    }
  }
}

