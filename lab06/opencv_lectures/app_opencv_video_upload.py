import streamlit as st
import cv2
import numpy as np
import tempfile
import time

# 필터 함수
def apply_filter(frame, mode):
    if mode == "Grayscale":
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    elif mode == "Blur":
        frame = cv2.GaussianBlur(frame, (15, 15), 0)
    elif mode == "Canny":
        frame = cv2.Canny(frame, 100, 200)
    if len(frame.shape) == 2:
        frame = cv2.cvtColor(frame, cv2.COLOR_GRAY2BGR)
    return frame

# Streamlit UI
st.set_page_config(page_title="🎥 1x2 무한 영상 처리", layout="wide")
st.title("📼 1x2 무한 비디오 재생 (OpenCV Only)")

# 필터 선택
filter_option = st.sidebar.selectbox("🔧 필터 선택 (오른쪽)", ["None", "Grayscale", "Blur", "Canny"])

# 비디오 업로드
uploaded_file = st.file_uploader("🎞️ 비디오 업로드 (mp4, avi)", type=["mp4", "avi", "mov", "mkv"])

# 비디오 재생용 공간
frame_area = st.empty()

if uploaded_file:
    # 업로드 파일 임시 저장
    tfile = tempfile.NamedTemporaryFile(delete=False)
    tfile.write(uploaded_file.read())
    video_path = tfile.name

    # 비디오 열기
    cap = cv2.VideoCapture(video_path)
    fps = cap.get(cv2.CAP_PROP_FPS)
    delay = 1.0 / fps if fps > 0 else 0.03

    # 전체 프레임 저장 (무한 반복을 위해)
    frames = []

    while True:
        ret, frame = cap.read()
        if not ret:
            break
        frames.append(frame)
    cap.release()

    st.success("✅ 영상 로드 완료. 무한 재생 시작!")

    # 무한 재생 루프
    while True:
        for frame in frames:
            processed = apply_filter(frame, filter_option)
            combined = np.hstack((frame, processed))
            combined_rgb = cv2.cvtColor(combined, cv2.COLOR_BGR2RGB)
            frame_area.image(combined_rgb, channels="RGB")
            time.sleep(delay)
