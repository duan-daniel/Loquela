//
//  DeckViewTableViewCell.swift
//  Loquela
//
//  Created by Daniel Duan on 3/23/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit

protocol MyCellDelegate: class {
    func didTapButton(_ sender: DeckViewTableViewCell)
}

class DeckViewTableViewCell: UITableViewCell {
    
    var delegate: MyCellDelegate?

    @IBOutlet weak var englishWord: UILabel!
    @IBOutlet weak var translatedWord: UILabel!
    @IBOutlet weak var viewOfContent: UIView!
    @IBOutlet weak var btn: UIButton!
    

    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.didTapButton(self)
    }
    
    
    
}
