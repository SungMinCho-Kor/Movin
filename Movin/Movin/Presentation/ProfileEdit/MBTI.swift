//
//  MBTI.swift
//  Movin
//
//  Created by 조성민 on 2/8/25.
//

enum MBTI: String {
    case ESTJ
    case ESTP
    case ESFJ
    case ESFP
    case ENTJ
    case ENTP
    case ENFJ
    case ENFP
    case ISTJ
    case ISTP
    case ISFJ
    case ISFP
    case INTJ
    case INTP
    case INFJ
    case INFP
}

struct MBTIElement {
    var ei: EI?
    var sn: SN?
    var tf: TF?
    var jp: JP?
    
    enum EI: Int, CaseIterable {
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
    
    enum SN: Int, CaseIterable {
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
    
    enum TF: Int, CaseIterable {
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
    
    enum JP: Int, CaseIterable {
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
    
    func getResult() -> MBTI? {
        if let ei, let sn, let tf, let jp {
            return MBTI(rawValue: ei.title + sn.title + tf.title + jp.title)
        } else {
            return nil
        }
    }
}
