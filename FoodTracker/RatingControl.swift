//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Zhihang Zhang on 2018-04-24.
//  Copyright © 2018 Zhihang Zhang. All rights reserved.
//

import UIKit

// IBDesignable lets Interface Builder instantiate and draw a copy of your control directly in the canvas.
@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    
    //By leaving it as internal access (the default), you can access it from any other class inside the app.
    var rating = 0 {
        didSet{
            updateButtonSelectionStates()
        }
    }
    
    // specify properties that can then be set in the Attributes inspector
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet{
            // gets called when the property is set
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }
    
    
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
       
        // Real Implementation of Tapping the Buttons
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        print("Button \(index) pressed 👍")
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    private func setupButtons(){
        // clear any existing buttons
        for button in ratingButtons{
            removeArrangedSubview(button) // Removes the provided view from the stack’s array of arranged subviews.
            button.removeFromSuperview() // Unlinks the view from its superview and its window, and removes it from the responder chain.
        }
        ratingButtons.removeAll()
        
        
        // load Button Images
        /*
         However, because the control is @IBDesignable, the setup code also needs to run in Interface
         Builder. For the images to load properly in Interface Builder, you must explicitly specify the
         catalog’s bundle
         */
        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        // creating five buttons and add them to the stack view
        for index in 0..<starCount{
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false //The first line of code disables the button’s automatically generated constraints.
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the button action
            // 1st arg: the obj whose action method is called
            // 2nd arg: a selector that identifies the method to call
            // 3rd arg: when (which event) to call the action method
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        // the rating is zero at the beginning so all buttons will be unselected
        updateButtonSelectionStates()

    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
    
}
