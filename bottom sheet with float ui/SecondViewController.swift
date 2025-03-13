//
//  SecondViewController.swift
//  bottom sheet with float ui
//
//  Created by Haidarov N on 3/11/25.
//

import UIKit

class SecondViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Bottom Sheet Content"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is a sample bottom sheet with floating content. The floating button follows the sheet as you drag it."
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.7),
            
            // TitleLabel constraints
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // DescriptionLabel constraints
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}


import SwiftUI

struct ContentView: View {
    @State private var bottomSheetPosition: CGFloat = 100 // Initial height
    @State private var isBottomSheetOpen: Bool = false
    
    // Bottom sheet height constants
    private let minHeight: CGFloat = 100
    private let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.7
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            Color.blue
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    Text("Main Content")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                )
            
            // Bottom Sheet
            BottomSheetView(bottomSheetPosition: $bottomSheetPosition, isBottomSheetOpen: $isBottomSheetOpen, minHeight: minHeight, maxHeight: maxHeight)
                .frame(height: bottomSheetPosition)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .offset(y: isBottomSheetOpen ? 0 : maxHeight - minHeight) // Adjust offset for initial state
                .animation(.spring(), value: isBottomSheetOpen)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let dragAmount = value.translation.height
                            bottomSheetPosition = max(minHeight, min(maxHeight, bottomSheetPosition - dragAmount))
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                if bottomSheetPosition > (maxHeight / 2) {
                                    bottomSheetPosition = maxHeight
                                    isBottomSheetOpen = true
                                } else {
                                    bottomSheetPosition = minHeight
                                    isBottomSheetOpen = false
                                }
                            }
                        }
                )
            
            // Floating Action Button (FAB)
            FloatingActionButton(bottomSheetPosition: $bottomSheetPosition, minHeight: minHeight, maxHeight: maxHeight)
                .padding(.trailing, 20)
                .padding(.bottom, 20)
        }
    }
}

struct BottomSheetView: View {
    @Binding var bottomSheetPosition: CGFloat
    @Binding var isBottomSheetOpen: Bool
    var minHeight: CGFloat
    var maxHeight: CGFloat
    
    var body: some View {
        VStack {
            // Handle for dragging
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            // Content inside the bottom sheet
            Text("Bottom Sheet Content")
                .font(.title)
                .padding()
            
            Spacer()
        }
    }
}

struct FloatingActionButton: View {
    @Binding var bottomSheetPosition: CGFloat
    var minHeight: CGFloat
    var maxHeight: CGFloat
    
    var body: some View {
        Button(action: {
            // Action for FAB
        }) {
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .offset(y: -bottomSheetPosition + minHeight) // Move FAB with the bottom sheet
        .animation(.spring(), value: bottomSheetPosition)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
