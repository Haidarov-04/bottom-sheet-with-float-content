////
////  ContainerManager.swift
////  iosApp
////
////  Created by Mac on 09/03/25.
////  Copyright © 2025 orgName. All rights reserved.
////
//
//
//import UIKit
//import SwiftUI
//
//class ContainerManager: ObservableObject {
//    @Published var container: ContainerController?
//    
//    /// Настраивает контейнер с заданным layout в переданном UIViewController
//    func setupContainer(in controller: UIViewController) {
//        let layout = ContainerLayout()
//        layout.startPosition = .bottom
//        // Здесь задаем динамически изменяемые позиции
//        layout.positions = ContainerPosition(top: 80, middle: nil, bottom: 80)
//        
//        container = ContainerController(addTo: controller, layout: layout)
//        container?.view.cornerRadius = 24
//        container?.view.addShadow()
//    }
//    
//    /// Перемещает контейнер в положение top (верх)
//    func moveToTop(animation: Bool = true, velocity: CGFloat = 0.0, completion: (() -> Void)? = nil) {
//        container?.move(type: .top, animation: animation, velocity: velocity, from: .custom, completion: completion)
//    }
//    
//    /// Перемещает контейнер в положение bottom (низ)
//    func moveToBottom(animation: Bool = true, velocity: CGFloat = 0.0, completion: (() -> Void)? = nil) {
//        container?.move(type: .bottom, animation: animation, velocity: velocity, from: .custom, completion: completion)
//    }
//}
