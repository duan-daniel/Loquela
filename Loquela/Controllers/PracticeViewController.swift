//
//  PracticeViewController.swift
//  Loquela
//
//  Created by Daniel Duan on 3/23/19.
//  Copyright © 2019 Daniel Duan. All rights reserved.
//

import UIKit

class PracticeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {

    var cardArray = [WordFlashcard]()
        
    var collectionView: UICollectionView!
    var currentCardIndex:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flashcards"
    
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(PracticeViewController.cancel))
        
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: view.frame.width, height: view.frame.height-(navigationController?.navigationBar.frame.height)!-64)
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flow)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.white
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.scrollToItem(at: IndexPath(row:0, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)

        currentCardIndex = UILabel(frame: CGRect(x: 16, y: view.frame.height-38, width: view.frame.width-32, height: 16))
        currentCardIndex.textAlignment = .center
        currentCardIndex.text = "[0] out of \(cardArray.count - 1)"
        currentCardIndex.textColor = UIColor.lightGray
        view.addSubview(currentCardIndex)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.white

        var background = cell.contentView.viewWithTag(1)
        if background == nil {
            background = UIView(frame: cell.contentView.frame.insetBy(dx: 16, dy: 16))
            background!.tag = 1
            background!.backgroundColor = UIColor(white: 0.95, alpha: 1)
            background?.layer.cornerRadius = 8
            cell.contentView.addSubview(background!)
        }
        
        var question = background!.viewWithTag(2) as? UILabel
        if question == nil {
            question = UILabel(frame: CGRect(x: 16, y: 16, width: background!.frame.width-32, height: background!.frame.height-32))
            question!.textColor = UIColor(white: 0.5, alpha: 1)
            question!.numberOfLines = 0
            question!.textAlignment = .center
            question!.font = UIFont(name: (question?.font?.fontName)!, size: 25)
            question!.tag = 2
            question!.alpha = 1
            background?.addSubview(question!)
        }
        question?.alpha = 1
        question?.text = cardArray[indexPath.row].englishWord
        
        var answer = background!.viewWithTag(3) as? UILabel
        if answer == nil {
            answer = UILabel(frame: CGRect(x: 16, y: 16, width: background!.frame.width-32, height: background!.frame.height-32))
            answer!.textColor = UIColor(white: 0.5, alpha: 1)
            answer!.numberOfLines = 0
            answer!.textAlignment = .center
            answer!.font = UIFont(name: (answer?.font?.fontName)!, size: 25)
            answer!.tag = 3
            answer!.alpha = 0
            answer!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PracticeViewController.didTapTextView(_:))))
            background?.addSubview(answer!)
        }
        answer?.alpha = 0
        answer?.text = cardArray[indexPath.row].translatedWord
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        flipCell(indexPath)
    }
    
    @objc func didTapTextView(_ tap:UITapGestureRecognizer) {
        
        flipCell(collectionView.indexPathForItem(at: tap.location(in: collectionView))!)
        
    }
    
    func flipCell(_ indexPath:IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let background = cell?.contentView.viewWithTag(1)
        let question = background?.viewWithTag(2) as! UILabel
        let answer = background?.viewWithTag(3) as! UILabel
        if question.alpha == 1 {
            question.alpha = 0
            answer.alpha = 1
        }else{
            question.alpha = 1
            answer.alpha = 0
        }
        UIView.transition(with: background!, duration: 0.3, options: [.allowUserInteraction, .transitionFlipFromTop] , animations: {
            
        }, completion: nil)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        let trashStr = indexPath
        let indexStartOfText = trashStr.index(indexPath.startIndex, offsetBy:  1)
        let subStr = trashStr[indexStartOfText...]

        currentCardIndex.text = "\(subStr) out of \(cardArray.count - 1)"
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
        

}

