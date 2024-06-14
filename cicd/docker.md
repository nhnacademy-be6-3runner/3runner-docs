# Docker를 활용한 배포 과정

# Docker

![%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2024-06-14_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5 12 18](https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/131134077/cdd68d0a-7e76-4752-badb-28b2cc2e4f36)

- docker 이미지 : Dockerfile(명령서)로 생성되며 컨테이너 실행 환경을 정의하는데 사용
- docker 컨테이너 : 이미지를 기반으로 생성되어 격리된 환경에서 실행 → 독립적으로 동작
    
    (컨테이너 안에 이미지가 있는 느낌)
    
- docker hub : 생성된 이미지들의 공유 저장소
- docker compose : 여러 개의 컨테이너를 정의하고 실행

## 1. Dockerfile 생성하기

<aside>
💡 도커 이미지를 생성하기 위한 DSL(Domain-Specific Language, 도메인 특화 언어)로서 몇가지 명령어들로 커스텀 이미지를 만들 수 있게 해줌

</aside>

```docker
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY target/hello.jar /app/hello.jar
EXPOSE 8080
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
# Run the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
```

- FROM : 기반이 되는 이미지를 의미 → 현재는 자바 애플리케이션 21
- WORDIR : Docker 컨테이너의 작업 디렉토리를 `/app`으로 설정
- COPY : 애플리케이션 내부의 [entrypoint.sh](http://entrypoint.sh)를 서버에 해당 경로로 복사
- EXPOSE :  Docker 컨테이너의 8080 포트를 외부에 노출
    - 이를 통해서 호스트 시스템에서 컨테이너의 8080 포트에 접근 가능
- RUN :  ****`entrypoint.sh` 스크립트에 실행 권한을 부여
- ENTRYPOINT : 컨테이너가 시작됐을 떄 실행할 스크립트를 명시

## 2. 생성된 Dockerfile로 도커 이미지 빌드하기

```
// 이미지 생성하기
docker build -t <생성할 이미지 이름> .
// docker build -t app
// 생성된 이미지 확인
docker images
```

![스크린샷 2024-06-14 오후 1.26.48.png](Docker%E1%84%85%E1%85%B3%E1%86%AF%20%E1%84%92%E1%85%AA%E1%86%AF%E1%84%8B%E1%85%AD%E1%86%BC%E1%84%92%E1%85%A1%E1%86%AB%20%E1%84%87%E1%85%A2%E1%84%91%E1%85%A9%20%E1%84%80%E1%85%AA%E1%84%8C%E1%85%A5%E1%86%BC%203adc7579130c4929b73f996a0fce094a/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-06-14_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%2592%25E1%2585%25AE_1.26.48.png)

## 3. 생성된 이미지를 DockerHub Repository에 push하기

### DockerHub

도커 이미지를 저장하는 공유 저장소로 개발자들이 자신이 빌드한 이미지를 업로드하고 공유할 수 있음

이미지를 dockerhub에 push하고 이미지를 사용할 서버에서 pull 받아와야함

1. 생성한 이미지를 태깅하기 → 자신이 생성한 이미지에 대해서 식별할 수 있도록 아이디를 붙여줘야함

```
docker login
docker tag <이미지 이름> <자신의 도커 아이디>/<이미지 이름>
// docker tag app alal55al9/app
```

1. 이미지를 dockerhub에 푸쉬하기

```
dockekr push <자신의 도커 아이디>/<이미지 이름>
```

## 4. 이 모든 과정을 Git Action을 활용해서 자동화하기

@helloJosh  https://github.com/nhnacademy-be6-3runner/3runner-docs/blob/main/cicd/gitaction-docker.md

```yaml
name: Java CI with Maven, SonarQube, and Docker

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
      - name: Check out the code
        uses: actions/checkout@v4

      - name: Set up JDK 21
        uses: actions/setup-java@v3
        with:
          java-version: '21'
          distribution: 'temurin'
          cache: maven

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1

      - name: Build with Maven
        run: mvn -B package --file pom.xml

      - name: Log in to Docker Hub
        run: echo "${{ secrets.DOCKER_PASSWORD }}" | sudo docker login -u "${{ secrets.DOCKER_USERNAME }}" --password-stdin

      - name: Build Docker image with Docker compose
        run : sudo docker-compose build

      - name: Push Docker image to Docker Hub
        run: |
          sudo docker-compose push

      - name: Copy files to server
        uses: appleboy/scp-action@master
        with:
          host: ${{ secrets.SSH_IP }}
          username: ${{ secrets.SSH_ID }}
          key: ${{ secrets.SSH_KEY }}
          port: ${{ secrets.SSH_PORT }}
          source: "."
          target: "/home/ubuntu/test"

      - name: Stop existing containers on port 80 and 8080
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SSH_IP }}
          username: ${{ secrets.SSH_ID }}
          key: ${{ secrets.SSH_KEY }}
          port: ${{ secrets.SSH_PORT }}
          script: |
            ports_to_check=("80" "8080")
            for port in "${ports_to_check[@]}"; do
              existing_container=$(sudo lsof -i:$port -t)
              if [ ! -z "$existing_container" ]; then
                sudo docker stop $existing_container
                sudo docker rm $existing_container
              fi
            done

      - name: Deploy to server via SSH
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SSH_IP }}
          username: ${{ secrets.SSH_ID }}
          key: ${{ secrets.SSH_KEY }}
          port: ${{ secrets.SSH_PORT }}
          script: |
            cd /home/ubuntu/test
            docker-compose pull
            docker-compose down || true
            docker-compose up -d
```

- Build Docker image with Docker compose
    - 멀티 아키텍처 Docker 이미지 빌드를 가능하게 하는 도구
    - Docker Buildx를 설정하여 다양한 CPU 아키텍처(x86, ARM 등)의 이미지를 빌드
- Set up QEMU
    - QEMU는 CPU 에뮬레이터로, 다양한 CPU 아키텍처를 에뮬레이션
    - QEMU를 설정하여 Docker Buildx가 다양한 CPU 아키텍처의 이미지를 빌드
- Copy files to server
    - 이미지 빌드를 위한 필요 파일들을 해당 서버에 복사
- Stop existing containers on port 80 and 8080
    - 만약 80 포트나 8080 포트가 사용 중일 경우 중지
- Deploy to server via SSH
    - GitHub Actions 워크플로우 실행 시, 원격 서버에 배포된 Docker Compose 서비스를 최신 상태로 업데이
    - `/home/ubuntu/test` 디렉토리로 이동
    - `docker-compose pull` 명령어로 Docker Compose 서비스의 최신 이미지를 가져옴
    - `docker-compose down` 명령어로 기존 Docker Compose 서비스를 중지 (실패해도 계속 진행)
    - `docker-compose up -d` 명령어로 Docker Compose 서비스를 새로 시작
        
        → 지속적인 배포
        

nginx.conf 

```
events {}

http {
    upstream java_app {
        server app1:8080;
        server app2:8080;
    }

    server {
        listen 80;

        location /app1/ {
            proxy_pass http://app1/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /app2/ {
            proxy_pass http://app2/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

- 로드 밸런싱: 두 개의 서버 app1:8080과 app2:8080을 정의합니다.NGINX는 이 두 서버 간에 요청을 분산시켜 부하를 균등하게 처리할 수 있습니다.
- 프록시 처리 : server 블록에서 클라이언트가 /app1/과 /app2/ 경로로 요청을 보내면, NGINX가 이를 각각 app1과 app2 서버로 프록시 전달
    - 이 과정에서 proxy_pass, proxy_set_header 지시어를 사용하여 요청 헤더 정보를 전달
