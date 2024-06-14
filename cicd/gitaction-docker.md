# Git Action
## 1. git action이란?
CICD 툴 중하나, 즉 개발하는 플로우를 자동화할수 있게해주는 툴.

> 예로 배포를 할때 인스턴스에 자바를 설치하고 mvn package와 sonar qube를 직접 손으로 적용시켜야 했다면, git action으로 코드로 이모든 과정을 자동화 할수 있음.<br/>
> 예제 : https://github.com/nhnacademy-bootcamp/project-ci-cd/blob/main/docs/07.git-action-configuration/index.adoc

## 2.  Docker란?
PC는 하드웨어 위에 운영체제가 올라가고 그것을 커널을 통해서 애플리케이션 레이어와 통신을 한다. Docker란, 운영체제 위에 도커 엔진을 올려서 애플리케이션 레이어를 나눠서 컨테이너를 만드는 프로그램이다.
- 예로 가상 PC는 하드웨어 위에 OS를 나눠서 여러가지 운영체제를 사용한다면
- Docker는 운영체제위에 애플리케이션 레이어를 여러가지로 나눠서 여러가지 필요한 애플리케이션 레이어를 사용한다.
> 즉 한 인스턴스에서 여러가지 자바 버전도 사용할수 있고, 프로그램에 필요한 의존성을 따로 만들수있다.

## 3. Docker 용어 설명
배포를 하면서 계속해서 환경을 맞춰 만들어주기위해 Docker를 사용
* Docker Image
도커 이미지란 애플리케이션과 그 애플리케이션을 실행하기 위한 모든 환경을 묶어서 저장한 파일
> build시 dockerfile을 끌어다가 씀

* Docker Container
현제 인스턴스에서 실행중이거나 실행할수있는 이미지를 뜻함

* Docker Hub
모든 사용자들의 도커 이미지가 공유되어 있는 저장소

* Docker Repository
도커 이미지를 빌드하여 Push한 저장소, 

* Docker Compose
명령어 한번으로 여러 컨테이너를 키고 끌수있는 서비스
> docker-compose.yml 파일을 끌어다가 씀

* Docker Build 명령어
dockerfile에 명시되어있는 것들을 도커 이미지로 만듬

- Docker push 명령어
build한 도커 이미지를 Docker Hub Repository에 올림

- Docker pull 명령어
Docker Hub Repository에 올라가있는 이미지를 가져옴

- Docker down 명령어
현재 실행되어있는 이미지 즉 컨테이너를 내림

- Docker up 명령어
현재 pull해서 가져온 이미지를 컨테이너에 올림
> 명령어는 docker-compose와 비슷합니다.

> 예상 시나리오
> 1. 컨테이너가 하나만 필요할 경우
> 필요한 의존 파일들을 dockerfile에 명시해주고 build를 통해 Docker Repository에 push 해주고 Hub에 방금 올라간 파일을 가져와서 Container를 띄운다
> 2. 컨테이너가 여러개 필요한 경우
> 필요한 의존 파일들을 컨테이너 마다 dockerfile을 만들어주고 docker-compose.yml에 필요한 컨테이너에 dockerfile 연결해주고 docker-compose 명령어를 통해 build -> push -> pull로 container 인스턴스에 올림.

## 4. 예제 파일 - gitaction으로 docker container에 app1,app2,nginx 올리기
소스 파일 : https://github.com/helloJosh/test-cicd

`maven.yml`
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

`Dockerfile`
```dockerfile
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY target/hello.jar /app/hello.jar

EXPOSE 8080

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
```

`entrypoint.sh`
```sh
#!/bin/bash
#### 사용중인 shell로

nginx &

java -jar /app/hello.jar
```

`docker-compose.yml`
```yaml
version: '3.8'

services:
  app1:
    build: .
    ports:
      - "8081:8080"
    networks:
      - app-network

  app2:
    build: .
    ports:
      - "8082:8080"
    networks:
      - app-network

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    networks:
      - app-network
    depends_on:
      - app1
      - app2

networks:
  app-network:
```

`nginx.conf`
```nginx
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
