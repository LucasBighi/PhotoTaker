//
//  PhotoServiceViewController.swift
//  Utils
//
//  Created by Lucas Bighi on 26/02/21.
//  Copyright © 2021 Lucas Marques Bighi. All rights reserved.
//

import UIKit

public protocol PhotoServiceDelegate: NSObjectProtocol {
    func didSelectImage(_ image: UIImage)
}

private let reuseIdentifier = "PhotoCell"

public class PhotoServiceViewController: UIViewController {
    
    var dragger: UIView!
    var contentView: UIView!
    var collectionView: UICollectionView!
    var cameraButton: UIButton!
    var cancelButton: UIButton!
    
    var service: PhotoService!
    
    public weak var delegate: PhotoServiceDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupContentView()
        setupCameraButton()
        setupCancelButton()
        setupCollectionView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        if let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            service = PhotoService(assetThumbnailSize: layout.itemSize)
        }
        
        collectionView.reloadData()
    }
    
    private func setupContentView() {
        contentView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        contentView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupCancelButton() {
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cancelButton)
        cancelButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    }
    
    private func setupCameraButton() {
        cameraButton = UIButton()
        cameraButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        cameraButton.addTarget(self, action: #selector(capturePhotoAction(_:)), for: .touchUpInside)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cameraButton)
        cameraButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cameraButton.heightAnchor.constraint(equalTo: cameraButton.widthAnchor).isActive = true
        cameraButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        cameraButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

    @objc private func capturePhotoAction(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            guard UIImagePickerController.availableCaptureModes(for: .rear) != nil else {
                fatalError("Couldn`t access the camera.")
            }
            
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
    
    @objc private func dismissView() {
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: 200)
        } completion: {_ in
            self.dismiss(animated: false)
        }
    }
}

extension PhotoServiceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return service.numberOfAssets()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        service.requestImage(forAssetAtPosition: indexPath.row) { image in
            if let image = image,
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell {
                cell.setup(with: image)
            }
        }

        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        service.requestImage(forAssetAtPosition: indexPath.row) { image in
            if let image = image {
                self.delegate?.didSelectImage(image)
            }
        }
        dismissView()
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension PhotoServiceViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            delegate?.didSelectImage(image)
        }
        picker.dismiss(animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
