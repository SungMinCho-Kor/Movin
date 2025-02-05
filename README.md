## Movin

```
영화를 쉽고 빠르게 검색하고 좋아하는 영화를 저장할 수 있는 영화 정보 서비스입니다.
```

### 📅 개발 기간
25.01.27 - 25.02.01 (6일)

<br>

### 👥 인원
iOS 1명

<br>

### 📱 앱 기능

|닉네임 설정|프로필 이미지 설정|프로필 수정|
|:-:|:-:|:-:|
|![온보딩+닉네임로직](https://github.com/user-attachments/assets/0d85a44d-1c2a-47fd-a498-cfef64ffab24)|![프로필이미지+온보딩종료](https://github.com/user-attachments/assets/d60c72d8-5fb8-452f-b773-0985defb4290)|![홈+프로필수정](https://github.com/user-attachments/assets/ae7b6977-fd3f-469f-8c7e-dc4109ec20e6)|

|홈 (최근 검색어X)|검색 및 상세|홈 (최근 검색어)|
|:-:|:-:|:-:|
|![홈+스크롤+좋아요](https://github.com/user-attachments/assets/793dd782-0599-4720-b3e5-f2380962e5e3)|![홈+검색+상세보기+돌아오기2](https://github.com/user-attachments/assets/74a71179-6e33-415d-a9b6-0c469be07c6b)|![홈+최근검색어+삭제](https://github.com/user-attachments/assets/4cc95ff1-ed34-4e6a-8118-b56da83cdddc)|

|탈퇴|
|:-:|
|![마이페이지+탈퇴](https://github.com/user-attachments/assets/1b3df06c-b27b-4be9-81d3-36a20990c990)|

<br>

### 🛠 기술 스택
- UIKit
- Alamofire
- SnapKit
- KingFisher

### 🔍 기술 활용 상세

<b>네트워크 레이어 구축</b>
1. URLRequestConvertible 프로토콜을 준수하는 Router 프로토콜을 구축하여 Alamofire의 매개변수를 추상화했습니다.
2. Router 프로토콜을 준수하는 Default Router를 열거형으로 관리하여 사용성을 높였습니다.
3. 네트워크 에러나 통신 에러의 상태 코드를 처리하여 커스텀 에러로 전환한 후 사용자에게 Alert 형식으로 제공했습니다.
4. APIService 객체는 확장성을 고려하여 Generic을 활용해 Decodable과 Router 프로토콜을 사용할 수 있도록 구현했습니다.

<b>사용자 정보 관리</b>
1. 사용자 정보를 UserDefaults로 관리하여 반 영구적으로 저장할 수 있도록 구현했습니다.
2. UserDefaults를 Property Wrapper로 사용하여 초기 값과 키 값을 관리할 수 있도록 구현했습니다.
3. UserDefaults의 Key 값을 열거형으로 관리하여 휴먼 에러를 방지했습니다.
4. UserDefault Property Wrapper 객체를 관리하는 UserDefaultsManager 객체를 싱글톤으로 구현하여 사용성을 높였습니다.

<b>이미지 처리</b>
1. width, height resize 함수를 구현하여 이미지 resizing 함수를 제공했습니다.
2. UIImageView의 extension으로 setImage를 구현했습니다.
3. setImage 함수에서 resize 함수와 KingFisher의 kf.setImage 함수를 혼합하여 메모리를 효율적으로 관리했습니다.

### 트러블 슈팅

