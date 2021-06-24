//
//  Floating add button.swift
//  Shop List HW14
//
//  Created by admin2 on 21.06.2021.
//

import UIKit

class floatingAddUIButton: UIButton {

    //MARK: - properties
    //percent of current screen size
    private let screenWidthPercent = UIScreen.main.bounds.width / 100
    private let screenHightPercent = UIScreen.main.bounds.height / 100
    
    private var buttonDiameter: CGFloat
    private var fontSize: CGFloat
    private let linehightCompensator: CGFloat
    
    let delegate: navigationBarVisibilityProtocol?

    
    private let highlitedTitleColor = UIColor(displayP3Red: 255/255,
                                         green: 255/255,
                                         blue: 255/255,
                                         alpha: 128/255)
    
    private let shadowColor = UIColor(displayP3Red: 0,
                                      green: 0,
                                      blue: 0,
                                      alpha: 0.33).cgColor
    
    //MARK: - initialize
    init(_ navBarDelegate: navigationBarVisibilityProtocol? = nil) {
        
        delegate = navBarDelegate
        
        buttonDiameter = screenWidthPercent * 20
        fontSize = buttonDiameter / 2
        linehightCompensator = -fontSize / 8
        
        super.init(frame: CGRect(x: screenWidthPercent * 75,
                                 y: screenHightPercent * 75,
                                 width: screenWidthPercent * 20,
                                 height: screenWidthPercent * 20))
        //styling
        addTarget(self, action: #selector(zoomIn(button:)), for: .touchUpInside)
        makeButtonround()
        configureTitle(title: "+")
        setNormalStateStyle()
        setHighlatedStateStyle()
        setShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - methods
    private func makeButtonround() {
        layer.cornerRadius = buttonDiameter / 2
    }
    
    private func configureTitle(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        titleLabel?.baselineAdjustment = .alignCenters
        contentEdgeInsets = UIEdgeInsets(top: linehightCompensator, left: 0, bottom: 0, right: 0)
    }
    
    private func setNormalStateStyle() {
        backgroundColor = .systemGreen
    }
    
    private func setHighlatedStateStyle() {
        setTitleColor(highlitedTitleColor, for: .highlighted)
    }
    
    private func setShadow() {
        layer.shadowColor = shadowColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
    }
}

fileprivate extension UIView  {
    
    @objc func zoomIn(button: floatingAddUIButton) {
        button.setTitle("", for: .normal)
        //button.removeTarget(nil, action: nil, for: .allEvents)
        button.delegate?.setNavigationBarVisibility(visible: false, animated: true)
        
        let originalTransform = self.transform
        let scaledTransform = originalTransform.scaledBy(x: 20, y: 20)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = scaledAndTranslatedTransform
        })
    }
}
