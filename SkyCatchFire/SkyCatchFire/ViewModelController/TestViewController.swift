//
//  TestViewController.swift
//  SkyCatchFire
//
//  Created by Programmer Raymond Barrinuevo on 6/13/20.
//  Copyright © JaMaYkAn 2020. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MVVM_C
import JitsiMeet

final class TestViewController: UIViewController, ViewControllerModellable, ControllerModellable {
    
    typealias ViewModel = TestViewModel

    fileprivate struct LayoutConstraints {
        // Put static constants for layouts here
    }
    
    // MARK: - Subviews -
    
    lazy var jitsiView: JitsiMeetView = {
        let view = JitsiMeetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: - Properties
    let coordinatedModel: CoordinatedInitiatable
    fileprivate let viewModel: ViewModel
    let disposeBag = DisposeBag()
    
    // MARK: - View lifecycle
    
    required init(model: ViewModel) {
        self.viewModel = model
        self.coordinatedModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setUpViews()
        setUpModelObservables()
    }
    
    fileprivate func setUpViews() {
        
        view.addSubview(jitsiView)
        
        NSLayoutConstraint.activate([
            jitsiView.topAnchor(equalTo: view.topAnchor),
            jitsiView.leadingAnchor(equalTo: view.leadingAnchor),
            jitsiView.trailingAnchor(equalTo: view.trailingAnchor),
            jitsiView.bottomAnchor(equalTo: view.bottomAnchor)
        ])
    }
    
    fileprivate func setUpModelObservables() {
        
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.serverURL = URL(string: "https://jitsi.tinda.app")//https://meet.jit.si
            builder.audioOnly = true
            builder.room = "SkyCatchFire"
            
        }
        
        jitsiView.join(options)
        
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            viewModel.dispose()
        }
    }
}

// MARK: - Extensions

extension TestViewController: JitsiMeetViewDelegate {

    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        print("STATUS:: \(data)")
    }
    
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        print("STATUS2:: \(data)")
    }
    
    func conferenceWillJoin(_ data: [AnyHashable : Any]!) {
        print("STATUS3:: \(data)")
    }
    
}
