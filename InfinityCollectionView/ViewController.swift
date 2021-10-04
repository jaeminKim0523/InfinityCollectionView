//
//  ViewController.swift
//  InfinityCollectionView
//
//  Created by 김재민 on 2021/10/04.
//

import UIKit

class ViewController: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    private var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.scrollDirection = scrollDirection
            }
            collectionView.reloadData()
        }
    }
    
    public var minZoomScale: CGFloat = 1.0 {
        didSet {
            self.collectionView.visibleCells.forEach{ ($0 as! ImagePreviewerCell).minZoomScale = minZoomScale }
        }
    }
    
    public var maxZoomScale: CGFloat = 2.0 {
        didSet {
            self.collectionView.visibleCells.forEach{ ($0 as! ImagePreviewerCell).maxZoomScale = maxZoomScale }
        }
    }
    
    public var currentIdx: Int = 0 {
        didSet {
            collectionView.scrollToItem(at: IndexPath(row: images.count + currentIdx, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    public var cellSize: CGSize = .zero {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var cellSpacing: CGFloat = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var isPaging: Bool = false {
        didSet {
            collectionView.isPagingEnabled = isPaging
        }
    }
    
    private var images: [UIImage] = [UIImage(named: "ryan1")!, UIImage(named: "ryan2")!, UIImage(named: "ryan3")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureUserInterface()
        configureCollectionView()
    }
    
    func configureUserInterface() {
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func configureCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = scrollDirection
        }
        
        let cell = UINib(nibName: "ImagePreviewerCell", bundle: Bundle(for: type(of: self)))
        collectionView.register(cell, forCellWithReuseIdentifier: "ImagePreviewerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.isPagingEnabled = false
        
        collectionView.scrollToItem(at: IndexPath(row: images.count, section: 0), at: .centeredVertically, animated: false)
    }

}

extension ViewController: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollDirection == .horizontal {
            let contentWidth = scrollView.contentSize.width
            let itemWidth = contentWidth / 3
            
            if scrollView.contentOffset.x < itemWidth {
                scrollView.contentOffset.x = itemWidth * 2
            } else if scrollView.contentOffset.x > (itemWidth * 2) {
                scrollView.contentOffset.x = itemWidth
            }
        } else {
            let contentHeight = scrollView.contentSize.height
            let itemHeight = contentHeight / 3
            
            if scrollView.contentOffset.y < itemHeight {
                scrollView.contentOffset.y = itemHeight * 2
            } else if scrollView.contentOffset.y > (itemHeight * 2) {
                scrollView.contentOffset.y = itemHeight
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIdx = collectionView.indexPathForItem(at: CGPoint(x: scrollView.contentOffset.x + ((scrollView.contentSize.width / CGFloat(images.count)) / 2), y: scrollView.contentOffset.y + ((scrollView.contentSize.height / CGFloat(images.count)) / 2)))
        if let idx = currentIdx?.row {
            self.currentIdx = idx - (images.count + 1)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count * 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImagePreviewerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePreviewerCell", for: indexPath) as! ImagePreviewerCell
        let idx: Int = indexPath.row % images.count
        
        cell.image = images[idx]
        cell.minZoomScale = minZoomScale
        cell.maxZoomScale = maxZoomScale
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
