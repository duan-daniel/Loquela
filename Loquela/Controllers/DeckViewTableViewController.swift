//
//  DeckViewTableViewController.swift
//  Loquela
//
//  Created by Daniel Duan on 3/23/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit
import AVFoundation
import StatefulViewController

class DeckViewTableViewController: UITableViewController, MyCellDelegate, StatefulViewController {

    var flashcardArray = [WordFlashcard]()
    var navigationBarName = ""
    
    // for state controller
    let emptyStateView = UIView()
    let noStateView = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        // set up empty data set
        createEmptyView()
        
        let stateMachine = ViewStateMachine(view: view)
        stateMachine["empty"] = emptyStateView
        stateMachine["none"] = noStateView
        
        // if there is at least one object in the memories array
        if flashcardArray != nil && flashcardArray.count > 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

            stateMachine.transitionToState(.view("none"), animated: true) {
            }
        }
            // if memories array is empty, display the empty state view
        else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

            stateMachine.transitionToState(.view("empty"), animated: true) {
            }
        }
        
        tableView.reloadData()
    }
    
    func createEmptyView() {
        let emptyStateLabel = UILabel()
        emptyStateLabel.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: 120)
        emptyStateLabel.text = "Go and translate some languages!"
        emptyStateLabel.textAlignment = .center
        
        emptyStateView.addSubview(emptyStateLabel)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = navigationBarName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Practice", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DeckViewTableViewController.studyDeck))


        tableView.rowHeight = 80.5
        tableView.separatorStyle = .none
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return flashcardArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as! DeckViewTableViewCell

        // Configure the cell...
        cell.delegate = self
        cell.viewOfContent.layer.cornerRadius = 10
        cell.viewOfContent.layer.masksToBounds = true
        
        cell.englishWord.text = flashcardArray[indexPath.row].englishWord
        cell.translatedWord.text = flashcardArray[indexPath.row].translatedWord

        return cell
    }
    
    func didTapButton(_ sender: DeckViewTableViewCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        let newWord = flashcardArray[tappedIndexPath.row].translatedWord
        let languageCode = flashcardArray[tappedIndexPath.row].languageCode
        let utterance = AVSpeechUtterance(string: newWord)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)

    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let identifier = segue.identifier else { return }
//
//        if identifier == "goPractice" {
//            guard let indexPath = tableView.indexPathForSelectedRow else { return }
//            let destination = segue.destination as! PracticeViewController
//
//            destination.cardArray = flashcardArray
//
//        }
//    }
    
    @objc func studyDeck() {
         let vc = PracticeViewController()
         vc.cardArray = flashcardArray
        present(UINavigationController(rootViewController:vc), animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

}
