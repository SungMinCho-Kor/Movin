//
//  MBTI.swift
//  Movin
//
//  Created by 조성민 on 2/8/25.
//

struct MBTI: Codable {
    var ei: EI?
    var sn: SN?
    var tf: TF?
    var jp: JP?
    
    enum EI: Int, CaseIterable, Codable {
        case e = 0
        case i = 4
        
        var title: String {
            switch self {
            case .e:
                return "e"
            case .i:
                return "i"
            }
        }
    }
    
    enum SN: Int, CaseIterable, Codable {
        case s = 1
        case n = 5
        
        var title: String {
            switch self {
            case .s:
                return "s"
            case .n:
                return "n"
            }
        }
    }
    
    enum TF: Int, CaseIterable, Codable {
        case t = 2
        case f = 6
        
        var title: String {
            switch self {
            case .t:
                return "t"
            case .f:
                return "f"
            }
        }
    }
    
    enum JP: Int, CaseIterable, Codable {
        case j = 3
        case p = 7
        
        var title: String {
            switch self {
            case .j:
                return "j"
            case .p:
                return "p"
            }
        }
    }
    
    func getResult() -> String? {
        if let ei, let sn, let tf, let jp {
            return ei.title + sn.title + tf.title + jp.title
        } else {
            return nil
        }
    }
    
    func getIndexList() -> [Bool] {
        var array = Array<Bool>(
            repeating: false,
            count: 8
        )
        if let ei {
            array[ei.rawValue] = true
        }
        if let sn {
            array[sn.rawValue] = true
        }
        if let tf {
            array[tf.rawValue] = true
        }
        if let jp {
            array[jp.rawValue] = true
        }
        
        return array
    }
    
    mutating func select(index: Int) {
        if let newEI = EI(rawValue: index) {
            ei = newEI
        } else if let newSN = SN(rawValue: index) {
            sn = newSN
        } else if let newTF = TF(rawValue: index) {
            tf = newTF
        } else if let newJP = JP(rawValue: index) {
            jp = newJP
        }
    }
    
    func isFull() -> Bool {
        return ei != nil && sn != nil && tf != nil && jp != nil
    }
}
