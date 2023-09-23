//
//  NavigationController.swift
//  TSUAbiturient
//

import UIKit

class NavigationController: UINavigationController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }

  private var popObservers: [NavigationPopObserver] = []

  init() {
    super.init(nibName: nil, bundle: nil)
    configureDefaultNavigationBarAppearance()
    delegate = self
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  func configureDefaultNavigationBarAppearance() {
    let titleAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.Light.Global.black,
                                                          .font: UIFont.Bold.body ?? .boldSystemFont(ofSize: 16)]

    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .Light.Global.white
    appearance.shadowColor = .clear
    appearance.shadowImage = UIImage()
    appearance.titleTextAttributes = titleAttributes
    navigationBar.standardAppearance = appearance
    navigationBar.scrollEdgeAppearance = appearance

    navigationBar.barTintColor = .Light.Global.white
    navigationBar.isTranslucent = false
    navigationBar.tintColor = .systemBlue
    navigationBar.titleTextAttributes = titleAttributes
    navigationBar.shadowImage = UIImage()
  }

  func addPopObserver(for viewController: UIViewController, coordinator: Coordinator) {
    let observer = NavigationPopObserver(observedViewController: viewController, coordinator: coordinator)
    popObservers.append(observer)
  }

  func removeAllPopObservers() {
    popObservers.removeAll()
  }
}

// MARK: - UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController, animated: Bool) {
    if viewController is NavigationBarHiding {
      navigationController.setNavigationBarHidden(true, animated: animated)
    } else {
      navigationController.setNavigationBarHidden(false, animated: animated)
      
    }
  }

  func navigationController(_ navigationController: UINavigationController,
                            didShow viewController: UIViewController, animated: Bool) {
    popObservers.forEach { observer in
      if !navigationController.viewControllers.contains(observer.observedViewController) {
        observer.didObservePop()
        popObservers.removeAll { $0 === observer }
      }
    }
  }
}
