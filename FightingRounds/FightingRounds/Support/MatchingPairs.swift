//
//  MatchingPairs.swift
//  FightingRounds
//
//  Created by Guido Roberto Carballo Guerrero on 6/7/20.
//  Copyright © 2020 Guido R Carballo G. All rights reserved.
//

import Foundation

class MatchingPairs {
    
    static let shared = MatchingPairs()
    
    private var peopleFighting: Int = 2
    private var fighterNames: [String] = ["Rickson", "Zulu"]
    
    func returnRoundMatches(fightRound: Int) -> [String]{
        
        let even: Bool
        let maxNumOfRounds: Int
        var round: Int
        
        if peopleFighting % 2 != 0 {
            even = false
            maxNumOfRounds = peopleFighting
        } else {
            even = true
            maxNumOfRounds = peopleFighting - 1
        }
        
        print("fightRound: \(fightRound)")
        print("maxNumOfRounds: \(maxNumOfRounds)")
        
        if fightRound > maxNumOfRounds {
            round = fightRound % maxNumOfRounds
            if round == 0 {
                round = maxNumOfRounds
            }
        } else {
            round = fightRound
        }
        
        print("round: \(round)")
        
        var left: Int
        var right: Int

        var maxPosition: Int
        var tempRight: Int
        
        var fightingMatches : [String] = []
        
        for j in 1...peopleFighting{
            
            left = j
            right = 0
            
            if even {
                
                if j == 1 {
                    
                    right = round+1
                    
                } else {
                    
                    maxPosition = (j * 2) - 2
                    
                    if maxPosition > maxNumOfRounds {
                        maxPosition -= maxNumOfRounds
                    }
                    
                    if j-1 == round {
                        right = 1
                    } else if maxPosition == round {
                        right = peopleFighting
                    } else {
                        tempRight = (round) - (j-2) // 1 - (3-2) = 0, 1 - (4-2) = -1, 3 - (2-2) = 3, 5 - (3-2) = 4, 7 - (4-2) = 5
                        if round >= j { // 2 - 3, 3 - 3, 4 - 4, 5 - 5, 6 - 6 -> j
                            right = tempRight
                        } else {
                            right = peopleFighting + (tempRight - 1) // (0+1) - (3-1) = -1, (1+1) - (3-1) = 0
                        }
                    }
                }
                
            } else {
                if round == j {
                    right = 0
                } else if round-1 == j && j > 1 {
                    right = 1
                } else {
                    
                    maxPosition = (j * 2) // 1 - 2, 2 - 4, 3 - 6
                    
                    if maxPosition > maxNumOfRounds {
                        maxPosition -= maxNumOfRounds
                    }
                    
                    if round == maxPosition{
                        right = peopleFighting
                    } else {
                        
                        tempRight = round - j
                        
                        if round >= j+2 { // 1 - 3, 2 - 5, 3 - 5, 4 - 6, 5 - 7 -> j + 2
                            right = tempRight
                        } else {
                            right = peopleFighting + tempRight // (0+1) - (3-1) = -1, (1+1) - (3-1) = 0
                        }
                    }
                }
            }
            
            if even && j < peopleFighting {
                if right > left {
                    fightingMatches.append("\(returnName(at: left)) vs \(returnName(at: right))")
                }
            } else {
                if j == round {
                    fightingMatches.append("\(returnName(at: left)) resting")
                } else if right > left {
                    fightingMatches.append("\(returnName(at: left)) vs \(returnName(at: right))")
                }
            }
        }
        
        return fightingMatches
    }
    
    func setFighterNames(names: [String]) {
        
        fighterNames = []
        
        for name in names {
            fighterNames.append(name)
        }
        
    }
    
    func setNumberOf(_ fighters: Int) {
        if fighters < 2 {
            peopleFighting = 2
        } else {
            peopleFighting = fighters
        }
        
        if fighterNames.count < fighters {
            
            for i in fighterNames.count ..< fighters {
                fighterNames.append("\(i+1)")
            }
        }
    }
    
    func getNumberOffighters() -> Int {
        return peopleFighting
    }
    
    private func returnName(at position: Int) -> String {
        
        if position-1 < fighterNames.count {
            return fighterNames[position-1]
        } else {
            return "\(position)"
        }
    }
    
    func returnAllFighterNames() -> [String] {
        return fighterNames
    }
}
