# API / 서비스 연동 규칙

## OpenAI (교정)
- 모델: `gpt-4o-mini` (비용 효율)
- Supabase Edge Function 또는 직접 호출 (API 키 노출 주의)
- iOS 앱에서 직접 OpenAI 호출 시 → Supabase 프록시 경유

## Apple Translation API (번역)
- iOS 17+ 필수
- `Translation` framework import
- 오프라인 지원 (언어팩 다운로드 후)
- fallback: DeepL API

## DeepL (번역 fallback)
- Apple Translation 미지원 언어 또는 iOS 16 이하 대응
- Supabase Edge Function 경유

## Vision Framework (OCR, Phase 3)
- `VNRecognizeTextRequest` 사용
- 언어 힌트 제공으로 정확도 향상
- 처리는 백그라운드 스레드

## Supabase
- 기존 프로젝트 재사용 (textBoi 인프라)
- Edge Functions: openai-proxy, gateway-proxy 재활용 검토

## API 키 관리
- `Config.xcconfig` → Info.plist 경유
- `.gitignore`에 Config.xcconfig 추가 필수
