//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Dimitrios Gravvanis on 1/4/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//

// Import the frameworks
import UIKit
import AVFoundation

// The first view of the app. Records the audio and stores it. Passes the audio to the second view.
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    // MARK: Outlets
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: Global variables
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Initialise the starting view
        readyLayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Set the starting buttons and message
    func readyLayout(){
        
        stopButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = "Tap to Record"
        
    }
    
    // Set the recording buttons and message
    func recordingLayout(){
        
        recordButton.enabled = false
        recordingInProgress.text = "recording in progress"
        stopButton.hidden = false
        
    }
    
    // Record the audio
    @IBAction func recordAudio(sender: UIButton) {
     
        recordingLayout()
        
        // Get the file path to the documents directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        // Get the current datetime
        let currentDateTime = NSDate()
        
        // Set the datetime format
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        // Set the name for the audio file
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        
        // Set the filepath
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Start the audio session. Set the category (play and record)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Start the audio recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        
        // Create audio file and prepare for recording
        audioRecorder.prepareToRecord()
        
        // Start recording
        audioRecorder.record()
        
        println("recording")
    }

    // Called by the system when a recording is stopped or has finished due to reaching its time limit.
    // In order to use it add AVAudioRecorderDelegate to class declaration and audioRecorder.delegate = self.
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if flag{
            
            // Save audio file
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            // Perform segue and pass recorderAudio object
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            
            println("Recording was not succesful")
            readyLayout()
        }
        
    }
    
    // Called by the system just before a segue is perfomed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "stopRecording"){
            
            // Access PlaySoundsViewController as playSoundsVC
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            // Get data from object
            let data = sender as! RecordedAudio
            
            // Pass data to PlaySoundsViewController
            playSoundsVC.receivedAudio = data
        }
    }

    // Stop the recording.
    @IBAction func stopRecording(sender: UIButton) {
        
        // Stop recording
        audioRecorder.stop()
        
        // Deactivating the audio session
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

