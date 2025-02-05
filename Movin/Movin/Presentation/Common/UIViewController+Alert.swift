//
//  UIViewController+Alert.swift
//  Movin
//
//  Created by 조성민 on 2/1/25.
//

import UIKit

extension UIViewController {
    func showErrorAlert() {
        let alertController = UIAlertController(
            title: "에러",
            message: "네트워크 에러가 발생했습니다",
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "확인",
                style: .default
            )
        )
        present(
            alertController,
            animated: true
        )
    }
}
