//
//  ViewController.swift
//  MemeMe
//
//  Created by Aaron Wagner on 12/6/15.
//  Copyright © 2015 Aaron Wagner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var albumBtn: UIBarButtonItem!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    
    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    override func viewDidLoad() {
        cameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        setTextFieldAttributes(topText)
        setTextFieldAttributes(bottomText)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (bottomText.isFirstResponder()) {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (bottomText.isFirstResponder()) {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeImage.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.tag == 1 && textField.text != "TOP") {
           textField.text = ""
        }
        if (textField.tag == 2 && textField.text != "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setTextFieldAttributes(textField: UITextField) {
        let attributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ]
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: attributes)
        textField.defaultTextAttributes = attributes
        textField.textAlignment = .Center
        textField.delegate = self
    }
    
    func presentImagePicker(source: UIImagePickerControllerSourceType) {
        let imagePick = UIImagePickerController()
        imagePick.sourceType = source
        imagePick.delegate = self
        self.presentViewController(imagePick, animated: true, completion: nil)
    }
    
    func makeMemeImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }

    @IBAction func shareMeme(sender: AnyObject) {
        let newMeme = self.makeMemeImage()
        let activityVC = UIActivityViewController(activityItems: [newMeme], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func pickFromCamera(sender: AnyObject) {
        presentImagePicker(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func pickFromAlbums(sender: AnyObject) {
        presentImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
    }
}

