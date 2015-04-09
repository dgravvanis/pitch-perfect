//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Dimitrios Gravvanis on 4/4/15.
//  Copyright (c) 2015 Dimitrios Gravvanis. All rights reserved.
//


// Import the frameworks
import UIKit
import AVFoundation

// The second view of the app. Plays the recorded audio with added effects.
class PlaySoundsViewController: UIViewController {
    
    // MARK: Global variables
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Initialise the audio player
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        // Must enable rate first to access it
        audioPlayer.enableRate = true
        
        // Initialise the audio engine
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Reset the audio so that we don't have overlaping audio
    func resetAudio(){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }
    
    // Play the audio with variable pitch, range (-2400, 2400)
    func playAudioWithVariablePitch(pitch: Float){
        
        resetAudio()
        
        // Start the player node and attach it to the engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Start the time pitch node and attach it to the engine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Connect the player node to the time pitch node
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        
        // Connect the time pitch node to the output node
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Select the file and start the audio engine
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // Play the audio
        audioPlayerNode.play()
    }
    
    // Play the audio with variable rate, range (0.5, 2)
    func playAudioWithVariableRate(rate: Float){
        
        resetAudio()
        audioPlayer.rate = rate
        audioPlayer.play()
        
        // Play the audio from the beginning
        audioPlayer.currentTime = 0.0
        
    }
    
    // Play the audio at half speed
    @IBAction func playSlowAudio(sender: UIButton) {
        
        playAudioWithVariableRate(0.5)
        
    }
    
    // Play the audio at double speed
    @IBAction func playFastAudio(sender: UIButton) {
        
        playAudioWithVariableRate(2.0)
    }

    // Play the audio with high pitch
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        
    }
    
    // Play the audio with low pitch
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
        
    }
    
    // Stop the audio playback
    @IBAction func stopAudio(sender: UIButton) {
        
        resetAudio()
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
