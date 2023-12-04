
import UIKit

class FileUploader: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    enum MimeType: String {
        case image = "image/png"
        case pdfDoc = "application/pdf"
    }
    static var shared = FileUploader()
    private override init() { }
    private let boundary = "Boundary-\(NSUUID().uuidString)"
    private let baseURL = ""
    // Upload Image Method
    func uploadFileOnServerWith(apiName: APIName, imageName: String, fileData: Data, keyForFile: String, parameters: [String:Any]?, mimeType: MimeType = .image, onSuccess:@escaping(_ httpStatus:Int,_ response:Data?)->(), onFailure:@escaping(_ httpStatus:Int,_ response:NSDictionary?)->()){
        let finalURL = baseURL + apiName.rawValue
        guard let requestURL = URL(string: finalURL) else {
            let tmpResponse = ["message": "Incorrect request URL"] as NSDictionary
            onFailure(0, tmpResponse)
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = MethodType.POST.rawValue
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.token {
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        let data = self.createDataBody(withParameters: parameters, media: fileData, boundary: self.boundary, keyForImage: keyForFile, imageName: imageName, mimeType: mimeType)
        
        session.uploadTask(with: urlRequest, from: data) { (tmpdata, response, error) in
            
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
                print(httpStatusCode)
            }
            if error != nil {
                let tmpResponse = ["message": error?.localizedDescription]
                onFailure(httpStatusCode, tmpResponse as NSDictionary)
            } else {
                if httpStatusCode == ResponseCode.sessionExpire {
                    // Refresh Token
                } else if httpStatusCode == ResponseCode.success {
                    let json =   try? JSONSerialization.jsonObject(with: tmpdata!, options: []) as? NSDictionary
                    onSuccess(httpStatusCode, tmpdata)
                } else {
                    do {
                        // convert response into json
                        let json = try JSONSerialization.jsonObject(with: tmpdata!, options: []) as! NSDictionary
                        onFailure(httpStatusCode, json)
                        
                    } catch {
                        let tmpResponse = ["message": "Unable to get json."] as NSDictionary
                        onFailure(httpStatusCode, tmpResponse)
                    }
                }
            }
            
        }.resume()
        
    }
   
   
    private func createDataBody(withParameters params: [String:Any]?, media: Data?, boundary: String, keyForImage:String, imageName:String, mimeType: MimeType) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\("\(value)" + lineBreak)")
            }
        }
       body.append("--\(boundary + lineBreak)")
       body.append("Content-Disposition: form-data; name=\"\(keyForImage)\"; filename=\"\(imageName)\"\(lineBreak)")
       body.append("Content-Type: \(mimeType.rawValue)\r\n\r\n")
       body.append(media!)
       body.append(lineBreak)
       body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    //MARK:- URLSession Delegates
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        let percent = uploadProgress * 100.0
        print(percent)
    }
}

//extension Data {
//    mutating func append(_ string: String) {
//        if let data = string.data(using: .utf8) {
//            append(data)
//        }
//    }
//}
