//
//  ViewController.swift
//  FightingRounds
//
//  Created by Guido R Carballo G on 9/29/19.
//  Copyright © 2019 Guido R Carballo G. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var bigTimer: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var accumTimer: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var playStopStackView: UIStackView!
    @IBOutlet weak var roundMatchesTV: UITextView!
    
    var clockTimer:Timer!
    
    var roundTimer: Timer!
    var initialTimerT1: Date!
    var currentTimerT2: Date!
    
    var breakTimer: Timer!
    var initialBreakTimerT1: Date!
    var currentBreakTimerT2: Date!
    
    let roundTimerSettings = RoundTimerSettings.shared
    let fightersInfo = MatchingPairs.shared
    
    var round: Int = 1
    
    var player: AVAudioPlayer?
    
    let numberStrFormatter = NumberFormatter()
    
    var alarmProblem: Bool!
    
    var lapsTimeAccumulator: Int = 0
    var lapsTimeDif: Int = 0
    
    var roundTimeSeconds: Int = 0
    var breakTimeSeconds: Int = 0
    let playingAlarmCounter: Int = 3
    var finalCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clockTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
        setTime()
        loadSound()
        
        formatView()
        
        numberStrFormatter.minimumIntegerDigits = 2
        
        let notificationName = Notification.Name("returningToClockView")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadClockView), name: notificationName, object: nil)
        
    }
    
    @objc func reloadClockView() {
        print("Reload ClockView")
        formatView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatView()
        updateMatchesTV()
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }*/
    
    @objc func setTime() {
        
        //print("inside setTime")
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        clockLabel.text = dateFormatter.string(from: date)
        
    }
    
    func loadSound(){
    
        
        do{
            //print("Config player")
            
            let path = Bundle.main.path(forResource: "alarm1.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            player = try AVAudioPlayer(contentsOf: url)
            
            //print("Alarm will play")
            alarmProblem = false
            
        } catch {
            
            alarmProblem = true
            //print("Can't play alarm")
            
        }
        
    }
    
    func formatView() {
        
        roundTimeSeconds = roundTimerSettings.roundMinutes * 60 + roundTimerSettings.roundSeconds
        breakTimeSeconds = roundTimerSettings.breakMin * 60 + roundTimerSettings.breakSec
        
        print("roundTimeSeconds: \(roundTimeSeconds)")
        print("breakTimeSeconds: \(breakTimeSeconds)")
        
    }
    
    @objc func updateTimerLabel() {
        
        currentTimerT2 = Date()
        let timeDif = Int(currentTimerT2.timeIntervalSince(initialTimerT1))
        var minutes = Int(timeDif/60)
        let seconds = timeDif - minutes * 60
        bigTimer.text = numberStrFormatter.string(from: NSNumber(value: minutes))! + ":" + numberStrFormatter.string(from: NSNumber(value: seconds))!
        
        if timeDif <= playingAlarmCounter {
            if !(player?.isPlaying ?? true) {
                if !alarmProblem{
                    //print("playing alarm")
                    player?.volume = 1.0
                    player?.play()
                }
                
            }
        } else if timeDif <= finalCount {
            
            if player?.isPlaying ?? false{
                //print("stop playing")
                player?.stop()
            }
            
            if finalCount == roundTimeSeconds {
                
                lapsTimeAccumulator += (timeDif - lapsTimeDif)
                lapsTimeDif = timeDif
                let hours = Int(lapsTimeAccumulator/3600)
                minutes = Int((lapsTimeAccumulator - (hours * 3600))/60)
                accumTimer.text = numberStrFormatter.string(from: NSNumber(value: hours))! + ":" + numberStrFormatter.string(from: NSNumber(value: minutes))!
                
            }
            
            
        } else {
            lapsTimeDif = 0
            goToBreak()
        }
        
    }
    
    func goToBreak() {
        
        if finalCount == breakTimeSeconds {
            breakTimer.invalidate()
            finalCount = roundTimeSeconds
            initialTimerT1 = Date()
            roundTimer?.invalidate()
            roundTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
        } else {
            round += 1
            updateMatchesTV()
            roundTimer.invalidate()
            finalCount = breakTimeSeconds
            initialTimerT1 = Date()
            breakTimer?.invalidate()
            breakTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
        }
        
    }
    
    func updateMatchesTV() {
        roundMatchesTV.text = "Round \(round)\n\n"
        let fights = fightersInfo.returnRoundMatches(fightRound: round)
        for fight in fights {
            roundMatchesTV.text += fight + "\n"
        }
    }

    @IBAction func startTimer(_ sender: UIButton) {
        
        print("Starting timer")
        
        finalCount = roundTimeSeconds
        initialTimerT1 = Date()
        roundTimer?.invalidate()
        roundTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func resetTimer(_ sender: UIButton) {
        
        print("Stoping timer")
        
        if finalCount == breakTimeSeconds {
            breakTimer?.invalidate()
        } else {
            roundTimer?.invalidate()
        }
        
        if player?.isPlaying ?? false {
            //print("stop playing")
            player?.stop()
        }
        
        if bigTimer.text == "00:00" {
            print("Reseting timer")
            accumTimer.text = "00:00"
            lapsTimeAccumulator = 0
            lapsTimeDif = 0
            round = 1
            updateMatchesTV()
        }
        
        finalCount = roundTimeSeconds
        bigTimer.text = "00:00"
        
    }
    
}

