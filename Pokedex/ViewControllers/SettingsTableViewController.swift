//
//  SettingsTableViewController.swift
//  Pokedex
//
//  Created by Nikola Majcen on 05/08/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import SCLAlertView

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var gameModeSwitch: UISwitch!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    @IBAction func changeGameStatus(sender: UISwitch) {
        UserDefaultsManager.gameMode = sender.on
    }
    
    private func initializeUI() {
        usernameLabel.text = UserDefaultsManager.trainerName
        gameModeSwitch.on = UserDefaultsManager.gameMode
    }
    
    private func showChangeUsernameWindow(title: String, message: String) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let changeUsernameWindow = SCLAlertView(appearance: appearance)
        let textField = changeUsernameWindow.addTextField("Enter username...")
        changeUsernameWindow.addButton("Confirm") {
            self.usernameLabel.text = textField.text
            UserDefaultsManager.trainerName = textField.text
        }
        changeUsernameWindow.addButton("Cancel") { }
        performUpdatesOnMain { 
            changeUsernameWindow.showEdit(title, subTitle: message)
        }
    }
    
    private func showMessageWindow(title: String, message: String) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let messageWindow = SCLAlertView(appearance: appearance)
        messageWindow.addButton("Yes") { 
            let manager = DatabaseManager()
            manager.deleteAllPokemons()
        }
        messageWindow.addButton("No") { }
        performUpdatesOnMain { 
            messageWindow.showError(title, subTitle: message)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            showChangeUsernameWindow("Change username", message: "Please enter new username:")
        } else if indexPath.section == 0 && indexPath.row == 2 {
            showMessageWindow("Clear game data", message: "Are you really want to delete current game data?")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
