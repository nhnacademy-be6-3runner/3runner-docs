# RabbitMQ

AMQP를 구현한 오픈소스 메세지 브로커이다. producers에서 consumers로 메세지(요청)를 전달할 때 중간에서 브로커 역할을 한다. 메시지가 전달이 성공하면 메시지가 바로 삭제 처리된다.

## 사용하는 이유
여러 서버를 구성하게 되면 서로 정보를 주고받아야하는 상황이 발생한다. 따라서 RestTemplate, Feign클라이언트로 http 요청을 보내게되는데, 이러한 요청은 응답을 받을 때까지 서버의 CPU자원 하나를 차지하게된다. 따라서 서버의 수행능력이 떨어진다. 이런 상황에서 AMQP를 이용한 RabbitMQ로 비동기식으로 메시지를 전달하게되면 성능을 높일 수 있다. 결합도도 낮출수 있는 장점이있다. redis Pub/sub과 다르게p roducer/consumer간의 보장되는 메세지 전달, prioirty queue를 지원하여 우선순위 처리가 가능하다. 

![image](https://github.com/user-attachments/assets/e775b25c-335f-4753-a4c7-17ac8549ffb9)
- Producer: 요청을 보내는 주체, 보내고자 하는 메세지를 exchange에 publish한다.
- Consumer: producer로부터 메세지를 받아 처리하는 주체
- Exchange: producer로부터 전달받은 메세지를 어떤 queue로 보낼지 결정하는 장소, 4가지 타입이 있음
- Queue: consumer가 메세지를 consume하기 전까지 보관하는 장소
- Binding: Exchange와 Queue의 관계, 보통 사용자가 특정 exchange가 특정 queue를 binding하도록 정의한다. (fanout 타입은 예외)


## 타입 설명
![image](https://github.com/user-attachments/assets/5e127281-e3a1-4ef8-ba89-f376da5d497a)

- Direct Exchange

![image](https://github.com/user-attachments/assets/ed81d2a5-4085-4392-8cc9-7d3167a456e1)

일치하는 Queue에만 전송
- Topic Exchange

![image](https://github.com/user-attachments/assets/d3ce66ac-8e1a-4ace-a9b6-113b215282d6)

binding이 되지 않는 경우

![image](https://github.com/user-attachments/assets/74a34954-460c-4d8e-bfe9-73ed28b52ef0)

"animal.rabbit"이 "animal.* "와 "#" 모두에 일치하기 때문에 모든 Queue에 전송되는 경우이다.
> #는 0개 이상의 단어를 대체

- Headers Exchange

![image](https://github.com/user-attachments/assets/410a3ac0-070b-4166-b6c7-abf45ac58c6b)

producer에서 정의된 header의 key-value 쌍과 consumer에서 정의된 argument의 key-value 쌍이 일치하면 binding된다.

![image](https://github.com/user-attachments/assets/74c16f63-4987-42ea-b3f9-68484462daae)


- Fanout

![image](https://github.com/user-attachments/assets/017eb90d-9fe4-4813-b30c-2110bc063b62)
broadcast

## RabbitMq, Kafka?
- 메시지 브로커 : pub/sub 구조라고 하며 대표적으로는 Redis, RabbitMQ 소프트웨어가 있고, GCP의 pubsub, AWS의 SQS 같은 서비스가 있다.
- 이벤트 브로커 : 메시지 브로커의 역할도 하지만 차이점은 이벤트 브로커는 publisher가 생산한 이벤트를 이벤트 처리 후에 바로 삭제하지 않고 저장하여, 이벤트 시점이 저장되어 있어서 consumer가 특정 시점부터 이벤트를 다시 consume 할 수 있는 장점이 있다. (예를 들어 장애가 일어난 시점부터 그 이후의 이벤트를 다시 처리할 수 있음) 대용량으로 더 많은 데이터를 처리할수있다. 대표적 Kafka, AWS의 kinesis가 있다.

## kafka의 동작 방식

![image](https://github.com/user-attachments/assets/07b82939-9bf7-49cc-b97a-595bbf7b9412)

구성 요소
- Event: kafka에서 producer 와 consumer가 데이터를 주고받는 단위. 메세지
- Producer: kafka에 이벤트를 게시(post, pop)하는 클라이언트 어플리케이션
- Consumer: Topic을 구독하고 이로부터 얻어낸 이벤트를 받아(Sub) 처리하는 클라이언트 어플리케이션
- Topic: 이벤트가 모이는 곳. producer는 topic에 이벤트를 게시하고, consumer는 - topic을 구독해 이로부터 이벤트를 가져와 처리. 게시판 같은 개념
- Partition: Topic은 여러 Broker에 분산되어 저장되며, 이렇게 분산된 topic을 partition이라고 함
- Zoopeeper: 분산 메세지의 큐의 정보를 관리

동작 원리
- publisher는 전달하고자 하는 메세지를 topic을 통해 카테고리화 한다.
- subscriber는 원하는 topic을 구독(=subscribe)함으로써 메시지를 읽어온다.
- publisher와 subscriber는 오로지 topic 정보만 알 뿐, 서로에 대해 알지 못한다.
- kafka는 broker들이 하나의 클러스터로 구성되어 동작하도록 설계
- 클러스터 내, broker에 대한 분산처리는 ZooKeeper가 담당한다.

장점
- 대규모 트래픽 처리 및 분산 처리에 효과적
- 클러스터 구성, Fail-over, Replication 같은 기능이 있음
- 100Kb/sec 정도의 속도 (다른 메세지 큐 보다 빠름)
- 디스크에 메세지를 특정 보관 주기동안 저장하여 데이터의 영속성이 보장되고 유실 위험이 적다. 또한 Consumer 장애 시 재처리가 가능하다.

단점
- 라우팅 지원X

## RabbitMq 사용이유
- 메시지의 재처리가 필요하지 않았음.
- producer, consumer간의 보장되는 메시지 전달.
- 유연한 라우팅이 확장성이 있어서 선택.
