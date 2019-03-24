//
//  LibraryCollectionCollectionViewController.swift
//  Loquela
//
//  Created by Daniel Duan on 3/23/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class LibraryCollectionCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
            
    var flashcardArray = ["Arabic", "Czech", "Danish", "German", "Greek", "Spanish", "Finnish", "French", "Hebrew", "Hindi", "Hungarian", "Indonesian", "Italian", "Japanese", "Korean", "Dutch", "Norwegian", "Polish", "Portugese", "Romanian", "Russian", "Slovak", "Swedish", "Thai", "Turkish", "Chinese"]
    
    var arabicWordsArray = [WordFlashcard]()
    var czechWordsArray = [WordFlashcard]()
    var danishWordsArray = [WordFlashcard]()
    var germanWordsArray = [WordFlashcard]()
    var greekWordsArray = [WordFlashcard]()
    var spanishWordsArray = [WordFlashcard]()
    var finnishWordsArray = [WordFlashcard]()
    var frenchWordsArray = [WordFlashcard]()
    var hebrewWordsArray = [WordFlashcard]()
    var hindiWordsArray = [WordFlashcard]()
    var hungarianWordsArray = [WordFlashcard]()
    var indoneisanWordsArray = [WordFlashcard]()
    var italianWordsArray = [WordFlashcard]()
    var japaneseWordsArray = [WordFlashcard]()
    var koreanWordsArray = [WordFlashcard]()
    var dutchWordsArray = [WordFlashcard]()
    var norwegianWordsArray = [WordFlashcard]()
    var polishWordsArray = [WordFlashcard]()
    var portugeseWordsArray = [WordFlashcard]()
    var romanianWordsArray = [WordFlashcard]()
    var russianWordsArray = [WordFlashcard]()
    var slovakWordsArray = [WordFlashcard]()
    var swedishWordsArray = [WordFlashcard]()
    var thaiWordsArray = [WordFlashcard]()
    var turkishWordsArray = [WordFlashcard]()
    var chineseWordsArray = [WordFlashcard]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (view.frame.width-64)/3,height: ((view.frame.width-64)/3)+40)


    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return flashcardArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "languageCell", for: indexPath) 
    
        cell.layer.cornerRadius = 3
        cell.layer.masksToBounds = true
        cell.clipsToBounds = true
        
        var titleLabel = cell.contentView.viewWithTag(1) as? UILabel
        if titleLabel == nil {
            titleLabel = UILabel(frame: CGRect(x: 4, y: 4, width: cell.frame.width-8, height: cell.frame.height-8))
            titleLabel!.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            titleLabel!.numberOfLines = 0
            titleLabel!.textAlignment = .center
            titleLabel!.tag = 1
            cell.contentView.addSubview(titleLabel!)
        }
        titleLabel!.text = flashcardArray[indexPath.row]
        
        // cell.languageTitle.text = flashcardArray[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeckViewTableViewController") as? DeckViewTableViewController
        let language = flashcardArray[indexPath.row]
        vc?.navigationBarName = language
        if (language == "Arabic") {
            vc?.flashcardArray = arabicWordsArray
        }
        else if (language == "Czech") {
            vc?.flashcardArray = czechWordsArray
        }
        else if (language == "Danish") {
            vc?.flashcardArray = danishWordsArray
        }
        else if (language == "German") {
            vc?.flashcardArray = germanWordsArray
        }
        else if (language == "Greek") {
            vc?.flashcardArray = greekWordsArray
        }
        else if (language == "Spanish") {
            vc?.flashcardArray = spanishWordsArray
        }
        else if (language == "Finnish") {
            vc?.flashcardArray = finnishWordsArray
        }
        else if (language == "French") {
            vc?.flashcardArray = frenchWordsArray
        }
        else if (language == "Hebrew") {
            vc?.flashcardArray = hebrewWordsArray
        }
        else if (language == "Hindi") {
            vc?.flashcardArray = hindiWordsArray
        }
        else if (language == "Hungarian") {
            vc?.flashcardArray = hungarianWordsArray
        }
        else if (language == "Indonesian") {
            vc?.flashcardArray = indoneisanWordsArray
        }
        else if (language == "Italian") {
            vc?.flashcardArray = italianWordsArray
        }
        else if (language == "Japanese") {
            vc?.flashcardArray = japaneseWordsArray
        }
        else if (language == "Korean") {
            vc?.flashcardArray = koreanWordsArray
        }
        else if (language == "Dutch") {
            vc?.flashcardArray = dutchWordsArray
        }
        else if (language == "Norwegian") {
            vc?.flashcardArray = norwegianWordsArray
        }
        else if (language == "Polish") {
            vc?.flashcardArray = polishWordsArray
        }
        else if (language == "Portugese") {
            vc?.flashcardArray = portugeseWordsArray
        }
        else if (language == "Romanian") {
            vc?.flashcardArray = romanianWordsArray
        }
        else if (language == "Russian") {
            vc?.flashcardArray = russianWordsArray
        }
        else if (language == "Slovak") {
            vc?.flashcardArray = slovakWordsArray
        }
        else if (language == "Swedish") {
            vc?.flashcardArray = swedishWordsArray
        }
        else if (language == "Thai") {
            vc?.flashcardArray = thaiWordsArray
        }
        else if (language == "Turkish") {
            vc?.flashcardArray = turkishWordsArray
        }
        else if (language == "Chinese") {
            vc?.flashcardArray = chineseWordsArray
        }
        
        
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let identifier = segue.identifier else { return }
//
//        if identifier == "displayWords" {
//            guard let indexPath = collectionView.indexPathsForSelectedItems else {return}
//            let destination = segue.destination as! DeckViewTableViewController
//
//            destination.flashcardArray = arrayToSend
//        }
//
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
