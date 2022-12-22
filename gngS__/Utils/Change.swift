import Foundation
import UIKit

class Change {
    //MARK: change関数
    
    var pos = DB.shared.selectPositionAll()
    var teams = DB.shared.selectTeamAll()

    func returnPosition(code:String) -> String {
        for position in pos {
            if code == position.code {
                return position.name
            }
        }
        return ""
    }
    
    func returnPosition2(code:String) -> String {
        for postion in pos {
            if code == postion.name {
                return postion.code
            }
        }
        return ""
    }
    
    func returnTeam(code:String) -> String {
        for team in teams {
            if code == team.code {
                return team.name
            }
        }
        return ""
    }
    
    func returnTeam2(code:String) -> String {
        for team in teams {
            if code == team.name {
                return team.code
            }
        }
        return ""
    }
    
    func posRow(code:String) -> Int {
        var row:Int = 0
        
        if code == "社員" {
            row = 0
            return row
        } else if code == "主任" {
            row = 1
            return row
        } else if code == "課長" {
            row = 2
            return row
        } else if code == "次長" {
            row = 3
            return row
        } else if code == "部長" {
            row = 4
            return row
        } else if code == "代表" {
            row = 5
            return row
        }
        return row
    }
    
    func teamRow(code:String) -> Int {
        var rows:Int = 0
        if code == "第1チーム" {
            rows = 0
            return rows
        } else if code == "第2チーム" {
            rows = 1
            return rows
        } else if code == "第3チーム" {
            rows = 2
            return rows
        } else if code == "第4チーム" {
            rows = 3
            return rows
        }
        return rows
    }
    
}
