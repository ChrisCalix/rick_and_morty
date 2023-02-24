//
//  PlayerScrollView.swift
//  rick_and_morty
//
//  Created by Sonic on 24/2/23.
//

import SwiftUI

struct PlayerScrollView: UIViewRepresentable {
    
    @ObservedObject var viewModel: CharacterViewModel
    
    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        let childView = UIHostingController(rootView: PaintingView(viewModel: viewModel))
        
        let cant = viewModel.characters.count
        childView.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * CGFloat(cant), height: UIScreen.main.bounds.height )
        
        view.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(cant), height: UIScreen.main.bounds.height)
        
        view.addSubview(childView.view)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        view.contentInsetAdjustmentBehavior = .never
        view.isPagingEnabled = true
        
        return view
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
    }
}
