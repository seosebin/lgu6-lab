# 필요한 라이브러리 임포트
import torch  # PyTorch 딥러닝 프레임워크
import torch.nn as nn  # 신경망 모듈
import torch.optim as optim  # 최적화 알고리즘
import seaborn as sns  # 데이터 시각화
import numpy as np  # 수치 연산
from sklearn.model_selection import train_test_split  # 데이터 분할
from sklearn.preprocessing import StandardScaler  # 데이터 스케일링

# GPU 사용 가능 여부에 따라 device 설정
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f"Using device: {device}")

# seaborn의 tips 데이터셋 로드 및 전처리
tips = sns.load_dataset('tips').dropna()  # 결측치 제거
X = tips[['total_bill', 'size']].values  # 입력 변수: 총 금액과 테이블 크기
y = tips['tip'].values.astype(np.float32)  # 타겟 변수: 팁 금액

# 학습/테스트 데이터 분할 (80:20)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 데이터 스케일링 (표준화)
scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)  # 학습 데이터로 스케일러 학습
X_test = scaler.transform(X_test)  # 학습된 스케일러로 테스트 데이터 변환

# PyTorch 텐서로 변환 및 device로 이동
X_train_tensor = torch.tensor(X_train, dtype=torch.float32).to(device)
y_train_tensor = torch.tensor(y_train, dtype=torch.float32).unsqueeze(1).to(device)  # 차원 추가
X_test_tensor = torch.tensor(X_test, dtype=torch.float32).to(device)
y_test_tensor = torch.tensor(y_test, dtype=torch.float32).unsqueeze(1).to(device)

# 단순 선형 회귀 모델 정의
class RegressionModel(nn.Module):
    def __init__(self):
        super(RegressionModel, self).__init__()
        self.linear = nn.Linear(2, 1)  # 2개 입력 -> 1개 출력
    
    def forward(self, x):
        return self.linear(x)  # 선형 변환

# 모델 초기화 및 device로 이동
model = RegressionModel().to(device)
criterion = nn.MSELoss()  # 평균 제곱 오차 손실 함수
optimizer = optim.Adam(model.parameters(), lr=0.01)  # Adam 최적화 알고리즘

# 모델 학습
epochs = 100000
for epoch in range(epochs):
    model.train()  # 학습 모드
    optimizer.zero_grad()  # 그래디언트 초기화
    outputs = model(X_train_tensor)  # 순전파
    loss = criterion(outputs, y_train_tensor)  # 손실 계산
    loss.backward()  # 역전파
    optimizer.step()  # 파라미터 업데이트
    
    # 100 에포크마다 진행상황 출력
    if (epoch + 1) % 100 == 0:
        print(f"Epoch [{epoch + 1}/{epochs}], Loss: {loss.item():.4f}")

# 모델 평가
model.eval()  # 평가 모드
with torch.no_grad():  # 그래디언트 계산 비활성화
    predictions = model(X_test_tensor)  # 테스트 데이터 예측
    test_loss = criterion(predictions, y_test_tensor)  # 테스트 손실 계산
    print(f"\nTest Loss: {test_loss.item():.4f}")

    # 예측값과 실제값 비교 (처음 10개 샘플)
    print("Sample predictions (rounded):", predictions.squeeze().round().cpu().numpy()[:10])
    print("Actual:", y_test[:10])
