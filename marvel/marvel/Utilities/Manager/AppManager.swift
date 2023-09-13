//
//  AppManager.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit
import UserNotifications

enum ServerType: Int {
    case develop = 0
    case release = 1
}

enum AppName: String {
    case marvel = "marvel"
}


class AppManager {
    let plist_Configuration: String = "Configuration"                       // debug, release 체크
    let plist_privateApi: String = "PrivateAPI"
    let plist_publicApi: String = "PublicAPI"
    let plist_timeStamp: String = "TimeStamp"
    let plist_version: String = "CFBundleShortVersionString"                // 앱 버젼
    let plist_appName: String = "CFBundleName"                              // 앱 이름
    let plist_buildVersion: String = "CFBundleVersion"                      // 빌드 번호
    
    let userDefault_CurrentDomain: String = "currentDomain"                 // 사용 도메인
    let userDefault_DesignQAMode: String = "designQAMode"                   // 디자인 QA 모드
    let userDefault_Characters: String = "marvelheros"                   // 마블 카드

    // 앱 매니저 부분
    var serverType: ServerType                                              // 서버 타입
    let version: String                                                     // 앱 버젼
    let buildVersion: String                                                // 앱 빌드 버젼
    var isRelease: Bool                                                     // 상용 배포 체크
    var pushToken: String?                                                  // 앱 푸시 토큰
    var isAdd: Bool = false                                                 // 정의되어 있지 않은 키값이 default에 들어가는 유무
    let appName: String                                                     // 앱 이름 저장
    var designQA: Bool = false                                              // 디자인 QA 모드
    
    
    let publicApi: String
    let privteApi: String
    let timeStamp: String

    static var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {return nil}
        return version
    }

    static let shared: AppManager = {
        let instance = AppManager()
        return instance
    }()

    private init() {
        // App Status: Debug/Release
        if let version = Bundle.main.object(forInfoDictionaryKey: plist_version) as? String {
            self.version = version
        } else {
            self.version = ""
        }

        if let name = Bundle.main.object(forInfoDictionaryKey: plist_appName) as? String {
                self.appName = name
        } else {
            self.appName = ""
        }

        // App Build Version on Debug Mode
        if let buildVersion = Bundle.main.object(forInfoDictionaryKey: plist_buildVersion) as? String {
            self.buildVersion = buildVersion
        } else {
            self.buildVersion = ""
        }
        
        let userDefault = UserDefaults.standard
        
        if userDefault.object(forKey: userDefault_DesignQAMode) == nil {
            userDefault.set(false, forKey: userDefault_DesignQAMode)
            self.designQA = false
        }
        else {
            let value = userDefault.bool(forKey: userDefault_DesignQAMode)
            self.designQA = value
        }
        
        if let privateapi = Bundle.main.object(forInfoDictionaryKey: plist_privateApi) as? String {
            self.privteApi = privateapi
        } else {
            self.privteApi = ""
        }

        if let publicapi = Bundle.main.object(forInfoDictionaryKey: plist_publicApi) as? String {
            self.publicApi = publicapi
        } else {
            self.publicApi = ""
        }

        if let ts = Bundle.main.object(forInfoDictionaryKey: plist_timeStamp) as? String {
            self.timeStamp = ts
        } else {
            self.timeStamp = ""
        }



        guard let configuration = Bundle.main.object(forInfoDictionaryKey: plist_Configuration) as? String else {
            self.serverType = .develop
            self.isRelease = false
            return
        }

        
        self.serverType = configuration == "Release" ? .release : .develop
        self.isRelease = configuration == "Release" ? true : false
        
    }
}

// MARK: - Application Status

extension AppManager {
    
    func getPlist(_ fileName: String) -> [[String: AnyObject]]? {
        var plist: [[String: AnyObject]]? = nil
        guard let path: String = Bundle.main.path(forResource: fileName, ofType: "plist") else {
            Log.message(to: "Fail to load file: \(fileName)")
            return nil
        }
        var format = PropertyListSerialization.PropertyListFormat.xml
        guard let aData: Data = FileManager.default.contents(atPath: path) else {
            Log.message(to: "Fail to load contents: \(path)")
            return nil
        }
        do {
            try plist = PropertyListSerialization.propertyList(from: aData,
                                                                  options: .mutableContainersAndLeaves,
                                                                  format: &format) as? [[String : AnyObject]]
        } catch let error as NSError {
            Log.message(to: "Error property list serialization: \(error)")
        }
        return plist
    }

    // 현재 위치
    func getLocaleCode() -> String {
        return NSLocale.current.languageCode ?? "kr"
    }

    // 현재 위치 타임존
    func getTimeZone() -> String {
        return TimeZone.current.identifier
    }
    
    // 특정 값을 삭제
    func removeUserDefaultKey(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // 모든 값을 삭제
    func removeAllUserDefault() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }

    // 특정 값을 추가 - (위에 정의안된 값을 추가 함, 정의 안된 값을 추가시 isAdd값이 Yes로 변경)
    func updateUserDefault(key: String, value: Any) -> Bool {
        self.isAdd = true
        let defaults = UserDefaults.standard
        defaults.setValue(value, forKey: key)
        return defaults.synchronize()
    }
    
    func loadUserDefault(key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }

    // 도메인
    func isDomain() -> Bool {
        return UserDefaults.standard.string(forKey: userDefault_CurrentDomain) != nil ? true : false
    }

    func setDomain(domain: String) {
        UserDefaults.standard.set(domain, forKey: userDefault_CurrentDomain)
    }

    func getDomain() -> String {
        if let domain = UserDefaults.standard.string(forKey: userDefault_CurrentDomain) {
            return domain
        } else {
            return "test"
        }
    }

    
    func setDesignQA(isMode: Bool) {
        UserDefaults.standard.set(isMode, forKey: userDefault_DesignQAMode)
    }

    func getDesignQA() -> Bool {
        let value = UserDefaults.standard.bool(forKey: userDefault_DesignQAMode)
        return value
    }
    
    func removeCharacter(model:ResultModel) {
        var results:[ResultModel] = []
        if let list = UserDefaults.standard.array(forKey: userDefault_Characters) as? [Data] {
            for i in 0..<list.count {
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(ResultModel.self, from: list[i]) {
                    if result.id != model.id {
                        results.append(result)
                    }
                }
            }
        }
        
        UserDefaults.standard.removeObject(forKey: userDefault_Characters)
        for i in 0..<results.count {
            self.setCharacters(model: results[i])
        }
    }

    func setCharacters(model: ResultModel) {
        let encoder = JSONEncoder()
        var list: [Data] = []
        if var results = UserDefaults.standard.array(forKey: userDefault_Characters) as? [Data] {
            if results.count > 4 {
                results.removeFirst()
            }
            list.append(contentsOf: results)
        }
                
        if let encoded = try? encoder.encode(model) {
            list.append(encoded)
            UserDefaults.standard.set(list, forKey: userDefault_Characters)
        }

    }

    func getCharacters() -> [ResultModel]? {
                
        if let list = UserDefaults.standard.array(forKey: userDefault_Characters) as? [Data] {
            var l:[ResultModel] = []
            for i in 0..<list.count {
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(ResultModel.self, from: list[i]) {
                    l.append(result)
                }
            }
            return l
        }
        
        return nil
        
    }


}

