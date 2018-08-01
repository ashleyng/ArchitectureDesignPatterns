//
//  AppRouter.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import ReSwift

enum RoutingDestination {
    case home
    case details(index: Int, photoType: PhotosType)
}

final class AppRouter {
    let navigationController: UINavigationController
    
    init(window: UIWindow) {
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        
        store.subscribe(self) {
            $0.select {
                $0.routingState
            }
        }
    }
    
    fileprivate func pushViewController(destination: UIViewController, animated: Bool) {
        let newViewControllerType = destination
        if let currentVc = navigationController.topViewController {
            let currentViewControllerType = type(of: currentVc)
            if currentViewControllerType == type(of: newViewControllerType) {
                return
            }
        }
        navigationController.pushViewController(destination, animated: animated)
    }
}

extension AppRouter: StoreSubscriber {
    func newState(state: RoutingState) {
        let shouldAnimate = navigationController.topViewController != nil
        let viewController: UIViewController
        switch state.navigationState {
        case .home:
            viewController =  HomeViewController()
        case .details(let index, let photoType):
            guard let model = state.photos[photoType.key]?[index] else {
                fatalError("Can't find model to present view controller")
            }
            viewController = NasaPhotoDetailViewController(photoInfo: model)
        }
        pushViewController(destination: viewController, animated: shouldAnimate)
    }
}
