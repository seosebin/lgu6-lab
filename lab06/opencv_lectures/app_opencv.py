import streamlit as st
import cv2
import numpy as np
from PIL import Image
import io

st.title("OpenCV 이미지 필터링 데모")

# 필터 설명 딕셔너리
filter_descriptions = {
    "원본": "원본 이미지를 그대로 표시합니다.",
    "블러": "평균 블러링 - 주변 픽셀의 평균값을 사용하여 이미지를 부드럽게 만듭니다.",
    "가우시안 블러": "가우시안 분포를 사용한 블러링 - 노이즈 제거에 효과적입니다.",
    "샤프닝": "이미지의 엣지를 강조하여 선명도를 높입니다.",
    "엣지 검출": "Canny 엣지 검출 알고리즘으로 이미지의 경계선을 찾습니다.",
    "그레이스케일": "컬러 이미지를 흑백으로 변환합니다."
}

# 사이드바에 필터 옵션 추가
st.sidebar.title("필터 옵션")
filter_type = st.sidebar.selectbox(
    "필터 선택",
    list(filter_descriptions.keys())
)

# 선택된 필터 설명 표시
st.sidebar.markdown("---")
st.sidebar.markdown(f"**{filter_type} 설명:**")
st.sidebar.markdown(filter_descriptions[filter_type])

# 이미지 업로드
uploaded_file = st.file_uploader("이미지를 업로드하세요", type=['jpg', 'jpeg', 'png'])

if uploaded_file is not None:
    # 이미지 읽기
    image = Image.open(uploaded_file)
    image = np.array(image)
    
    # BGR로 변환 (OpenCV는 BGR 사용)
    if len(image.shape) == 3:
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
    
    # 필터 적용
    if filter_type == "블러":
        filtered = cv2.blur(image, (5,5))
    elif filter_type == "가우시안 블러":
        filtered = cv2.GaussianBlur(image, (5,5), 0)
    elif filter_type == "샤프닝":
        kernel = np.array([[-1,-1,-1], [-1,9,-1], [-1,-1,-1]])
        filtered = cv2.filter2D(image, -1, kernel)
    elif filter_type == "엣지 검출":
        filtered = cv2.Canny(image, 100, 200)
    elif filter_type == "그레이스케일":
        filtered = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    else:
        filtered = image

    # BGR에서 RGB로 변환 (Streamlit 표시용)
    if len(filtered.shape) == 3:
        filtered = cv2.cvtColor(filtered, cv2.COLOR_BGR2RGB)
    
    # 이미지 표시
    st.image(filtered, caption=f"적용된 필터: {filter_type}", use_container_width=True)
    
    # 이미지 다운로드 버튼
    if st.button("이미지 다운로드"):
        # PIL Image로 변환
        if len(filtered.shape) == 2:  # 그레이스케일인 경우
            filtered = cv2.cvtColor(filtered, cv2.COLOR_GRAY2RGB)
        pil_image = Image.fromarray(filtered)
        
        # 이미지를 바이트로 변환
        img_byte_arr = io.BytesIO()
        pil_image.save(img_byte_arr, format='PNG')
        img_byte_arr = img_byte_arr.getvalue()
        
        # 다운로드 버튼 생성
        st.download_button(
            label="PNG로 다운로드",
            data=img_byte_arr,
            file_name="filtered_image.png",
            mime="image/png"
        )