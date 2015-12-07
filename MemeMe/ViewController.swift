//
//  ViewController.swift
//  MemeMe
//
//  Created by Aaron Wagner on 12/6/15.
//  Copyright © 2015 Aaron Wagner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var albumBtn: UIBarButtonItem!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    
    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    override func viewDidLoad() {
        cameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        shareBtn.enabled = false
        setupTextFields(topText)
        setupTextFields(bottomText)
        super.viewDidLoad()
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
    
    func setupTextFields(field: UITextField) {
        let attributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ]
        field.defaultTextAttributes = attributes
        field.textAlignment = .Center
    }

    @IBAction func pickFromCamera(sender: AnyObject) {
        let imagePick = UIImagePickerController()
        imagePick.delegate = self
        self.presentViewController(imagePick, animated: true, completion: nil)
    }
    
    @IBAction func pickFromAlbums(sender: AnyObject) {
        let imagePick = UIImagePickerController()
        imagePick.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePick.delegate = self
        self.presentViewController(imagePick, animated: true, completion: nil)
    }
}

