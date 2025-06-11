import streamlit as st
import cv2
import numpy as np

# 📌 필터 함수
def apply_filter(frame, mode):
    if mode == "Grayscale":
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    elif mode == "Blur":
        frame = cv2.GaussianBlur(frame, (15, 15), 0)
    elif mode == "Canny":
        frame = cv2.Canny(frame, 100, 200)

    # 단일 채널은 3채널로 변환
    if len(frame.shape) == 2:
        frame = cv2.cvtColor(frame, cv2.COLOR_GRAY2BGR)
    return frame

# 🌐 Streamlit 설정
st.set_page_config(layout="wide")
st.title("📷 1x2 실시간 웹캠 필터 앱 (OpenCV + Streamlit)")

# 🎛️ 필터 선택
filter_option = st.sidebar.selectbox(
    "오른쪽 필터 선택",
    ["None", "Grayscale", "Blur", "Canny"]
)

# 📸 웹캠 연결
cap = cv2.VideoCapture(0)
FRAME_WINDOW = st.empty()  # 이미지 출력용

if not cap.isOpened():
    st.error("❌ 웹캠을 열 수 없습니다.")
else:
    st.success("✅ ESC 없이 자동 스트리밍 중입니다. 웹캠을 종료하려면 창을 닫으세요.")

    while True:
        ret, frame = cap.read()
        if not ret:
            st.error("❗ 프레임을 읽을 수 없습니다.")
            break

        # 필터 적용
        processed = apply_filter(frame, filter_option)

        # 1x2 영상 병합
        combined = np.hstack((frame, processed))

        # BGR → RGB 변환
        combined = cv2.cvtColor(combined, cv2.COLOR_BGR2RGB)

        # Streamlit에 표시
        FRAME_WINDOW.image(combined, channels="RGB")

cap.release()
