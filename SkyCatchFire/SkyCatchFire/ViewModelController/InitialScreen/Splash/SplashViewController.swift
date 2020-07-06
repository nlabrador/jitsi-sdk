//
//  SplashViewController.swift
//  MyChevroletConnect
//
//  Created by Programmer Raymond Barrinuevo on 5/31/20.
//  Copyright © JaMaYkAn 2020. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MVVM_C

final class SplashViewController: UIViewController, ViewControllerModellable, ControllerModellable {
    
    typealias ViewModel = SplashViewModel

    fileprivate struct LayoutConstraints {
        // Put static constants for layouts here
    }
    
    // MARK: - Subviews -
    
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            let view = UIActivityIndicatorView(style: .white)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tintColor = AppColorStyle.base2
            return view
        } else {
            let view = UIActivityIndicatorView(style: .white)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tintColor = AppColorStyle.base2
            return view
        }
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
        view.backgroundColor = AppColors.white
        setUpViews()
        setUpModelObservables()
    }
    
    fileprivate func setUpViews() {
        
        var launchScreenFileName = "LaunchScreen"
        if let launchScreen = Bundle.main.infoDictionary?["UILaunchStoryboardName"] as? String {
            launchScreenFileName = launchScreen
        }
        
        let storyBoard = UIStoryboard(name: launchScreenFileName, bundle: nil)
        let launchVC = storyBoard.instantiateViewController(withIdentifier: "launchController")
        addChild(launchVC)
        self.view.addSubview(launchVC.view)
        launchVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            launchVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            launchVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            launchVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        launchVC.didMove(toParent: self)
        self.view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
           activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    fileprivate func setUpModelObservables() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.viewModel.splashFinish()
        }
        
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            viewModel.dispose()
        }
    }
}

// MARK: - Extensions

extension SplashViewController {
    
}
