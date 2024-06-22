## 1. 홈 새로운 item 클릭
## 2. maven project 선택
## 3. 구성 가서 설정 (설정해야할것: github, sonarqube, shell script)
## 4. github 설정
- gitproject 체크 후 설정

<img width="993" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/279902ca-5876-4763-98a7-2adee9f422b2">

- git 체크

<img width="1001" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/d80850c6-f1be-478c-80e3-7437417a8027">

- 여기서 Credentials는 gitaction에서 한것처럼 새로운 계정을 만들어야함 -> 이유는 repository에 배포키 하나밖에 할당이 안됨

- git webhook : jekinsurl 넣어주고
  
<img width="1117" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/484daca5-9ec5-4db5-bbef-556cb5dfca46">

- git Deploykey : 공개키 넣어줌

<img width="1157" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/c7a70008-ab30-40cf-bc85-583ef1685c35">

- 해보고 지금 빌드에서 Console output확인

<img width="1409" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/e6c21450-f4f3-4675-a9aa-ca0b11c1aaad">


## 5. sonarqube설정(새로 프로젝트파서 만드는거 추천)
- SonarQube 프로젝트 설정(prebuild step에서 execute sonarqube scan 추가 하기전에 프로젝트를 밑에서 등록해야함 시스템에서)

<img width="1367" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/242138b3-bec9-4068-801f-50bbb4494d81">

- 자격증명은 crendtial 밑에 목록에서 global누르면 아래화면이 나오고 여기에서 키 추가를 누름

<img width="1442" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/c75df2dd-bf01-4928-9563-e686200dcd8b">

- 소나큐브 토큰값 넣어줌 secret text항목으로 넣어서 값 넣어주면됨
 
- 아까 넣었던 프로젝트 설정해주고 밑에도 값들 넣어줌

<img width="971" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/ecb25712-60bb-4ee4-b14e-c9fd55e82e7e">

- 해보고 지금 빌드에서 Console output확인

<img width="1409" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/40ce7d8d-feb7-4948-9d55-e68cb1e87ab4">


## 6. shellscript 추가
- 자격증명추가 젠킨스관리 -> 시스템가서 호스트 이름만 추가
  
<img width="1343" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/cd707994-2e65-40e1-afeb-b81c937080df">

> 이름만 추가하고 apply 어차피 여기에선 자격증명 못넣어서 테스트가 안됨 꼭 이름만 추가하고 apply누르기

- 빌드후 조치에서 Send build artifacts over SSH 선택 방금 추가했던 이름 넣고 username : 생성한 계정명 넣고 key에 개인키 추가

<img width="1426" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/a9d1bc2b-c0c0-43aa-9925-f8dc4720a8e4">

- 알아서 맞게 transfer set 추가

<img width="960" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/9b4f6164-ff9c-418c-93b0-c853b13931eb">

- 이제 shell script 랑 docerkfile을 서버 인스턴스쪽에 추가해야함

<img width="1199" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/78cf8485-376d-4b40-9eee-e43fed9b4108">

- 이런식으로 프로젝트에 있는 파일들 똑같이 복사 붙여넣기
startup.sh은 
```sh
cd /home/nhnacademy/gateway
sudo docker stop gateway || true
sudo docker rm gateway || true
sudo docker build -t gateway-image .
sudo docker run -d -p 8080:8080 --name gateway --net back_network gateway-image
```

entrypoint.sh은
```sh
#!/bin/bash

java -jar /gateway/gateway.jar
```


리눅스는 bash shell 을 쓰기 때문에 #!/bin/bash써야함 맥처럼 zsh아님


- 해보고 지금 빌드에서 Console output확인
<img width="1409" alt="image" src="https://github.com/nhnacademy-be6-3runner/3runner-docs/assets/37134368/40ce7d8d-feb7-4948-9d55-e68cb1e87ab4">



   
