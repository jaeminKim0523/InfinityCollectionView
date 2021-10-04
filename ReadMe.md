# InfinityCollectionView Example
무한 스크롤 콜렉션뷰의 예제

### 무한 스크롤 로직
- 이미지 리스트의 Count * 3만큼 셀 생성
- 시작시 List[Count]에서 시작
- Index가 Count보다 작아지면 (Count * 2) - 1 로 이동
- Index가 Count * 2 보다 커지면 Count로 이동

### 셀 이미지 확대 로직
- 이미지 확대에 따른 Inset 조정
- Inset의 조정으로 스크롤시 이미지 이상으로 이동 불가
- 검으 여백 공간이 제거되는 효과
