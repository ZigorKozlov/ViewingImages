//
//  ViewController.swift
//  UIMenuTest
//
//  Created by Игорь Козлов on 14.03.2021.
//

import UIKit

class AlbumViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Animal>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Album"
        configurateHierarchy()
        configurateDataSource()
    }
}


extension AlbumViewController {
    func createLayut() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configurateHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayut())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.reuseIdetifire)
        view.addSubview(collectionView)
    }
}

extension AlbumViewController {
    func configurateDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Animal>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, animal) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseIdetifire, for: indexPath) as? AlbumCell else { fatalError("Could not create cell")}
            
            cell.imageView.image = UIImage(named: animal.name)
            
            return cell
        })
        
        createSnapShot()
    }
    
    func createSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Animal>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(animals)
        
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

extension AlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configurateContextMenu()
    }
    
    func configurateContextMenu() -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let copy = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc"), identifier: nil, discoverabilityTitle: nil, state: .off) { (action) in
                print("COPY")
            }
            
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, discoverabilityTitle: nil, state: .off) { (action) in
                print("SHARE")
            }
            
            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [copy, share])
        }
        return context
    }
}
