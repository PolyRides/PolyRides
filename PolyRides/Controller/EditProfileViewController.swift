//
//  EditProfileViewController.swift
//  PolyRides
//
//  Created by Vanessa Forney on 4/1/16.
//  Copyright © 2016 Vanessa Forney. All rights reserved.
//

protocol EditProfileDelegate: class {

  func onProfileSaved()

}

class EditProfileViewController: UIViewController {

  let emptyDescription = "Enter a short description about yourself."
  let userService = UserService()

  var delegate: EditProfileDelegate?
  var user: User?

  @IBOutlet weak var makeLabel: UITextField?
  @IBOutlet weak var modelLabel: UITextField?
  @IBOutlet weak var yearLabel: UITextField?
  @IBOutlet weak var colorLabel: UITextField?
  @IBOutlet weak var descriptionTextView: UITextView?

  @IBAction func cancelButtonAction(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func saveButtonAction(sender: AnyObject) {
    user?.car = Car(make: makeLabel?.text, model: modelLabel?.text, year: yearLabel?.text, color: colorLabel?.text)
    if descriptionTextView?.text != emptyDescription {
      user?.description = descriptionTextView?.text
    }
    if let user = user {
      userService.updateProfile(user)
      delegate?.onProfileSaved()
    }
    dismissViewControllerAnimated(true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    descriptionTextView?.text = user?.description ?? emptyDescription
    makeLabel?.text = user?.car?.make
    modelLabel?.text = user?.car?.model
    colorLabel?.text = user?.car?.color

    if let year = user?.car?.year {
      yearLabel?.text = "\(year)"
    }
  }

}
