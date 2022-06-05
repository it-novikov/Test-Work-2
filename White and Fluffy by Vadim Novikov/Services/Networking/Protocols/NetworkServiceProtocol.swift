//
//  NetworkServiceProtocol.swift
//  White and Fluffy by Vadim Novikov
//
//  Created by Vadim Novikov on 05.06.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func getRandomImages(completion: @escaping (Data?, Error?) -> Void)
    func getSearchImages(searchText: String, completion: @escaping (Data?, Error?) -> Void)
    func getInfoOfImage(id: String?, completion: @escaping (Data?, Error?) -> Void)
}
