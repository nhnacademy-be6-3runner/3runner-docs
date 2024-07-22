# JWT+Access RefreshToken

<aside>
💡 JWT 토큰을 사용하여 정보를 주고 받고, Access,RefreshToken을 사용한다.

</aside>

# 기본 개념(JWT)

***JWT* 란?**

JWT(JSON Web Token)는 두 개체 간 정보를 안전하게 전송하기 위해 사용되는 컴팩트하고 자가 포함적인 토큰입니다. 일반적으로 사용자 인증을 위해 사용되며, 세 가지 부분으로 구성됩니다. 쉽게말하면 JWT란 정보를 안전하게 주고받기 위한 특별한 디지털 상자라고 할 수 있습니다. 상자에는 중요한 정보가 들어있고, 이 상자가 변하지 않았다는 것을 증명해주는 잠금장치가 있습니다. 주로 인터넷에서 안전하게 정보를 주고받을 때 사용합니다.

**JWT의 세가지 구성요소는?**

- 헤더 (Header)
    
    JWT 상자에 어떤 종류의 잠금 장치가 있는지 알려줍니다.
    
    ```json
    {  "alg": "HS256",  "typ": "JWT"}
    ```
    
- 페이로드 (Payload)
    
    페이로드는 중요한 정보를 담고 있는 상자입니다. 예를 들어, 누가 이 상자를 만들었는지, 언제까지 유효한지 같은 정보를 담고 있어요.
    
    ```json
    {  "sub": "1234567890",  "name": "John Doe",  "admin": true}
    ```
    
- 서명 (Signature)
    
    JWT가 변하지 않았다는 것을 증명해주는 잠금 장치로 헤더와 페이로드를 합친다음, 비밀코드가 있는 잠금장치를 사용한다.
    
    ```
    HMACSHA256(
      base64UrlEncode(header) + "." +
      base64UrlEncode(payload),
      secret)
    ```
    

### *JWT 최종형태*

```
xxxxx.yyyyy.zzzzz
```

- **xxxxx**: 헤더
- **yyyyy**: 페이로드
- **zzzzz**: 서명

**JWT의 두가지 주요역할은?**

1. **인증(Authentication)**
    
    JWT는 사용자가 웹사이트에 로그인할 때, 인증된 요청을 보내기 위해 사용됩니다. 사용자가 로그인하면 서버는 사용자가 올바른 정보를 입력했는지 확인하고 JWT를 생성하여 사용자에게 보냅니다. 이후 사용자는 이 JWT를 사용해 인증된 요청을 보낼 수 있으며, 서버는 각 요청에 포함된 JWT를 확인하여 사용자가 인증되었는지 검증합니다.
    
2. **정보 교환 (Information Exchange)**
    
    JWT는 서로 다른 웹사이트가 정보를 주고받을 때도 사용됩니다. 예를 들어, 사용자가 페이스북 계정으로 다른 웹사이트에 로그인하면, 페이스북이 사용자의 정보를 담은 JWT를 생성하여 해당 웹사이트에 보냅니다. 다른 웹사이트는 이 JWT를 받아서 변조되지 않았고 유효한지 확인한 후, 사용자의 정보를 신뢰할 수 있게 됩니다.
    

JWT 설명 이미지

![JWT+Access%20RefreshToken%20cbd473428e794585971efd00f5603573/e298e470-f0d9-4850-88cf-0641aa26360c2FExport-83da6b4b-0a4a-4468-893d-138daf80305aJWTAccess_RefreshToken_a0d67e48de0144eab6043954a36b938fsunny.jpeg](JWT+Access%20RefreshToken%20cbd473428e794585971efd00f5603573/e298e470-f0d9-4850-88cf-0641aa26360c2FExport-83da6b4b-0a4a-4468-893d-138daf80305aJWTAccess_RefreshToken_a0d67e48de0144eab6043954a36b938fsunny.jpeg)

sunny.jpeg

# 기본 개념(Access/Refresh Token)

***AccessToken*이란?**

- 역할
    
    사용자가 인증된 후, 서버에 API 요청을 할 때 사용되는 토큰입니다. Access Token은 주로 사용자의 권한을 검증하고 특정 리소스에 대한 접근을 허용하는 데 사용됩니다.
    
- 특징
    - **짧은 만료 기간**: 보통 몇 분에서 몇 시간 정도로 설정됩니다. 짧은 만료 기간은 보안상의 이유로 중요합니다. 만약 Access Token이 유출되더라도, 유효 기간이 짧기 때문에 피해를 줄일 수 있습니다.
    - **자주 사용됨**: 클라이언트 애플리케이션이 API 서버에 요청할 때마다 Access Token을 포함시킵니다. 이를 통해 서버는 요청이 인증된 사용자로부터 온 것인지 확인할 수 있습니다.
    - **Bearer Token**: 일반적으로 Authorization 헤더에 “Bearer” 방식으로 포함됩니다.
- 예시
    
    ```
    Authorization: Bearer <access_token>
    ```
    

***RefreshToken*이란?**

- 역할
    
    Access Token의 만료 후 새로운 Access Token을 발급받기 위해 사용됩니다. Refresh Token은 사용자가 재로그인 없이 세션을 연장할 수 있도록 해줍니다.
    
- 특징
    - **긴 만료 기간**: 보통 몇 주에서 몇 달 정도로 설정됩니다. 긴 만료 기간은 사용자가 로그인을 자주 하지 않아도 되도록 하여 사용자 경험을 개선합니다.
    - **안전한 저장**: Refresh Token은 보통 클라이언트 측의 안전한 저장소(예: HttpOnly 쿠키)에 저장됩니다. 클라이언트 애플리케이션이 Refresh Token을 사용해 새로운 Access Token을 요청합니다.
    - **교환 가능**: 사용자는 유효한 Refresh Token을 서버에 보내 새로운 Access Token을 요청할 수 있습니다. 서버는 이 요청을 검증한 후 새로운 Access Token을 발급합니다.
- 예시
    - 클라이언트가 Access Token을 사용하여 API 요청을 보냅니다.
    - Access Token이 만료되면, 클라이언트는 저장된 Refresh Token을 서버에 보내 새로운 Access Token을 요청합니다.
    - 서버는 Refresh Token을 검증하고, 유효하다면 새로운 Access Token과 함께 새로운 Refresh Token을 발급할 수 있습니다.

**토큰 흐름 예시**

1. **로그인**:
    - 사용자가 로그인하면 서버는 Access Token과 Refresh Token을 발급합니다.
    - 클라이언트는 Access Token을 API 요청에 포함시키고, Refresh Token은 안전하게 저장합니다.
2. **API 요청**:
    - 클라이언트는 Access Token을 사용하여 API 서버에 요청을 보냅니다.
    - 서버는 Access Token의 유효성을 검사하고 요청을 처리합니다.
3. **Access Token 만료**:
    - Access Token이 만료되면 클라이언트는 저장된 Refresh Token을 사용해 새로운 Access Token을 요청합니다.
4. **새로운 Access Token 발급**:
    - 서버는 Refresh Token의 유효성을 검사하고, 유효하다면 새로운 Access Token을 발급합니다. 필요에 따라 새로운 Refresh Token도 발급할 수 있습니다.
5. **로그아웃**:
    - 사용자가 로그아웃하면, 클라이언트는 Access Token과 Refresh Token을 폐기하거나 서버에서 해당 토큰을 무효화합니다.

# 실습

## JWT + Access/Refresh Token

Step1) dependency 설정한다.

```java
<dependency>    <groupId>io.jsonwebtoken</groupId>    <artifactId>jjwt-api</artifactId>    <version>0.12.3</version></dependency><dependency>    <groupId>io.jsonwebtoken</groupId>    <artifactId>jjwt-impl</artifactId>    <version>0.12.3</version></dependency><dependency>    <groupId>io.jsonwebtoken</groupId>    <artifactId>jjwt-jackson</artifactId>    <version>0.12.3</version></dependency>
```

Step2) JWTUtil 클래스를 만든다.

`JWTUtil` 클래스는 JWT 토큰을 생성, 검증, 그리고 토큰의 카테고리와 UUID를 추출하는 기능을 제공합니다. 이를 통해 사용자의 인증 정보를 안전하게 관리하고, 토큰의 유효성을 확인하며, 필요한 정보를 토큰에서 추출할 수 있습니다.

```java
@Componentpublic class JWTUtil {    private final SecretKey secretKey;    // 생성자: secret 값을 받아서 SecretKey 객체를 생성합니다.    public JWTUtil(@Value("${spring.jwt.secret}") String secret) {       this.secretKey=new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8),            Jwts.SIG.HS256.key().build().getAlgorithm());    }    /**     * Token 을 생성한다.     * @param category Access, or Refresh
     * @param username 이메일     * @param auth 권한     * @param memberId 멤버 아이디     * @param expiredMs the expired ms
     * @return token 값     */    public String generateToken(String category, String username, String auth, Long memberId, Long expiredMs) {        return Jwts.builder()            .claim("category", category)  // 클레임 추가: 카테고리            .claim("username", username)  // 클레임 추가: 사용자 이름            .claim("memberId", memberId)  // 클레임 추가: 멤버 아이디            .claim("auth", auth)  // 클레임 추가: 권한            .issuedAt(new Date(System.currentTimeMillis()))  // 발급 시간 설정            .expiration(new Date(System.currentTimeMillis() + expiredMs))  // 만료 시간 설정            .signWith(secretKey)  // 서명: 비밀 키 사용            .compact();  // JWT 문자열로 변환    }    // UUID로 토큰 생성하는 메소드    public String generateTokenWithUuid(String category, String uuid, Long expiredMs) {        Date now = new Date();        return Jwts.builder()            .claim("category", category)  // 클레임 추가: 카테고리            .claim("uuid", uuid)  // 클레임 추가: UUID            .issuedAt(now)  // 발급 시간 설정            .expiration(new Date(now.getTime() + expiredMs))  // 만료 시간 설정            .signWith(secretKey)  // 서명: 비밀 키 사용            .compact();  // JWT 문자열로 변환    }    /**     * JWT 유효 기간(만료 기간) 체크한다.     *     * @param token access token
     * @return 유효성     */    public Boolean isExpired(String token) {        return Jwts.parser()            .verifyWith(secretKey)  // 검증: 비밀 키 사용            .build()            .parseSignedClaims(token)  // 토큰 파싱            .getPayload()            .getExpiration()            .before(new Date());  // 현재 시간이 만료 시간보다 이전인지 확인    }    // JWT에서 카테고리 추출    public String getCategory(String token) {        return Jwts.parser()            .verifyWith(secretKey)  // 검증: 비밀 키 사용            .build()            .parseSignedClaims(token)  // 토큰 파싱            .getPayload()            .get("category", String.class);  // 클레임에서 카테고리 추출    }    /**     * JWT 에서 멤버의 uuid 를 가져온다.     *     * @param token 토큰     * @return the uuid
     */    public String getUuid(String token) {        return Jwts.parser()            .verifyWith(secretKey)  // 검증: 비밀 키 사용            .build()            .parseSignedClaims(token)  // 토큰 파싱            .getPayload()            .get("uuid", String.class);  // 클레임에서 UUID 추출    }}
```

Step3)TokenService를 생성한다.

`TokenServiceImpl` 클래스는 JWT를 사용하여 Access Token과 Refresh Token을 생성하고, 이들을 Redis에 저장 및 관리하며, 토큰의 유효성을 검증하는 역할을 합니다. 이 클래스는 토큰의 세부 정보를 Redis에서 조회하고 삭제하며, 클라이언트의 요청에 따라 새로운 토큰을 발급하는 기능을 수행합니다.

```java
@Slf4j@Servicepublic class TokenServiceImpl implements TokenService {    private final String TOKEN_DETAILS = "token_details";    private final String REFRESH_TOKEN = "refresh_token";    private final Long ACCESS_TOKEN_TTL = 3600000L; // 60 * 60 * 1000 = 3600000L    private final Long REFRESH_TOKEN_TTL = 604800000L; // 7 * 24 * 60 * 60 * 1000    private final JWTUtil jwtUtil;    private final RedisTemplate<String, Object> redisTemplate;    ObjectMapper objectMapper = new ObjectMapper();    public TokenServiceImpl(JWTUtil jwtUtil, RedisTemplate<String, Object> redisTemplate) {        this.jwtUtil = jwtUtil;        this.redisTemplate = redisTemplate;    }    @Override    public List<String> generateToken(String username, List<String> auths, Long memberId) {        String uuid = UUID.randomUUID().toString();        log.error("새로운 uuid: {}", uuid);        TokenDetails tokenDetails = new TokenDetails(username, auths, memberId);        try {            redisTemplate.opsForHash().put(TOKEN_DETAILS, uuid, objectMapper.writeValueAsString(tokenDetails));        } catch (JsonProcessingException e) {            throw new RuntimeException(e);        }        // TODO redis expire 설정        // redisTemplate.expire(TOKEN_DETAILS, ACCESS_TOKEN_TTL, TimeUnit.MICROSECONDS);        String accessToken = jwtUtil.generateTokenWithUuid("ACCESS", uuid, ACCESS_TOKEN_TTL);        String refreshToken = jwtUtil.generateTokenWithUuid("REFRESH", uuid, REFRESH_TOKEN_TTL);        redisTemplate.opsForHash().put(REFRESH_TOKEN, uuid, refreshToken);        return Arrays.asList(accessToken, refreshToken);    }    @Override    public TokenDetails getTokenDetails(String uuid) {        String data = (String)redisTemplate.opsForHash().get(TOKEN_DETAILS, uuid);        try {            return objectMapper.readValue(data, TokenDetails.class);        } catch (JsonProcessingException e) {            throw new RuntimeException(e);        }    }    @Override    public void deleteTokenDetail(String uuid) {        redisTemplate.opsForHash().delete(TOKEN_DETAILS, uuid);    }    @Override    public String getRefreshToken(String uuid) {        return (String)redisTemplate.opsForHash().get(REFRESH_TOKEN, uuid);    }    @Override    public void deleteRefreshToken(String uuid) {        redisTemplate.opsForHash().delete(REFRESH_TOKEN, uuid);    }    @Override    public boolean existsRefreshToken(String uuid, String inputRefresh) {        String storedRefresh = getRefreshToken(uuid);        return Objects.nonNull(storedRefresh) && inputRefresh.equals(storedRefresh);    }}
```

Step4)TokenController클래스도 작성해준다.

`TokenController` 클래스는 클라이언트로부터 리프레시 토큰을 받아서 검증하고, 유효한 경우 새로운 Access Token을 발급하는 역할을 합니다. 이 과정에서 토큰의 만료 여부와 카테고리를 확인하고, Redis에 저장된 토큰 정보와 비교하여 유효성을 검증한 후, 새로운 토큰을 생성하여 HTTP 응답의 헤더와 쿠키에 포함시킵니다.

```java
@Slf4j@RestController@RequestMapping("/auth")public class TokenController {    @Autowired    private JWTUtil jwtUtil;    @Autowired    private TokenService tokenService;    /**     * 토큰을 재발급한다.     *     *     * @param refreshRequest 리프레시 토큰     * @param response HttpServletResponse
     * @return 액세스 토큰     */    @PostMapping("/reissue")    public ApiResponse<RefreshResponse> reissue(@RequestBody RefreshRequest refreshRequest,        HttpServletResponse response) {        String refresh = refreshRequest.refreshToken();        if (refresh == null) {            log.error("Refresh token is null");            return ApiResponse.badRequestFail(new ApiResponse.Body<>(new RefreshResponse("refresh token null", null)));        }        //expired check        try {            jwtUtil.isExpired(refresh);        } catch (ExpiredJwtException e) {            return ApiResponse.badRequestFail(                new ApiResponse.Body<>(new RefreshResponse("리프레시 토큰 만료", null)));        }        // 토큰이 refresh 인지 확인 (발급시 페이로드에 명시)        String category = jwtUtil.getCategory(refresh);        if (!category.equals("REFRESH")) {            return ApiResponse.badRequestFail(                new ApiResponse.Body<>(new RefreshResponse("유효하지 않은 리프레시 토큰", null)));        }        String uuid = jwtUtil.getUuid(refresh);        // Redis 에 저장되어 있는지 확인 (refresh 토큰 내용도 비교)        if (!tokenService.existsRefreshToken(uuid, refresh)) {            return ApiResponse.badRequestFail(                new ApiResponse.Body<>(new RefreshResponse("유효하지 않은 리프레시 토큰", null)));        }        TokenDetails tokenDetails = null;        tokenDetails = tokenService.getTokenDetails(uuid);        // 기존 uuid 삭제        tokenService.deleteRefreshToken(uuid);        tokenService.deleteTokenDetail(uuid);        log.error("기존 uuid redis 삭제: {} ", uuid);        // make new Access token        List<String> tokens = tokenService.generateToken(tokenDetails.getEmail(), tokenDetails.getAuths(),            tokenDetails.getMemberId());        // TODO 블랙리스트        // jwt 생성후 헤더와 쿠키에 붙여준다.        response.addHeader("Authorization", "Bearer " + tokens.getFirst());        response.addCookie(CookieUtil.createCookie("Refresh", tokens.getLast()));        response.setStatus(HttpStatus.OK.value());        log.error("Access token: {}", tokens.getFirst());        log.error("Refresh token: {}", tokens.getLast());        return ApiResponse.success(new RefreshResponse("토큰 재발급 완료", tokens.getFirst()));    }}
```