//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Zhihang Zhang on 2018-04-22.
//  Copyright © 2018 Zhihang Zhang. All rights reserved.
//

import UIKit
import os.log


class MealViewController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        // i.e. some of the work of the text field is now delegated to this
        // controller. e.g. what to do when return is tapped; what to do after the press of return
        // these should be defined in the protocol functions below
        nameTextField.delegate = self
        
        
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        
        // enable the save button only if the text field has a valid meal name
        updateSaveButtonState()
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    
    
    
    //MARK: UITextFieldDelegate
    
    // get called when an editing session begins OR when the keyboard gets displayed
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false // disable the save button while editing
    }
    
    // get called when tapping the return key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        // return true because the system needs to process the press of the return key
        return true
    }
    
    // get called when the text field resigns its first responder status
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    // get called when the user pressed the cancel button on the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    // get called when the user select a photo
    // a chance to do something with the image or images that a user selected from the picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // set the photoview to be the selected image
        photoImageView.image = selectedImage
        
        
        // Dismiss the picker.
        // gets called on the picker controller
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        
    }
    
    
    // this method lets you configure a view controller before it is prepared
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed
        // check if button is pressed and the button has the identifier saveButton
        guard let button = sender  as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling", log: OSLog.default,
                   type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""  // The nil coalescing operator is used to return the value of an optional if the optional has a value, or return a default value otherwise.
        let photo = photoImageView.image // photo is optional
        let rating = ratingControl.rating // rating is 0 by default
        
        // set the meal to be passed to MealTableViewController after the unwind segue
        meal = Meal(name: name, photo: photo, rating: rating)
        
    }
    
    
    
    
    //MARK: Actions
    //get called when the image is tapped
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        // this is for handling the case where the user taps the image while typing in the text field
        nameTextField.resignFirstResponder() //MARK: CONFUSION
        // not sure if the meal label will be set or not
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is **notified** when the user picks an image.
        /*
         Because ViewController will be in charge of presenting the image picker
         controller, it also needs to adopt the UINavigationControllerDelegate
         protocol, which simply lets ViewController take on some basic navigation
         responsibilities.
         */
        imagePickerController.delegate = self
        
        // ask the current controller to present the image picker controller with animation and without any closure to execure when it finishes
        present(imagePickerController, animated: true, completion: nil)

    }
    

    //MARK: Private Methods
    private func updateSaveButtonState(){
        // disable the button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    


}

