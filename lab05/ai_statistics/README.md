# uv를 활용한 개발환경

## PowerShell 정책 변경
- PowerShell 관리자 권한으로 열기 
    + uv 설치 참고 : [Installing uv](https://docs.astral.sh/uv/getting-started/installation/)
    + PowerShell 정책 참고 : [PowerShell execution policies](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.4#powershell-execution-policies)

- 보안 정책 우회 변경
```
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

- 환경변수 설정
```
$env:Path = "C:\Users\Admin\.local\bin;$env:Path"
```

- 기존 PowerShell 닫고, 다시 관리자 권한으로 실행
```
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/0.7.3/install.ps1 | iex"
```

## 가상환경 설정 
- Git-bash에서 실행
- python 버전은 3.11로 진행
- 순차적으로 실행
```
$ uv venv --python 3.11  
$ source .venv/Scripts/activate

(Mac/Linux)
$ source .venv/bin/activate
```

## 라이브러리 설치
- 이제 라이브러리를 설치한다. 
```bash
uv pip install -r requirements.txt
```