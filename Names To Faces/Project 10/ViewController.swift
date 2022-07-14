//
//  ViewController.swift
//  Project 10
//
//  Created by Andrew Emad on 11/07/2022.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var persons = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persons.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("can't dequeue cells.")
        }
        let currentPerson = persons[indexPath.item]
        let imagePathURL = getDocumentsDirectory().appendingPathComponent(currentPerson.image)
        cell.changeImage(imagePath: imagePathURL.path)
        cell.changeLabel(name: currentPerson.name)
        cell.layer.cornerRadius = 7
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Rename Person OR Delete Person", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .default){ [weak self] _ in
            DispatchQueue.main.async {
                self?.deletePerson(indexPath: indexPath)
            }
        }
        let rename = UIAlertAction(title: "Rename", style: .default){ [weak self] _ in
            DispatchQueue.main.async {
                self?.renamePersonAlert(indexPath: indexPath)
            }
        }
        alert.addAction(rename)
        alert.addAction(delete)
        present(alert, animated: true)
    }
    
    @objc func addPerson(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 1){
            try? jpegData.write(to: imagePath)
        }
        let newUser = Person(name: "UNKNOWN", image: imageName)
        persons.append(newUser)
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func renamePersonAlert(indexPath : IndexPath){
        let person = persons[indexPath.item]
        
        let alert = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        let submit = UIAlertAction(title: "OK", style: .default){ [weak self , weak alert] _ in
            guard let text = alert?.textFields?[0].text else {return}
            person.name = text
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        alert.addAction(submit)
        present(alert, animated: true)
    }
    func deletePerson(indexPath : IndexPath){
        persons.remove(at: indexPath.item)
        collectionView.reloadData()
    }
}

