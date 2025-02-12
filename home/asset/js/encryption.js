// encryption.js (암호화된 연결 정보를 저장하는 JavaScript 파일)
const encryptedDBInfo = "QW5jcnlwdGVkRGF0YUJhc2VDb25uZWN0aW9uSW5mbw==";

// 서버에서 복호화 키를 받아 복호화
function decryptDBInfo(encryptedInfo, decryptionKey) {
    const bytes = CryptoJS.AES.decrypt(encryptedInfo, decryptionKey);
    return bytes.toString(CryptoJS.enc.Utf8);
}

// 복호화 후 사용할 정보
const decryptionKey = "your-strong-key"; // 서버와 공유된 키
const dbInfo = decryptDBInfo(encryptedDBInfo, decryptionKey);

// 예제 출력 (보안상 실제 코드는 DB 연결에만 사용하세요)
console.log(dbInfo);
