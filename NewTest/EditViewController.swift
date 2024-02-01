//
//  EditViewController.swift
//  NewTest
//
//  Created by D. P. on 31.01.2024.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private let manager = CoreManager.shared
    var note: Notes?
    var tmpImage: Data?
   
    //MARK: - элементы вью
    lazy var titleTf: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemFill
        textField.placeholder = "Заголовок"
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    lazy var textViewNote: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.imageView?.tintColor = .systemGray
        button.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        return button
    }()
    
    lazy var imageView: UIImageView = {
       let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 10
        imgView.layer.borderWidth = 1
        imgView.clipsToBounds = true

        return imgView
    }()
    
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Setup view
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(button)
        view.addSubview(titleTf)
        view.addSubview(textViewNote)
        
        
        if let note = self.note {
            titleTf.text = note.title
            textViewNote.text = note.text
        }
        
        saveButtonSetup()
        
        NSLayoutConstraint.activate([
            titleTf.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTf.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleTf.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            titleTf.heightAnchor.constraint(equalToConstant: 50),
            
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            button.leadingAnchor.constraint(equalTo: titleTf.trailingAnchor, constant: 5),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 50),
            
            textViewNote.topAnchor.constraint(equalTo: titleTf.bottomAnchor),
            textViewNote.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textViewNote.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textViewNote.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        // проверяем наличие изображения и устанавливаем его во вью
        if let imgData = note?.image {
            imageView.image = UIImage(data: imgData)
            imageView.contentMode = .scaleAspectFill
            setupImgView()
        }
    }
    
    func setupImgView() {
          if let x = tmpImage {
                imageView.image = UIImage(data: x)
                imageView.contentMode = .scaleAspectFill
            }
        view.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(lessThanOrEqualTo: textViewNote.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                imageView.heightAnchor.constraint(equalToConstant: 250),
                imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    
    //MARK: - кнопка сохранения заметки
    private func saveButtonSetup() {
        let saveButton = UIButton(type: .custom)
        saveButton.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
        saveButton.imageView?.tintColor = .systemGray
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let uIBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = uIBarButton
    }
    
    @objc func saveButtonTapped() {
        //проверям новая заметка или редактируемая
        if note == nil {
            //проверяем на наличие изображения
            if let noteImg = tmpImage {
                //картинка есть
                manager.addNewNote(title: titleTf.text ?? "", noteText: textViewNote.text, image: noteImg)
                navigationController?.popViewController(animated: true)
            } else {
                //картинки нет
                manager.addNewNote(title: titleTf.text ?? "", noteText: textViewNote.text)
                navigationController?.popViewController(animated: true)
            }
        } else {
            if let noteImg = tmpImage {
                //картинка есть
                note?.updateNote(title: titleTf.text ?? "", noteText: textViewNote.text, image: noteImg )
                navigationController?.popViewController(animated: true)
            } else {
                //картинки нет
                note?.updateNote(title: titleTf.text ?? "", noteText: textViewNote.text)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: - кнопка вложения картинки
    @objc func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Add Image", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Choose from Library", style: .default) { action in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "Take Photo", style: .default) { action in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            tmpImage = selectedImage.jpegData(compressionQuality: 1)
        }
        picker.dismiss(animated: true, completion: nil)
        setupImgView()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
