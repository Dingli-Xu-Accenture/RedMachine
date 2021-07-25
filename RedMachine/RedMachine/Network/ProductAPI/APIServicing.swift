import Foundation
import RxSwift

protocol APIServicing {
    /// fetch product list with  pageSize (Current API doesn't support `page`)
    ///
    /// - Parameters:
    /// - pageSize: page size
    /// - direction: direction of items in list, should be ASC or DESC
    /// - fieldName: no idea about this means, should be code or entity_id
    /// - fields: item in response with keys we need, eg. item[sku, name, price]
    func fetchProductsList(pageSize: Int, direction: String, fieldName: String, fields: String) -> Single<ProductList?>
    
    /// fetch product with sku
    ///
    /// - Parameters:
    /// - sku: product's stock keeping unit
    func fetchProduct(sku: String) -> Single<Product?>
    
    
    /// Login to get token
    ///
    /// - Parameters:
    /// - userName: user name
    /// - password: user password
    func login(userName: String, password: String) -> Single<String?>
}
