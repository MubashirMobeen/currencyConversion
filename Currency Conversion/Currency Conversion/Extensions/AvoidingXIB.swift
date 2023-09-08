//
//  AvoidingXIB.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 05/08/2023.
//

import Foundation
import UIKit

@objc extension UIViewController {
    public static var reuseIdentifier: String { String(describing: self) }

    public static func viewController(fromBoard sb: UIStoryboard) -> Self {
        guard let vc = sb.instantiateViewController(withIdentifier: reuseIdentifier) as? Self else {
            fatalError("could not initialize viewcontroller \(Self.self) with identifier \(reuseIdentifier) from storyboard \(sb)")
        }
        return vc
    }
}

@objc extension UIView {
    public static var reuseIdentifier: String { String(describing: self) }
    
    public static var nib: UINib { UINib(nibName: reuseIdentifier, bundle: nil) }
    
    public static func viewFromNib() -> Self {
        guard let view = Bundle.main.loadNibNamed(reuseIdentifier, owner: nil, options: nil)?.first as? Self else {
            fatalError("Could not initialize view \(Self.self) with identifier \(reuseIdentifier)")
        }
        return  view
    }
}

@objc extension UITableViewCell {
    
    /// Use this if NOT using XIB
    public static func registerCell(with tableView: UITableView) {
        tableView.register(Self.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    /// Use this if using XIB
    public static func registerCellNib(with tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }

    public static func dequeueCell(from tableView: UITableView, atIndexPath indexPath: IndexPath) -> Self {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Self else {
            fatalError("Could not dequeue cell of type \(Self.self) with identifier \(reuseIdentifier)")
        }
        return cell
    }
}

@objc extension UITableViewHeaderFooterView {
    
    /// Use this if NOT using XIB
    public static func registerHeaderFooter(with tableView: UITableView) {
        tableView.register(Self.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    /// Use this if using XIB
    public static func registerHeaderFooterNib(with tableView: UITableView) {
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    public static func dequeueHeaderFooter(from tableView: UITableView) -> Self {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? Self else {
            fatalError("could not dequeue headerFooter of type \(Self.self) with identifier \(reuseIdentifier)")
        }
        return view
    }
}

@objc extension UICollectionViewCell {
    /// Use this if NOT using XIB
    public static func registerCell(with collectionView: UICollectionView) {
        collectionView.register(Self.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    /// Use this if using XIB
    public static func registerCellNib(with collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }

    public static func dequeueCell(from collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> Self {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? Self else {
            fatalError("Could not dequeue cell of type \(Self.self) with identifier \(reuseIdentifier)")
        }
        return cell
    }
}

@objc extension UICollectionReusableView {
    /// Use this if using XIB
    public static func registerSectionHeaderNib(with collectionView: UICollectionView) {
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
    }
    
    /// Use this if NOT using XIB
    public static func registerSectionHeader(with collectionView: UICollectionView) {
        collectionView.register(Self.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
    }

    public static func dequeueHeader(from collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> Self {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier, for: indexPath) as? Self else {
            fatalError("Could not dequeue header view of type \(Self.self) with identifier \(reuseIdentifier)")
        }
        return cell
    }

    /// Use this if NOT using XIB
    public static func registerSectionFooter(with collectionView: UICollectionView) {
        collectionView.register(Self.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifier)
    }
    
    /// Use this if using XIB
    public static func registerSectionFooterNib(with collectionView: UICollectionView) {
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifier)
    }

    public static func dequeueFooter(from collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> Self {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifier, for: indexPath) as? Self else {
            fatalError("could not dequeue footer view of type \(Self.self) with identifier \(reuseIdentifier)")
        }
        return view
    }
}
