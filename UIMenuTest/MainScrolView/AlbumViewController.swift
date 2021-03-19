//
//  ViewController.swift
//  UIMenuTest
//
//  Created by Игорь Козлов on 14.03.2021.
//

import UIKit

class AlbumViewController: UIViewController {
    var testView: UIView!
    
    var activityViewCOntroller: UIActivityViewController?
    private enum Section {
        case main
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Animal>!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.navigationItem.title = NSLocalizedString("Album", comment: "")
        configurateHierarchy()
        configurateDataSource()
    }
}


extension AlbumViewController {
    private func createLayut() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configurateHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayut())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.reuseIdetifire)
        view.addSubview(collectionView)
    }
}

extension AlbumViewController {
    private func configurateDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Animal>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, animal) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseIdetifire, for: indexPath) as? AlbumCell else { fatalError("Could not create cell")}
            
            cell.imageView.image = UIImage(named: animal.name)
            
            return cell
        })
        
        createSnapShot()
    }
    
    private func createSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Animal>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(animals)
        
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

extension AlbumViewController: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configurateContextMenu(indexPath: indexPath)
    }
    
    private func configurateContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let copy = UIAction(title: NSLocalizedString("Copy", comment: ""), image: UIImage(systemName: "doc.on.doc"), identifier: nil, discoverabilityTitle: nil, state: .off) { (action) in
                print("COPY")
            }
            
            let share = UIAction(title: NSLocalizedString("Share", comment: ""), image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] (action) in
                if let image = UIImage(named: animals[indexPath.row].name){
                    let items: [Any] = [image]
                    self?.activityViewCOntroller = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    if let activityViewCOntroller = self?.activityViewCOntroller {
                        self?.present(activityViewCOntroller, animated: true, completion: nil)
                    }
                }
            }
            
            return UIMenu(title: NSLocalizedString("Options", comment: ""), image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [copy, share])
        }
        return context
    }
}

//show SingleVCRepository
extension AlbumViewController {
    func presentSingleImageVC(image: UIImage, imageRect: CGRect) {
        let viewController = SingleImageViewController()
        viewController.image = image
        viewController.inputImageRect = imageRect
        viewController.modalPresentationStyle = .overCurrentContext //
        present(viewController, animated: true, completion: nil)
    }
}
