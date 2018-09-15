//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Vui Nguyen on 8/31/18.
//  Copyright © 2018 Sunfish Empire. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

  var audioRecorder: AVAudioRecorder!

  // MARK: Outlets

  @IBOutlet weak var recordingLabel: UILabel!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var stopRecordingButton: UIButton!

  // MARK: Actions

  @IBAction func recordAudio(_ sender: Any) {
    configureUI(isRecordingState: true)

    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let recordingName = "recordedVoice.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = URL(string: pathArray.joined(separator: "/"))
    print(filePath!)

    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
    try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
    audioRecorder.delegate = self
    audioRecorder.isMeteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
  }

  @IBAction func stopRecording(_ sender: Any) {
    configureUI(isRecordingState: false)
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
  }

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI(isRecordingState: false)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "stopRecording" {
      let playSoundsVC = segue.destination as! PlaySoundsViewController
      let recordedAudioURL = sender as! URL
      playSoundsVC.recordedAudioURL = recordedAudioURL
    }
  }

  // MARK: - Audio Recorder Delegate

  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag {
      performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    } else {
      let alert = UIAlertController(title: "Recording Alert", message: "Recording Was Not Successful",
                                    preferredStyle: .alert)
      self.present(alert, animated: true, completion: nil)
      print("recording was not successful")
    }
  }

  // MARK: - Helper Function
  // sets the values for the recording label, recording button, and stop recording button
  // based on the app state of recording or not
  func configureUI(isRecordingState: Bool = false) -> Void {
    recordingLabel.text = isRecordingState ? "Recording in Progress" : "Tap To Record"
    recordButton.isEnabled = !isRecordingState
    stopRecordingButton.isEnabled = isRecordingState
  }
}

