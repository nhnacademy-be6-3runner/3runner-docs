# Elastic Search 기술공유
> 참고 : https://esbook.kimjmin.net/

## 1. Elastic Search 소개
모든 데이터를 색인하여 저장하고 검색, 집계 등을 수행하며 결과를 클라이언트 또는 다른 프로그램으로 전달하여 동작하는 검색 엔진
- 오픈소스
- 실시간분석 : ElasticSearch 클래서터가 실행되고 있는 동안 계속해서 데이터가 입력 되고 색인되 검색 집계 가능.
- 전문(full text) 검색 엔진 : 역색인으로 모든 텍스트를 저장
- RESTFul API : Rest API 지원
- 멀티테넌시

> Elastic Stack : Elastic Search(검색엔진), Logstash(데이터를 집계하고 가공), Kibana(데이터 시각화), Beats(Logstash경량화버전) 을 전부 포함 <br/>
> 여기서 우리는 Elastic Search만 알아보자

## 2. Elastic Search 시작하기
##### 데이터 색인은 아래와 같은 이미지로 표현한다고 한다.
![image](https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/715607fe-43d5-42cd-ad16-bf243a27361d)

#### 2.1 설치
```sh
docker run -d --name elastic-test -p 9200:9200 -e "discovery.type=single-node" -e "xpack.security.enabled=false" docker.elastic.co/elasticsearch/elasticsearch:8.8.2
```
docker로 설치후 container 이미지 받아와서 실행

## 3. Elastic Search 시스템 구조
하나의 서버에는 하나의 노드가 구성됨
#### 3.1 클러스터 구성 (중요하지않음)
디스크를 RAID처럼 짜는 것을 말하는 것 같음 -> 현재는 필요하지 않음
![image](https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/f5025d70-9c87-4a52-8a9b-ed43bfaf4e61)
클러스터 구성을 위와 같이 할수있음

#### 3.2 인덱스와 샤드
- 도큐먼트 : 단일 데이터 단위
- 인덱스(인디시즈) : 이 도큐먼트를 모아놓은 집합
- 색인 : elastic search에 저장하는 행위

- 샤드 : 인덱스가 기본적으로 분리되고 각 노드에 분산되어 자장되는 것 <br>
![image](https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/fe241365-5c03-47fc-a977-8a3bfde9105c)

- 마스터 노드 : Elasticsearch 클러스터는 하나 이상의 노드들로 이루어집니다. 이 중 하나의 노드는 인덱스의 메타 데이터, 샤드의 위치와 같은 클러스터 상태(Cluster Status) 정보를 관리하는 마스터 노드의 역할

- 데이터 노드 : 데이터 노드는 실제로 색인된 데이터를 저장하고 있는 노드

## 4. ElasticSearch 데이터 처리
#### 4.1 Rest API
- 입력 : PUT http://user.com/kim -d {"name":"kim", "age":38, "gender":"m"}
- 조회 : GET http://user.com/kim
- 삭제 : DELETE http://user.com/kim
- 수정 : POST
``` html
POST my_index/_doc
{
  "name":"Jongmin Kim",
  "message":"안녕하세요 Elasticsearch"
}
```

#### 4.2 bulk data 넣기
```
POST _bulk
{"index":{"_index":"test", "_id":"1"}}
{"field":"value one"}
{"index":{"_index":"test", "_id":"2"}}
{"field":"value two"}
{"delete":{"_index":"test", "_id":"2"}}
{"create":{"_index":"test", "_id":"3"}}
{"field":"value three"}
{"update":{"_index":"test", "_id":"1"}}
{"doc":{"field":"value two"}}
```
![image](https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/9b96b836-02ab-421c-98ac-85205e36c679)

#### 4.3 검색 API
- URI 검색 : `GET test/_search?q=value` , `GET test/_search?q=value AND three` , `GET test/_search?q=field:value`
- 데이터 본문 (Data Body)검색 :
```html
GET test/_search
{
  "query": {
    "match": {
      "field": "value"
    }
  }
}
```

