//
//  KeyboardContentScrollable.swift
//  MyChevroletConnect
//
//  Created by Raymond Barrinuevo on 30/11/2019.
//  Copyright © 2019 michael.p.siapno. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct KeyboardInfo {
    
    let frameBegin: CGRect
    let frameEnd: CGRect
    let curve: UInt
    let duration: Double
    
    init(notification: Notification, endFrame: CGRect? = nil) {
        let frameEnd = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let frameBegin = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue
        self.frameBegin = frameBegin ?? CGRect.zero
        if let closeFrame = endFrame {
            self.frameEnd = closeFrame
        } else {
            self.frameEnd = frameEnd ?? CGRect.zero
        }
        
        if let animationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            self.curve = animationCurve.uintValue
        } else {
            self.curve = 0
        }
        self.duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.0
    }
}

protocol KeyboardContentScrollable {
    associatedtype ScrollType
    
    var disposeBag: DisposeBag { get }
    var contentView: ScrollType { get }
    var currentTextInput: UITextInput? { get set }
    func setUpKeyboardObservables(_ adjustment: CGFloat)
    var keyboardEvent: ((_ height: CGFloat) -> Void)? { get }
}

extension KeyboardContentScrollable {
    
    var keyboardEvent: ((_ height: CGFloat) -> Void)? {
        return nil
    }
}

extension KeyboardContentScrollable where Self: UIViewController {
    func setUpKeyboardObservables(_ adjustment: CGFloat = 0) {
        
        if let content = contentView as? UIScrollView {
            content.keyboardDismissMode = .interactive
        }

        keyboardObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] keyboardInfo in
                /*guard let weakSelf = self else {
                    return
                }*/
                //self?.keyboardSubject.onNext(keyboardInfo.frameEnd.height > 0)
                let bottomOffset = max(0, keyboardInfo.frameEnd.height - adjustment)
                let contentInsets = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: bottomOffset,
                                                 right: 0)
                UIView.animate(withDuration: keyboardInfo.duration, delay: 0.0,
                               options: UIView.AnimationOptions(rawValue: keyboardInfo.curve),
                               animations: {
                                if let content = self?.contentView as? UIScrollView {
                                    content.contentInset = contentInsets
                                }
//                                self?.scrollView.contentInset = contentInsets
                                /*if let custom = self?.customAdjustment {
                                 custom(keyboardInfo.frameEnd.height)
                                 } else {
                                 self?.contentInset = contentInsets
                                 }*/
                }, completion: { _ in
                    self?.keyboardEvent?(keyboardInfo.frameEnd.height)
                    if keyboardInfo.frameEnd.height > 0.0 {
                        self?.scrollToField()
                    }
                })
                
            }).disposed(by: disposeBag)
        
        inputBeginEditing()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] textInput in
                self?.currentTextInput = textInput
            }).disposed(by: disposeBag)
    }
    
    fileprivate func scrollToField() {
        var convertedRect: CGRect?
        if let input = currentTextInput {
            if let textField = input as? UITextField, let fieldParent = textField.superview {
                if let content = self.contentView as? UIScrollView {
                    convertedRect = content.convert(textField.frame, from: fieldParent)
                }
                
            }
            
            if let textView = input as? UITextView, let fieldParent = textView.superview {
                if let content = self.contentView as? UIScrollView {
                    convertedRect = content.convert(textView.frame, from: fieldParent)
                }
                
            }
        }
        DispatchQueue.main.async { [weak self] in
            if let convertedFrame = convertedRect {
                if let content = self?.contentView as? UIScrollView {
                    content.scrollRectToVisible(convertedFrame, animated: true)
                }
                
            }
        }
    }
    
    fileprivate func keyboardObservable() -> Observable<KeyboardInfo> {
        
        return Observable.from([
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                .map { notification -> KeyboardInfo in
                    KeyboardInfo(notification: notification)
            },
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                .map { notification -> KeyboardInfo in
                    KeyboardInfo(notification: notification, endFrame: CGRect.zero)
            }]).merge()
    }
    
    fileprivate func inputBeginEditing() -> Observable<UITextInput?> {
        
        return Observable.from([
            NotificationCenter.default.rx.notification(UITextField.textDidBeginEditingNotification)
                .map { notification -> UITextInput? in
                    notification.object as? UITextInput
            },
            NotificationCenter.default.rx.notification(UITextView.textDidBeginEditingNotification)
                .map { notification -> UITextInput? in
                    notification.object as? UITextInput
            }]).merge()
    }
}
