//
//  ViewController.swift
//  Shop List HW14
//
//  Created by admin2 on 17.06.2021.
//

import UIKit
import Spring

class OnboardViewController: UIViewController {

    @IBOutlet var topImageView: SpringImageView!
    @IBOutlet var labelGreeting: SpringLabel!
    @IBOutlet var labelUnderGreeting: SpringLabel!
    @IBOutlet var getStartedButton: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: on the first load add some categories to user db
        
        //round button corners
        getStartedButton.layer.cornerRadius = 15
        labelUnderGreeting.textColor = UIColor(displayP3Red: 0,
                                               green: 0,
                                               blue: 0,
                                               alpha: 0.7)
        
        changeWidgetsVisibility(isHidden: true)
        animateWidgetsAppearance()
    }

    private func changeWidgetsVisibility(isHidden: Bool) {
        labelGreeting.isHidden = isHidden
        labelUnderGreeting.isHidden = isHidden
        getStartedButton.isHidden = isHidden
    }
    
    private func setAnimation(animation: String, curve: String, delay: CGFloat, force: CGFloat, duration: CGFloat, widgets: [Springable]) {
        for widget in widgets {
            widget.animation = animation
            widget.curve = curve
            widget.delay = delay
            widget.force = force
            widget.duration = duration
        }
    }
    
    private func animateWidgetsAppearance() {
        changeWidgetsVisibility(isHidden: false)
        //animation delay of button animation should
        //be greater for better experience
        setAnimation(animation: "fadeInUp",
                     curve: "easyIn",
                     delay: 0.3,
                     force: 0.7,
                     duration: 0.4,
                     widgets: [labelGreeting, labelUnderGreeting])
        
        setAnimation(animation: "fadeInUp",
                     curve: "easyIn",
                     delay: 0.5,
                     force: 0.5,
                     duration: 0.6,
                     widgets: [getStartedButton])
        
        labelGreeting.animate()
        labelUnderGreeting.animate()
        getStartedButton.animate()
    }
    
    private func animateWidgetsDisappearance() {
        setAnimation(animation: "fadeOut",
                     curve: "easyIn",
                     delay: 0,
                     force: 1,
                     duration: 0.3,
                     widgets: [labelGreeting, labelUnderGreeting, getStartedButton, topImageView])
        
        getStartedButton.animate()
        labelUnderGreeting.animate()
        labelGreeting.animate()
        topImageView.animate()
    }

    @IBAction func didTapGetStarted(_ sender: Any) {
        //animateWidgetsDisappearance()
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //sleep(1)
        performSegue(withIdentifier: "toShoppingList", sender: sender)
        //}
    }
}
