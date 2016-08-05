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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameModeSwitch.on = UserDefaultsManager.gameMode
    }
    
    @IBAction func changeGameStatus(sender: UISwitch) {
        UserDefaultsManager.gameMode = sender.on
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
        dispatch_async(dispatch_get_main_queue()) { 
            messageWindow.showError(title, subTitle: message)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            showMessageWindow("Clear game data",
                              message: "Are you really want to delete current game data?")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
