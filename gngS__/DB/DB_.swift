import Foundation
import SQLite3


class DB {
    
    static let shared = DB()
    let dbFile = "db.sqlite"
    var db: OpaquePointer? = nil
    
    private init() {
        db = openDatabase()
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbFile)
        print(fileURL)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("DataBaseOpen 失敗")
            return nil
        } else {
            print("DataBaseOpen 成功")
            return db
        }
    }
    
    
    //MARK: CREATE
    
    //login/tbl
    func createLoginTbl() {
        let createSql = """
        CREATE TABLE IF NOT EXISTS login_tbl (EMPLOYEE_NUM TEXT NOT NULL PRIMARY KEY, EMPLOYEE_ID TEXT NOT NULL UNIQUE, EMPLOYEE_PW TEXT NOT NULL, LAST_LOGIN TEXT NULL);
"""
        var createStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (createSql as NSString).utf8String, -1, &createStmt, nil) != SQLITE_OK {
            print("create error: \(DBErrorMsg(db))")
            return
        }
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            print ("create step 失敗 \(DBErrorMsg(db))")
            sqlite3_finalize(createStmt)
            return
        }
            sqlite3_finalize(createStmt)
    }
    
    //employee_tbl
    func createEmployeeTbl() {
        let createSql = """
        CREATE TABLE IF NOT EXISTS employee_tbl (EMPLOYEE_NUM TEXT NOT NULL PRIMARY KEY, EMPLOYEE_ID TEXT NOT NULL UNIQUE, EMPLOYEE_PW TEXT NOT NULL, EMPLOYEE_KANJI TEXT NOT NULL, EMPLOYEE_KANA TEXT NOT NULL, EMPLOYEE_ENG TEXT NOT NULL, TEL TEXT NOT NULL, GENDER INTEGER NOT NULL, POSITION TEXT NOT NULL, TEAM TEXT NOT NULL, AGREE INTEGER NOT NULL, MEGAZINE INTEGER NOT NULL, MEMO TEXT NULL, REGISTER_DATE TEXT NOT NULL, CHANGE_DATE TEXT NULL);
        """
        
        var createStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createSql, -1, &createStmt, nil) != SQLITE_OK {
            print("create_emp error: \(DBErrorMsg(db))")
            return
        }
        
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            print("create_emp step error: \(DBErrorMsg(db))")
            sqlite3_finalize(createStmt)
            return
        }
        sqlite3_finalize(createStmt)
    }
    
    //position_tbl
    func createPosition() {
        let createSql = """
        CREATE TABLE IF NOT EXISTS position_tbl (POSITION_CODE TEXT NOT NULL PRIMARY KEY,POSITION_NAME TEXT NOT NULL);
        """
        
        var createStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createSql, -1, &createStmt, nil) != SQLITE_OK {
            print("create_position error: \(DBErrorMsg(db))")
            return
        }
        
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            print("create_position step error: \(DBErrorMsg(db))")
            sqlite3_finalize(createStmt)
            return
        }
        sqlite3_finalize(createStmt)
    }
    
    //team_tbl
    func createTeam() {
        let createSql = """
        CREATE TABLE IF NOT EXISTS team_tbl (TEAM_CODE TEXT NOT NULL PRIMARY KEY,TEAM_NAME TEXT NOT NULL);
        """
        
        var createStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createSql, -1, &createStmt, nil) != SQLITE_OK {
            print("create_team error: \(DBErrorMsg(db))")
            return
        }
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            print("create_team step error: \(DBErrorMsg(db))")
            return
        }
        sqlite3_finalize(createStmt)
    }
    
    
    
    
    //MARK: INSERT
    
    //login
    func insertLogin(login:[Login]) {
        let insertSql = """
        INSERT INTO login_tbl (EMPLOYEE_NUM, EMPLOYEE_ID, EMPLOYEE_PW, LAST_LOGIN) VALUES (?, ?, ?, ?);
""";
        var insertStmt:OpaquePointer? = nil
        
        for data in login {
            if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
                print("insert error: \(DBErrorMsg(db))")
                return
            }
            sqlite3_bind_text(insertStmt, 1, (data.EmployeeNum as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 2, (data.EmployeeId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 3, (data.EmployeePw as NSString).utf8String, -1, nil)
            
            if data.LastLogin == "" {
                sqlite3_bind_null(insertStmt, 4)
            } else {
                sqlite3_bind_text(insertStmt, 4, (data.LastLogin as NSString).utf8String, -1, nil)
            }
            
            
            if sqlite3_step(insertStmt) != SQLITE_DONE {
                //print("insert step 失敗 \(DBErrorMsg(db))")
                sqlite3_finalize(insertStmt)
                return
            }
            sqlite3_finalize(insertStmt)
        }
        return
    }
    
    func insertLogin2(login:[Login]) {
        let insertSql = """
        INSERT INTO login_tbl (EMPLOYEE_NUM, EMPLOYEE_ID, EMPLOYEE_PW, LAST_LOGIN) VALUES ('\(AutoNum2(finalCount: "SELECT COUNT(*) FROM login_tbl"))', ?, ?, ?);
""";
        var insertStmt:OpaquePointer? = nil
        
        for data in login {
            if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
                print("insert error: \(DBErrorMsg(db))")
                return
            }
            
            sqlite3_bind_text(insertStmt, 1, (data.EmployeeId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 2, (data.EmployeePw as NSString).utf8String, -1, nil)
            
            if data.LastLogin == "" {
                sqlite3_bind_null(insertStmt, 3)
            } else {
                sqlite3_bind_text(insertStmt, 3, (data.LastLogin as NSString).utf8String, -1, nil)
            }
            
            if sqlite3_step(insertStmt) != SQLITE_DONE {
                print("insert step 失敗 \(DBErrorMsg(db))")
                sqlite3_finalize(insertStmt)
                return
            }
            sqlite3_finalize(insertStmt)
        }
        return
    }
    
    
    //employee
    func insertEmployee(employee:[Employee]) {
        //var empNum = AutoNum(finalCount: "SELECT COUNT(*) FROM employee_tbl")
        let insertSql = """
        INSERT INTO employee_tbl
        (EMPLOYEE_NUM, EMPLOYEE_ID, EMPLOYEE_PW, EMPLOYEE_KANJI, EMPLOYEE_KANA, EMPLOYEE_ENG, TEL, GENDER, POSITION, TEAM, AGREE, MEGAZINE, MEMO, REGISTER_DATE, CHANGE_DATE) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """;
        
        for data in employee {
            var insertStmt:OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, insertSql, -1, &insertStmt, nil) != SQLITE_OK {
                print("insert_emp error: \(DBErrorMsg(db))")
                return
            }
            
//            if data.EmployeeNum.isEmpty {
//                data.EmployeeNum = empNum
//               // empNum = String(Int(empNum)! + 1)
//            } else {
            sqlite3_bind_text(insertStmt, 1, (data.EmployeeNum as NSString).utf8String, -1, nil)
            //}
            sqlite3_bind_text(insertStmt, 2, (data.EmployeeId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 3, (data.EmployeePw as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 4, (data.EmployeeKanji as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 5, (data.EmployeeKana as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 6, (data.EmployeeEng as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 7, (data.Tel as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStmt, 8, Int32(data.Gender))
            sqlite3_bind_text(insertStmt, 9, (data.Position as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 10, (data.Team as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStmt, 11, Int32(data.Agree))
            sqlite3_bind_int(insertStmt, 12, Int32(data.Megazine))
         
            if data.Memo == "" {
                sqlite3_bind_null(insertStmt, 13)
            } else {
                sqlite3_bind_text(insertStmt, 13, (data.Memo as NSString).utf8String, -1, nil)
            }
            
            if data.RegisterDate == "" {
                sqlite3_bind_null(insertStmt, 14)
            } else {
                sqlite3_bind_text(insertStmt, 14, (data.RegisterDate as NSString).utf8String, -1, nil)
            }
                             
            if sqlite3_step(insertStmt) != SQLITE_DONE {
                //print ("insert_emp step error: \(DBErrorMsg(db))")
                sqlite3_finalize(insertStmt)
                return
            }
            sqlite3_finalize(insertStmt)
        }
        return
    }
    
    func insertEmployee2(employee:[Employee]) {
        
        let insertSql = """
        INSERT INTO employee_tbl
        (EMPLOYEE_NUM, EMPLOYEE_ID, EMPLOYEE_PW, EMPLOYEE_KANJI, EMPLOYEE_KANA, EMPLOYEE_ENG, TEL, GENDER, POSITION, TEAM, AGREE, MEGAZINE, MEMO, REGISTER_DATE, CHANGE_DATE) VALUES ('\(AutoNum(finalCount: "SELECT COUNT(*) FROM employee_tbl"))', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """;
        
        for data in employee {
            var insertStmt:OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, insertSql, -1, &insertStmt, nil) != SQLITE_OK {
                print("insert_emp error: \(DBErrorMsg(db))")
                return
            }
    
            sqlite3_bind_text(insertStmt, 1, (data.EmployeeId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 2, (data.EmployeePw as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 3, (data.EmployeeKanji as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 4, (data.EmployeeKana as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 5, (data.EmployeeEng as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 6, (data.Tel as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStmt, 7, Int32(data.Gender))
            sqlite3_bind_text(insertStmt, 8, (data.Position as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 9, (data.Team as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStmt, 10, Int32(data.Agree))
            sqlite3_bind_int(insertStmt, 11, Int32(data.Megazine))
         
            if data.Memo == "" {
                sqlite3_bind_null(insertStmt, 12)
            } else {
                sqlite3_bind_text(insertStmt, 12, (data.Memo as NSString).utf8String, -1, nil)
            }
            
            if data.RegisterDate == "" {
                sqlite3_bind_null(insertStmt, 13)
            } else {
                sqlite3_bind_text(insertStmt, 13, (data.RegisterDate as NSString).utf8String, -1, nil)
            }
                             
            if sqlite3_step(insertStmt) != SQLITE_DONE {
                print ("insert_emp step error: \(DBErrorMsg(db))")
                sqlite3_finalize(insertStmt)
                return
            }
            sqlite3_finalize(insertStmt)
        }
        return
    }
    
    //position
    func insertPosition(position:[Position]) {
        
        let insertSql = """
        INSERT INTO position_tbl(POSITION_CODE, POSITION_NAME) VALUES(?, ?);
        """;
        
        var insertStmt:OpaquePointer? = nil
        
        for data in position {
            if sqlite3_prepare_v2(db, insertSql, -1, &insertStmt, nil) != SQLITE_OK {
            print("insert_position error: \(DBErrorMsg(db))")
        }
        
            sqlite3_bind_text(insertStmt, 1, (data.PositionCode as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 2, (data.PositionName as NSString).utf8String, -1, nil)
        
            if sqlite3_step(insertStmt) != SQLITE_DONE {
                //print("insert_position step error: \(DBErrorMsg(db))")
                sqlite3_finalize(insertStmt)
                return
            }
            sqlite3_finalize(insertStmt)
        }
        return
    }
    
    //team
    
    func insertTeam(team:[Team]){
        
        let insertSql = """
        INSERT INTO team_tbl(TEAM_CODE, TEAM_NAME) VALUES(?, ?);
        """;
        
        var insertStmt:OpaquePointer? = nil
        
        for data in team {
            if sqlite3_prepare_v2(db, insertSql, -1, &insertStmt, nil) != SQLITE_OK {
                print("insert_team error: \(DBErrorMsg(db))")
                return
            }
            
            sqlite3_bind_text(insertStmt, 1, (data.TeamCode as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStmt, 2, (data.TeamName as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStmt) != SQLITE_DONE {
                //print("insert_team step error: \(DBErrorMsg(db))")
                sqlite3_finalize(insertStmt)
                return
            }
            sqlite3_finalize(insertStmt)
        }
        return
    }
    
    
    
    //MARK: SELECT
    
    //login_IdでPW SELECT
    func selectLogin(loginId:String) -> String? {
        
        let selectSql = "select EMPLOYEE_PW from login_tbl where EMPLOYEE_ID ='\(loginId)';"
        var selectStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (selectSql as NSString).utf8String, -1, &selectStmt, nil) != SQLITE_OK {
            print("select error: \(DBErrorMsg(db))")
        }
        
        if sqlite3_step(selectStmt) == SQLITE_ROW {
            let loginPw = String(cString: sqlite3_column_text(selectStmt, 0))
            sqlite3_finalize(selectStmt)
            return loginPw
        }
        sqlite3_finalize(selectStmt)
        return nil
    }

    // empID
    func selectEmployeeID(employeeID:String) -> String? {
        
        let selectSql = "select EMPLOYEE_ID from employee_tbl where EMPLOYEE_ID = '\(employeeID)';"
        var selectStmt:OpaquePointer? = nil
        
        if sqlite3_prepare(db, (selectSql as NSString).utf8String, -1, &selectStmt, nil) != SQLITE_OK {
            print("select error: \(DBErrorMsg(db))")
        }
        
        if sqlite3_step(selectStmt) == SQLITE_ROW {
            let empId = String(cString: sqlite3_column_text(selectStmt, 0))
            return empId
        }
        sqlite3_finalize(selectStmt)
        return nil
    }
    
    
    //employee
    func selectEmployee() ->[Employee] {

        var emps:[Employee] = []

        let selectSql = """
        SELECT * FROM employee_tbl;
"""
        var selectStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, selectSql, -1, &selectStmt, nil) != SQLITE_OK {
            print("select_emp error: \(DBErrorMsg(db))")
        }
        
        while (sqlite3_step(selectStmt) == SQLITE_ROW) {
            
            let empNum = String(describing: String(cString: sqlite3_column_text(selectStmt, 0)))
            let empId = String(describing: String(cString: sqlite3_column_text(selectStmt, 1)))
            let empPw = String(describing: String(cString: sqlite3_column_text(selectStmt, 2)))
            let empKanji = String(describing: String(cString: sqlite3_column_text(selectStmt, 3)))
            let empKana = String(describing: String(cString: sqlite3_column_text(selectStmt, 4)))
            let empEng = String(describing: String(cString: sqlite3_column_text(selectStmt, 5)))
            let empTel = String(describing: String(cString: sqlite3_column_text(selectStmt, 6)))
            let empGender = Int(sqlite3_column_int(selectStmt, 7))
            let empPosition = String(describing: String(cString: sqlite3_column_text(selectStmt, 8)))
            let empTeam = String(describing: String(cString: sqlite3_column_text(selectStmt, 9)))
            let empAgree = Int(sqlite3_column_int(selectStmt, 10))
            let empMegazine = Int(sqlite3_column_int(selectStmt, 11))
            
            var empMemo: String
            if (sqlite3_column_type(selectStmt, 12) == SQLITE_NULL ) {
                empMemo = ""
            } else {
                empMemo = String(describing: String(cString: sqlite3_column_text(selectStmt, 12)))
            }
            
            let empregisterDate = String(describing: String(cString: sqlite3_column_text(selectStmt, 13)))
            
            var empChangeDate: String
            if (sqlite3_column_type(selectStmt, 14) == SQLITE_NULL) {
                empChangeDate = ""
            } else {
                empChangeDate = String(describing: String(cString: sqlite3_column_text(selectStmt, 14)))
            }
            
            let empV = Employee()
            empV.EmployeeNum = empNum
            empV.EmployeeId = empId
            empV.EmployeePw = empPw
            empV.EmployeeKanji = empKanji
            empV.EmployeeKana = empKana
            empV.EmployeeEng = empEng
            empV.Tel = empTel
            empV.Gender = empGender
            empV.Position = empPosition
            empV.Team = empTeam
            empV.Agree = empAgree
            empV.Megazine = empMegazine
            empV.Memo = empMemo
            empV.RegisterDate = empregisterDate
            empV.ChangeDate = empChangeDate
            
            emps.append(empV)
        }
        return emps
    }
    
    //login
    func selectLogin() ->[Login] {

        var logins:[Login] = []

        let selectSql = """
        SELECT * FROM login_tbl;
"""
        var selectStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, selectSql, -1, &selectStmt, nil) != SQLITE_OK {
            print("select_login error: \(DBErrorMsg(db))")
        }
        
        while (sqlite3_step(selectStmt) == SQLITE_ROW) {
            
            let empNum = String(describing: String(cString: sqlite3_column_text(selectStmt, 0)))
            let empId = String(describing: String(cString: sqlite3_column_text(selectStmt, 1)))
            let empPw = String(describing: String(cString: sqlite3_column_text(selectStmt, 2)))
           
            var lastDate: String
            if (sqlite3_column_type(selectStmt, 3) == SQLITE_NULL ) {
                lastDate = ""
            } else {
                lastDate = String(describing: String(cString: sqlite3_column_text(selectStmt, 3)))
            }
            
            let loginV = Login()
            loginV.EmployeeNum = empNum
            loginV.EmployeeId = empId
            loginV.EmployeePw = empPw
            loginV.LastLogin = lastDate
            
            logins.append(loginV)
        }
        return logins
    }
    
    
    //position
    
    func selectPositionAll() -> [Position] {
        
        var pos:[Position] = []
        
        let selectSql = """
        SELECT * FROM position_tbl;
"""
        var selectStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (selectSql as NSString).utf8String, -1, &selectStmt, nil) != SQLITE_OK {
            print("\(DBErrorMsg(db))")
        }
        
        while (sqlite3_step(selectStmt)) == SQLITE_ROW {
            let postionCode = String(describing: String(cString: sqlite3_column_text(selectStmt, 0)))
            let positionName = String(describing: String(cString: sqlite3_column_text(selectStmt, 1)))
        
            let positionT = Position()
            positionT.PositionCode = postionCode
            positionT.PositionName = positionName
            
            pos.append(positionT)
        }
       print("position \(pos)")
        return pos
    }
    
    
    func selectPosition() ->[Position] {
        
        var pos:[Position] = []
        
        let selectSql = "SELECT * FROM position_tbl INNER JOIN employee_tbl ON position_tbl.POSITION_CODE = employee_tbl.POSITION"
        var selectStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, selectSql, -1, &selectStmt, nil) != SQLITE_OK {
            print("select_pos error: \(DBErrorMsg(db))")
        }
        
        while(sqlite3_step(selectStmt)) == SQLITE_ROW {
            
            let positionCode = String(describing: String(cString: sqlite3_column_text(selectStmt, 0)))
            let positionName = String(describing: String(cString: sqlite3_column_text(selectStmt, 1)))
           
            
            let posV = Position()
            posV.PositionCode = positionCode
            posV.PositionName = positionName
            
            pos.append(posV)

        }
        return pos
    }
    
    //team
    //selet * -> 出力まで完了
    func selectTeamAll() -> [Team] {
        
        var teams:[Team] = []
        
        let selectSql = """
        SELECT * FROM team_tbl;
"""
        var selectStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (selectSql as NSString).utf8String, -1, &selectStmt, nil) != SQLITE_OK {
            print("\(DBErrorMsg(db))")
        }
        
        while (sqlite3_step(selectStmt)) == SQLITE_ROW {
            let teamCode = String(describing: String(cString: sqlite3_column_text(selectStmt, 0)))
            let teamName = String(describing: String(cString: sqlite3_column_text(selectStmt, 1)))
        
            let teamV = Team()
            teamV.TeamCode = teamCode
            teamV.TeamName = teamName
            
            teams.append(teamV)
        }
       //print("team \(emp)")
        return teams
    }
    
    func selectTeam() -> [Team] {
        
        var teams:[Team] = []
        let selectSql = "SELECT * FROM team_tbl INNER JOIN employee_tbl ON team_tbl.TEAM_CODE = employee_tbl.TEAM"
        var selectStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, selectSql, -1, &selectStmt, nil) != SQLITE_OK {
            print("select_team error \(DBErrorMsg(db))")
        }
        
        while(sqlite3_step(selectStmt)) == SQLITE_ROW {
            
            let teamCode = String(describing: String(cString: sqlite3_column_text(selectStmt, 0)))
            let teamName = String(describing: String(cString: sqlite3_column_text(selectStmt, 1)))
            
            
            let teamV = Team()
            teamV.TeamCode = teamCode
            teamV.TeamName = teamName
            
            teams.append(teamV)
        }
        return teams
    }
    
    //MARK: UPDATE
    func updateEmployee(employee:Employee) {
        let updateSql = """
        UPDATE employee_tbl SET EMPLOYEE_KANJI = ?, EMPLOYEE_KANA = ?, EMPLOYEE_ENG = ?, TEL = ?, POSITION = ?, TEAM = ?, MEGAZINE = ?, MEMO = ?, CHANGE_DATE = ? WHERE EMPLOYEE_ID == '\(employee.EmployeeId)'
"""
        var updateStmt:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateSql, -1, &updateStmt, nil) != SQLITE_OK {
            print("update_emp error: \(DBErrorMsg(db))")
        }
        
        sqlite3_bind_text(updateStmt, 1, (employee.EmployeeKanji as NSString).utf8String, -1, nil)
        sqlite3_bind_text(updateStmt, 2, (employee.EmployeeKana as NSString).utf8String, -1, nil)
        sqlite3_bind_text(updateStmt, 3, (employee.EmployeeEng as NSString).utf8String, -1, nil)
        sqlite3_bind_text(updateStmt, 4, (employee.Tel as NSString).utf8String, -1, nil)
        sqlite3_bind_text(updateStmt, 5, (employee.Position as NSString).utf8String, -1, nil)
        sqlite3_bind_text(updateStmt, 6, (employee.Team as NSString).utf8String, -1, nil)
        sqlite3_bind_int(updateStmt, 7, Int32(employee.Megazine))
        sqlite3_bind_text(updateStmt, 8, (employee.Memo as NSString).utf8String, -1, nil)
        let nowDate = Date() //現在DATE
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let str = dateFormatter.string(from: nowDate) //dateをStringで変換
        employee.ChangeDate = str
        sqlite3_bind_text(updateStmt, 9, (employee.ChangeDate as NSString).utf8String, -1,  nil)
        
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            print("update step error: \(DBErrorMsg(db))")
            sqlite3_finalize(updateStmt)
            return
        }
        sqlite3_finalize(updateStmt)
    }
    
    func updateLogin(loginId:String) -> String {
        let updateSql = """
        UPDATE login_tbl SET LAST_LOGIN = ? WHERE EMPLOYEE_ID == '\(loginId)'
"""
        var updateStmt:OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateSql, -1, &updateStmt, nil) != SQLITE_OK {
            print("update_login error: \(DBErrorMsg(db))")
        }
        
        let loginId = Login()
        let nowDate = Date() //現在DATE
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let str = dateFormatter.string(from: nowDate) //dateをStringで変換
        loginId.LastLogin = str
        
        sqlite3_bind_text(updateStmt, 1, (loginId.LastLogin as NSString).utf8String, -1, nil)
       
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            print("update_login step error: \(DBErrorMsg(db))")
            sqlite3_finalize(updateStmt)
        }
        sqlite3_finalize(updateStmt)
        return loginId.LastLogin
    }
    
    
    
    
    
    //MARK: CSV
    
    //login
    func loadCSV(fileName:String) -> [Login] {
        var csvArray = [String]()
        var csvv = [Login]()
        let csvBundle = Bundle.main.path(forResource: fileName, ofType:"csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle,encoding:String.Encoding.utf8 )
            let lineChange = csvData.replacingOccurrences(of: "\r\n", with: "\n" )
                .replacingOccurrences(of: "\r", with: "\n" )
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        } catch {
            print("エラー")
        }
        for csvData in csvArray {
            let csvDetail = csvData.components(separatedBy: ",")
            let csvT = Login()
            csvT.EmployeeNum = csvDetail[0]
            csvT.EmployeeId = csvDetail[1]
            csvT.EmployeePw = csvDetail[2]
            csvT.LastLogin = csvDetail[3]
            csvv.append(csvT)
        }
    //    print("=======================================")
    //    print(csvv.count)
    //    print(csvv)
    //    print("=======================================")
        return csvv
    }
    
    //employee
    func emploadCSV(fileName:String) -> [Employee] {
        var csvArray = [String]()
        var csvv = [Employee]()
        let csvBundle = Bundle.main.path(forResource: fileName, ofType:"csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle,encoding:String.Encoding.utf8 )
            let lineChange = csvData.replacingOccurrences(of: "\r\n", with: "\n" )
                .replacingOccurrences(of: "\r", with: "\n" )
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        } catch {
            print("エラー")
        }
        for csvData in csvArray {
            let csvDetail = csvData.components(separatedBy: ",")
            let csvT = Employee()
            let gender = Int(csvDetail[7])
            csvT.EmployeeNum = csvDetail[0]
            csvT.EmployeeId = csvDetail[1]
            csvT.EmployeePw = csvDetail[2]
            csvT.EmployeeKanji = csvDetail[3]
            csvT.EmployeeKana = csvDetail[4]
            csvT.EmployeeEng = csvDetail[5]
            csvT.Tel = csvDetail[6]
            csvT.Gender = gender!
            csvT.Position = csvDetail[8]
            csvT.Team = csvDetail[9]
            csvT.RegisterDate = csvDetail[10]
            csvv.append(csvT)
        }
    //    print("=======================================")
    //    print(csvv.count)
    //    print(csvv)
    //    print("=======================================")
        return csvv
    }
    
    //position
    func positionloadCSV(fileName:String) -> [Position] {
        var csvArray = [String]()
        var csvv = [Position]()
        let csvBundle = Bundle.main.path(forResource: fileName, ofType:"csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle,encoding:String.Encoding.utf8 )
            let lineChange = csvData.replacingOccurrences(of: "\r\n", with: "\n" )
                .replacingOccurrences(of: "\r", with: "\n" )
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        } catch {
            print("エラー")
        }
        for csvData in csvArray {
            let csvDetail = csvData.components(separatedBy: ",")
            let csvT = Position()
            csvT.PositionCode = csvDetail[0]
            csvT.PositionName = csvDetail[1]
            csvv.append(csvT)
        }
    //    print("=======================================")
    //    print(csvv.count)
    //    print(csvv)
    //    print("=======================================")
        return csvv
    }
    
    //team
    func teamloadCSV(fileName:String) -> [Team] {
        var csvArray = [String]()
        var csvv = [Team]()
        let csvBundle = Bundle.main.path(forResource: fileName, ofType:"csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle,encoding:String.Encoding.utf8 )
            let lineChange = csvData.replacingOccurrences(of: "\r\n", with: "\n" )
                .replacingOccurrences(of: "\r", with: "\n" )
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        } catch {
            print("エラー")
        }
        for csvData in csvArray {
            let csvDetail = csvData.components(separatedBy: ",")
            let csvT = Team()
            csvT.TeamCode = csvDetail[0]
            csvT.TeamName = csvDetail[1]
            csvv.append(csvT)
        }
    //    print("=======================================")
    //    print(csvv.count)
    //    print(csvv)
    //    print("=======================================")
        return csvv
    }
    
    
    
    //MARK: ERROR 関数
    func DBErrorMsg(_ db:OpaquePointer?) -> String {
        if let err = sqlite3_errmsg(db) {
            return String(cString: err)
        } else {
            return ""
        }
    }
    
    
    //MARK: 社員番号関数
    //employee
    func AutoNum(finalCount:String) -> String {
        //Date XX-XXXX
        let nowDate = Date() // 現在の時間
        let dateFormatter = DateFormatter() // 変数
        dateFormatter.dateFormat = "yy-MMdd" // データを型
        let dateStr = dateFormatter.string(from: nowDate) // Dateを現在の時間でFormatをStringで返す
        
        //SELECT cOunt
        let countSql = "SELECT COUNT(*) FROM employee_tbl"
        var Stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, countSql , -1, &Stmt, nil) != SQLITE_OK {
            print("INSERT::ERROR:: AUTONUM \(DBErrorMsg(db))")
        }
        
        if sqlite3_step(Stmt) == SQLITE_ROW {
            sqlite3_column_int(Stmt, 0)
        }
        
        let numCount = sqlite3_column_int(Stmt, 0)
       // print("================================================\(numCount)")
        if numCount >= 0 && numCount <= 8 {
            let Num = numCount + 1
            var finalCount = dateStr + "000\(Num)"  // XX-XXXX + XXX + X
            return finalCount
        } else if numCount >= 9 && numCount <= 98 {
            let Num = numCount + 1
            var finalCount = dateStr + "00\(Num)"  // XX-XXXX + XX + XX // XX-XXXX + XX + XX
            return finalCount
        } else if numCount >= 99 && numCount <= 998 {
            let Num = numCount + 1
            var finalCount = dateStr + "0\(Num)" // XX-XXXX + X + XXX
            return finalCount
        } else if numCount >= 999 && numCount <= 9998 {
            let Num = numCount + 1
            var finalCount = dateStr + "\(Num)" // XX-XXXX + XXXX
            return finalCount
        }
        sqlite3_finalize(Stmt)
        return finalCount
    }
    
    
    //login
    func AutoNum2(finalCount:String) -> String {
        //Date XX-XXXX
        let nowDate = Date() // 現在の時間
        let dateFormatter = DateFormatter() // 変数
        dateFormatter.dateFormat = "yy-MM-dd" // データを型
        let dateStr = dateFormatter.string(from: nowDate) // Dateを現在の時間でFormatをStringで返す
        
        //SELECT cOunt
        let countSql = "SELECT COUNT(*) FROM login_tbl"
        var Stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, countSql , -1, &Stmt, nil) != SQLITE_OK {
            print("INSERT::ERROR:: AUTONUM \(DBErrorMsg(db))")
        }
        
        if sqlite3_step(Stmt) == SQLITE_ROW {
            sqlite3_column_int(Stmt, 0)
        }
        
        let numCount = sqlite3_column_int(Stmt, 0)
        //print("================================================\(numCount)")
        if numCount >= 0 && numCount <= 8 {
            let Num = numCount + 1
            var finalCount = dateStr + "000\(Num)"  // XX-XXXX + XXX + X
            return finalCount
        } else if numCount >= 9 && numCount <= 98 {
            let Num = numCount + 1
            var finalCount = dateStr + "00\(Num)"  // XX-XXXX + XX + XX // XX-XXXX + XX + XX
            return finalCount
        } else if numCount >= 99 && numCount <= 998 {
            let Num = numCount + 1
            var finalCount = dateStr + "0\(Num)" // XX-XXXX + X + XXX
            return finalCount
        } else if numCount >= 999 && numCount <= 9998 {
            let Num = numCount + 1
            var finalCount = dateStr + "\(Num)" // XX-XXXX + XXXX
            return finalCount
        }
        sqlite3_finalize(Stmt)
        return finalCount
    }
}
