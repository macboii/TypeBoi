# 제품 결정 원칙

## 핵심 가치
번역 + 교정을 **화면 어디서나** 할 수 있게 한다.

## 기능 우선순위 판단 기준
1. **MVP에 포함**: 번역, 교정, Share Extension
2. **Phase 2**: 히스토리, 위젯, polish
3. **Phase 3 (킬러 차별화)**: OCR Capture & Translate

## OCR 결정 배경
- 사용 빈도는 낮지만 만족도 매우 높은 기능
- DeepL, Grammarly 모두 없는 기능
- Vision Framework(Apple 내장)으로 외부 의존성 없이 구현 가능
- 지금 당장 개발 X → 구조만 설계해두고 Phase 3에 붙임

## Share Extension 우선 이유
- iOS에서 가장 중요한 진입점
- 다른 앱에서 텍스트 선택 → 바로 TypeBoi 처리
- 설치만 해도 즉시 가치 전달 가능

## 과도한 기능 추가 금지
각 Phase 완료 후 다음 Phase 진행. 동시 개발 금지.
