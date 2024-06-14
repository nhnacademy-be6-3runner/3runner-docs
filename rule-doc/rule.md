# API 규칙

### API

- 쿠폰 API → db2
- 도서/주문 API → db1
- 인증 API → db1

# 명명 규칙

---

### entity

- userId (id)
- Set 사용

### 변수

- userList

### 컨트롤러/서비스

- service → serviceImpl
- CreateUserService, UpdateUser

### Service

- createUser
- updateUser
- readById.., readAllUser….
- deleteUser

# 설계 규칙

---

### package 구조 → domain

- entity
    - book
        - Enums
        - Book.java
        - dto
            - request
                - [CreateUserRequest.java](http://CreateUserRequest.java) → record, builder
            - response
    - review
        - Review.java
        - dto
            - request
                - CreateUserRequest.java
            - response
- book
    - service
    - exception
    - …
- review
    - service
    - exception
    - …
- global
    - config
    - validate
    - exceptionHandler
    
    Exception → 한글로 시간, 에러 코드, 메세지
    
    Order → 테이블 이름 orders로 변경
    

### front

- domain
    - userClient

<User>

POST 

GET

GET projects/{id}/tags

GET projects/{id}/tags/{id}/books 

tags → projects → books

GET tags/{id}/projects/{id}/books 

- 책 안의 고유 태그?
- 전체적인 태그?

조건이 앞, 검색되는 entity가 뒤

- tags/{id}/books → 해당 태그의 책
- books/{id}/tags → 해당 책의 태그

## front API

- 메인 페이지 : main.html
- 로그인 페이지 : login.html
- 회원가입 페이지 : register.html
- 마이페이지 페이지 : mypage.html
- 장바구니 페이지 : cart.html
- 주문 페이지 : order.html
- 결제 페이지 : payment.html
- 관리자 페이지 : admin.html
- 도서
    - 도서 상세 페이지

3runner-gateway → 8080 

3runner-eureka → 8761

3runeer-bookstore → 8081, 8082

3runner-coupon

3runner-auth

3runner-front

## 도커

- 

## entity

- repo 생성
- entity → h2

## 템플릿