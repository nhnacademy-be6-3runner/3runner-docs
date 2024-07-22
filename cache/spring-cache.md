# Spring Cache를 사용하여 조회 성능 개선 (Jmeter로 성능 측정하기)



스프링은 일부 데이터를 미리 메모리 저장소에 저장하고, 저장된 데이터를 다시 읽어서 사용하는 cache 기능을 제공한다. 

## 📍 로컬 캐시 vs 원격 캐시


### ✔️ 로컬 캐시(Local Cache) : Ehcache, Caffeine …

- **빠른 접근 속도**: 데이터가 애플리케이션 내부에 캐시되므로, 메모리 접근 속도로 매우 빠르다.
- **메모리 제한**: 애플리케이션 서버의 메모리 용량에 제한된다.
- **데이터 일관성 문제**: 다중 서버 환경에서 각각의 서버가 별도의 캐시를 가지므로, 캐시 데이터의 일관성을 유지하기 어렵다.
- **데이터 손실 가능성**: 서버 재시작 시 캐시된 데이터가 손실될 수 있다.

### 예시

- **단일 서버 환경**: 애플리케이션이 단일 서버에서 동작하는 경우
- **성능 최적화**: 매우 빠른 데이터 접근이 필요한 경우

### ✔️ 원격 캐시(Remote Cache) : Redis …

- **확장성**: 여러 서버 간에 캐시를 공유할 수 있어, 확장성이 좋다.
- **데이터 일관성**: 여러 서버 간에 데이터 일관성을 유지할 수 있다.
- **데이터 영속성**: 원격 캐시는 서버 재시작 후에도 데이터가 유지될 수 있다.
- **네트워크 지연**: 네트워크를 통해 접근하기 때문에 로컬 캐시보다 느릴 수 있다.

### 예시

- **다중 서버 환경**: 애플리케이션이 여러 서버에서 동작하는 경우.
- **데이터 일관성**: 여러 서버 간에 일관된 데이터 접근이 필요한 경우.
- **데이터 영속성**: 캐시된 데이터가 서버 재시작 후에도 유지되어야 하는 경우.
- **큰 데이터 세트**: 애플리케이션 서버 메모리 용량을 초과하는 큰 데이터를 캐싱해야 하는 경우.

### 선택 기준

1. **확장성**
    - 단일 서버 환경 또는 작은 규모의 데이터: **로컬 캐시**.
    - 다중 서버 환경 또는 큰 규모의 데이터: **원격 캐시**.
2. **데이터 일관성**
    - 데이터 일관성이 중요하지 않음: **로컬 캐시**.
    - 데이터 일관성이 중요함: **원격 캐시**.
3. **성능 요구 사항**
    - 극도로 빠른 데이터 접근이 필요함: **로컬 캐시**.
    - 네트워크 지연을 감수할 수 있음: **원격 캐시**.
4. **데이터 영속성**:
    - 데이터가 휘발: **로컬 캐시**.
    - 데이터가 영속적: **원격 캐시**.

## 📍 캐시 전략



![스크린샷 2024-07-22 오후 2.12.22.png](Spring%20Cache%20e59acd74a37b49bf954b60d1fc324fde/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-07-22_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_2.12.22.png)

- Cache Hit : 캐시 스토어에 데이터가 있을 경우 가져옴
- Cache Miss : 캐시 스토어에 데이터가 없을 경우 DB 조회

## 📍 캐시 전략이 필요한 이유


캐시를 이용하게 되면 반드시 닥쳐오는 문제점이 있는데 바로 데이터 정합성 문제다. 데이터 정합성 문제란 어느 한 데이터가 캐시 스토어와 데이터베이스 이 두 곳에서 같은 데이터임에도 불구하고 데이터 정보값이 서로 다른 현상을 말한다. 이전에는 DB에서 데이터 조회와 작성을 처리하였기 때문에 데이터 정합성 문제가 나타나지 않았지만, 캐시 스토어라는 또 다른 데이터 저장소를 이용하기 때문에 같은 데이터라도 두 저장소에서 저장된 값이 서로 다를 수 있는 현상이 일어날 수 밖에 없다. 따라서 적절한 캐시 읽기 전략과 쓰기 전략이 필요하다.

### ✔️ 읽기 전략


- Look Aside 패턴
    - 데이터를 찾을 때 우선 캐시에 저장된 데이터가 있는지 우선적으로 확인하는 전략
    - 캐시에 데이터가 없을 경우 DB 조회
    - 반복적으로 읽기가 많은 호출에 적합
    - DB가 분리되어 가용되기 때문에 원하는 데이터만 별도로 구성
    - 만약 redis가 다운되더라도 서버에서 데이터를 가져오면 됨

### ✔️ 쓰기 전략


- Write Back
    - 캐시와 DB 동기화를 비동기하기 때문에 도익화 과정이 생략
    - 데이터를 저장할 때 DB에 바로 쿼리하지 않고, 캐시에 모아서 일정 주기 배치 작업을 통해 DB에 반영
    - 캐시에 모아놨다가 DB에 쓰기 때문에 쓰기 쿼리 회수 비용과 부하를 줄일 수 있음
    - write가 빈번하면서 Read를 하는데 많은 양의 리소스가 소모되는 서비스에 적합 → 데이터 정합성 확보
    - 자주 사용되지 않는 불필요한 리소스 저장
    - 캐시에서 오류가 발생할 경우 데이터 영구 소실
- Write Through
    - 데이터베이스와 캐시에 동시에 데이터를 저장하는 전략
    - 저장할 때 먼저 캐시에 저장한 다음 바로 DB에 저장
    - DB 동기화 작업을 캐시에게 위임 → DB와 캐시가 항상 동기화 되어 있어, 캐시 데이터는 항상 최신 상태로 유지
    - 캐시와 백업 저장소에 업데이트를 같이 하여 데이터 일관성 유지 가능
    - 안정적인 데이터가 필요할 경우 사용
    - 두 번의 write가 발생하게 됨으로써 빈번한 생성, 수정이 발생하는 서비스에서는 성능 이슈
- Write Around
    - write through 보다 훨씬 빠름
    - 모든 데이터는 DB에 저장 → 캐시 갱신 x
    - 캐시 미스가 발생하는 경우에만 DB와 캐시에도 데이터를 저장 → 캐시와 DB 내의 데이터가 다를 수 있음
    - 데이터가 저장/삭제될 때마다 캐시 또한 삭제하고 변경해야 함 → 캐시의 유효 기간을 짧게 조정
    

### ✔️ 가장 많이 쓰이는 조합


- Look Aside + Write Through
    
    ![스크린샷 2024-07-22 오후 3.54.10.png](Spring%20Cache%20e59acd74a37b49bf954b60d1fc324fde/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-07-22_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_3.54.10.png)
    

## Redis Cache 적용하기


```java
/**
 * 레디스 캐싱을 위한 config 입니다.
 *
 * @author 김은비
 */
@Configuration
@EnableCaching
public class RedisCacheConfig {

    @Bean
    public CacheManager cacheManager(RedisConnectionFactory redisConnectionFactory) {
        // 다형성 타입 검증기를 설정, 모든 하위 타입을 허용
        // jackson이 다양한 서브타입을 처리할 수 있도록 검증기 설정
        PolymorphicTypeValidator ptv = BasicPolymorphicTypeValidator
                .builder()
                .allowIfSubType(Object.class)
                .build();

        // ObjectMapper 설정
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.enable(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY); // 단일 값을 배열로 수락
        objectMapper.registerModule(new JavaTimeModule()); // Java 8 날짜/시간 모듈 등록
        objectMapper.registerModule(new PageJacksonModule()); // 페이지 모듈 등록
        // 다형성 타입을 활성화하여 객체의 타입 정보를 json에 포함
        // 역직렬화 시 원래의 타입을 복원하는 데 사용
        objectMapper.activateDefaultTyping(ptv, ObjectMapper.DefaultTyping.NON_FINAL, JsonTypeInfo.As.PROPERTY);
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false); // 알 수 없는 속성 무시

        // Redis 캐시 설정
        RedisCacheConfiguration redisCacheConfiguration = RedisCacheConfiguration.defaultCacheConfig()
                .disableCachingNullValues() // null 값 캐시하지 않음
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer())) // 키 직렬화 설정
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(new GenericJackson2JsonRedisSerializer(objectMapper))) // 값 직렬화 설정
                .entryTtl(Duration.ofMinutes(5L)); // 캐시 TTL 설정 (5분)

        // RedisCacheManager 생성 및 반환
        return RedisCacheManager.RedisCacheManagerBuilder.fromConnectionFactory(redisConnectionFactory)
                .cacheDefaults(redisCacheConfiguration)
                .build();
    }
}
```

### 캐시 어노테이션 적용하기

```
/**
	 * 도서 페이지 조회 메서드입니다.
	 * @param page 페이지
	 * @param size 사이즈
	 * @return 도서 리스트
	 */
	@Override
	@Cacheable(value = "BookPage", key = "#page + '-' + #size + '-' + #sort", cacheManager = "cacheManager")
	public Page<BookListResponse> readAllBooks(int page, int size, String sort) {
		ApiResponse<Page<BookListResponse>> response = bookClient.readAllBooks(page, size, sort);

		if (response.getHeader().isSuccessful() && response.getBody() != null) {
			return response.getBody().getData();
		} else {
			throw new InvalidApiResponseException("도서 페이지 조회 exception");
		}
	}
```
- @Cacheable : 해당 메서드 호출 전 캐시 스토어에 데이터 조회, 만약 없으면 메서드 로직 수행

```
	@Override
	@CacheEvict(value = {"BookPage", "CategoryBooks", "AdminBookPage"}, allEntries = true)
	public void updateBook(long bookId, UserCreateBookRequest userCreateBookRequest, String imageName) {

		CreateBookRequest updateBookRequest = CreateBookRequest.builder()
			.title(userCreateBookRequest.title())
			.description(userCreateBookRequest.description())
			.publishedDate(stringToZonedDateTime(userCreateBookRequest.publishedDate()))
			.price(userCreateBookRequest.price())
			.quantity(userCreateBookRequest.quantity())
			.sellingPrice(userCreateBookRequest.sellingPrice())
			.packing(userCreateBookRequest.packing())
			.author(userCreateBookRequest.author())
			.isbn(userCreateBookRequest.isbn())
			.publisher(userCreateBookRequest.publisher())
			.imageName(imageName)
			.imageList(descriptionToImageList(userCreateBookRequest.description()))
			.tagIds(stringIdToList(userCreateBookRequest.tagList()))
			.categoryIds(stringIdToList(userCreateBookRequest.categoryList()))
			.build();

		bookClient.updateBook(bookId, updateBookRequest);
	}

```
- @CacheEvict : 캐시에 저장된 데이터가 수정/삭제될 경우 캐시 삭제

- redis를 캐시 스토어로 사용
- 데이터 직렬화 / 역직렬화
- Jackson을 사용하여 json 형식으로 데이터 저장
- `registerModule(new PageJacksonModule)` : 페이지 모듈을 등록하여 페이징된 데이터의 직렬화 / 역직렬화 설정
- 왜 Object Mapper 사용?
    - json 데이터에 알 수 없는 속성이 포함되었을 때 오류 방지
    - 
    
    ```java
    com.fasterxml.jackson.databind.exc.UnrecognizedPropertyException: Unrecognized field "hasContent" (class org.springframework.cloud.openfeign.support.PageJacksonModule$SimplePageImpl), not marked as ignorable (6 known properties: "size", "content", "totalElements", "sort", "pageable", "number"])
     at [Source: REDACTED (StreamReadFeature.INCLUDE_SOURCE_IN_LOCATION disabled); line: 1, column: 2954] (through reference chain: org.springframework.cloud.openfeign.support.PageJacksonModule$SimplePageImpl["hasContent"])
    	at com.fasterxml.jackson.databind.exc.UnrecognizedPropertyException.from(UnrecognizedPropertyException.java:61) ~[jackson-databind-2.17.1.jar:2.17.1]
    	at com.fasterxml.jackson.databind.DeserializationContext.handleUnknownProperty(DeserializationContext.java:1153) ~[jackson-databind-2.17.1.jar:2.17.1]
    ```
    
    → json이 인식하지 못하는 데이터 ‘hasContent’ → jackson 설정을 통해 알 수 없는 속성 무시하도록 설정
    

## 📍 메인 페이지 캐시 적용 결과 비교

### ✔️ 적용 전

![스크린샷 2024-07-22 오후 3.18.12.png](Spring%20Cache%20e59acd74a37b49bf954b60d1fc324fde/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-07-22_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_3.18.12.png)

![스크린샷 2024-07-22 오후 3.18.04.png](Spring%20Cache%20e59acd74a37b49bf954b60d1fc324fde/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-07-22_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_3.18.04.png)

- 5000개의 요청이 갔을 경우 평균 6092ms → 약 6초

### ✔️ 적용 후

![스크린샷 2024-07-22 오후 3.18.56.png](Spring%20Cache%20e59acd74a37b49bf954b60d1fc324fde/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-07-22_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_3.18.56.png)

![스크린샷 2024-07-22 오후 3.18.43.png](Spring%20Cache%20e59acd74a37b49bf954b60d1fc324fde/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-07-22_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_3.18.43.png)

- 똑같이 5000개의 요청이 갔을 경우 → 약 0.2초
- 96.06% 향상
