//
//  BookDetailViewController.swift
//  Movin
//
//  Created by 조성민 on 2/11/25.
//

import UIKit

final class BookDetailViewController: BaseViewController {
    
    init(isbn: String) {
        super.init()
        print(self, #function)
    }
    
    deinit {
        print(self, #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
